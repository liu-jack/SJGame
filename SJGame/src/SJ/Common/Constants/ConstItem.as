package SJ.Common.Constants
{
	import flash.utils.Dictionary;

	/**
	 * 物品类别与子类别存放位置
	 * @author longtao
	 * 
	 */
	public final class ConstItem
	{
		public function ConstItem()
		{
		}
		
		////  道具类别   ////
		/**
		 * 道具类型 - 道具
		 */
		public static const SCONST_ITEM_TYPE_USE:uint = 1;
		/**
		 * 道具类型 - 装备
		 */
		public static const SCONST_ITEM_TYPE_EQUIP:uint = 2;
		/**
		 * 道具类型 - 材料
		 */
		public static const SCONST_ITEM_TYPE_MATERIAL:uint = 4;
		/**
		 * 道具类型 - 宝石
		 */
		public static const SCONST_ITEM_TYPE_JEWEL:uint = 8;
		/**
		 * 道具类型 - 宝物
		 */
		public static const SCONST_ITEM_TYPE_TREASURE:uint = 16;
		/**
		 * 道具类型 - 饰品
		 */
		public static const SCONST_ITEM_TYPE_ORNAMENT:uint = 32;
		////  道具类别 end ////
		
		
		
		////  道具子类别    ////
		/*--    装备道具 同时也是装备位置     --*/
		/**
		 * 全部
		 */
		public static const SCONST_ITEM_SUBTYPE_ALL:uint = 63;
		/**
		 * 武器
		 */
		public static const SCONST_ITEM_SUBTYPE_WEAPON:uint = 1;
		/**
		 * 头盔
		 */
		public static const SCONST_ITEM_SUBTYPE_HELMET:uint = 2;
		/**
		 * 披风
		 */
		public static const SCONST_ITEM_SUBTYPE_CLOAK:uint = 4;
		/**
		 * 铠甲
		 */
		public static const SCONST_ITEM_SUBTYPE_ARMOUR:uint = 8;
		/** 
		 * 鞋子
		 */
		public static const SCONST_ITEM_SUBTYPE_SHOES:uint = 16;
		/** 
		 * 腰带
		 */
		public static const SCONST_ITEM_SUBTYPE_BELT:uint = 32;
		
		
		/** 道具属类 - 道具 - 等级礼包 */
		public static const SCONST_ITEM_SUBTYPE_USE_LVPACKAGE:uint = 0;
		/** 道具属类 - 道具 - 礼包 */
		public static const SCONST_ITEM_SUBTYPE_USE_PACKAGE:uint = 1;
		/** 道具属类 - 道具 - 坐骑 */
		public static const SCONST_ITEM_SUBTYPE_USE_HORSE:uint = 2;
		/** 道具属类 - 道具 - 元宝卡 */
		public static const SCONST_ITEM_SUBTYPE_USE_GOLD:uint = 3;
		/** 道具属类 - 道具 - 银两卡 */
		public static const SCONST_ITEM_SUBTYPE_USE_SILVER:uint = 4;
		/** 道具属类 - 道具 - 体力丹 */
		public static const SCONST_ITEM_SUBTYPE_USE_VIT:uint = 5;
		/** 道具属类 - 道具 - 声望丹 */
		public static const SCONST_ITEM_SUBTYPE_USE_CREDIT:uint = 6;
		/** 道具属类 - 道具 - 武魂丹 */
		public static const SCONST_ITEM_SUBTYPE_USE_FORCESOUL:uint = 7;
		/** 道具属类 - 道具 - 随机宝箱 */
		public static const SCONST_ITEM_SUBTYPE_USE_BOX:uint = 8;
		/** 道具属类 - 道具 - 随机宝箱钥匙 */
		public static const SCONST_ITEM_SUBTYPE_USE_BOXKEY:uint = 9;
		/** 道具属类 - 道具 - 合成道具碎片 */
		public static const SCONST_ITEM_SUBTYPE_USE_COMPOSEITEM:uint = 10;
		/** 道具属类 - 道具 - 合成武将碎片 */
		public static const SCONST_ITEM_SUBTYPE_USE_COMPOSEHERO:uint = 11;
		/** 道具属类 - 道具 - 合成坐骑碎片 */
		public static const SCONST_ITEM_SUBTYPE_USE_COMPOSEHORSE:uint = 12;
		
		/** 道具属类 - 材料 - 铸造 */
		public static const SCONST_ITEM_SUBTYPE_METAIL_ZHUZAO:uint = 1;
		/** 道具属类 - 材料 - 升星 */
		public static const SCONST_ITEM_SUBTYPE_METAIL_SHENGXING:uint = 2;
		/** 道具属类 - 材料 - 传功 */
		public static const SCONST_ITEM_SUBTYPE_METAIL_CHUANGONG:uint = 3;
		
		/*--     装备道具 end    --*/
		
		/** 装备位 - 武器 */
		public static const SCONST_ITEM_POSITION_WEAPON:uint = 1;
		/** 装备位 - 头盔 */
		public static const SCONST_ITEM_POSITION_HEAD:uint = 2;
		/** 装备位 - 披风 */
		public static const SCONST_ITEM_POSITION_CLOAK:uint = 4;
		/** 装备位 - 铠甲 */
		public static const SCONST_ITEM_POSITION_ARMOR:uint = 8;
		/** 装备位 - 鞋子 */
		public static const SCONST_ITEM_POSITION_SHOE:uint = 16;
		/** 装备位 - 腰带 */
		public static const SCONST_ITEM_POSITION_BELT:uint = 32;
		
		public static const SCONST_ITEM_POSITION_ALL:Array = [SCONST_ITEM_POSITION_WEAPON, 
															  SCONST_ITEM_POSITION_HEAD, 
															  SCONST_ITEM_POSITION_CLOAK, 
															  SCONST_ITEM_POSITION_ARMOR, 
															  SCONST_ITEM_POSITION_SHOE, 
															  SCONST_ITEM_POSITION_BELT];
		
		/** 道具品质类型 - 普通 */
		public static const SCONST_ITEM_QUALITY_TYPE_NORMAL:int = 1;
		/** 道具品质类型 - 绿 */
		public static const SCONST_ITEM_QUALITY_TYPE_GREEN:int = 2;
		/** 道具品质类型 - 蓝 */
		public static const SCONST_ITEM_QUALITY_TYPE_BLUE:int = 3;
		/** 道具品质类型 - 紫 */
		public static const SCONST_ITEM_QUALITY_TYPE_PURPLE:int = 4;
		/** 道具品质类型 - 橙 */
		public static const SCONST_ITEM_QUALITY_TYPE_ORANGE:int = 5;
		/** 道具品质类型 - 红 */
		public static const SCONST_ITEM_QUALITY_TYPE_RED:int = 6;
//		
//		/** 装备品质颜色 */		
//		public static const SCONST_ITEM_QUALITY_COLOR:Array = [0xE3CFB2, 0x00ff00, 0x0000FF, 0xD517D0, 0xFF8800];
		
		/**
		 * 装备品质名称颜色
		 * 1.白
		 * 2.绿
		 * 3.蓝
		 * 4.紫
		 * 5.橙
		 * 6.红
		 */		
		public static const SCONST_ITEM_QUALITY_COLOR:Array = [0x000000,0xFFFFFF,0x00FF00,0x0000FF,0xA349A4,0xFF8000,0xFF0000];
		/**
		 * 道具品质名称颜色
		 * 1.白
		 * 2.绿
		 * 3.蓝
		 * 4.紫
		 * 5.橙
		 * 6.红
		 */		
		public static const SCONST_ITEM_QUALITY_COLOR_STR:Array = ["#000000","#FFFFFF","#00FF00","#0000FF","#A349A4","#FF8000","#FF0000"];
		/**
		 * 装备品质名称
		 * 1.白
		 * 2.绿
		 * 3.蓝
		 * 4.紫
		 * 5.橙
		 * 6.红
		 */
		public static const SCONST_ITEM_QUALITY_LANG:Array = ["","ITEM_QUALITY_WHITE","ITEM_QUALITY_GREEN","ITEM_QUALITY_BLUE","ITEM_QUALITY_PURPLE","ITEM_QUALITY_ORANGE","ITEM_QUALITY_RED"];
		/** 装备是否可有孔 - 无孔 */
		public static const SCONST_ITEM_HOLE_NOTHASHOLE:int = 0;
		/** 装备是否可有孔 - 有孔 */
		public static const SCONST_ITEM_HOLE_HASHOLE:int = 1;
		
		/** 装备是否是套装 - 不是套装 */
		public static const SCONST_ITEM_SUIT_NOTHASSUIT:int = -1;
		
		/** 道具是否可出售 - 不可出售 */
		public static const SCONST_ITEM_SELL_STATE_NOT:int = 0;
		/** 道具是否可出售 - 可出售 */
		public static const SCONST_ITEM_SELL_STATE_CAN:int = 1;
		
		/** 道具是否可使用 - 不可使用 */
		public static const SCONST_ITEM_USE_STATE_NOT:int = 0;
		/** 道具是否可使用 - 可使用 */
		public static const SCONST_ITEM_USE_STATE_CAN:int = 1;
		
		/** 道具使用逻辑 - 不可使用 */
		public static const SCONST_ITEM_USE_LOGIC_CANNOT:int = -1;
		/** 道具使用逻辑 - 礼包 */
		public static const SCONST_ITEM_USE_LOGIC_PACKAGE:int = 1;
		/** 道具使用逻辑 - 增加货币 */
		public static const SCONST_ITEM_USE_LOGIC_MONEY:int = 3;
		/** 道具使用逻辑 - 增加属性值 */
		public static const SCONST_ITEM_USE_LOGIC_ADDPROP:int = 4;
		/** 道具使用逻辑 - 合成道具 */
		public static const SCONST_ITEM_USE_LOGIC_COMPOSEITEM:int = 5;
		/** 道具使用逻辑 - 合成武将 */
		public static const SCONST_ITEM_USE_LOGIC_COMPOSEHERO:int = 6;
		/** 道具使用逻辑 - 合成坐骑 */
		public static const SCONST_ITEM_USE_LOGIC_COMPOSEHORSE:int = 7;
		/** 道具使用逻辑 - 随机宝箱 */
		public static const SCONST_ITEM_USE_LOGIC_RANDOMBOX:int = 8;
		
		/** 战斗力值计算开方与否 - 不开方 */
		public static const SCONST_BATTLE_EFFECT_NOTSQRT:int = 0;
		/** 战斗力值计算开方与否 - 开方 */
		public static const SCONST_BATTLE_EFFECT_SQRT:int = 1;
	}
}