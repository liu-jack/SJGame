package SJ.Game.data.config
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.controls.CJRechargeUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.json.Json_function_open_setting;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SManufacturerUtils;
	import engine_starling.utils.SStringUtils;
	
	/**
	 +------------------------------------------------------------------------------
	 * 开启配置列表数据
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-25 上午11:34:48  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfFuncPropertyList
	{
		private var _dataDict:Dictionary;
		private static var _o:CJDataOfFuncPropertyList;
		private var _length:int = 0;
		
		public function CJDataOfFuncPropertyList()
		{
			_initData();
		}
		
		public static function get o():CJDataOfFuncPropertyList
		{
//			if(_o == null)
				_o = new CJDataOfFuncPropertyList();
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResFuncListSetting) as Array;
			_dataDict = new Dictionary();
			var length:int = obj.length;
			this._length = length;
			for(var i:int=0;i<length;i++)
			{
				var funcConfig:Json_function_open_setting = new Json_function_open_setting();
				funcConfig.loadFromJsonObject(obj[i]);
				if(! _funcNeedShow(funcConfig))
				{
					continue;
				}
				_dataDict[parseInt(obj[i]['functionid'])] = funcConfig;
			}
		}
		
		
		private function _funcNeedShow(funcConfig:Json_function_open_setting):Boolean
		{
			
			if (funcConfig.modulename == "CJFirstRechargeModule")
			{
				// 首充礼包
				//首充礼包已经领取则关闭首充功能点开启
				var roleData:CJDataOfRole = CJDataManager.o.DataOfRole;
				if (roleData.firstrechargecount == -1)
				{
					return false;
				}
			}
			else if(funcConfig.modulename == "CJPileRechargeModule")
			{
				// 充值活动
				// 累积充值时间不合法，则不显示
				// 累计充值是否活动中
				var isShowPileRecharge:Boolean = CJRechargeUtil.isPileRechargeActivity();
				// 单笔充值是否活动中
				var isShowSingleRecharge:Boolean = CJRechargeUtil.isSingleRechargeActivity();
				
				if (!isShowPileRecharge && !isShowSingleRecharge)
				{
					return false;
				}
			}
			else if(funcConfig.modulename == "CJCommentModule")
			{
				//add by zhengzheng 如果评论活动配置中没有配置url，则不显示评论活动图标
				var commentConfigList:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonCommentUrl) as Array;
				var currentChannel:String = String(ConstGlobal.CHANNEL);
				//评论配置为空，或者评论配置不包含当前渠道
				if(commentConfigList == null || !commentConfigList.hasOwnProperty(currentChannel))
				{
					commentUrl = null;
				}
				else
				{
					//	当前设备型号
					var manufactory:String = SManufacturerUtils.getManufacturerType();
					var commentUrl:String;
					if(manufactory == SManufacturerUtils.TYPE_ANDROID)
					{
						commentUrl = commentConfigList[currentChannel].commenturlandroid;
					}
					else if(manufactory == SManufacturerUtils.TYPE_IOS)
					{
						commentUrl = commentConfigList[currentChannel].commenturlios;
					}
					else
					{
						commentUrl = null;
					}
				}
				// 已经进行评论活动，则不显示
				if (CJDataManager.o.DataOfRole.commentstatus == -1 || SStringUtils.isEmpty(commentUrl))
				{
					return false;
				}
			}
			return true;
		}
		
		public function getProperty(id:int):Json_function_open_setting
		{
			return _dataDict[id];
		}
		
		/** 通过模块名称查找开启配置数据 **/
		public function getPropertyByModulename(modulename:String):Json_function_open_setting
		{
			if (SStringUtils.isEmpty(modulename))
			{
				return null;
			}
				
			for each (var data:Json_function_open_setting in _dataDict)
			{
				if (String(data.modulename).indexOf(modulename) != -1)
				{
					return data
				}
			}
			return null;
		}
		
		/** 通过图标名称查找开启配置数据 **/
		public function getPropertyByIconName(iconName:String):Json_function_open_setting
		{
			if (SStringUtils.isEmpty(iconName))
				return null;
			
			for each (var data:Json_function_open_setting in _dataDict)
			{
				if (String(data.icon) == iconName)
					return data
			}
			return null;
		}
		
		/**
		 * 获得LEVEL等级下所有配置的开启功能列表
		 * 如10级内所有的开启配置
		 */		
		public function getFunctionIdListByLevel(level:int):Array
		{
			var temp:Array = new Array();
			for(var functionid:String in this._dataDict)
			{
				var config:Json_function_open_setting = _dataDict[functionid];
				if(int(config.level) != 0 && config.level <= level && config.needopen == 1)
				{
					temp.push(functionid);
				}
			}
			temp.sort(_compare);
			return temp;
		}
		
		private function _compare(a:String , b :String):int
		{
			if(int(a) > int(b))
			{
				return 1;
			}
			else if(int(a) == int(b))
			{
				return 0;
			}
			return -1;
		}
		
		/**
		 * 获得功能点对应的指引配置
		 */		
		public function getFuncIndicateList(functionid:int):Array
		{
			if(functionid == -1)
			{
				return new Array();
			}
			var funcConfig:Json_function_open_setting = this._dataDict[functionid];
			if(funcConfig.guidelist == undefined)
			{
				return new Array();
			}
			var indicateIdList:Array = (funcConfig.guidelist as String).split(";");
			return indicateIdList;
		}
		
		/**
		 * 根据类型 @see ConstFunctionList
		 * 获取不需要开启的功能点列表
		 * @param type : 0 - 需要开启 | 1 - 下 2 - 右 3 - 上 4 - 左
		 */		
		public function getFunctionListNoNeedOpenByType(type:int):Array
		{
			var temp:Array = new Array();
			for(var functionid:String in this._dataDict)
			{
				var config:Json_function_open_setting = _dataDict[functionid];
				if(int(config.needopen) == 0 && int(config.type) == type)
				{
					temp.push(functionid);
				}
			}
			return temp;
		}
		
		/**
		 * 通过名字准确定位模块
		 */ 
		public function getPropertyByExactlyModulename(modulename:String):Json_function_open_setting
		{
			if (SStringUtils.isEmpty(modulename))
			{
				return null;
			}
			
			for each (var data:Json_function_open_setting in _dataDict)
			{
				if (String(data.modulename) == modulename)
				{
					return data
				}
			}
			return null;
		}

		/**
		 * 获取单个开启功能点配置
		 * @param id ：功能点配置id
		 * @return Json_function_open_setting
		 */	
		public function get length():int
		{
			return _length;
		}
	}
}