package SJ.Game.Platform
{
	public class SPlatformEvents
	{
		public function SPlatformEvents()
		{
		}
		
		/**
		 * 初始化 
		 */
		public static const EventInited:String = "SPlatFormEvents.EventInit";
		
		/**
		 * 登录事件.e.data.ret = true or false
		 * e.data.reason = "原因"
		 *  
		 */
		public static const EventLogined:String = "SPlatFormEvents.EventLogined";
		
		
		/**
		 * 登出 
		 */
		public static const EventLogout:String = "SPlatFormEvents.EventLogout";
		
		
		/**
		 * 购买接口
		 * e.data.ret = true or false
		 * e.data.receipt = (base64...) 
		 * e.data.code = retcode
		 */
		public static const EventBuy:String = "SPlatFormEvents.EventBuy";
		
		
		/**
		 * 获取商品
		 *  e.data.code = retcode
		 */
		public static const EventGetProducts:String = "SPlatFormEvents.EventGetProducts";
	}
}