package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFormation;

	/**
	 +------------------------------------------------------------------------------
	 * @name 领奖接口
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-11-19 17:32:12  
	 +------------------------------------------------------------------------------
	 */
	public class SocketCommand_reward
	{
		/**
		 * 获取用户上次阵型
		 */		
		public static function getAll():void
		{
			SocketManager.o.call(ConstNetCommand.CS_REWARD_GETALL);
		}
		
		/**
		 * 领取奖励
		 */
		public static function getReward(id:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_REWARD_GETREWARD , id);
		}
	}
}