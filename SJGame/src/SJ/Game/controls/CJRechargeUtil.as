package SJ.Game.controls
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfPileRechargeSetting;
	import SJ.Game.data.config.CJDataOfSingleRechargeSetting;
	
	/**
	 * 充值工具类
	 * @author sangxu
	 * @date 2013-12-16
	 */	
	public class CJRechargeUtil
	{
		public function CJRechargeUtil()
		{
		}
		/**
		 * 累计充值活动是否进行中
		 * @return 
		 * 
		 */		
		public static function isPileRechargeActivity():Boolean
		{
			var curType:String = CJDataManager.o.DataOfPileRecharge.curType;
			if (curType == "-1")
			{
				return false;
			}
			var serverOpenTime:uint = CJDataManager.o.DataOfPileRecharge.serverOpenTime;
			var isShowPileRecharge:Boolean = CJDataOfPileRechargeSetting.o.isShowFunc(serverOpenTime);
			return isShowPileRecharge;
		}
		/**
		 * 单笔充值活动是否进行中
		 * @return 
		 * 
		 */		
		public static function isSingleRechargeActivity():Boolean
		{
			var curType:String = CJDataManager.o.DataOfSingleRecharge.curType;
			if (curType == "-1")
			{
				return false;
			}
			var serverOpenTimeSingle:uint = CJDataManager.o.DataOfSingleRecharge.serverOpenTime;
			var isShowSingleRecharge:Boolean = CJDataOfSingleRechargeSetting.o.isShowFunc(serverOpenTimeSingle);
			return isShowSingleRecharge;
		}
	}
}