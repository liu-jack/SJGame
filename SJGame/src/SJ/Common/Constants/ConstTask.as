package SJ.Common.Constants
{
	/**
	 +------------------------------------------------------------------------------
	 * 任务常量
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-28 下午5:08:44  
	 +------------------------------------------------------------------------------
	 */
	public final class ConstTask
	{
		/*开启任务的条件的个数*/
		public static const CONDTION_NUM:int = 2;
		/*任务action数量*/
		public static const ACTION_NUM:int = 3;
		
		/*任务开启常量 0 - 等级  1-前置任务*/
		public static const TASK_CONDITION_LEVEL:int = 0;
		public static const TASK_CONDITION_PRETASK:int = 1;
		
		/*任务操作类型常量 - 完成任务的条件*/
		/*对话*/
		public static const TASK_ACTION_TALK:int = 0;
		/*使用道具*/
		public static const TASK_ACTION_USE_TOOL:int = 1;
		/*打怪*/
		public static const TASK_ACTION_HUNT:int = 2;
		/*收集*/
		public static const TASK_ACTION_COLLECTNORMAL:int = 3;
		/*装备某装备*/
		public static const TASK_ACTION_EQUIPMENT:int = 4;
		/*进入场景*/
		public static const TASK_ACTION_ENTER:int = 5;
		/*PK*/
		public static const TASK_ACTION_PK:int = 6;
		/*升级*/
		public static const TASK_ACTION_LEVELUP:int = 7;
		/*道具对话*/
		public static const TASK_ACTION_ITEM_TALK:int = 8;
		/*加入阵营*/
		public static const TASK_ACTION_JOIN_CAMP:int = 9;
		/*收集任务物品*/
		public static const TASK_ACTION_COLLECTTASK:int = 10;
			
		/*任务状态常量*/
		/*不可接受*/
		public static const TASK_CAN_NOT_ACCEPT:int = -1 ;
		/*可接受*/
		public static const TASK_CAN_ACCEPT:int = 0 ;
		/*已接受*/
		public static const TASK_ACCEPTED:int = 1 ;
		/*完成*/
		public static const TASK_COMPLETE:int = 2;
		/*已领取奖励*/
		public static const TASK_REWARDED:int = 3;
		/*放弃*/
		public static const TASK_ABORT:int = 4;
		
		/*界面NPC的状态*/
		/*不可接受*/
		public static const TASK_NPC_CAN_NOT_ACCEPT:int = -2 ;
		/*没有任务*/
		public static const TASK_NPC_NO_TASK:int = -1;
		/*可接任务*/
		public static const TASK_NPC_TASK_CAN_ACCEPT:int = 0;
		/*已接任务 正在执行*/
		public static const TASK_NPC_TASK_EXECUTING:int = 1;
		/*已完成*/
		public static const TASK_NPC_TASK_COMPLETED:int = 2;
		/*已奖励*/
		public static const TASK_NPC_TASK_REWARDED:int = 3;
	}
}