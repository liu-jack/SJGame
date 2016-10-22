package SJ.Game.task
{
	import SJ.Common.Constants.ConstTask;
	import SJ.Game.NPCDialog.CJNPCDialogContentObject;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfTask;
	import SJ.Game.data.CJDataOfTaskList;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.task.npcdialogdata.CJTaskActionType;
	import SJ.Game.task.npcdialogdata.CJTaskNpcDialogDataBase;
	
	import engine_starling.SApplication;
	import engine_starling.utils.Logger;
	import engine_starling.utils.SStringUtils;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	/**
	 +------------------------------------------------------------------------------
	 * NPC点击处理 显示对话框，调用任务逻辑
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-4 下午5:00:34  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskUIHandler extends EventDispatcher
	{
		private static var INSTANCE:CJTaskUIHandler;
		private var _taskList:CJDataOfTaskList;
		private var _npcData:CJPlayerData;
		private var _task:CJDataOfTask;
		
		public function CJTaskUIHandler()
		{
			super();
			this._taskList = CJDataManager.o.DataOfTaskList;
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_NPCDIALOG_ACTIONCLICKED , _actionClicked);
		}
		
		public static function get o():CJTaskUIHandler
		{
			if(null == INSTANCE)
			{
				INSTANCE = new CJTaskUIHandler();
			}
			return INSTANCE;
		}
		
		private function _actionClicked(e:Event):void
		{
			if(e.target is CJEventDispatcher)
			{
				this._task = e.data.task;
				handleAction(e.data);
			}
		}
		
		/**
		 * 处理action点击事件
		 */		
		protected function handleAction(data:Object):void
		{
			var status:int = _task.status;
			var clickType:String = data.type;
			//可接受任务点击处理
			if(status == ConstTask.TASK_CAN_ACCEPT)
			{
				this._handleCanAcceptAction(clickType);
			}
			//已经接受 ，点击导航
			else if(status == ConstTask.TASK_ACCEPTED)
			{
				this._handleAcceptedAction(clickType);
			}
			//可完成任务点击处理
			else if(status == ConstTask.TASK_COMPLETE)
			{
				this._handleCompleteAction(clickType);
			}
		}
		
		private function _handleCompleteAction(type:String):void
		{
			//完成页面，领取奖励，激活下一个任务界面
			if(type == CJTaskActionType.CAN_COMPLETE_CLICKED)
			{
				if(!this._checkCanReward(_task))
				{
					CJMessageBox(CJLang("TASK_REWARD_BAG_FULL"));
					return;
				}
				//发请求加奖励
				CJTaskManager.o.reward(_task.taskId);
				SApplication.moduleManager.exitModule("CJNPCDialogModule");
				var taskList:CJDataOfTaskList = CJDataManager.o.DataOfTaskList;
				taskList.addEventListener(CJEvent.EVENT_TASK_DATA_CHANGE , this._onRewardEvent);
			}
		}
		
		private function _checkCanReward(task:CJDataOfTask):Boolean
		{
			var itemList:Array = new Array();
			var data:Object = new Object();
			var configList:String = task.taskConfig.rewardlist;
			
			if(SStringUtils.isEmpty(configList))
			{
				return true;
			}
			var list:Array = configList.split("&");
			for(var i:String in list)
			{
				data[list[i]] = 1;
				itemList.unshift(data);
			}
			return CJItemUtil.canPutItemsInBag(CJDataManager.o.DataOfBag , itemList);
		}
		
		private function _handleAcceptedAction(clickType:String):void
		{
			SApplication.moduleManager.exitModule("CJNPCDialogModule");
			//执行导航
			new CJTaskDirector(_task).navigate();
		}
		
		private function _handleCanAcceptAction(type:String):void
		{
			//可接点击，进入接受页面
			if(type == CJTaskActionType.CAN_ACCEPT_CLICKED)
			{
				//等级不够，提示
				if(!CJTaskChecker.isTaskCanAccept(_task))
				{
					CJMessageBox(CJLang("TASK_ACCEPT_LEVEL_ILEGAL" , {'level':_task.acceptLevel}));
					SApplication.moduleManager.exitModule("CJNPCDialogModule");
					return;
				}
				
				var taskList:CJDataOfTaskList = CJDataManager.o.DataOfTaskList;
				taskList.addEventListener(CJEvent.EVENT_TASK_DATA_CHANGE , this._doNavigate);
				CJTaskManager.o.accept(_task.taskId);
				SApplication.moduleManager.exitModule("CJNPCDialogModule");
			}
		}
		
		/**
		 * 接受任务导航
		 */
		private function _doNavigate(e:Event):void
		{
			if(e.data.eventKey == "acceptTask")
			{
				Logger.log("--------------->" , "_doNavigate");
				new CJTaskDirector(_task).navigate();
				CJDataManager.o.DataOfTaskList.removeEventListener(CJEvent.EVENT_TASK_DATA_CHANGE , this._doNavigate)
			}
		}
		
		private function _onRewardEvent(e:Event):void
		{
			if(e.data.eventKey == "rewardTask")
			{
				var taskList:CJDataOfTaskList = CJDataManager.o.DataOfTaskList;
				var npcid:int = this._npcData.templateId;
				//打开下一个对话框 仅主线,需要检测是否是主线
//				var npcTaskDic:Dictionary = taskList.npcTaskDic;
//				if(npcTaskDic.hasOwnProperty(npcid))
//				{
//					CJTaskUIHandler.o.npcClick(_npcData);
//				}
				taskList.removeEventListener(CJEvent.EVENT_TASK_DATA_CHANGE , this._onRewardEvent);
				
				//更新人物属性UI界面
				SocketCommand_role.get_role_info();
			}
		}
		
		/**
		 * 处理NPC点击
		 */		
		public function npcClick(npc:CJPlayerData):void
		{
			this._npcData = npc;
//			var npcStatus:int = _taskList.getNpcStatus(_npcData.templateId);
			SApplication.moduleManager.enterModule("CJNPCDialogModule" , _createData());
		}
		
		private function _createData():Object
		{
			var normalData:CJNPCDialogContentObject = new CJTaskNpcDialogDataBase(_npcData);
			return normalData;
		}
	}
}