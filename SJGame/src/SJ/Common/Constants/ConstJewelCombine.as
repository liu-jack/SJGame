package SJ.Common.Constants
{
	/**
	 * 宝石合成常量信息
	 * @author zhengzheng
	 */	
	public final class ConstJewelCombine
	{
		public function ConstJewelCombine()
		{
		}
		/**
		 *宝石合成返回结果-合成成功
		 */		
		public static const JEWEL_COMBINE_RESULT_SUCCESS:int = 0;
		/**
		 *宝石合成返回结果-宝石等级已达到上限
		 */		
		public static const JEWEL_COMBINE_RESULT_ALREADY_MAX_LEVEL:int = 1;
		/**
		 *宝石合成返回结果-背包空间不足
		 */		
		public static const JEWEL_COMBINE_RESULT_BAG_SPACE_LACK:int = 2;
		/**
		 *宝石合成返回结果-材料不足
		 */		
		public static const JEWEL_COMBINE_RESULT_MATERIAL_LACK:int = 3;
		/**
		 *宝石合成返回结果-未放入要合成宝石材料
		 */		
		public static const JEWEL_COMBINE_RESULT_NOT_PUT_JEWEL_IN:int = 4;
		/**
		 *宝石合成返回结果-要合成宝石数量非法
		 */		
		public static const JEWEL_COMBINE_RETSTATE_DESNUM_INVALID:int = 5;
		/**
		 *宝石合成显示面板可显示的宝石数 
		 */		
		public static const ITEMS_PANEL_PER_PAGE:int = 4;
		
		/**
		 *宝石一键合成可选择等级的个数 
		 */		
		public static const JEWEL_COMBINE_ONE_KEY_SELECT_LVL_NUM:int = 9;
		/**
		 *宝石一键合成返回状态-vip级别不够 
		 */		
		public static const JEWEL_COMBINE_ONE_KEY_RETSTATE_VIP_NOT_ENOUGH:int = 1;
		/**
		 *宝石一键合成返回结果-背包空间不足
		 */		
		public static const JEWEL_COMBINE_ONE_KEY_RESULT_BAG_SPACE_LACK:int = 2;
		/**
		 *宝石一键合成返回结果-材料不足
		 */		
		public static const JEWEL_COMBINE_ONE_KEY_RESULT_MATERIAL_LACK:int = 3;
		/**
		 *宝石一键合成返回状态-没有比选择等级更低级别的宝石
		 */		
		public static const JEWEL_COMBINE_ONE_KEY_RETSTATE_NO_LOWER_LEVEL:int = 4;
		/**
		 *宝石一键合成选择等级的水平间隔
		 */		
		public static const JEWEL_SELECT_LVL_SPACE_HOR:int = 87;
		
		/**
		 *宝石一键合成选择等级的垂直间隔
		 */		
		public static const JEWEL_SELECT_LVL_SPACE_VER:int = 30;
		/**
		 *宝石一键合成选择等级行数
		 */		
		public static const JEWEL_SELECT_LVL_ROW_NUM:int = 3;
		/**
		 *宝石一键合成选择等级列数
		 */		
		public static const JEWEL__SELECT_LVL_COL_NUM:int = 3;
		
		/**点击宝石显示提示信息改变事件*/
		public static const JEWEL_TIPS_CHANGED:String = "jewel_tips_changed";
		
	}
}