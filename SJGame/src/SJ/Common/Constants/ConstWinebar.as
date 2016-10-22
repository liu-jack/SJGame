package SJ.Common.Constants
{
	/**
	 * 酒馆常量
	 *
	 * @author longtao 
	 * 创建时间：2013/4/24  18:45
	 */
	public final class ConstWinebar
	{
		public function ConstWinebar()
		{
		}
		
		/**
		 * 酒馆武将卡最大数量
		 */		
		public static const ConstWinebarMaxHeroCards:uint = 5;
		
		/**
		 * 酒馆名牌状态
		 */
		public static const ConstWinebarStateFront:String = "1";
		
		/**
		 * 酒馆暗牌状态(暗牌状态下当抽取武将次数为0时，翻开所有武将牌，此时酒馆状态仍为暗牌阶段)
		 */
		public static const ConstWinebarStateBack:String = "2";
		
		/**
		 * 武将卡状态  未选择
		 */
		public static const ConstWinebarHeroStateNoSelected:String = "1";
		
		/**
		 * 武将卡状态  已选择
		 */
		public static const ConstWinebarHeroStateSelected:String = "2";
		
		/**
		 * 武将卡状态  已雇佣
		 */
		public static const ConstWinebarHeroStateEmployed:String = "3";
		
		/**
		 * 酒馆VIP等级不同翻牌次数变化
		 */
		public static const WINEBAR_PICK_COUNT_LIMIT:Array = new Array(1,1,1,2,2,2,2,2,2,3,3,3,3);
		
		/**
		 * 酒馆最大翻牌次数
		 */
		public static const WINEBAR_MAX_PICK_COUNT:uint = 3;
	}
}