package SJ.Game.task.npcdialogdata
{
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstTask;
	import SJ.Game.NPCDialog.CJNPCDialogActionObject;
	import SJ.Game.NPCDialog.CJNPCDialogContentObject;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfTask;
	import SJ.Game.lang.CJLang;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.task.CJTaskChecker;
	import SJ.Game.task.CJTaskType;
	import SJ.Game.task.util.CJTaskHtmlUtil;
	
	import lib.engine.utils.functions.Assert;
	
	/**
	 +------------------------------------------------------------------------------
	 * @comment NPC对话框数据基类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-15 上午11:51:35  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskNpcDialogDataBase extends CJNPCDialogContentObject
	{
		/*NPC的数据*/
		protected var _npcData:CJPlayerData;
		
		public function CJTaskNpcDialogDataBase(npcData:CJPlayerData)
		{
			super();
			this._npcData = npcData;
			var npcid:int = _npcData.templateId;
			var taskid:int =  CJDataManager.o.DataOfTaskList.getNpcCurrentTaskid(npcid);
			this.createContentData(taskid);
			//更新的action
			this.createActionData(taskid);
			//奖励信息
			this.createRewardData(taskid);
		}
		
		protected function createContentData(taskid:int):void
		{
			var task:CJDataOfTask = CJDataManager.o.DataOfTaskList.getTaskById(taskid);
			//半身像
			this.portraitResourceName = "banshenxiang_" + this._npcData.playerAnim;
			//名字
			this.npcName = this._npcData.displayName;
			//对话框内容
			if(task && CJTaskChecker.isTaskCanAccept(task))
			{
				this.content = CJLang(task.taskConfig.desckey+"DESC_BEGIN");
			}
			else if (task && CJTaskChecker.isTaskCanReward(task) == 1)
			{
				this.content = CJLang(task.taskConfig.desckey+"DESC_END");
			}
			else
			{
				this.content = CJLang("NPC_TALK_"+ _npcData.templateId);
			}
		}
		
		/**
		 * 显示的可点击的action
		 */		
		protected function createActionData(taskid:int):void
		{
			if(taskid == 0)
			{
				return;
			}
			var actoinArray:Array = new Array();
			var task:CJDataOfTask = CJDataManager.o.DataOfTaskList.getTaskById(taskid);
			actoinArray.unshift(this._createAction(task));
			this.NPCActionObjectArray = actoinArray;
		}
		
		private function _createAction(t:CJDataOfTask):CJNPCDialogActionObject
		{
			var actionData:CJNPCDialogActionObject = new CJNPCDialogActionObject();
			//任务状态--是否完成
			var statusText:String = "";
			//任务的符号--叹号，问号
			var signal:int = -1;
			//任务点击回调
			var recallParams:Object = {task:t};
			
			if(t.status == ConstTask.TASK_CAN_ACCEPT)
			{
				if(!CJTaskChecker.isTaskCanAccept(t))
				{
					signal = ConstNPCDialog.IconType_TanHao_xu;
					actionData.levelLimit = "  (" +CJLang("TASK_ACCEPT_LEVEL_LIMIT" , {'level':t.acceptLevel})+")";
				}
				else
				{
					signal = ConstNPCDialog.IconType_Tanhao_SHI;
				}
				statusText = CJTaskHtmlUtil.buttonText(CJLang("TASK_UNACCEPT")); 
				recallParams = {task:t , type:CJTaskActionType.CAN_ACCEPT_CLICKED};
				this.buttonText = CJLang("TASK_ACCEPT");
			}
			else if(CJTaskChecker.isTaskCanReward(t) == 1)
			{
				statusText = CJTaskHtmlUtil.buttonText(CJLang("TASK_COMPLETE")); 
				signal = ConstNPCDialog.IconType_Wenhao_SHI;
				recallParams = {task:t , type:CJTaskActionType.CAN_COMPLETE_CLICKED};
				this.buttonText = CJLang("TASK_REWARD");
			}
			else if(t.status == ConstTask.TASK_ACCEPTED)
			{
				statusText = CJTaskHtmlUtil.buttonText(CJLang("TASK_UNCOMPLETE")); 
				signal = ConstNPCDialog.IconType_Wenhao_xu;
				this.buttonText = CJLang("TASK_LABEL_IMPLEMENT");
			}
			
			var type:String = getTaskTypeText(t);
			var taskName:String = CJLang(t.taskConfig.desckey+"NAME");
			actionData.actionName = type + CJTaskHtmlUtil.space+taskName + CJTaskHtmlUtil.space + statusText;
			actionData.specialIconType = signal;
			actionData.recallParams = recallParams;
			
			return actionData;
		}
		
		/**
		 * 传入到UI的数据
		 */		
		public function flushData(task:CJDataOfTask):void
		{
			Assert(false , "子类需要重载该方法 data");
		}
		
		/**
		 * 获取主|支|环等
		 */		
		protected function getTaskTypeText(task:CJDataOfTask):String
		{
			var langType:String = "";
			if(task.taskConfig.tasktype == CJTaskType.TASK_MAIN)
			{
				langType = "TASK_TYPE_MAIN";
			}
			else if(task.taskConfig.tasktype == CJTaskType.TASK_BRANCH)
			{
				langType = "TASK_TYPE_BRANCH";
			}
			var type:String = CJTaskHtmlUtil.colorText(CJLang(langType) , "#4AFD2C") ;
			return type;
		}
		
		private function createRewardData(taskid:int):void
		{
			if(taskid == 0)
			{
				return;
			}
			var task:CJDataOfTask = CJDataManager.o.DataOfTaskList.getTaskById(taskid);
			//显示银两 ， 经验
			this.rewardExp = task.taskConfig.expr;
			this.rewardYinliang = task.taskConfig.silver;
			//显示奖励的物品
			var itemList:Array = getRewardIdList(task);
			this.rewardItemIdArray = itemList;
		}
		
		//获得奖励的物品列表
		protected function getRewardIdList(task:CJDataOfTask):Array
		{
			var itemList:Array = new Array();
			
			for(var i:int = 1 ; i<= 4 ; i++)
			{
				var rewardTemplateId:int = int(task.taskConfig["reward"+i]);
				var num:int = int(task.taskConfig["num"+i]);
				if(rewardTemplateId > 0 && num > 0 )
				{
					itemList.push({"id":rewardTemplateId , "count":num});
				}
			}
			return itemList;
		}
		
		public function clearData():void
		{
			this._npcData = null;
		}
	}
}