package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTask;
	import SJ.Game.SocketServer.SocketCommand_Task;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.task.CJTaskChecker;
	
	import engine_starling.data.SDataBaseRemoteData;
	import engine_starling.utils.Logger;
	
	import flash.utils.Dictionary;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 用户所有任务列表 MODEL 
	 * 发事件，更新任务状态，数据唯一入口
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-24 下午9:15:18  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfTaskList extends SDataBaseRemoteData
	{
		public static const DATA_KEY:String = "task_list_data";
		/*任务字典 - 过滤已经完成的*/
		private var _taskDic:Dictionary = new Dictionary();
		
		private var _allTaskDic:Dictionary = new Dictionary();
		
		public function CJDataOfTaskList()
		{
			super("CJDataOfTaskList");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , this._onDataLoaded);
		}
		
		private function _onDataLoaded(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() == ConstNetCommand.CS_TASK_GETALL)
			{
				if(message.retcode == 1)
				{
					this._initData(message.retparams);
					this._onloadFromRemoteComplete();
					//更新NPC的任务列表
					this._updateStatus("initTask");
				}
			}
		}
		
		private function _initData(obj:Object):void
		{
			for(var taskid:String in obj)
			{
				var task:CJDataOfTask = new CJDataOfTask();
				task.init(obj[taskid]);
				
				_allTaskDic[int(taskid)] = task;
				//过滤已完成任务
				if(task.isTaskRewarded())
				{
					continue;
				}
				this._taskDic[int(taskid)] = task;
			}
			this.setData(DATA_KEY , this._taskDic);
		}
		
		private function _updateStatus(updateType:String):void
		{
			Assert(this._dataIsEmpty == false , "数据还没初始化");
			this.dispatchEventWith(CJEvent.EVENT_TASK_DATA_CHANGE , false , {eventKey:updateType});
		}
		
		/**
		 * 根据任务id获得CJDataOfTask
		 */		
		public function getTaskById(taskid:int):CJDataOfTask
		{
			return this._taskDic[taskid];
		}
		
		/**
		 * 取得taskid的下一个任务
		 * @param taskid
		 */		
		public function getNextTask(taskid:int):CJDataOfTask
		{
			var currentTask:CJDataOfTask = this.getTaskById(taskid);
			var nextTaskid:int = currentTask.taskConfig.nextid;
			if(nextTaskid == 0)
			{
				return null;
			}
			return this._taskDic[nextTaskid];
		}
		
		/**
		 * 计算NPC的当前的任务
		 * @param npcid
		 */		
		public function getNpcCurrentTaskid(npcid:int):int
		{
			//单个NPC身上所有的任务列表，只有可接，已接和可领取奖励
			var tempList:Array = new Array();
			for(var taskid:String in this._taskDic)
			{
				var task:CJDataOfTask = this._taskDic[taskid];
				var status:int = task.status;
				//过滤已经领取过奖励的
				if(status == ConstTask.TASK_REWARDED)
				{
					continue;
				}
				//可接任务，只看接受NPC
				if(status == ConstTask.TASK_CAN_ACCEPT && int(task.taskConfig.npcbegin) == npcid)
				{
					tempList.push(taskid);
				}
				//接受的任务，只看完成NPC
				else if(status >= ConstTask.TASK_ACCEPTED  && int(task.taskConfig.npcend) == npcid)
				{
					tempList.push(taskid);
				}
			}
			//获取npc当前任务
			return this._getNpcTask(tempList);
		}
		
		private function _getNpcTask(taskidList:Array):int
		{
			if(taskidList.length == 0)
			{
				return 0;
			}
			//所有可领取奖励的
			var allCanRewardTaskList:Array = new Array();
			//所有可接受的
			var allCanAcceptTaskList:Array = new Array();
			//所有已经接受的
			var allAcceptedTaskList:Array = new Array();
			for(var i:String in taskidList)
			{
				var taskDao:CJDataOfTask = this._taskDic[taskidList[i]];
				if(CJTaskChecker.isTaskCanReward(taskDao) == 1)
				{
					allCanRewardTaskList.push(taskidList[i]);
				}
				//可接受
				else if(CJTaskChecker.isTaskCanAccept(taskDao))
				{
					allCanAcceptTaskList.push(taskidList[i]);
				}
				//已接受
				else
				{
					allAcceptedTaskList.push(taskidList[i]);
				}
			}
			//从三个列表里面找出一个顺序是可完成 (主线 > 支线) > 可接受(主线 > 支线) > 已接受(主线 > 支线)
			var taskid1:int = _getMainTask(allCanRewardTaskList);
			if(taskid1 != 0 )
			{
				return taskid1;
			}
			taskid1 = _getMainTask(allCanAcceptTaskList);
			if(taskid1 != 0 )
			{
				return taskid1;
			}
			taskid1 = _getMainTask(allAcceptedTaskList);
			if(taskid1 != 0 )
			{
				return taskid1;
			}
			return taskid1;
		}
		
		//如果有主线任务 则是主线任务，否则是其他任务，暂时没做排序，只考虑主线和支线
		private function _getMainTask(taskList:Array):int
		{
			if(taskList.length == 0)
			{
				return 0;
			}
			for(var i:String in taskList)
			{
				if((this._taskDic[taskList[i]] as CJDataOfTask).isMainTask())
				{
					return int(taskList[i]);
				}
			}
			return taskList[0];
		}
		
		/**
		 * 计算NPC当前的状态
		 * 已完成 > 可接受  > 正在执行 > 没有任务
		 */	
		public function getNpcStatus(npcid:int):int
		{
			var currentTaskid:int = getNpcCurrentTaskid(npcid);
			//没有任务
			if(currentTaskid == 0)
			{
				return ConstTask.TASK_NPC_NO_TASK;
			}
			else
			{
				var taskDao:CJDataOfTask = this._taskDic[currentTaskid];
				//可领取奖励
				if(CJTaskChecker.isTaskCanReward(taskDao) == 1)
				{
					return ConstTask.TASK_NPC_TASK_COMPLETED;
				}
				//已接受
				else if(taskDao.status == ConstTask.TASK_ACCEPTED)
				{
					return ConstTask.TASK_NPC_TASK_EXECUTING;
				}
				//可接受
				else if(CJTaskChecker.isTaskCanAccept(taskDao))
				{
					return ConstTask.TASK_NPC_TASK_CAN_ACCEPT;
				}
				//不可接受
				else
				{
					return ConstTask.TASK_NPC_CAN_NOT_ACCEPT;
				}
			}
		}

		/**
		 *  获取可接受任务列表
		 */		
		public function getCanAcceptTaskList():Dictionary
		{
			var tempDic:Dictionary = new Dictionary();
			for(var taskid:String in this._taskDic)
			{
				if((this._taskDic[taskid] as CJDataOfTask).status == ConstTask.TASK_CAN_ACCEPT)
				{
					tempDic[taskid] = this._taskDic[taskid];
				}
			}
			return tempDic;
		}
		
		/**
		 * 激活一个任务成为可接受状态,不判断任务接受条件
		 */		
		private function _activeTask(taskId:int):void
		{
			if(this._taskDic.hasOwnProperty(taskId))
			{
				Assert(false , "任务已经被激活过");
			}
			var task:CJDataOfTask = new CJDataOfTask() ;
			//秒
			task.init({"taskid":taskId,"ctime":new Date().time/1000});
			this._taskDic[taskId] = task;
			Logger.log("--------task------>" , "active next task : "+taskId);
			this.setData(DATA_KEY , this._taskDic);
		}
		
		/**
		 * 接受任务
		 */		
		public function acceptTask(taskid:int):void
		{
			var task:CJDataOfTask = this.getTaskById(taskid);
			task.accept();
			this._updateStatus("acceptTask");
		}
		
		/**
		 * 完成任务
		 */
		public function completeTask(taskid:int):void
		{
			this.getTaskById(taskid).complete();
			this._updateStatus("completeTask");
		}
		
		/**
		 * 领取奖励
		 */		
		public function rewardTask(taskid:int):void
		{
			var task:CJDataOfTask = this.getTaskById(taskid);
			task.reward();
			
//			//激活下一个任务
//			var nextTaskId:int = task.taskConfig.nextid;
//			if(!nextTaskId == 0)
//			{
//				this._activeTask(nextTaskId);
//			}
			this._updateStatus("rewardTask");
		}
		
		/**
		 * 放弃任务
		 */		
		public function abortTask(taskid:int):void
		{
			this.getTaskById(taskid).abort();
			this._updateStatus("abortTask");
		}
		
		/**
		 * 已经接受，但是没有完成的任务字典
		 */		
		public function getUnCompleteTaskList():Dictionary
		{
			var tempDic:Dictionary = new Dictionary();
			for(var taskid:String in this._taskDic)
			{
				var task:CJDataOfTask = this._taskDic[taskid] as CJDataOfTask;
				if(task.status >= ConstTask.TASK_ACCEPTED && task.status <= ConstTask.TASK_COMPLETE)
				{
					tempDic[taskid] = this._taskDic[taskid];
				}
			}
			return tempDic;
		}
		
		/**
		 * 已领取任务列表
		 */		
		public function getAcceptedTaskList():Dictionary
		{
			var tempDic:Dictionary = new Dictionary();
			for(var taskid:String in this._taskDic)
			{
				if((this._taskDic[taskid] as CJDataOfTask).status == ConstTask.TASK_ACCEPTED)
				{
					tempDic[taskid] = this._taskDic[taskid];
				}
			}
			return tempDic;
		}
		
		/**
		 * 已完成任务列表
		 */		
		public function getCompleteTaskList():Dictionary
		{
			var tempDic:Dictionary = new Dictionary();
			for(var taskid:String in this._taskDic)
			{
				if((this._taskDic[taskid] as CJDataOfTask).status == ConstTask.TASK_COMPLETE)
				{
					tempDic[taskid] = this._taskDic[taskid]
				}
			}
			return tempDic;
		}
		
		/**
		 * 已领取奖励列表
		 */		
		public function getRewardedTaskList():Dictionary
		{
			var tempDic:Dictionary = new Dictionary();
			for(var taskid:String in this._allTaskDic)
			{
				if((this._allTaskDic[taskid] as CJDataOfTask).status == ConstTask.TASK_REWARDED)
				{
					tempDic[taskid] = this._allTaskDic[taskid]
				}
			}
			return tempDic;
		}
		
		/**
		 * 已放弃任务列表
		 */		
		public function getAbortTaskList():Dictionary
		{
			var tempDic:Dictionary = new Dictionary();
			for(var taskid:String in this._taskDic)
			{
				if((this._taskDic[taskid] as CJDataOfTask).status == ConstTask.TASK_ABORT)
				{
					tempDic[taskid] = this._taskDic[taskid]
				}
			}
			return tempDic;
		}
		
		/**
		 * 获取当前的主线任务
		 */		
		public function getCurrentMainTask():CJDataOfTask
		{
			for(var taskid:String in this._taskDic)
			{
				var task:CJDataOfTask = this._taskDic[taskid];
				if(task.isMainTask() && task.status != ConstTask.TASK_REWARDED)
				{
					return task;
				}
			}
			return null;
		}
		
		override public function clearAll():void
		{
			_taskDic = null;
			_taskDic = new Dictionary();
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData , this._onDataLoaded);
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			SocketCommand_Task.getTaskList();
		}

		public function get taskDic():Dictionary
		{
			return _taskDic;
		}
	}
}