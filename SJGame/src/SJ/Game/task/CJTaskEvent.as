package SJ.Game.task
{
	/**
	 +------------------------------------------------------------------------------
	 * 任务事件类型 - 对应于实际的操作
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-25 下午3:03:48  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskEvent
	{
		/***************************任务各种操作事件************************************/
		/*与NPC对话*/
		public static const TASK_EVENT_TALK:String = "TASK_EVENT_TALK";
		/*使用道具*/
		public static const TASK_EVENT_USE_TOOL:String = "TASK_EVENT_USE_TOOL";
		/*打怪*/
		public static const TASK_EVENT_HUNT:String = "TASK_EVENT_HUNT";
		/*收集普通物品*/
		public static const TASK_EVENT_COLLECTNORMAL:String = "TASK_EVENT_COLLECTNORMAL";
		/*穿装备*/
		public static const TASK_EVENT_EQUIPMENT:String = "TASK_EVENT_EQUIPMENT";
		/*进入某地*/
		public static const TASK_EVENT_ENTER:String = "TASK_EVENT_ENTER";
		/*PK*/
		public static const TASK_EVENT_PK:String = "TASK_EVENT_PK";
		/*升级*/
		public static const TASK_EVENT_LEVELUP:String = "TASK_EVENT_LEVELUP";
		/*道具对话*/
		public static const TASK_EVENT_ITEM_TALK:String = "TASK_EVENT_ITEM_TALK";
		/*加入阵营*/
		public static const TASK_EVENT_JOIN_CAMP:String = "TASK_EVENT_JOIN_CAMP";
		/*收集任务物品*/
		public static const TASK_EVENT_COLLECTTASK:String = "TASK_EVENT_COLLECTTASK";
	}
}