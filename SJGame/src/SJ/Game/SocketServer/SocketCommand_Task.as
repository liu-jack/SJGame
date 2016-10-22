package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 +------------------------------------------------------------------------------
	 * 任务RPC调用
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-24 下午9:19:13  
	 +------------------------------------------------------------------------------
	 */
	public class SocketCommand_Task
	{
		public function SocketCommand_Task()
		{
		}
		
		/**
		 * 增加任务 
		 * @param taskid
		 */		
		public static function acceptTask(taskid:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_TASK_ACCEPTTASK , taskid);
		}
		
		/**
		 * 完成任务 
		 * @param taskid
		 */		
		public static function completeTask(taskid:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_TASK_COMPLETETASK , taskid);
		}
		
		/**
		 * 领取奖励任务 
		 * @param taskid
		 */		
		public static function rewardTask(taskid:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_TASK_REWARDTASK , taskid);
		}
		
		/**
		 * 放弃任务 
		 * @param taskid
		 */		
		public static function abortTask(taskid:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_TASK_ABORTTASK , taskid);
		}
		
		/**
		 * 获取所有任务 
		 * @param taskid
		 */		
		public static function getTaskList():void
		{
			SocketManager.o.call(ConstNetCommand.CS_TASK_GETALL);
		}
	}
}