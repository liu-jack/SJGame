package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 * 排行榜网络操作
	 @author	zhengzheng
	 */
	public class SocketCommand_rank
	{
		public function SocketCommand_rank()
		{
		}
		
		/**
		 *获取等级榜信息 
		 */
		public static function getRankLevel():void
		{
			SocketManager.o.call(ConstNetCommand.CS_RANK_LEVEL);
		}
		/**
		 *获取战力榜信息
		 */
		public static function getRankBattleLevel():void
		{
			SocketManager.o.call(ConstNetCommand.SC_RANK_BATTLE_LEVEL);
		}
		/**
		 *获取土豪榜信息
		 */
		public static function getRankRichLevel():void
		{
			SocketManager.o.call(ConstNetCommand.SC_RANK_RICH_LEVEL);
		}
	}
}