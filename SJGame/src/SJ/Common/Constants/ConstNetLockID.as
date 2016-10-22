package SJ.Common.Constants
{
	/**
	 * 生成网络锁id
	 * 可以以模块为单位，也可根据功能自己定义
	 * @author longtao
	 * 
	 */
	public final class ConstNetLockID
	{
		public function ConstNetLockID()
		{
		}
		
		// 
		private static var _seed:uint = 0;
		
		
		/**
		 * 登录
		 */
		public static var LoginModule:int = _amass();
		/**
		 * 创建角色
		 * */
		public static var CreateRoleModule:int = _amass();
		
		/**
		 * 武将ui的网络锁
		 */
		public static var HeroUIModule:int = _amass();
		
		/**
		 * 武将星级的网络锁
		 */
		public static var HeroStarModule:int = _amass();
		
		/**
		 * 武将训练网络锁
		 * */
		public static var HeroTrainModule:int = _amass();
		
		/**
		 * 在线礼包网络锁
		 * */
		public static var OnlineRewardModule:int = _amass();
		
		/**
		 * 主角升阶
		 * */
		public static var StageLevelModule:int = _amass();
		
		/**
		 * 酒馆
		 * */
		public static var WinebarModule:int = _amass();
		/**
		 * 洗练
		 * */
		public static var CJEnhanceModule:int = _amass();
		/**
		 * 宝石
		 * */
		public static var CJJewelModule:int = _amass();
		/**
		 * 排行榜
		 * */
		public static var CJRankModule:int = _amass();
		/**
		 * 好友
		 * */
		public static var CJFriendModule:int = _amass();
		
		/** 商城 */
		public static var MallModule:int = _amass();
		
		/** 装备强化 */
		public static var EnhanceEquipModule:int = _amass();
		
		/** 宝石镶嵌 */
		public static var JewelInlayModule:int = _amass();
		
		/** 背包 */
		public static var BagModule:int = _amass();
		
		/** 动态助战*/
		public static var CJDynamicModule:int = _amass();
		
		
		/** 用于生成网络锁 **/
		private static function _amass():int
		{
			var date:Date = new Date;
			var time:uint = date.time / 1000;
			
			_seed++;
			if (_seed >= 0xFFFF)
				_seed = 0;
			
			var guid:Number = ( time ) << (16) + _seed;
			return int(guid);
		}
	}
}