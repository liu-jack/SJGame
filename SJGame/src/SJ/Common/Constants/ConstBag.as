package SJ.Common.Constants
{
	/**
	 * @author zhengzheng
	 * 创建时间：Mar 29, 2013 10:18:35 AM
	 * 背包常量信息
	 * 
	 */
	public final class ConstBag
	{
		public function ConstBag()
		{
		}
		/**
		 * 背包物品栏目的数量
		 */		
		public static const ConstBagItemsNum:uint = 5;
		
		/** 
		 * 默认的未锁定的物品框数
		 */
		public static const DefaultUnlockFrameNum:uint = 15;
		/** 
		 * 单页物品框数 
		 */
		public static const OnePageGoodsFrameNum:uint = 20;
		/** 
		 * 单页行数 
		 */
		public static const OnePageRowNum:uint = 4;
		/** 
		 * 单页列数  
		 */
		public static const OnePageColumnNum:uint = 5;
		
		
		/** 
		 * 两个物品框水平方向距离
		 */
		public static const TwoGoodsFrameDistanceH:uint = 62;
		/** 
		 * 两个物品框垂直方向距离
		 */
		public static const TwoGoodsFrameDistanceV:uint = 59;
		/** 
		 * 创建解锁物品框状态值
		 */
		public static const FrameCreateStateUnlock:uint = 0;
		/** 
		 * 创建未解锁物品框状态值
		 */
		public static const FrameCreateStateLocked:uint = 1;
		/** 
		 * 滚动页水平坐标
		 */
		public static const BagLayerX:uint = 88;
		/** 
		 * 滚动页垂直坐标
		 */
		public static const BagLayerY:uint = 21;
		/** 背包背景图宽高 */
		public static const BAG_LAYER_WIDTH:uint = 336;
		public static const BAG_LAYER_HEIGHT:uint = 285;
		/** 背包框与背景图偏移量 */
		public static const BAG_ITEM_INITX:uint = 17;	//TODO 使用TurnPage翻页，此值为10
		public static const BAG_ITEM_INITY:uint = 16;
		/** 背包格图片宽高 */
		public static const BAG_ITEM_WIDTH:uint = 51;
		public static const BAG_ITEM_HEIGHT:uint = 51;
		
		/** 背包格内道具图片宽高 */
		public static const BAG_ITEM_CONT_WIDTH:uint = 44;
		public static const BAG_ITEM_CONT_HEIGHT:uint = 44;
		/** 背包格内道具图片相对背包格图片坐标偏移量 */
		public static const BAG_ITEM_CONT_SPACEX:uint = 4;
		public static const BAG_ITEM_CONT_SPACEY:uint = 4;
		
		/**
		 * 背包类型 - 全部
		 */		
		public static const BAG_TYPE_ALL:uint = 0;
		/**
		 * 背包类型 - 道具
		 */		
		public static const BAG_TYPE_PROP:uint = 1;
		/**
		 * 背包类型 - 装备
		 */		
		public static const BAG_TYPE_EQUIP:uint = 2;
		/**
		 * 背包类型 - 材料
		 */		
		public static const BAG_TYPE_MATERIAL:uint = 4;
		/**
		 * 背包类型 - 宝石
		 */		
		public static const BAG_TYPE_JEWEL:uint = 8;
		/**
		 * 背包类型 - 宝物
		 */		
		public static const BAG_TYPE_CIMELIA:uint = 16;
		/**
		 * 背包类型 - 饰品
		 */		
		public static const BAG_TYPE_DECO:uint = 32;
		
		/**
		 * 道具容器类型 - 背包
		 */		
		public static const CONTAINER_TYPE_BAG:int = 1;
		/**
		 * 道具容器类型 - 仓库
		 */		
		public static const CONTAINER_TYPE_WH:int = 2;
		/**
		 * 道具容器类型 - 装备栏
		 */		
		public static const CONTAINER_TYPE_EQUIP:int = 3;
		/**
		 * 道具容器类型 - 装备孔
		 */		
		public static const CONTAINER_TYPE_HOLE:int = 4;
		
		/**
		 * 事件类型 - 道具容器扩充成功
		 */		
		public static const EVENT_TYPE_BAG_EXPAND_COMPLETE:String = "EVENT_TYPE_BAG_EXPAND_COMPLETE";
		
		/** 装备选中底图图片名 */
		public static const IMG_NAME_SEL_WUQI:String = "zhuangbeiqianghua_jinengkuang_wuqi_xuanzhong";
		public static const IMG_NAME_SEL_TOUKUI:String = "zhuangbeiqianghua_jinengkuang_toukui_xuanzhong";
		public static const IMG_NAME_SEL_PIFENG:String = "zhuangbeiqianghua_jinengkuang_pifeng_xuanzhong";
		public static const IMG_NAME_SEL_KUIJIA:String = "zhuangbeiqianghua_jinengkuang_kuijia_xuanzhongpng";
		public static const IMG_NAME_SEL_XIEZI:String = "zhuangbeiqianghua_jinengkuang_xiezi_xuanzhong";
		public static const IMG_NAME_SEL_YAODAI:String = "zhuangbeiqianghua_jinengkuang_wuyao_xuanzhong";
		/** 图片名 - 选中框 */
		public static const IMG_NAME_SEL_KUANG:String = "common_tubiaokuangxuanzhong";
		
		public static const INLAY_HOLE_STATE_LOCK:String = "-1";
		public static const INLAY_HOLE_STATE_EMPTY:String = "0";
		
		/** 按钮最小宽高 */
		public static const BUTTON_WIDTH_MIN:int = 53;
		public static const BUTTON_HEIGHT_MIN:int = 28;
	}
}