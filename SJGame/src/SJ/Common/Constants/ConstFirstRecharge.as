package SJ.Common.Constants
{

	/**
	 * 首次充值常量信息
	 * @author zhengzheng
	 * 
	 */	
	public final class ConstFirstRecharge
	{
		public function ConstFirstRecharge()
		{
		}
		/**
		 *领取首充礼包返回类型-领取成功
		 */		
		public static const FIRST_RECHARGE_GET_SUCCESS:int = 0;
		/**
		 *领取首充礼包返回类型-没有充值
		 */		
		public static const FIRST_RECHARGE_NO_RECHARGE:int = 1;
		/**
		 *领取首充礼包返回类型-已经领取
		 */		
		public static const FIRST_RECHARGE_GET_ALREADY:int = 2;
		/**
		 *领取首充礼包返回类型-背包已满
		 */		
		public static const FIRST_RECHARGE_BAG_FULL:int = 3;
		
	}
}