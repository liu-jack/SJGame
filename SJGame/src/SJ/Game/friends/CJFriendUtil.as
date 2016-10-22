package SJ.Game.friends
{
	import SJ.Common.Constants.ConstFriend;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_friend;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	
	import starling.events.Event;

	/**
	 * 好友工具类
	 * @author zhengzheng
	 * 
	 */
	public class CJFriendUtil
	{
		public function CJFriendUtil()
		{
		}
		private static var _o:CJFriendUtil = null;
		/**
		 * 好友工具类的单例
		 * @return CJFriendUtil实例
		 */		
		public static function get o():CJFriendUtil
		{
			if(null == _o)
			{
				_o = new CJFriendUtil();
			}
			return _o;
		}
		
		/**
		 * 转化秒为日期
		 *
		 */
		public function changeSecondToDate(seconds:Number):String
		{
			var time:String;
			var curDate:Date = new Date();
			var timeDistance:Number = (curDate.time / 1000) - seconds;
			var hours:Number = timeDistance / 3600;
			var days:Number = timeDistance / (3600 * 24);
			if (days >= 1)
			{
				time = int(days) + CJLang("FRIEND_OFFLINE_DAY");
			}
			else if (hours >= 1)
			{
				time = int(hours) + CJLang("FRIEND_OFFLINE_HOUR");
			}
			else
			{
				time = CJLang("FRIEND_OFFLINE_LESS_HOUR");
			}
			return time;
		}
		/**
		 *  我的好友、最近联系人、黑名单中玩家显示排序
		 * 
		 */		
		public function playerShowSort(playerInfo0:Object, playerInfo1:Object):int
		{
			var compareResult:int;
			compareResult = this._compare(Number(playerInfo0.online), Number(playerInfo1.online), true);
			if (0 != compareResult)
			{
				return compareResult;
			}
			compareResult = this._compare(Number(playerInfo0.lately_login), Number(playerInfo1.lately_login), true);
			return compareResult;
		}
		
		/**
		 *  好友管理层中玩家显示排序
		 * 
		 */		
		public function playerManageShowSort(playerInfo0:Object, playerInfo1:Object):int
		{
			var compareResult:int;
			compareResult = this._compare(Number(playerInfo0.online), Number(playerInfo1.online), false);
			if (0 != compareResult)
			{
				return compareResult;
			}
			compareResult = this._compare(Number(playerInfo0.lately_login), Number(playerInfo1.lately_login), false);
			return compareResult;
		}
		
		/**
		 * 比较两个数字, 返回1、-1、0
		 * @param valueA
		 * @param valueB
		 * @param reverse	反转与否, 默认为false
		 * @return reverse为false(默认)时A>B返回1, A<B返回-1, A==B返回0
		 *         reverse为true时A<B返回1, A>B返回-1, A==B返回0
		 * 
		 */		
		private function _compare(valueA:Number, valueB:Number, reverse:Boolean = false):int
		{
			var rvsValue:int = !reverse ? 1 : -1;
			if (valueA > valueB)
			{
				return 1 * rvsValue;
			}
			else if(valueA < valueB)
			{
				return -1 * rvsValue;
			}
			else
			{
				return 0;
			}
		}
		public function dipose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadRequest);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadResponse);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadDelFriend);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadAddBlacklist);
		}
		/**
		 * 申请添加好友信息返回提示 
		 * 
		 */		
		public function requestRetTips():void
		{
			//添加数据到达监听 
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadRequest);
		}
		/**
		 * 加载服务器返回数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadRequest(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_FRIEND_REQUEST_ADD_FRIEND)
			{
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadRequest);
				// 去除网络锁
//				SocketLockManager.KeyUnLock(ConstNetCommand.CS_FRIEND_REQUEST_ADD_FRIEND);
				// 去除网络锁
//				SocketLockManager.KeyUnLock(ConstNetCommand.CS_FRIEND_REQUEST_ADD_FRIEND);
				switch(message.retcode)
				{
					case ConstFriend.FRIEND_RETCODE_SUCC:
						CJFlyWordsUtil(CJLang("FRIEND_SEND_REQUEST_SUCCESS"));
						SocketCommand_friend.getAllRequestsInfo();
						//活跃度
						CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false , {"key":CJActivityEventKey.ACTIVITY_ADDFRIEND});
						break;
					case ConstFriend.FRIEND_RETCODE_FRIEND_FULL:
						CJFlyWordsUtil(CJLang("FRIEND_FULL"));
						break;
					case ConstFriend.FRIEND_RETCODE_IS_SELF:
						CJFlyWordsUtil(CJLang("FRIEND_IS_SELF"));
						break;
					case ConstFriend.FRIEND_RETCODE_OFFLINE:
						CJFlyWordsUtil(CJLang("FRIEND_PLAYER_OFFLINE"));
						break;
					case ConstFriend.FRIEND_RETCODE_ALREADY_IN_REQUEST_LIST:
						CJFlyWordsUtil(CJLang("FRIEND_ALREADY_IN_REQUEST_LIST"));
						break;
					case ConstFriend.FRIEND_RETCODE_ALREADY_FRIEND:
						CJFlyWordsUtil(CJLang("FRIEND_ALERADY_FRIEND"));
						break;
					case ConstFriend.FRIEND_OTHER_FULL:
						CJFlyWordsUtil(CJLang("FRIEND_OTHER_FULL"));
						break;
					case ConstFriend.FRIEND_RETCODE_UNKNOWN:
						CJFlyWordsUtil(CJLang("FRIEND_UNKNOWN_ERROR"));
						break;
					default:
						break;
				}
			}
		}
		
		/**
		 * 回应添加好友请求信息返回提示 
		 * 
		 */		
		public function responseRetTips():void
		{
			//添加数据到达监听 
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadResponse);
		}
		/**
		 * 加载服务器返回数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadResponse(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_FRIEND_RESPONSE_ADD_FRIEND)
			{
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadResponse);
				// 去除网络锁
//				SocketLockManager.KeyUnLock(ConstNetCommand.CS_FRIEND_RESPONSE_ADD_FRIEND);
				switch(message.retcode)
				{
					case ConstFriend.FRIEND_RETCODE_SUCC:
						CJFlyWordsUtil(CJLang("FRIEND_ADD_FRIEND_SUCCESS") + CJLang("FRIEND_SUCCESS"));
						SocketCommand_friend.getAllFriendInfo();
						break;
					case ConstFriend.FRIEND_RETCODE_FRIEND_FULL:
						CJFlyWordsUtil(CJLang("FRIEND_FULL"));
						break;
					case ConstFriend.FRIEND_RETCODE_REQUEST_NOT_EXIST:
						CJFlyWordsUtil(CJLang("FRIEND_REQUEST_NOT_EXIST"));
						break;
					case ConstFriend.FRIEND_OTHER_FULL:
						CJFlyWordsUtil(CJLang("FRIEND_OTHER_FULL"));
						break;
					default:
						break;
				}
			}
			
		}
		/**
		 * 删除好友返回提示 
		 * 
		 */		
		public function delFriendRetTips():void
		{
			//添加数据到达监听 
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadDelFriend);
		}
		/**
		 * 加载服务器返回数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadDelFriend(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_FRIEND_DEL_FRIEND)
			{
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadDelFriend);
				// 去除网络锁
//				SocketLockManager.KeyUnLock(ConstNetCommand.CS_FRIEND_DEL_FRIEND);
				switch(message.retcode)
				{
					case ConstFriend.FRIEND_RETCODE_SUCC:
						SocketCommand_friend.getAllFriendInfo();
						CJFlyWordsUtil(CJLang("FRIEND_DELETE_FRIEND") + CJLang("FRIEND_SUCCESS"));
						break;
					case ConstFriend.FRIEND_RETCODE_IS_SELF:
						CJFlyWordsUtil(CJLang("FRIEND_IS_SELF"));
						break;
					case ConstFriend.FRIEND_RETCODE_IS_NOT_FRIEND:
						CJFlyWordsUtil(CJLang("FRIEND_NOT_FRIEND"));
						break;
					default:
						break;
				}
			}
		}
		
		/**
		 * 添加黑名单返回提示 
		 * 
		 */		
		public function addBlacklistRetTips():void
		{
			//添加数据到达监听 
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadAddBlacklist);
		}
		/**
		 * 加载服务器返回数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadAddBlacklist(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_FRIEND_ADD_BLACKLIST)
			{
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadAddBlacklist);
				// 去除网络锁
//				SocketLockManager.KeyUnLock(ConstNetCommand.CS_FRIEND_ADD_BLACKLIST);
				switch(message.retcode)
				{
					case ConstFriend.FRIEND_RETCODE_SUCC:
						CJMessageBox(CJLang("FRIEND_TO_BLACKLIST_SUCCESS"));
						SocketCommand_friend.getBlacklist();
						break;
					case ConstFriend.FRIEND_RETCODE_BLACKLIST_FULL:
						CJFlyWordsUtil(CJLang("FRIEND_BLACKLIST_FULL"));
						break;
					case ConstFriend.FRIEND_RETCODE_IS_SELF:
						CJFlyWordsUtil(CJLang("FRIEND_IS_SELF"));
						break;
					case ConstFriend.FRIEND_RETCODE_OFFLINE:
						CJFlyWordsUtil(CJLang("FRIEND_PLAYER_OFFLINE"));
						break;
					case ConstFriend.FRIEND_RETCODE_ALREADY_BLACKLIST:
						CJFlyWordsUtil(CJLang("FRIEND_ALREADY_IN_BLACKLIST"));
						break;
					default:
						break;
				}
			}
		}
	}
}