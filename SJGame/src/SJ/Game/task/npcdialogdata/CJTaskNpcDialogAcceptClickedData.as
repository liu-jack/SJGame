package SJ.Game.task.npcdialogdata
{
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Game.NPCDialog.CJNPCDialogActionObject;
	import SJ.Game.data.CJDataOfTask;
	import SJ.Game.lang.CJLang;
	import SJ.Game.player.CJPlayerData;
	
	/**
	 +------------------------------------------------------------------------------
	 * 可接受任务点击后UI数据
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-15 下午1:52:32  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskNpcDialogAcceptClickedData extends CJTaskNpcDialogDataBase
	{
		private var _task:CJDataOfTask ; 
		
		public function CJTaskNpcDialogAcceptClickedData(npcData:CJPlayerData)
		{
			super(npcData);
		}
		
		/**
		 * 传入到UI的数据
		 */		
		override public function flushData(task:CJDataOfTask):void
		{
			_task = task;
			this.content = CJLang(this._task.taskConfig.desckey+"DESC_BEGIN");
			this._drawAction();
		}
		
		private function _drawAction():void
		{
			var actoinArray:Array = new Array();
			var actionData:CJNPCDialogActionObject = new CJNPCDialogActionObject();
			actionData.actionName = CJLang("TASK_ACCEPT");
			actionData.specialIconType = ConstNPCDialog.IconType_Tanhao_SHI;
			actoinArray.unshift(actionData);
			actionData.recallParams = {task:_task , type:CJTaskActionType.ACCEPT_CLICKED};
			this.NPCActionObjectArray = actoinArray;
		}
	}
}