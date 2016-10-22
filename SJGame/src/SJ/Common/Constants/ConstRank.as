package SJ.Common.Constants
{

	/**
	 * 排行榜常量信息
	 * @author zhengzheng
	 * 
	 */	
	public final class ConstRank
	{
		public function ConstRank()
		{
		}
		/**
		 *显示数据类型
		 */		
		public static var RANK_TYPE:int = 0;
		/**
		 *显示数据类型-等级榜
		 */		
		public static const RANK_TYPE_RANK_LEVEL:int = 0;
		/**
		 *显示数据类型-战力榜
		 */		
		public static const RANK_TYPE_RANK_BATTLE_LEVEL:int = 1;
		/**
		 *显示数据类型-土豪榜
		 */		
		public static const RANK_TYPE_RANK_RICH_LEVEL:int = 2;
		/**
		 *每页显示条目个数
		 */		
		public static const RANK_PLAYER_PER_PAGE_ITEM_NUM:int = 5;
		/**
		 *玩家阵营- 无
		 */		
		public static const RANK_CAMP_NULL:int = 0;
		/**
		 *玩家阵营- 魏
		 */		
		public static const RANK_CAMP_WEI:int = 1;
		/**
		 *玩家阵营- 蜀
		 */		
		public static const RANK_CAMP_SHU:int = 2;
		/**
		 *玩家阵营- 吴
		 */		
		public static const RANK_CAMP_WU:int = 3;
		
		/**
		 * 获取等级榜的本地时间
		 */		
		public static var RANK_GET_RANK_LEVEL_TIME:String = "";
		/**
		 * 获取战力榜的本地时间
		 */		
		public static var RANK_GET_RANK_BATTLE_LEVEL_TIME:String = "";
		
	}
}