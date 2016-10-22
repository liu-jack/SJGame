package lib.engine.data.module
{
	public class CDataModuleRequestType
	{
		public function CDataModuleRequestType()
		{
		}
		/**
		 * 网络立刻请求 
		 */
		public static const TYPE_Immediately_Request:String = "TYPE_Immediately_Request";
		/**
		 * 定时请求 
		 */
		public static const TYPE_Timing_Request:String = "TYPE_Timing_Request";
		/**
		 * 本地获取 
		 */
		public static const TYPE_Local_Request:String = "TYPE_Local_Request";
		/**
		 * 空请求 
		 */
//		public static const TYPE_NONE_Request:String = "TYPE_NONE_Request";
	}
}