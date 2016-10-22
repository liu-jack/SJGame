package SJ.Game.data
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_friend;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;

	/**
	 * 我的好友信息
	 * @author zhengzheng
	 * 
	 */	
	public class CJDataOfFriends extends SDataBaseRemoteData
	{
		//我的好友数据
		private var _myFriendData:Array = new Array();
		//最近联系人数据
		private var _recentContactData:Array = new Array();
		//好友申请数据
		private var _requestData:Array = new Array();
		//黑名单数据
		private var _blacklistData:Array = new Array();
		//好友相关所有数据
		private var _friendsDic:Dictionary = new Dictionary();
		
		public function CJDataOfFriends()
		{
			super("CJDataOfFriends");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , this._onSocketComplete);
		}
		/**
		 * 从远程加载数据
		 * @param params
		 * 
		 */		
		override protected function _onloadFromRemote(params:Object = null):void
		{
			SocketCommand_friend.getAllFriendInfo();
			SocketCommand_friend.getAllFriendTempInfo();
			SocketCommand_friend.getAllRequestsInfo();
			SocketCommand_friend.getBlacklist();
			super._onloadFromRemote(params);
		}
		/**
		 * 数据加载完毕
		 * @param e
		 * 
		 */		
		private function _onSocketComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			var retParams:Array;
			var listData:Array;
			var friendData:CJDataOfFriendItem;
			var friendRequestData:CJDataOfFriendRequestItem;
			if (message.getCommand() == ConstNetCommand.CS_FRIEND_GET_ALL_FRIEND_INFO)
			{
				if (message.retcode == 0)
				{
					retParams = message.retparams;
					listData= retParams[1] as Array;
					_myFriendData = [];
					for each(var data:Object in listData)
					{
						if (data)
						{
							friendData = new CJDataOfFriendItem();
							friendData.uid = String(data.uid);
							friendData.frienduid = String(data.frienduid);
							friendData.createdate = String(data.createdate);
							friendData.extcode = int(data.extcode);
							friendData.camp = int(data.camp);
							friendData.job = int(data.job);
							friendData.lately_login = String(data.lately_login);
							friendData.level = int(data.level);
							friendData.online = int(data.online);
							friendData.rolename = String(data.rolename);
							friendData.templateid = int(data.templateid);
							friendData.viplevel = int(data.viplevel);
							friendData.battleeffect = String(data.battleeffect);
							friendData.battleeffectsum = String(data.battleeffectsum);
							if (!_isContainFriendData(friendData, _myFriendData))
							{
								_myFriendData.push(friendData);
							}
						}
					}
					_friendsDic["MY_FRIEND"] = _myFriendData;
					this._dataIsEmpty = true;
					this._onloadFromRemoteComplete();
				}
			}
			else if (message.getCommand() == ConstNetCommand.CS_FRIEND_GET_ALL_FRIEND_TEMP_INFO)
			{
				if (message.retcode == 0)
				{
					retParams = message.retparams;
					listData= retParams[1] as Array;
					_recentContactData = [];
					for each(data in listData)
					{
						if (data)
						{
							friendData = new CJDataOfFriendItem();
							friendData.uid = String(data.uid);
							friendData.frienduid = String(data.frienduid);
							friendData.createdate = String(data.createdate);
							friendData.extcode = int(data.extcode);
							friendData.camp = int(data.camp);
							friendData.job = int(data.job);
							friendData.lately_login = String(data.lately_login);
							friendData.level = int(data.level);
							friendData.online = int(data.online);
							friendData.rolename = String(data.rolename);
							friendData.templateid = int(data.templateid);
							friendData.viplevel = int(data.viplevel);
							friendData.battleeffect = String(data.battleeffect);
							friendData.battleeffectsum = String(data.battleeffectsum);
							if (!_isContainFriendData(friendData, _recentContactData))
							{
								_recentContactData.push(friendData);
							}
						}
					}
					_friendsDic["RECENT_CONTACT"] = _recentContactData;
					this._dataIsEmpty = true;
					this._onloadFromRemoteComplete();
				}
			}
			else if (message.getCommand() == ConstNetCommand.CS_FRIEND_GET_ALL_REQUESTS_INFO)
			{
				if (message.retcode == 0)
				{
					retParams = message.retparams;
					listData= retParams[1] as Array;
					_requestData = [];
					for each(data in listData)
					{
						if (data)
						{
							friendRequestData = new CJDataOfFriendRequestItem();
							friendRequestData.requestid = String(data.requestid);
							friendRequestData.recvuid = String(data.recvuid);
							friendRequestData.senduid = String(data.senduid);
							friendRequestData.createdate = String(data.createdate);
							friendRequestData.camp = int(data.camp);
							friendRequestData.job = int(data.job);
							friendRequestData.lately_login = String(data.lately_login);
							friendRequestData.level = int(data.level);
							friendRequestData.online = int(data.online);
							friendRequestData.rolename = String(data.rolename);
							friendRequestData.templateid = int(data.templateid);
							friendRequestData.viplevel = int(data.viplevel);
							if (!_isContainRequestData(friendRequestData, _requestData))
							{
								_requestData.push(friendRequestData);
							}
						}
					}
					_friendsDic["REQUEST"] = _requestData;
					this._dataIsEmpty = true;
					this._onloadFromRemoteComplete();
				}
			}
			else if (message.getCommand() == ConstNetCommand.CS_FRIEND_GET_BLACKLIST)
			{
				if (message.retcode == 0)
				{
					retParams = message.retparams;
					listData= retParams[1] as Array;
					_blacklistData = [];
					for each(data in listData)
					{
						if (data)
						{
							friendData = new CJDataOfFriendItem();
							friendData.uid = String(data.uid);
							friendData.frienduid = String(data.frienduid);
							friendData.createdate = String(data.createdate);
							friendData.extcode = int(data.extcode);
							friendData.camp = int(data.camp);
							friendData.job = int(data.job);
							friendData.lately_login = String(data.lately_login);
							friendData.level = int(data.level);
							friendData.online = int(data.online);
							friendData.rolename = String(data.rolename);
							friendData.templateid = int(data.templateid);
							friendData.viplevel = int(data.viplevel);
							friendData.battleeffect = String(data.battleeffect);
							friendData.battleeffectsum = String(data.battleeffectsum);
							if (!_isContainFriendData(friendData, _blacklistData))
							{
								_blacklistData.push(friendData);
							}
						}
					}
					_friendsDic["BLACKLIST"] = _blacklistData;
					this._dataIsEmpty = true;
					this._onloadFromRemoteComplete();
				}
			}
		}
		/**
		 * 判断该数组中是否已经有该玩家数据
		 */		
		private function _isContainFriendData(friendData:CJDataOfFriendItem, array:Array):Boolean
		{
			for (var i:int = 0; i < array.length; i++) 
			{
				var friendDataInArray:CJDataOfFriendItem = array[i] as CJDataOfFriendItem;
				if (String(friendDataInArray.frienduid) == String(friendData.frienduid))
				{
					return true;
				}
			}
			return false;
		}
		/**
		 * 判断该数组中是否已经有该玩家请求数据
		 */		
		private function _isContainRequestData(friendRequestData:CJDataOfFriendRequestItem, array:Array):Boolean
		{
			for (var i:int = 0; i < array.length; i++) 
			{
				var friendRequestDataInArray:CJDataOfFriendRequestItem = array[i] as CJDataOfFriendRequestItem;
				if (String(friendRequestDataInArray.senduid) == String(friendRequestData.senduid))
				{
					return true;
				}
			}
			return false;
		}
		public function get friendsDic():Dictionary
		{
			return _friendsDic;
		}

		public function set friendsDic(value:Dictionary):void
		{
			_friendsDic = value;
		}

		public function get myFriendData():Array
		{
			return _friendsDic['MY_FRIEND'];
		}


	}
}