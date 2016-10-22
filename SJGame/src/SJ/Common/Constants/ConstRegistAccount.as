package SJ.Common.Constants
{
	/**
	 * 创建帐号常量信息
	 * @author longtao
	 * 
	 */
	public final class ConstRegistAccount
	{
		public function ConstRegistAccount()
		{
		}
		
		/**
		 * 帐号名称最小字符数
		 */
		public static const ConstMinAccountCount:uint = 6;
		
		/**
		 * 帐号名称最大字符数
		 */
		public static const ConstMaxAccountCount:uint = 12;
		
		/**
		 * 密码最小字符数
		 */
		public static const ConstMinPassWordCount:uint = 6;
		
		/**
		 * 密码最大字符数
		 */
		public static const ConstMaxPassWordCount:uint = 12;
		
		/**
		 * 账号限制规则
		 */
		public static const ConstUsernameRestrict:String = "a-zA-Z0-9";
		/**
		 * 密码限制规则
		 */
		public static const ConstPasswordRestrict:String = "a-zA-Z0-9";
	}
}