package SJ.Common.Constants
{
	import SJ.Game.data.CJDataOfEnhanceHero;
	import SJ.Game.data.CJDataOfHero;

	/**
	 * 传功常量信息
	 * @author zhengzheng
	 * 
	 */	
	public final class ConstTransferAbility
	{
		public function ConstTransferAbility()
		{
		}
		/**
		 *显示武将单元个数
		 */		
		public static const TRANSFER_ABILITY_HERO_NUM:int = 2;
		/**
		 * 传功成功
		 */		
		public static const TRANSFER_ABILITY_SUCCESS:int = 0;
		/**
		 * 接受传功武将不存在
		 */		
		public static const TRANSFER_ABILITY_HERO_NEW_NOT_EXIST:int = 1;
		/**
		 * 发出传功武将不存在
		 */		
		public static const TRANSFER_ABILITY_HERO_OLD_NOT_EXIST:int = 2;
		/**
		 * 接受传功武将不能是主角
		 */		
		public static const TRANSFER_ABILITY_HERO_NEW_IS_MAIN_HERO:int = 3;
		/**
		 * 发出传功武将不能是主角
		 */		
		public static const TRANSFER_ABILITY_HERO_OLD_IS_MAIN_HERO:int = 4;
		/**
		 * 发出传功武将等级不足
		 */		
		public static const TRANSFER_ABILITY_HERO_OLD_LV_NOT_REACH:int = 5;
		/**
		 * 所需传功丹不足
		 */		
		public static const TRANSFER_ABILITY_MYAX_NOT_ENOUGH:int = 6;
		/**
		 * 所需传功丹不足
		 */		
		public static const TRANSFER_ABILITY_MYAX_USE_FAIL:int = 7;
		/**
		 * 发出传功武将不能在阵型中
		 */		
		public static const TRANSFER_ABILITY_HERO_OLD_IN_FORMATION:int = 8;
		/**
		 * 背包空间不足
		 */		
		public static const TRANSFER_ABILITY_BAG_SPACE_NOT_ENOUGH:int = 9;
		/**
		 * 接受传功武将等级大于发出传功武将等级
		 */		
		public static const TRANSFER_ABILITY_HERO_OLD_LEVEL_HIGHER:int = 10;
		
		/**
		 *显示武将单元个数
		 */		
		public static const TRANSFER_ABILITY_NEED_MYAX_NUM:String = "TRANSFER_ABILITY_NEED_MYAX_NUM";
		/**
		 *选择是否使用传功丹事件
		 */		
		public static const TRANSFER_ABILITY_USE_MYAX:String = "TRANSFER_ABILITY_USE_MYAX";
		
		/** 传功数据 */
		public static var transInfo:Object;
		/** 左侧武将数据 */
		public static var leftHeroData:CJDataOfHero;
		/** 左侧武将强化数据 */
		public static var leftHeroEnhanceData:CJDataOfEnhanceHero;
		/** 加载传功信息返回码*/
		public static var loadTransInfoRetCode:int;
		/** 发出传功等级的武将是否足够*/
		public static var isLvReach:Boolean;
		/** 传功后左边武将等级 */
		public static var leftHeroLvAfterTrans:int;
		/**
		 * 清空内存数据
		 * 
		 */		
		public static function clear():void
		{
			transInfo = null;
			leftHeroData = null;
			leftHeroEnhanceData = null;
			loadTransInfoRetCode = 0;
			isLvReach = false;
			leftHeroLvAfterTrans = 0;
		}
	}
}