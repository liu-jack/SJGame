package SJ.Common.Constants
{
	/**
	 * @author zhengzheng
	 * 常量 - 邮件
	 * 
	 */
	public final class ConstMail
	{
		public function ConstMail()
		{
		}
		/** 邮件类型 - 系统邮件 */		
		public static const MAIL_TYPE_SYSTEM:uint = 0;
		/** 邮件类型 - 助战好友 */
		public static const MAIL_TYPE_FRIEND:uint = 2;
		/** 邮件类型 - 夺宝邮件 */
		public static const MAIL_TYPE_SNATCH:uint = 4;
		
		/** 邮件类型 - 夺宝通知雇佣好友邮件 */
		public static const MAIL_TYPE_FRISNATCH:uint = 5;
	}
}