package SJ.Game.data
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstChat;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_chat;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.chat.CJChatUtil;
	import SJ.Game.data.config.CJDataOfMaskWordProperty;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 聊天数据类型
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-9 下午3:42:02  
	 +------------------------------------------------------------------------------
	*/
	public class CJDataOfChat extends SDataBaseRemoteData
	{
		private var _allChatElementList:Array;
		private var _worldChatElementList:Array;
		private var _armyChatElementList:Array;
		private var _privateChatElementList:Array;
		private var _noticeChatElementList:Array;
		
		private var _elementDic:Dictionary = new Dictionary();
		/*最新的一个列表*/
		private var _newestElments:Array = new Array();
		/*最大显示条数*/
		private static const MAX_CHAT_NUM:int = 80;
		/*最后发消息的时间 毫秒*/
		private var _lastChatTime:Number;
		
		public function CJDataOfChat()
		{
			super("CJDataOfChat");
			_init();
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onSocketChatMessage);
		}
		
		private function _init():void
		{
			_allChatElementList = new Array();
			_worldChatElementList = new Array();
			_armyChatElementList = new Array();
			_privateChatElementList = new Array();
			_noticeChatElementList = new Array();
			_elementDic["ALL"] = _allChatElementList;
			_elementDic["WORLD"] = _worldChatElementList;
			_elementDic["ARMY"] = _armyChatElementList;
			_elementDic["PRIVATE"] = _privateChatElementList;
			_elementDic["NOTICE"] = _noticeChatElementList;
			
			
		}
		
		/**
		 * 聊天消息
		 */		
		private function _onSocketChatMessage(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			var command:String = message.getCommand();
			if(!command)
			{
				return;
			}
			var params:Object = message.retparams;
			//新消息出现
			if(command == ConstNetCommand.SC_CHAT && params)
			{
				if(params["chatType"] == ConstChat.CHAT_TYPE_SPEAKER)
				{
					return;
				}
				this._processMsg(params);
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_CHAT_NEW_MESSAGE ,false, params);
			}
			//初始化消息
			else if(command == ConstNetCommand.CS_GET_LAST_MSG && params)
			{
				_worldChatElementList.splice(0);
				this._initData(params as Array);
				//控制CJChatScreen 初始化
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_CHAT_INIT_MESSAGE);
				this._onloadFromRemoteComplete();
			}
		}
		
		/**
		 * 初始化30条聊天记录
		 */ 
		private function _initData(msgList:Array):void
		{
			if(msgList == null || msgList.length == 0)
			{
				return;
			}
			for(var i:String in msgList)
			{
				var msgDic:Object = msgList[i];
				this._processMsg(msgDic);
			}
		}
		
		private function _processMsg(data:Object):void
		{
			var type:int = int(data["chatType"]);
			var origincontent:String = data["content"];
			var fromuid:String = data["fromuid"];
			var roleName:String = data["fromrolename"];
			var elements:Array;
			
			var content:String = CJDataOfMaskWordProperty.o.filterString(origincontent);
			
			//黑名单过滤
			var blackList:Array = CJDataManager.o.DataOfFriends.friendsDic.BLACKLIST;
			for(var i:String in blackList)
			{
				var friendData:CJDataOfFriendItem = blackList[i];
				if(friendData.frienduid && friendData.frienduid == fromuid)
				{
					return;
				}
			}
			
			if(type == ConstChat.CHAT_TYPE_WORLD)
			{
				if(this._worldChatElementList.length >= MAX_CHAT_NUM)
				{
					this._worldChatElementList.shift();
				}
				elements = CJChatUtil.pushWorldChatLabels(content , fromuid , roleName);
				_newestElments = CJChatUtil.pushWorldChatLabels(content , fromuid , roleName , 10 , 12);
				this._worldChatElementList.push(elements);
			}
			else if(type == ConstChat.CHAT_TYPE_ARMY)
			{
				if(this._armyChatElementList.length >= MAX_CHAT_NUM)
				{
					this._armyChatElementList.shift();
				}
				elements = CJChatUtil.pushArmyChatLabels(content , fromuid , roleName);
				_newestElments = CJChatUtil.pushArmyChatLabels(content , fromuid , roleName , 10 , 12);
				this._armyChatElementList.push(elements);
			}
			else if(type == ConstChat.CHAT_TYPE_NOTICE)
			{
				if(this._noticeChatElementList.length >= MAX_CHAT_NUM)
				{
					this._noticeChatElementList.shift();
				}
				
				elements = CJChatUtil.pushNoticeChatLabels(content);
				_newestElments = CJChatUtil.pushNoticeChatLabels(content , 10 , 12);
				this._noticeChatElementList.push(elements);
			}
			else if(type == ConstChat.CHAT_TYPE_PRIVATE)
			{
				if(this._privateChatElementList.length >= MAX_CHAT_NUM)
				{
					this._privateChatElementList.shift();
				}
				
				elements = CJChatUtil.pushPrivateChatLabels(content , fromuid , roleName ,data["touid"] , data["torolename"]);
				_newestElments = CJChatUtil.pushPrivateChatLabels(content , fromuid , roleName ,data["touid"] , data["torolename"], 10 , 12);
				this._privateChatElementList.push(elements);
			}
			
			if(this._allChatElementList.length >= MAX_CHAT_NUM)
			{
				this._allChatElementList.shift();
			}
			this._allChatElementList.push(elements)
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			SocketCommand_chat.getLastMsg();
		}
		
		public function get allChatElementList():Array
		{
			return _allChatElementList;
		}

		public function get worldChatElementList():Array
		{
			return _worldChatElementList;
		}

		public function get armyChatElementList():Array
		{
			return _armyChatElementList;
		}

		public function get privateChatElementList():Array
		{
			return _privateChatElementList;
		}

		public function get noticeChatElementList():Array
		{
			return _noticeChatElementList;
		}

		public function get elementDic():Dictionary
		{
			return _elementDic;
		}

		public function get newestElments():Array
		{
			return _newestElments;
		}

		public function get lastChatTime():Number
		{
			return _lastChatTime;
		}

		public function set lastChatTime(value:Number):void
		{
			_lastChatTime = value;
		}
	}
}