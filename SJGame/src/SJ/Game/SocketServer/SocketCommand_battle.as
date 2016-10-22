package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	public class SocketCommand_battle
	{
		public function SocketCommand_battle()
		{
		}
		
		/**
		 * 战斗与玩家 一般为测试 
		 * @param destuid
		 * 
		 */
		public static function battle(destuid:String = "216175330854012167"):void
		{
			SocketManager.o.call(ConstNetCommand.CS_BATTLE,destuid);
		}
		/**
		 * 战斗与NPC  一般为测试 
		 * @param battleid 关卡战斗id
		 * 
		 */
		public static function battlenpc(battleid:String = "1000"):void
		{
			SocketManager.o.call(ConstNetCommand.CS_BATTLENPC,battleid);
		}
		
		/**
		 * 切磋 
		 * @param func		回调函数
		 * @param destuid	目标用户id
		 * 
		 */
		public static function battleplayer(func:Function, destuid:String):void
		{
			SocketManager.o.callwithRtn(ConstNetCommand.CS_BATTLEPLAYER, func,false, destuid);
		}
		
		/**
		 * 第一场战斗 
		 * @param func
		 * 
		 */
		public static function fristbattleplayer(func:Function = null):void
		{
			SocketManager.o.callUnlockWithRtn(ConstNetCommand.CS_BATTLEFRIST_BATTLE, func,false);
		}
	}
}