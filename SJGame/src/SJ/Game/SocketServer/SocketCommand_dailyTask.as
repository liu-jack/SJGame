package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 +------------------------------------------------------------------------------
	 * 每日任务-RPC接口类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-10-2 上午10:37:09  
	 +------------------------------------------------------------------------------
	 */
	public class SocketCommand_dailyTask
	{
		/**
		 * 获取每日任务数据
		 */
		public static function getAll():void
		{
			SocketManager.o.call(ConstNetCommand.CS_DAILYTASK_GETALL);
		}
		
		/**
		 * 接受任务
		 */
		public static function accept(index:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_DAILYTASK_ACCEPT, index);
		}
		
		/**
		 * 立即完成 
		 */
		public static function imdComplete(index:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_DAILYTASK_IMDCOMPLETE, index);
		}
		
		/**
		 * 领取奖励 
		 */
		public static function reward(index:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_DAILYTASK_REWARD , index);
		}
		
		/**
		 * 立即刷新 
		 */
		public static function imdRefresh():void
		{
			SocketManager.o.call(ConstNetCommand.CS_DAILYTASK_IMDREFRESH);
		}
	}
}