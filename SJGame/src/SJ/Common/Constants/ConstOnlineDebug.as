package SJ.Common.Constants
{
	/**
	 * 调试配置。只在渠道0生效 
	 * @author zhipeng
	 * 
	 */
	public class ConstOnlineDebug
	{
		public function ConstOnlineDebug()
		{
		}
		
		
		/**
		 * 是否开启线上调试
		 */
		public static const isDebug:Boolean = false;
		/**
		 * 用户名(null 为默认逻辑)
		 */
		public static const debugUserName:String = null;//"GEN73159659123317387";
		/**
		 * 密码(null 为默认逻辑)
		 */
		public static const debugPassword:String = null;//"3f05f20c363c074b3b6d66184e03a679";
		/**
		 * 链接服务器
		 */
		public static const debugServerIp:String = "27.131.221.105";
		
		
		/**
		 * 调试资源下载路径 null 为使用默认的
		 */
		public static const debugResourceURL:String = null;//"http://wgimg.kaixin001.com.cn/shenjiang/"+ "1_0_36" +"/";
	}
}