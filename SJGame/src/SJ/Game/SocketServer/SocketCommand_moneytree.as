package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	
	import engine_starling.utils.Logger;

	/**
	 * 摇钱树
	 * @author sangxu
	 * 
	 */
	public class SocketCommand_moneytree
	{
		public function SocketCommand_moneytree()
		{
			
		}
		
		/**
		 * 获取自己摇钱树信息
		 */
		public static function getSelfMoneyTreeInfo():void
		{
			SocketManager.o.call(ConstNetCommand.CS_MONEYTREE_GETSELFMONEYTREEINFO);
		}
		/**
		 * 给自己的摇钱树施肥
		 * 
		 */		
		public static function feedSelfMoneyTree():void
		{
			SocketManager.o.call(ConstNetCommand.CS_MONEYTREE_FEEDSELFMONEYTREE);
		}
		/**
		 * 给好友的摇钱树施肥
		 * @param friendUid	好友uid
		 */
		public static function feedFriendMoneyTree(friendUid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_MONEYTREE_FEEDFRIENDMONEYTREE, friendUid);
		}
		/**
		 * 给所有好友的摇钱树施肥
		 */
		public static function feedAllFriendMoneyTree():void
		{
			SocketManager.o.call(ConstNetCommand.CS_MONEYTREE_FEEDALLFRIENDMONEYTREE);
		}
		/**
		 * 摇一摇
		 */
		public static function harverstMoneyTreeSliver():void
		{
			SocketManager.o.call(ConstNetCommand.CS_MONEYTREE_HARVERSTMONEYTREESLIVER, 1);
		}
		/**
		 * 批量摇
		 */
		public static function harverstMoneyTreeSliverPiliang():void
		{
			SocketManager.o.call(ConstNetCommand.CS_MONEYTREE_HARVERSTMONEYTREESLIVER, 10);
		}
		/**
		 * 收获摇钱树等级
		 */
		public static function harverstMoneyTreeLevel():void
		{
			SocketManager.o.call(ConstNetCommand.CS_MONEYTREE_HARVERSTMONEYTREELEVEL);
		}
		/**
		 * 获取好友摇钱树信息
		 */
		public static function getFriendMoneyTreeInfo():void
		{
			SocketManager.o.call(ConstNetCommand.CS_MONEYTREE_GETFRIENDMONEYTREEINFO);
		}
		
	}
}