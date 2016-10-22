package SJ.Game.task
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstTask;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfTask;
	import SJ.Game.event.CJEvent;
	
	import engine_starling.utils.Logger;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	/**
	 +------------------------------------------------------------------------------
	 * 任务事件处理器，负责监听外部各种操作的事件
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-2 上午10:52:03  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskEventHandler extends EventDispatcher
	{
		private static var INSTANCE:CJTaskEventHandler = null;
		
		public function CJTaskEventHandler()
		{
			super();
			this.addEventListener(CJEvent.EVENT_TASK_ACTION_EXECUTED , this._actionHandler);
		}
		
		public static function get o():CJTaskEventHandler
		{
			if(null == INSTANCE)
			{
				INSTANCE = new CJTaskEventHandler();
			}
			return INSTANCE;
		}
		
		/**
		 * 实际处理各种事件
		 * @return boolean :返回是否有数据发生变化
		 */		
		public function _actionHandler(e:Event):void
		{
			if(e.target is CJTaskEventHandler && e.type == CJEvent.EVENT_TASK_ACTION_EXECUTED)
			{
				var data:Object = e.data;
				Logger.log("-------- CJEvent.EVENT_TASK_ACTION_EXECUTED ----------" , "type => "+data.type);
				var handlerRet:Object = {};
				handlerRet.dataChanged = false;
				if(data.type == CJTaskEvent.TASK_EVENT_HUNT)
				{
					handlerRet = this._huntHandler(data);
				}
				else if(data.type == CJTaskEvent.TASK_EVENT_COLLECTNORMAL)
				{
					handlerRet = this._collectHandler(data);
				}
				else
				{
					//尝试完成任务
					var tasks:Dictionary = CJDataManager.o.DataOfTaskList.getAcceptedTaskList();
					
					var count:int = 0 ;
					
					for(var taskid:String in tasks)
					{
						count++;
						var task:CJDataOfTask = tasks[taskid];
						CJTaskManager.o.complete(int(taskid));
					}
					if(count > 0 )
					{
						CJDataManager.o.DataOfTaskList.loadFromRemote();
					}
				}
			}
		}
		
		private function _collectHandler(data:Object):Object
		{
			var tasks:Dictionary = CJDataManager.o.DataOfTaskList.getAcceptedTaskList();
			for(var taskid:String in tasks)
			{
				var task:CJDataOfTask = tasks[taskid];
				if(task.taskConfig.action1 == ConstTask.TASK_ACTION_COLLECTNORMAL)
				{
					Logger.log("--------collect handler---check task--->" , "taskid:"+task.taskId);
					CJTaskManager.o.complete(int(taskid));
				}
				
			}
			return {};
		}
		
		private function _huntHandler(data:Object):Object
		{
//			ret 0 -打赢 1 -打输
			if(int(data["ret"]) != 0 )
			{
				return null;
			}
			//怪物id
			var monsteridList:Array = data.npcidlist;
			var tasks:Dictionary = CJDataManager.o.DataOfTaskList.getAcceptedTaskList();
			for(var taskid:String in tasks)
			{
				var task:CJDataOfTask = tasks[taskid];
				Logger.log("--------hunt handler---check task--->" , "taskid:"+task.taskId);
				for(var j:int = 1 ; j<= ConstTask.ACTION_NUM ; j++)
				{
					if(task.taskConfig["action"+j] != undefined && int(task.taskConfig["action"+j]) == ConstTask.TASK_ACTION_HUNT && task.taskConfig["key"+j] && monsteridList.indexOf(int(task.taskConfig["key"+j])) != -1 )
					{
						CJTaskManager.o.complete(int(taskid));
						CJDataManager.o.DataOfTaskList.loadFromRemote();
					}
				}
			}
			return {};
		}
	}
}