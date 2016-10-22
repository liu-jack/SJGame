package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	/**
	 *  竞技场
	 * @author yongjun
	 * 
	 */
	public class SocketCommand_arena
	{
		public function SocketCommand_arena()
		{
		}
		
		/**
		 * 获取竞技场信息
		 * @param fid 副本ID
		 * @param gid 关卡ID
		 * 
		 */
		public static function getInfo():void
		{
			SocketManager.o.call(ConstNetCommand.CS_ARENA_GETINFO);
		}
		/**
		 *获取竞技榜数据
		 * @param goldnum
		 * 
		 */
		public static function getRank():void
		{
			SocketManager.o.call(ConstNetCommand.CS_ARENA_GETRNAK);
		}
		
		/**
		 *够吗挑战次数
		 * @param fid
		 * 
		 */
		public static function buyChallegeChance(num:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_ARENA_BUYCHALLENGECHANCE,num);
		}
		
		/**
		 * 
		 * 清除CD
		 */
		public static function clearCD():void
		{
			SocketManager.o.call(ConstNetCommand.CS_ARENA_CLEARCDTIME);
		}
		
		public static function getnums():void
		{
			SocketManager.o.call(ConstNetCommand.CS_ARENA_GETBUYTIMES);
		}
		/**
		 * 竞技场战斗
		 * 
		 */		
		public static function battle(toUserid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_ARENA_BATTLE,toUserid);
		}
		
		public static function report(reportid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_ARENA_REPORT,reportid);
		}
		public static function getrecord():void
		{
			SocketManager.o.call(ConstNetCommand.CS_ARENA_GETRECORD)
		}
		/**
		 * 领取上次排名奖励
		 * @param fid
		 * @param itemid
		 * 
		 */
		public static function reward():void
		{
			SocketManager.o.call(ConstNetCommand.CS_ARENA_REWARD);
		}
		
		public static function checkawardtime():void
		{
			SocketManager.o.call(ConstNetCommand.CS_ARENA_CHECKTIME);
		}
		
		public static function tospeaker():void
		{
			SocketManager.o.call(ConstNetCommand.CS_ARENA_SPEAKER);
		}
	}
}