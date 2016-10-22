package SJ.Game.task
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTask;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfTask;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.task.util.CJTaskRewardUtil;
	
	import engine_starling.utils.Logger;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	/**
	 +------------------------------------------------------------------------------
	 * 任务管理类，对外接口，负责任务的条件检测，任务的状态切换 ， 每次ACTION手动操作去完成任务
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-25 下午3:44:08  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskManager extends EventDispatcher
	{
		private static var INSTANCE:CJTaskManager = null;
		
		public function CJTaskManager()
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , this._serverEventHandler);
		}
		
		public static function get o():CJTaskManager
		{
			if( null == INSTANCE)
			{
				INSTANCE = new CJTaskManager();
			}
			return INSTANCE;
		}
		
		/**
		 * 服务端请求返回事件处理
		 */		
		private function _serverEventHandler(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			var retCode:int = message.params(0);
			if(retCode == 1)
			{
				var taskid:int = int(message.retparams);
				if(message.getCommand() == ConstNetCommand.CS_TASK_ACCEPTTASK)
				{
					Logger.log("--------task------>" , "accept task succ: "+taskid);
					CJDataManager.o.DataOfTaskList.acceptTask(taskid);
					this._onAcceptTask(taskid);
				}
				else if(message.getCommand() == ConstNetCommand.CS_TASK_COMPLETETASK)
				{
					Logger.log("--------task------>" , "complete task succ: "+taskid);
					CJDataManager.o.DataOfTaskList.completeTask(taskid);
					CJDataManager.o.DataOfTaskList.loadFromRemote();
				}
				else if(message.getCommand() == ConstNetCommand.CS_TASK_REWARDTASK)
				{
					Logger.log("--------task------>" , "reward task succ: "+taskid);
					CJDataManager.o.DataOfTaskList.rewardTask(taskid);
					this._onRewardTask(taskid);
				}
				else if(message.getCommand() == ConstNetCommand.CS_TASK_ABORTTASK)
				{
					Logger.log("--------task------>" , "abort task succ: "+taskid);
					CJDataManager.o.DataOfTaskList.abortTask(taskid);
				}
				else if(message.getCommand() == ConstNetCommand.SC_SYNC_SELF_UPLEVEL)
				{
					Logger.log("--------task------>" , "uplevel happende update task data!");
					CJDataManager.o.DataOfTaskList.loadFromRemote();
				}
			}
		}
		
		private function _onAcceptTask(taskid:int):void
		{
			//如果是道具对话，需要刷背包
			var task:CJDataOfTask = CJDataManager.o.DataOfTaskList.getTaskById(taskid);
			var action:int = int(task.taskConfig.action1);
			if(action == ConstTask.TASK_ACTION_ITEM_TALK || action == ConstTask.TASK_ACTION_TALK)
			{
				//直接发出对话的操作
				CJTaskEventHandler.o.dispatchEventWith(CJEvent.EVENT_TASK_ACTION_EXECUTED , false , {"type":action});
			}
			
			if(action == ConstTask.TASK_ACTION_ITEM_TALK)
			{
				CJDataManager.o.DataOfBag.loadFromRemote();
			}
			//收集类任务
			if(action == ConstTask.TASK_ACTION_COLLECTNORMAL || action == ConstTask.TASK_ACTION_COLLECTTASK)
			{
				this.complete(taskid);
			}
			
			new CJTaskFlowImage("texiaozi_jieshouxinrenwu" , 1 , 10 , 0 , -100).addToLayer();
			
			//刷新数据
			CJDataManager.o.DataOfTaskList.loadFromRemote();
		}
		
		private function _onRewardTask(taskid:int):void
		{
			CJDataManager.o.DataOfBag.loadFromRemote();
			//更新界面
			SocketCommand_hero.get_heros();
			SocketCommand_role.get_role_info();
			//飘奖励的字
			Starling.juggler.delayCall(function():void
			{
				new CJTaskFlowString(CJTaskRewardUtil.rewardString(CJDataManager.o.DataOfTaskList.getTaskById(taskid).taskConfig)  , 2 , 10).addToLayer();
			},1
			);
			
			new CJTaskFlowImage("texiaozi_renwuwancheng" , 1 , 10 , 0 , -100).addToLayer();
			
			//刷新数据
			CJDataManager.o.DataOfTaskList.loadFromRemote();
			
			//活跃度刷新
			CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false , {"key":CJActivityEventKey.ACTIVITY_COMPLETETASK , "data":taskid});
		}
		
		/**
		 * 接受任务
		 */		
		public function accept(taskid:int):void
		{
			var task:CJDataOfTask = CJDataManager.o.DataOfTaskList.getTaskById(taskid);
			if(!task || !CJTaskChecker.isTaskCanAccept(task))
			{
				return ;
			}
			
			Logger.log("--------task------>" , "try accept task : "+taskid);
			SocketManager.o.call(ConstNetCommand.CS_TASK_ACCEPTTASK , taskid);
		}
		
		/**
		 * 完成任务
		 */
		public function complete(taskid:int):void
		{
			var task:CJDataOfTask = CJDataManager.o.DataOfTaskList.getTaskById(taskid);
			if(!task || !CJTaskChecker.isTaskCanComplete(task))
			{
				return ;
			}
			Logger.log("--------task------>" , "try complete task : "+taskid);
			SocketManager.o.call(ConstNetCommand.CS_TASK_COMPLETETASK , taskid);
		}
		
		/**
		 * 领取奖励
		 */		
		public function reward(taskid:int):void
		{
			var task:CJDataOfTask = CJDataManager.o.DataOfTaskList.getTaskById(taskid);
			if(!task)
			{
				return ;
			}
			
			//背包已满。
			if(!CJTaskRewardUtil.canPutRewardInBag(task.taskConfig))
			{
				CJMessageBox(CJLang("ITEM_MAKE_RESULT_STATE_BAG_FULL"));
				return;
			}
			
			if(CJTaskChecker.isTaskCanReward(task) != 1)
			{
				return;
			}
			Logger.log("--------task------>" , "try reward task : "+taskid);
			SocketManager.o.call(ConstNetCommand.CS_TASK_REWARDTASK, taskid);
		}
		
		/**
		 * 放弃任务
		 */		
		public function abort(taskid:int):void
		{
			var task:CJDataOfTask = CJDataManager.o.DataOfTaskList.getTaskById(taskid);
			if(!task || !CJTaskChecker.isTaskCanAbort(task))
			{
				return ;
			}
			Logger.log("--------task------>" , "try abort task : "+taskid);
			SocketManager.o.call(ConstNetCommand.CS_TASK_ABORTTASK, taskid);
		}
	}
}