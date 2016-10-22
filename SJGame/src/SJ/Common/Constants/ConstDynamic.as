package SJ.Common.Constants
{

	/**
	 * 动态常量信息
	 * @author zhengzheng
	 * 
	 */	
	public final class ConstDynamic
	{
		public function ConstDynamic()
		{
		}
		/**
		 *显示数据类型
		 */		
		public static var DYNAMIC_TYPE:int = 0;
		/**
		 *显示数据类型-系统
		 */		
		public static const DYNAMIC_TYPE_SYSTEM:int = 3;
		/**
		 *显示数据类型-好友
		 */		
		public static const DYNAMIC_TYPE_FRIEND:int = 0;
		/**
		 *每页显示条目个数
		 */		
		public static const DYNAMIC_PER_PAGE_ITEM_NUM:int = 4;
		/**
		 *标志阵型中助战好友是否已经添加
		 */		
		public static var isAssistantAdd:Boolean = false;
		/**
		 * 标志助战结束后是否弹出邀请加好友弹窗
		 */		
		public static var isAddFriendDialogPopup:Boolean = false;
		/**
		 * 标志助战结束后是否弹出奖励好友体力弹窗
		 */		
		public static var isRewardVitDialogPopup:Boolean = false;
		/**
		 *标志是否是从副本进入阵型
		 */		
		public static var isEnterFromFuben:int = 0;
		//从副本进入阵型
		public static const ENTER_FROM_FB:int = 1;
		//从活动副本进入阵型
		public static const ENTER_FROM_ACTFB:int = 2;
		/**
		 *添加助战好友开始战斗事件
		 */		
		public static const DYNAMIC_START_FIGHT:String = "DYNAMIC_START_FIGHT";
		/**
		 *添加助战好友开始活动副本战斗事件
		 */	
		public static const DYNAMIC_STARTFROMACTFB_FIGHT:String = "DYNAMIC_STARTFROMACTFB_FIGHT";
		/**
		 * 邮件改变事件
		 */	
		public static const DYNAMIC_MAIL_CHANGED:String = "DYNAMIC_MAIL_CHANGED";
		
	}
}