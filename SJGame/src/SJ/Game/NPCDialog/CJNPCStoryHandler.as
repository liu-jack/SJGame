package SJ.Game.NPCDialog
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfNpcTalkProperty;
	
	import engine_starling.SApplication;
	
	import flash.utils.Dictionary;

	public class CJNPCStoryHandler
	{
		public function CJNPCStoryHandler()
		{
			
		}
		/**
		 *  执行任务剧情
		 * @param taskId 任务ID
		 * @param step 0:接受任务 1:完成任务
		 * 
		 */		
		public static function executeTaskStory(taskId:String,status:int,callBack:Function):void
		{
			//任务剧情配置
//			var taskStoryConfig:Json_task_story_setting = CJDataOfTaskStoryProperty.o.getConfigById(taskId);
//			if(!taskStoryConfig)
//			{
//				callBack();
//				return;
//			}
//			var confdata:String = "";
//			if(status == ConstTask.TASK_ACCEPTED)
//			{
//				confdata = taskStoryConfig.accepttask
//			}
//			else if(status == ConstTask.TASK_REWARDED)
//			{
//				confdata = taskStoryConfig.finishtask
//			}
//			if(!confdata)
//				callBack();
//				return;
//			var dataArr:Array = taskStoryConfig.accepttask.split("&")
//			var npcId:int = dataArr[0]
//			var talkId:int = dataArr[1]
//			//对白配置
//			var talkConfig:Array = CJDataOfNpcTalkProperty.o.getConfigById(talkId)
//			if(!talkConfig)
//			{
//				callBack();
//				return;
//			}
//			//进入剧情对白模块
//			SApplication.moduleManager.enterModule("CJNPCTaskDialogMoudle",{"npcid":npcId,"content":talkConfig,"callback":function():void
//			{
//				callBack();
//			}});
		}
		
		/**
		 * 副本战斗 剧情检测，通过已经接受的任务反查任务剧情配置。
		 * 
		 */		
		public static function checkBattleStory(TaskId:int,NPCId:int,storyId:int,callBack:Function):void
		{
			var acceptTaskList:Dictionary = CJDataManager.o.DataOfTaskList.getAcceptedTaskList();
//			//只有接受了任务才显示剧情
			if(acceptTaskList.hasOwnProperty(TaskId))
			{
				var talkConfig:Array = CJDataOfNpcTalkProperty.o.getConfigById(storyId)
				//进入剧情对白模块
				SApplication.moduleManager.enterModule("CJNPCTaskDialogMoudle",{"npcid":NPCId,"content":talkConfig,"callback":function():void
				{
					callBack();
				}});
			}
			else
			{
				callBack();
			}
		}
	}
}