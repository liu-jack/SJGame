package SJ.Game.data
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfNoticeProperty;
	import SJ.Game.data.json.Json_function_open_setting;
	import SJ.Game.data.json.Json_news_notice;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBase;
	
	import starling.events.Event;
	
	/**
	 * 新消息提醒数据
	 * @author    zhengzheng   
	*/
	public class CJDataOfNews extends SDataBase
	{
		//新消息提醒字典
		private var _jsonNoticeList:Object = new Object();
		//新消息类型
		private var _noticeType:int;
		//进入相应模块的插页id
		private var _pageid:int;
		//新消息提醒类型数组
		private var _jsonNoticeTypeArray:Array = new Array();
		//新消息提醒类型数组
		private var _tempNoticeTypeArray:Array = new Array();
		//新消息提醒类型数组
		private var _tempPageidArray:Array = new Array();
		//第一次登录的时候
		private var  _isFirst:Boolean = true;
		
		public function CJDataOfNews()
		{
			super("CJDataOfNews");
			this.loadFromCache(true);
			_initData();
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onReceiveNotice);
		}
		/**
		 * 取出已经保存到本地的数据
		 * 
		 */		
		private function _initData():void
		{
			if (noticeList == null ) return;
			if (noticeList is Dictionary)
			{
				noticeList = null;
				return;
			}
			var tempNoticeList:Object = JSON.parse(noticeList)
			for (var noticeType:String in tempNoticeList) 
			{
				if (_tempNoticeTypeArray.indexOf(int(noticeType)) == -1)
				{
					_tempNoticeTypeArray.push(int(noticeType));
					var pageId:int = tempNoticeList[noticeType];
					_tempPageidArray.push(pageId);
				}
			}
		}
		
		override public function clearAll():void
		{
			super.clearAll();
			
			saveToCache(false, true);
		}
		
		
		/**
		 * 等武将列表的数据初始化后，再次设置提醒的数据
		 * 
		 */		
		public function setNewsData():void
		{
			if (_isFirst)
			{
				_isFirst = false;
				var roleLevel:int = _roleLevelValide();
				if (roleLevel == 0)
				{
					return;
				}
				for (var i:int = 0; i < _tempNoticeTypeArray.length; i++) 
				{
					_saveNewsDataToCache(roleLevel, _tempNoticeTypeArray[i], _tempPageidArray[i]);
				}
				_tempNoticeTypeArray = new Array();
			}
		}
		/**
		 * 有新消息提醒 
		 * @param e
		 * 
		 */
		private function _onReceiveNotice(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.SC_CMD_SYNC_NOTICE)
				return;
			var params:Object = message.retparams;
			_noticeType = int(params.noticetype);
			if (_isFirst && _tempNoticeTypeArray.indexOf(_noticeType) == -1)
			{
				_tempNoticeTypeArray.push(_noticeType);
			}
			var extparams:Object = params.extparams;
			if (extparams.hasOwnProperty("pageid"))
			{
				_pageid = int(params.extparams.pageid);
			}
			else
			{
				_pageid = 0;
			}
			if (_isFirst)
			{
				_tempPageidArray.push(_pageid);
			}
			_setNewsWithReceiveNotice();
			
		}
		
		/**
		 * 收到提醒信息时， 保存提醒信息
		 * 
		 */		
		private function _setNewsWithReceiveNotice():void
		{
			var roleLevel:int = _roleLevelValide();
			if (roleLevel == 0)
			{
				return;
			}
			_saveNewsDataToCache(roleLevel, _noticeType, _pageid);
		}
		/**
		 * 角色等级验证
		 * 
		 */		
		private function _roleLevelValide():int
		{
			var herolistData:CJDataOfHeroList = CJDataManager.o.DataOfHeroList;
			var heroData:CJDataOfHero = herolistData.getMainHero();
			if (heroData == null)
			{
				return 0;
			}
			
			var roleLevel:int = int(heroData.level);
			var guideMinLv:int = int(CJDataOfGlobalConfigProperty.o.getData("GUIDE_MAX_LV"));
			if (roleLevel <= guideMinLv)
			{
				return 0 ;
			}
			return roleLevel;
		}
		/**
		 * 把提醒信息保存到本地
		 * 
		 */		
		private function _saveNewsDataToCache(roleLevel:int, noticeType:int, pageid:int):void
		{
			var propertys:Array = CJDataOfNoticeProperty.o.getAllPropertys();
			if (propertys.indexOf(noticeType) != -1 && !_jsonNoticeList.hasOwnProperty(String(noticeType)))
			{
				var noticeConfig:Json_news_notice = CJDataOfNoticeProperty.o.getProperty(noticeType);
				if (noticeConfig == null) 
					return;
				var tempModuleName:String = noticeConfig.modulename;
				var curModuleName:String = tempModuleName.substring(7, tempModuleName.length);
				var funcOpenSetting:Json_function_open_setting = CJDataOfFuncPropertyList.o.getPropertyByModulename(curModuleName);
				
				if (funcOpenSetting && roleLevel >= int(funcOpenSetting.level))
				{
					if (_jsonNoticeTypeArray.indexOf(noticeType) == -1)
					{
						_jsonNoticeTypeArray.push(noticeType);
					}
					_jsonNoticeList[String(noticeType)] = pageid;
					this.setData("noticeList", JSON.stringify(_jsonNoticeList));
					this.setData("noticeTypeArray",JSON.stringify(_jsonNoticeTypeArray));
					this.saveToCache(false,true);
				}
			}
		}
		/**
		 * 获取当前拥有的新消息提醒
		 * @return 
		 * 
		 */
		public function get noticeList():*
		{
			return getData("noticeList");
		}

		public function set noticeList(value:*):void
		{
			return setData("noticeList", value);
		}
		
		public function get noticeTypeArray():*
		{
			return getData("noticeTypeArray");
		}

		public function get jsonNoticeList():Object
		{
			return _jsonNoticeList;
		}

		public function set jsonNoticeList(value:Object):void
		{
			_jsonNoticeList = value;
		}

		public function get jsonNoticeTypeArray():Array
		{
			return _jsonNoticeTypeArray;
		}

		public function set jsonNoticeTypeArray(value:Array):void
		{
			_jsonNoticeTypeArray = value;
		}

		public function get tempNoticeTypeArray():Array
		{
			return _tempNoticeTypeArray;
		}

		public function set tempNoticeTypeArray(value:Array):void
		{
			_tempNoticeTypeArray = value;
		}


	}
}