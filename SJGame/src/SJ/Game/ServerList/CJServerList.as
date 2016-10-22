package SJ.Game.ServerList
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstPlatformId;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_serverid_and_channelid;
	import SJ.Game.data.json.Json_serverlist;
	import SJ.Game.utils.SApplicationUtils;
	import SJ.Game.utils.SCompileUtils;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.Logger;
	import engine_starling.utils.SObjectUtils;
	import engine_starling.utils.SPlatformUtils;

	public class CJServerList
	{
		private static const _dataName:String = "CJServerListData";
		private static var _CurrentServerList:Array = null;
		private static var _CurrentServerDict:Dictionary = null;
		private static var _CurrentServerAndChannelDict:Dictionary = null;
		private static var _logger:Logger = Logger.getInstance(CJServerList);
		public function CJServerList()
		{
			getServerList();
		}
		
		/**
		 * 加载默认配置 主要是资源路径
		 * 
		 */
		public static function loadDefaultResSetting():void
		{
			var cacheData:SDataBase = new SDataBase(_dataName);
			cacheData.loadFromCache();
			if(cacheData.hasKey("ex"))
			{
				var jsonObj:Object = JSON.parse(cacheData.getData("ex"));
				ConstGlobal.ServerSetting.loadFromJsonObject(jsonObj);
//				loadServerList();
			}
			else //赋值默认的资源加载路径
			{
				ConstGlobal.ServerSetting.md5url = ConstGlobal.Default_MD5_Path;
				ConstGlobal.ServerSetting.cdnurl = ConstGlobal.Default_Resource_Path;
			}
		}
		/**
		 * 加载服务器列表 
		 * 
		 */
		public static function loadServerList():void
		{
			var cacheData:SDataBase = new SDataBase(_dataName);
			cacheData.loadFromCache();
			
			var serverid:int = -1;
			if(cacheData.hasKey("serverid"))
			{
				serverid = cacheData.getData("serverid");
			}
			else
			{
				serverid = getDefaultServer();
			}
			
			Logger.log("B","A5");
			SelectServer(serverid);
		}
		/**
		 * 获取默认进入的服务器 
		 * @return 
		 * 
		 */
		private static function getDefaultServer():int
		{
			var serverlist:Array = getServerList();
			//推荐服务器列表
			var defaultserverlist:Array = new Array();
			//选择默认推荐
			for each(var serverinfo:Json_serverlist in serverlist)
			{
				if( int(serverinfo.defaultserver) == 1)
				{
					if(parseInt( serverinfo.isclose) == 1)
					{
						//推荐服务器已经关闭
//						break;
					}
					else
					{
						defaultserverlist.push(int(serverinfo.id));
					}
				}
			}
			
			//随机一个推荐服务器
			if(defaultserverlist.length != 0)
			{
				return defaultserverlist[int(Math.random() * defaultserverlist.length)];
			}
			
			
			
			//默认选择一个不关闭的服务器
			for each( serverinfo in serverlist)
			{
				if( int(serverinfo.isclose) == 0)
				{
					return serverinfo.id;
				}
			}
			
			//修改从外网切换到内网。服务器配置不统一。重新设置资源下载地址
			if(serverlist.length == 0)
			{
				//给全局服务器赋值
				var cacheData:SDataBase = new SDataBase(_dataName);
				cacheData.loadFromCache();
				ConstGlobal.ServerSetting.md5url = ConstGlobal.Default_MD5_Path;
				ConstGlobal.ServerSetting.cdnurl = ConstGlobal.Default_Resource_Path;
				cacheData.setData("serverid",0);
				cacheData.setData("ex",JSON.stringify(ConstGlobal.ServerSetting));
				cacheData.saveToCache();
				SApplicationUtils.exit();
			}
			//还有啊.... 那就第0个吧
			return serverlist[0].id;
		}
		/**
		 * 切换选择服务器 
		 * @param ServerId
		 * 
		 */
		public static function SelectServer(ServerId:int):void
		{
			
			if (_CurrentServerDict.hasOwnProperty(ServerId))
			{
				var serjson:Json_serverlist = _CurrentServerDict[ServerId];
				if(parseInt(serjson.isclose) == 1)
				{
					//服务器已经关闭
					//选择默认服务器
					SelectServer(getDefaultServer());
					return;
				}
				//全局配置加载
				ConstGlobal.ServerSetting.loadFromJsonObject(serjson);
				//修正资源访问路径
				//不是内网服务器组
				if(parseInt( serjson.groupid) != 0)
				{
					var ver:String = SPlatformUtils.getApplicationVersion();
					ver = ver.replace( /\./g,"_");
					ConstGlobal.ServerSetting.cdnurl +=  ver +"/";
					ConstGlobal.ServerSetting.md5url += ver +"/";			
				}
				
				
				
				//给全局服务器赋值
				var cacheData:SDataBase = new SDataBase(_dataName);
				cacheData.loadFromCache();
				cacheData.setData("serverid",ServerId);
				cacheData.setData("ex",JSON.stringify(ConstGlobal.ServerSetting));
				cacheData.saveToCache();
			}
			else
			{
				SelectServer(getDefaultServer());
			}
			
		}
		
		/**
		 * 获取当前进入的服务器id
		 * @return 
		 */
		public static function getServerID():int
		{
			var cacheData:SDataBase = new SDataBase(_dataName);
			cacheData.loadFromCache();
			return int(cacheData.getData("serverid"));
		}
		
		/**
		 * 获取服务器json信息
		 * @return 
		 */
		public static function getServerJS(id:int):Json_serverlist
		{
			var serverlist:Object = AssetManagerUtil.o.getObject(ConstResource.sResJsonServerList);
			var serjson:Json_serverlist = new Json_serverlist();
			//选择默认推荐
			for each(var serverinfo:Object in serverlist)
			{
				serjson.loadFromJsonObject(serverinfo);
				if( int(serjson.id) == id)
				{
					return serjson;
				}
			}
			
			return null;
		}
		/**
		 * 获取服务器列表 
		 * @return array[Json_serverlist]
		 * 
		 */		
		public static function getServerList():Array
		{
			if(_CurrentServerList == null)
			{
				_CurrentServerList = new Array();
				_CurrentServerDict = new Dictionary();
				_CurrentServerAndChannelDict = new Dictionary();
			}
			else
			{
				return _CurrentServerList;
			}
			var _CurrentServerList:Array = new Array();
			var serverlist:Object = AssetManagerUtil.o.getObject(ConstResource.sResJsonServerList);
			
			var serjson:Json_serverlist = new Json_serverlist();
			
			var serChannellist:Object = AssetManagerUtil.o.getObject(ConstResource.sResJsonServerChannelList);
			
			var serveridforchannel:Dictionary = new Dictionary();
			for each(var tmp:Object in serChannellist)
			{
				var serChanneljson:Json_serverid_and_channelid = new Json_serverid_and_channelid();
				serChanneljson.loadFromJsonObject(tmp);
				var channelid:int = parseInt(ConstGlobal.CHANNEL);
				if (parseInt(serChanneljson.channel) == channelid)
				{
					serveridforchannel[serChanneljson.id] = serChanneljson;
				}
			}
//			
			var checkserverid:int = ConstPlatformId.PlatformServerVerifyId[ConstGlobal.CHANNELID];;
//			//外网对外审核
//			//强制进入审核服务器
			
			
			//选择默认推荐
			for each(var serverinfo:Object in serverlist)
			{
				serjson.loadFromJsonObject(serverinfo);
				if (serveridforchannel.hasOwnProperty(serjson.id))
				{
					var serverObject:Json_serverid_and_channelid = serveridforchannel[parseInt(serjson.id)];
					
					var obj:Object = SObjectUtils.clone(serjson);
					obj.defaultserver = serverObject.defaultserver;
					obj.recommend = serverObject.recommend;
					
					//如果是在审核中。强制进入审核服务器
					if(SCompileUtils.o.isOnVerify())
					{
						if(checkserverid == parseInt(serjson.id))
						{
							_CurrentServerList.push(obj);
							_CurrentServerDict[parseInt(serjson.id)] = obj;
						}
					}
					else //不在审核中，走正常逻辑
					{
						if(checkserverid != parseInt(serjson.id))
						{
							_CurrentServerList.push(obj);
							_CurrentServerDict[parseInt(serjson.id)] = obj;
						}
					}
				}
			}
			
			return _CurrentServerList;
		}
		
	}
}