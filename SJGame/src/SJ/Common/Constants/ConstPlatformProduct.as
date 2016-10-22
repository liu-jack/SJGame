package SJ.Common.Constants
{
	import flash.utils.Dictionary;

	/**
	 * 平台套餐id
	 * @author sangxu
	 * 
	 */	
	public final class ConstPlatformProduct
	{
		public function ConstPlatformProduct()
		{
//			PLATFORM_PRODUCT[ConstPlatformId.ID_APPSTORE] = CURRENT_APP_PRODUCT;
//			PLATFORM_PRODUCT[ConstPlatformId.ID_DEBUG] = CURRENT_APP_PRODUCT;
//			
//			
//			CURRENT_PLATFORM_PRODUCT = PLATFORM_PRODUCT[ConstGlobal.CHANNELID];
		}
		
//		/** 当前苹果套餐 */
//		private static const CURRENT_APP_PRODUCT:Array = APP_PRODUCT_ID_TEST;
		/** 套餐类型 - 苹果 - 正式 */
		private static const APP_PRODUCT_ID:Array = ["manitos_tie_1",
													"manitos_tie_2",
													"manitos_tie_3",
													"manitos_tie_4",
													"manitos_tie_5",
													"manitos_tie_6"];
		/** 套餐类型 - 苹果 - 测试 */
		private static const APP_PRODUCT_ID_TEST:Array = ["Gods_tie_1",
													"Gods_tie_2",
													"Gods_tie_3",
													"Gods_tie_4",
													"Gods_tie_5",
													"Gods_tie_6"];
//		/** 平台套餐 */
//		private static var PLATFORM_PRODUCT:Dictionary = new Dictionary();
		
		/** 当前平台套餐 */
		public static const CURRENT_PLATFORM_PRODUCT:Array = APP_PRODUCT_ID_TEST;
	}
}