package SJ.Game.activity
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	
	import engine_starling.data.SDataBase;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 活跃度agent 发事件
	 * CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false , {"key":CJActivityEventKey.ACTIVITY_HORSEUPGRADE});
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-5 下午2:45:35  
	 +------------------------------------------------------------------------------
	 */
	public class CJActivityManager extends SDataBase
	{
		public function CJActivityManager()
		{
			super("CJActivityManager");
			this.addEventListener(CJEvent.EVENT_ACTIVITY_HAPPEN , this._onActivityHappened);
		}
		
		private function _onActivityHappened(e:Event):void
		{
			var activityKey:String = e.data.key;
			var data:Object = e.data.data;
			
			//过滤已经完成 || 没有开启的
			if(activityKey && CJDataManager.o.DataOfActivity.isActionCompleted(activityKey))
			{
				return;
			}
			
			
			CJDataManager.o.DataOfActivity.loadFromRemote();
			
//			//完成任务需要特殊处理
//			if(activityKey == CJActivityEventKey.ACTIVITY_COMPLETETASK)
//			{
//				//检测任务是否已经完成
//				var json:Json_activity_progress_setting = CJDataOfActivityPropertyList.o.getConfigByKey(activityKey);
//				var taskid:int = json.condition;
//				if(!data.hasOwnProperty('taskid') || data.taskid != taskid)
//				{
//					return;
//				}
//				CJDataManager.o.DataOfActivity.loadFromRemote();
//			}
//			else
//			{
//				CJDataManager.o.DataOfActivity.loadFromRemote();
//			}
		}
	}
}
