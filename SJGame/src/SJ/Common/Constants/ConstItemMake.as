package SJ.Common.Constants
{
	/**
	 * @author zhengzheng
	 * 创建时间：Apr 27, 2013 5:40:35 PM
	 * 装备铸造常量信息
	 */
	public final class ConstItemMake
	{
		public function ConstItemMake()
		{
		}
		/**
		 *可铸造装备面板显示的装备数 
		 */		
		public static const ITEMS_PANEL_PER_PAGE:int = 5;
		/**
		 * 可铸造装备名称的X坐标 
		 */		
		public static const ITEM_MAKE_ITEM_NAME_X:int = 59;
		/**
		 * 可铸造装备名称的Y坐标 
		 */	
		public static const ITEM_MAKE_ITEM_NAME_Y:int = 10;
		/**
		 * 可铸造装备等级的X坐标 
		 */		
		public static const ITEM_MAKE_ITEM_LEVEL_X:int = 59;
		/**
		 * 可铸造装备等级的Y坐标 
		 */	
		public static const ITEM_MAKE_ITEM_LEVEL_Y:int = 33;
		/**
		 * 铸造显示层显示材料名称的Y坐标 
		 */	
		public static const ITEM_MAKE_SHOW_MATERIAL_NAME_Y:int = 55;
		/**
		 * 铸造显示层显示材料个数信息的Y坐标 
		 */	
		public static const ITEM_MAKE_SHOW_MATERIAL_INFO_Y:int = 88;
		/**
		 * 铸造显示层要铸造装备的X坐标 
		 */	
		public static const ITEM_MAKE_SHOW_MAKE_ITEM_X:int = 274;
		/**
		 * 铸造显示层要铸造装备的Y坐标 
		 */	
		public static const ITEM_MAKE_SHOW_MAKE_ITEM_Y:int = 13;
		/**
		 * 铸造显示层提示文字的X坐标 
		 */	
		public static const ITEM_MAKE_SHOW_TIPS_LABEL_X:int = 242;
		/**
		 * 铸造显示层提示文字的Y坐标 
		 */	
		public static const ITEM_MAKE_SHOW_TIPS_LABEL_Y:int = 127;
		/**
		 * 铸造显示层显示材料名称的宽 
		 */		
		public static const ITEM_MAKE_SHOW_MATERIAL_NAME_WIDTH:int = 57;
		/**
		 * 可铸造装备条目的宽 
		 */		
		public static const ITEM_MAKE_ITEM_MAKE_WIDTH:int = 127;
		/**
		 * 可铸造装备信息的高
		 */	
		public static const ITEM_MAKE_ITEM_MAKE_HEIGHT:int = 49;
		/**
		 * 装备铸造分类条目个数
		 */	
		public static const ITEM_MAKE_ITEMS_NUM:int = 7;
		
		/**铸造显示层信息改变事件*/
		public static const ITEM_SHOW_CHANGED:String = "item_show_change";
		/**铸造层信息改变事件*/
		public static const ITEM_MAKE_CHANGED:String = "item_make_change";
		
		/**
		 * 装备铸造结果返回码-0:成功
		 */	
		public static const ITEM_MAKE_RESULT_STATE_SUCCESS:int = 0;
		/**
		 * 装备铸造结果返回码-1:背包已满
		 */	
		public static const ITEM_MAKE_RESULT_STATE_BAG_FULL:int = 1;
		/**
		 * 装备铸造结果返回码-2:银币不足
		 */	
		public static const ITEM_MAKE_RESULT_STATE_LACK_SILVER:int = 2;
		/**
		 * 装备铸造结果返回码-3:金币不足
		 */	
		public static const ITEM_MAKE_RESULT_STATE_LACK_GOLD:int = 3;
		/**
		 * 装备铸造结果返回码-4:材料不足
		 */	
		public static const ITEM_MAKE_RESULT_STATE_LACK_MATERIAL:int = 4;
		/**
		 * 判断是不是正在铸造中 
		 */		
		public static var isMakingItem:Boolean = false;
		
		/**
		 * 装备子类型键值映射表
		 */
		public static const Const_ITEM_MAKE_SUBTYPE:Object = { 
			"1":32, "2":16, "4":8, "8":4, "16":2, "32":1};
		
	}
}