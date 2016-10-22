package SJ.Game.task
{
	import SJ.Common.Constants.ConstTask;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfTask;
	import SJ.Game.data.json.Json_task_setting;

	/**
	 +------------------------------------------------------------------------------
	 * 检测任务的开启和完成条件
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-28 上午10:48:29  
	 +------------------------------------------------------------------------------
	 */
	public final class CJTaskChecker
	{
		/**
		 * 检测是否可接任务 判断任务接受的条件
		 * @return true:可接任务 false:不可接受
		 */		
		public static function isTaskCanAccept(task:CJDataOfTask):Boolean
		{
			if(task.status > ConstTask.TASK_CAN_ACCEPT)
			{
				return false;
			}
			var taskTemplate:Json_task_setting = task.taskConfig;
			for(var i:int = 1 ; i<= ConstTask.CONDTION_NUM ; i++)
			{
				if(taskTemplate["conditionkey"+i] != undefined)
				{
					if(!_checkAcceptConditionSatisfied(task , taskTemplate["conditionkey"+i] , taskTemplate["conditionvalue"+i]))
					{
						return false;
					}
				}
			}
			return true;
		}
		
		/**
		 * 任务是否可以领取奖励
		 * 1.任务是否已经完成
		 * 2.检测背包是否有剩余空间
		 */		
		public static function isTaskCanReward(task:CJDataOfTask):int
		{
			//如果是对话类任务，并且已经接受，直接可以完成
			if(_isTaskCanCompleteDirectlyAfterAccept(task))
			{
				return 1;
			}
			
			if(!task.isTaskComplete())
			{
				return -2;
			}
			
			return  1 ;	
		}
		
		/**
		 * 任务是否可以完成
		 */		
		public static function isTaskCanComplete(task:CJDataOfTask):Boolean
		{
			return true;
		}
		
		/**
		 * 任务是否可以放弃
		 */		
		public static function isTaskCanAbort(task:CJDataOfTask):Boolean
		{
			return _checkAbortSatisfied(task);
		}

		/**
		 * 检测开启条件是否满足
		 * @param task 任务DAO
		 * @param conditionKey 开启条件的key type:int 0|1  0 - level 1 - pretask
		 * @param conditionValue 开启条件的值 15级 或者 前置开启任务 id
		 */		
		private static function _checkAcceptConditionSatisfied(task:CJDataOfTask , conditionKey:* , conditionValue:*):Boolean
		{
			if(conditionKey == undefined || conditionValue == undefined)
			{
				return true;
			}
			var taskTemplate:Json_task_setting = task.taskConfig;
			//检测等级
			if(int(conditionKey) == ConstTask.TASK_CONDITION_LEVEL)
			{
				return int(CJDataManager.o.DataOfHeroList.getMainHero().level) >= int(conditionValue);
			}
			//前置任务检测
			else if(int(conditionKey) == ConstTask.TASK_CONDITION_PRETASK)
			{
				var preTask:CJDataOfTask = CJDataManager.o.DataOfTaskList.getTaskById(conditionValue);
				if(preTask == null)
				{
					return true;
				}
				return preTask.isTaskRewarded();
			}
			return false;
		}
		
		/**
		 * 检测任务是否可以放弃
		 * 接受过，并且没有领取奖励之前都可以放弃
		 */		
		private static function _checkAbortSatisfied(task:CJDataOfTask):Boolean
		{
			var status:int = task.status;
			if(status >= ConstTask.TASK_ACCEPTED && status <= ConstTask.TASK_REWARDED)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 是否可以接受完直接完成的任务
		 */ 
		private static function _isTaskCanCompleteDirectlyAfterAccept(task:CJDataOfTask):Boolean
		{
			if(!task.isTaskAccepted())
			{
				return false;
			}
			var action:int = task.taskConfig.action1;
			if(action == ConstTask.TASK_ACTION_ITEM_TALK || action == ConstTask.TASK_ACTION_TALK)
			{
				return true;
			}
			return false;
		}
	}
}