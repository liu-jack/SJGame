package SJ.Game.task.npcdialogdata
{
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Game.NPCDialog.CJNPCDialogActionObject;
	import SJ.Game.data.CJDataOfTask;
	import SJ.Game.lang.CJLang;
	import SJ.Game.player.CJPlayerData;
	
	/**
	 +------------------------------------------------------------------------------
	 * 可完成任务点击后UI数据
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-15 下午1:52:32  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskNpcDialogCompleteClickedData extends CJTaskNpcDialogDataBase
	{
		private var _task:CJDataOfTask ; 
		
		public function CJTaskNpcDialogCompleteClickedData(npcData:CJPlayerData)
		{
			super(npcData);
		}
		
		/**
		 * 传入到UI的数据
		 */		
		override public function flushData(task:CJDataOfTask):void
		{
			_task = task;
			this.content = CJLang(this._task.taskConfig.desckey+"DESC_END");
			this._drawAction();
			//显示奖励
//			this._showReward();
		}
		
		private function _drawAction():void
		{
			var actoinArray:Array = new Array();
			var actionData:CJNPCDialogActionObject = new CJNPCDialogActionObject();
			actionData.actionName = CJLang("TASK_REWARD");
			actionData.specialIconType = ConstNPCDialog.IconType_Wenhao_SHI;
			actoinArray.unshift(actionData);
			actionData.recallParams = {task:_task , type:CJTaskActionType.COMPLETE_CLICKED};
			this.NPCActionObjectArray = actoinArray;
		}
	}
}