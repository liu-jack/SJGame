
package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	/**
	 * 好友网络操作
	 @author	zhengzheng
	 */
	public class SocketCommand_friend
	{
		public function SocketCommand_friend()
		{
		}
		/**
		 *获取所有申请加好友信息 
		 */
		public static function getAllRequestsInfo():void
		{
			SocketManager.o.call(ConstNetCommand.CS_FRIEND_GET_ALL_REQUESTS_INFO);
		}
		/**
		 *申请添加好友
		 * param destUid 对方的用户id
		 */
		public static function requestAddFriend(destUid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FRIEND_REQUEST_ADD_FRIEND, destUid);
		}
		/**
		 *删除添加好友请求 
		 * param requestId 申请方的用户id
		 */	
		public static function responseDelAddFriend(requestId:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FRIEND_RESPONSE_DEL_ADD_FRIEND, requestId);
		}
		/**
		 *同意添加好友
		 * param requestId 申请方的用户id
		 */
		public static function responseAddFriend(requestId:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FRIEND_RESPONSE_ADD_FRIEND, requestId);
		}
		/**
		 *删除好友 
		 * param destUid 对方的用户id
		 */
		public static function delFriend(destUid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FRIEND_DEL_FRIEND, destUid);
		}
		/**
		 *添加黑名单 
		 * param destUid 对方的用户id
		 */
		public static function addBlacklist(destUid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FRIEND_ADD_BLACKLIST, destUid);
		}
		/**
		 *获取黑名单 
		 */
		public static function getBlacklist():void
		{
			SocketManager.o.call(ConstNetCommand.CS_FRIEND_GET_BLACKLIST);
		}
		/**
		 *删除黑名单
		 * param destUid 对方的用户id
		 */
		public static function delBlacklist(destUid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FRIEND_DEL_BLACKLIST, destUid);
		}
		/**
		 *获取所有好友的信息 
		 */
		public static function getAllFriendInfo():void
		{
			SocketManager.o.call(ConstNetCommand.CS_FRIEND_GET_ALL_FRIEND_INFO);
		}
		/**
		 *获取好友信息 
		 * param destUid 对方的用户id
		 */
		public static function getFriendInfo(destUid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FRIEND_GET_FRIEND_INFO, destUid);
		}
		/**
		 *删除最近联系人
		 * param destUid 对方的用户id
		 */	
		public static function delFriendTemp(destUid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FRIEND_DEL_FRIEND_TEMP, destUid);
		}
		/**
		 *获取所有最近联系人信息 
		 */	
		public static function getAllFriendTempInfo():void
		{
			SocketManager.o.call(ConstNetCommand.CS_FRIEND_GET_ALL_FRIEND_TEMP_INFO);
		}
	}
}