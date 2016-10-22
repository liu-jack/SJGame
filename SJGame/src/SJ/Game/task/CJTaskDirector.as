package SJ.Game.task
{
	import SJ.Common.Constants.ConstTask;
	import SJ.Game.data.CJDataOfTask;
	import SJ.Game.data.json.Json_task_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.task.util.CJTaskPathUtil;
	
	import engine_starling.SApplication;
	import engine_starling.utils.Logger;

	/**
	 +------------------------------------------------------------------------------
	 * 任务各类操作指引导航
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-3 下午8:13:21  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskDirector
	{
		private var _task:CJDataOfTask;
		
		public function CJTaskDirector(task:CJDataOfTask)
		{
			this._task = task;
		}
		
		/**
		 * 根据任务的当前状态进行任务导航
		 */		
		public function navigate():void
		{
			//todo : 需处理销毁数据
			if(_task == null)
			{
				return ;
			}
			
			//可接 -- 接受NPC
			if(this._task.status == ConstTask.TASK_CAN_ACCEPT)
			{
				this._acceptNavigate();
			}
			//执行中
			else if(this._task.status == ConstTask.TASK_ACCEPTED)
			{
				this._executingNavigate();
			}
			//完成 -- 完成NPC
			else if(this._task.status == ConstTask.TASK_COMPLETE)
			{
				this._completeNavigate();
			}
		}
		
		private function _completeNavigate():void
		{
			var pathUtil:CJTaskPathUtil = new CJTaskPathUtil();
			var endNpc:int = this._task.taskConfig.npcend;
			var gid:int = this._task.taskConfig.key2
			CJEventDispatcher.o.dispatchEventWith(CJEvent.Event_Task_GuideNpc , false , {"npcid":endNpc,"gid":gid, "type":"autonavigate"});
		}
		
		private function _acceptNavigate():void
		{
			var pathUtil:CJTaskPathUtil = new CJTaskPathUtil();
			var beginNpc:int = this._task.taskConfig.npcbegin;
			var gid:int = this._task.taskConfig.key2
			CJEventDispatcher.o.dispatchEventWith(CJEvent.Event_Task_GuideNpc , false , {"npcid":beginNpc , "gid":gid,"type":"autonavigate"});
		}
		
		private function _executingNavigate():void
		{
			//todo: 暂时只对一种action的进行导航，后续如果有多个任务完成条件，需要建立导航规则
			var type:int = this._task.taskConfig.action1;
			switch(type)
			{
				case ConstTask.TASK_ACTION_TALK:
					this._talkNavigate();
					break;
				case ConstTask.TASK_ACTION_USE_TOOL:
					this._userToolNavigate();
					break;
				case ConstTask.TASK_ACTION_HUNT:
					this._huntNavigate();
					break;
				case ConstTask.TASK_ACTION_COLLECTNORMAL:
					this._collectNavigate();
					break;
				case ConstTask.TASK_ACTION_EQUIPMENT:
					this._equipNavigate();
					break;
				case ConstTask.TASK_ACTION_ENTER:
					this._enterNavigate();
					break;
				case ConstTask.TASK_ACTION_PK:
					this._pkNavigate();
					break;
				case ConstTask.TASK_ACTION_LEVELUP:
					this._upLevelNavigate();
					break;
				case ConstTask.TASK_ACTION_ITEM_TALK:
					this._itemTalkNavigate();
				case ConstTask.TASK_ACTION_JOIN_CAMP:
					this._joinCampNavigate();
					break;
				default:
					break;
			}
		}
		
		private function _upLevelNavigate():void
		{
			Logger.log("----------------------->" , "navigate to upLevel");
			// TODO Auto Generated method stub
		}
		
		private function _pkNavigate():void
		{
			Logger.log("----------------------->" , "navigate to pk");
			// TODO Auto Generated method stub
		}
		
		private function _enterNavigate():void
		{
			Logger.log("----------------------->" , "navigate to enter");
			// TODO Auto Generated method stub
		}
		
		private function _equipNavigate():void
		{
			Logger.log("----------------------->" , "navigate to equipment");
			SApplication.moduleManager.enterModule("CJHeroPropertyUIModule");
		}
		
		private function _collectNavigate():void
		{
			Logger.log("----------------------->" , "navigate to collect");
			// TODO Auto Generated method stub
		}
		
		private function _joinCampNavigate():void
		{
			Logger.log("----------------------->" , "navigate to joinCamp");
			var config:Json_task_setting = this._task.taskConfig;
			if(int(config.action1) != ConstTask.TASK_ACTION_JOIN_CAMP)
			{
				return;
			}
			SApplication.moduleManager.enterModule("CJCampModule");
		}
		
		private function _huntNavigate():void
		{
			Logger.log("----------------------->" , "navigate to hunt");
			
			var config:Json_task_setting = this._task.taskConfig;
			if(int(config.action1) != ConstTask.TASK_ACTION_HUNT)
			{
				return;
			}
			var gid:int = this._task.taskConfig.key2
			CJEventDispatcher.o.dispatchEventWith(
				CJEvent.Event_Task_GuideNpc , 
				false , 
				{"npcid":this._task.taskConfig.key1,"gid":gid,"type":"autonavigate"}
			);
		}
		
		private function _userToolNavigate():void
		{
			Logger.log("----------------------->" , "navigate to collect");
			SApplication.moduleManager.enterModule("CJBagModule");
		}
		
		/**
		 * 简单对话
		 */		
		private function _talkNavigate():void
		{
			Logger.log("----------------------->" , "navigate to talk");
			//发出对话事件
			CJTaskEventHandler.o.dispatchEventWith(CJEvent.EVENT_TASK_ACTION_EXECUTED 
				, false 
				, {"type":CJTaskEvent.TASK_EVENT_TALK , "npcid":this._task.taskConfig.npcend});
			CJEventDispatcher.o.dispatchEventWith(CJEvent.Event_Task_GuideNpc , false , {"npcid":this._task.taskConfig.npcend,"gid":this._task.taskConfig.key2, "type":"autonavigate"});
		}
		
		/**
		 * 道具对话处理
		 */		
		private function _itemTalkNavigate():void
		{
			Logger.log("----------------------->" , "navigate to itemtalk");
			//发出对话事件
			CJTaskEventHandler.o.dispatchEventWith(CJEvent.EVENT_TASK_ACTION_EXECUTED 
				, false 
				, {"type":CJTaskEvent.TASK_EVENT_ITEM_TALK , "npcid":this._task.taskConfig.npcend});
			CJEventDispatcher.o.dispatchEventWith(CJEvent.Event_Task_GuideNpc , false , {"npcid":this._task.taskConfig.npcend,"gid":this._task.taskConfig.key2, "type":"autonavigate"});
		}
	}
}