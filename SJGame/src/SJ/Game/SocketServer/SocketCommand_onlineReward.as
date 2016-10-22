package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 * 在线奖励
	 * @author longtao
	 * 
	 */
	public class SocketCommand_onlineReward
	{
		public function SocketCommand_onlineReward()
		{
		}
		
		/**
		 * 获取在线奖励信息
		 */
		public static function get_info():void
		{
			SocketManager.o.call(ConstNetCommand.CS_OLREWARD_GET_INFO);
		}
		
		/**
		 * 激活奖励
		 */
		public static function activate():void
		{
			SocketManager.o.callunlock(ConstNetCommand.CS_OLREWARD_ACTIVATE);
		}
		
		/**
		 * 领取奖励
		 */
		public static function get_reward(rewardid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_OLREWARD_GET_REWARD, rewardid);
		}
		
	}
}