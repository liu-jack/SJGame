package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 +------------------------------------------------------------------------------
	 * 活跃度网络接口
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-5 下午5:24:31  
	 +------------------------------------------------------------------------------
	 */
	public class SocketCommand_activity
	{
		public function SocketCommand_activity()
		{
		}
		
		/**
		 * 获取活跃度数据 
		 */
		public static function getActivityData():void
		{
			SocketManager.o.call(ConstNetCommand.CS_GET_ACTIVITY_DATA);
		}
		
		/**
		 * 获取活跃度数据 
		 */
		public static function getActivityReward(index:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_GET_ACTIVITY_REWARD , index);
		}
	}
}