package SJ.Game.data.config
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_fuben_config;
	import SJ.Game.data.json.Json_fuben_guanka_config;
	
	import engine_starling.utils.AssetManagerUtil;
	
	public class CJDataOfFubenProperty
	{
		private var _listDict:Dictionary;
		private var _cacheDict:Dictionary;
		public function CJDataOfFubenProperty()
		{
			_initData();
		}
		
		private static var _o:CJDataOfFubenProperty;
		public static function get o():CJDataOfFubenProperty
		{
			if(_o == null)
				_o = new CJDataOfFubenProperty();
			return _o;
		}
		
		private function _initData():void
		{
			_listDict = new Dictionary;
			_cacheDict = new Dictionary;
			var fubenConf:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonFubenConfig) as Array;
			var jsonObj:Json_fuben_config = new Json_fuben_config;
			for(var i:String in fubenConf)
			{
				
				jsonObj.loadFromJsonObject(fubenConf[i])
				_listDict[fubenConf[i].id] = fubenConf[i];
			}
		}
		
		public function getFidByGid(gid:int):int
		{
			var fid:int = 0
			for(var i:String in _listDict)
			{
				var jsonObj:Object = _listDict[i];
//				jsonObj.gids = jsonObj.gids.split("&");
				if(jsonObj.gids.indexOf(String(gid))!=-1)
				{
					fid = jsonObj.id;
					break;
				}
			}
			return fid;
		}
		
		public function isFirstGuanka(fid:int,gid:int):Boolean
		{
			var fubenConf:Json_fuben_config = this.getPropertyById(fid);
			var index:int = fubenConf.gids.indexOf(String(gid));
			return index == 0;
		}
		/**
		 * 根据ID获取配置数据 
		 * @param id
		 * @return 
		 * 
		 */
		public function getPropertyById(id:int):Json_fuben_config
		{
			if(_cacheDict.hasOwnProperty(id))
			{
				return _cacheDict[id];
			}
			var fubenConfig:Json_fuben_config = new Json_fuben_config;
			fubenConfig.loadFromJsonObject(_listDict[id]);
			fubenConfig.gids = fubenConfig.gids.split("&");
			_cacheDict[id] = fubenConfig;
			return fubenConfig
		}
		
		public function getFubenInfos(mainCityId:Vector.<int>,level:String,isCommon:Boolean = true):Vector.<Object>
		{
			var fubenList:Vector.<Object> = new Vector.<Object>;
			var minLevel:int = 0;
			var nextInfo:Object;
			for(var i:String in mainCityId)
			{
				var mainCityConf:Object = CJDataOfMainSceneProperty.o.getPropertyById(mainCityId[i]);
				var fidstr:String = mainCityConf.fids;
				var fidArr:Array = fidstr.split("&");
				for(var j:String in fidArr)
				{
					var fubenInfo:Object = this.getPropertyById(fidArr[j]);
					if(fubenInfo.openvalue <= level)
					{
						if(isCommon && fubenInfo.id<300)
						{
							fubenList.push(fubenInfo);
						}
						if(!isCommon && fubenInfo.id>300)
						{
							fubenList.push(fubenInfo);
						}
					}
					else
					{
						if(!minLevel)
						{
							if(isCommon && fubenInfo.id<300)
							{
								minLevel = fubenInfo.openvalue;
								nextInfo = fubenInfo;
							}
							if(!isCommon && fubenInfo.id>300)
							{
								minLevel = fubenInfo.openvalue;
								nextInfo = fubenInfo;
							}
						}

					}
				}
			}
			if(nextInfo)
			{
				fubenList.push(nextInfo);
			}
			fubenList.sort(sortOnLevel);
			return fubenList;
		}
		private function sortOnLevel(a:Object,b:Object):Number
		{
			if(a.openvalue>b.openvalue)
			{
				return -1;
			}
			else if(a.openvalue<b.openvalue)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		public function getGuankaInfos(fid:int):Vector.<Object>
		{
			var fubenConf:Json_fuben_config = CJDataOfFubenProperty.o.getPropertyById(fid);
			var guankaidArr:Array = fubenConf.gids;
			var data:Vector.<Object> = new Vector.<Object>;
			for(var i:String in guankaidArr)
			{
				var item:Json_fuben_guanka_config = CJDataOfGuankaProperty.o.getPropertyById(guankaidArr[i]);
				data.push(item);
			}
			return data;
		}
		/**
		 * 根据ID，第几页得到背景图地址路径 
		 * @param id
		 * @param page
		 * @return 
		 * 
		 */
		public function getPageBgimg(id:int,page:int):String
		{
			var info:Json_fuben_config = this.getPropertyById(id);
			var path:Array = info.bgimg.split("&");
			if (path.hasOwnProperty(page-1))
			{
				return path[page-1];
			}
			return path[0];
		}
		
		//每页显示6个关卡
		public static var _pageNum:int = 6;
		public function getPageGuankaIds(id:int,page:int):Array
		{
			var info:Json_fuben_config = this.getPropertyById(id);
			var gidArr:Array = info.gids;
			return gidArr.slice(_pageNum*(page-1),_pageNum*(page))
		}
		/**
		 * 根据关卡ID 获取此关卡在第几页 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getPageById(fid:int,gid:int):int
		{
			var info:Json_fuben_config = this.getPropertyById(fid);
			var gidArr:Array = info.gids;
			var index:int = gidArr.indexOf(String(gid));
			return Math.floor(index/_pageNum)+1
		}
	}
}