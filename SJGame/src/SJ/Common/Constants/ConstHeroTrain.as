package SJ.Common.Constants
{
	/**
	 * 武将训练
	 * @author longtao
	 * 
	 */
	public final class ConstHeroTrain
	{
		public function ConstHeroTrain()
		{
		}
		
		/** 状态 -- 不可超过主将等级(仅普通武将有该状态) **/
		public static const HERO_STATE_LIMIT:int = -1;
		/** 状态 -- 已满级 **/
		public static const HERO_STATE_FULL:int = 0;
		/** 状态 -- 空闲中 **/
		public static const HERO_STATE_IDLE:int = 1;
		/** 状态 -- 训练中 **/
		public static const HERO_STATE_BUSY:int = 2;
		
		
		/** 训练类型 -- 普通训练 **/
		public static const HERO_TRAIN_TYPE_COMMON:int = 1;
		/** 训练类型 -- 双倍训练 **/
		public static const HERO_TRAIN_TYPE_2:int = 2;
		/** 训练类型 -- 五倍训练 **/
		public static const HERO_TRAIN_TYPE_5:int = 3;
	}
}