
package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	/**
	 @author	Weichao
	 @date	上午11:48:27
	 */
	public class SocketCommand_horse
	{
		public function SocketCommand_horse()
		{
		}
		
		public static function activeRideSkill():void
		{
			SocketManager.o.call(ConstNetCommand.CS_HORSE_ACTIVERIDESKILL);
		}
		
		public static function getHorseInfo():void
		{
			SocketManager.o.call(ConstNetCommand.CS_HORSE_GETHORSEINFO);
		}
		
		public static function rideHorse(horseid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_HORSE_RIDEHORSE, horseid);
		}
		
		public static function dismount():void
		{
			SocketManager.o.call(ConstNetCommand.CS_HORSE_DISMOUNT);
		}
		
		public static function upgradeRideSkill(type:String, count:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_HORSE_UPGRADERIDESKILL, type, count);
		}
		
		public static function upgradeRideSkillRank():void
		{
			SocketManager.o.call(ConstNetCommand.CS_HORSE_UPGRADERIDESKILLRANK);
		}
		
		public static function extendHorse(horseid:String, days:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_HORSE_EXTENDHORSE, horseid, days);
		}
	}
}