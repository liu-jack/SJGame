package SJ.Common.Constants
{

	/**
	 * 装备位洗练常量信息
	 * @author zhengzheng
	 * 
	 */	
	public final class ConstItemRecast
	{
		public function ConstItemRecast()
		{
		}
		/**
		 *刷新返回类型- 刷新成功
		 */		
		public static var RECAST_REFRESH_SUCCESS:int = 0;
		/**
		 *刷新返回类型- 武将不存在
		 */		
		public static var RECAST_HERO_NOT_EXIST:int = 1;
		/**
		 *刷新返回类型-装备位非法
		 */		
		public static const RECAST_INVILIDATE_POS:int = 2;
		/**
		 *刷新返回类型-元宝不足
		 */		
		public static const RECAST_GOLD_LESS:int = 3;
		/**
		 *刷新返回类型-刷新失败
		 */		
		public static const RECAST_REFRESH_FAIL:int = 4;
		/**
		 *洗练返回类型-洗练成功
		 */		
		public static const RECAST_RECAST_SUCCESS:int = 0;
		/**
		 *洗练返回类型-银两不足
		 */		
		public static const RECAST_SILVER_LESS:int = 1;
		/**
		 *洗练返回类型-洗练失败
		 */		
		public static const RECAST_RECAST_FAIL:int = 2;
		
	}
}