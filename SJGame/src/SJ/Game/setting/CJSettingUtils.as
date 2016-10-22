package SJ.Game.setting
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstGlobal;
	
	import engine_starling.utils.AssetManagerUtil;

	/**
	 * 设置 
	 * @author zhipeng
	 * 
	 */
	public class CJSettingUtils
	{
		public static var resourcedelayCacheTime:int = 1 * 60 * 1000;
		public static var highDeviceNames:Dictionary = new Dictionary();
		public static var lowDeviceNames:Dictionary = new Dictionary();
		
		public function CJSettingUtils()
		{
		}
		
		/**
		 * 通过设备类型设置显示 
		 * 
		 */
		public static function setDeviceLevelByDeviceType():void
		{
			 if(highDeviceNames.hasOwnProperty(ConstGlobal.DeviceInfo.DeviceName))
			 {
				 setDeviceLevel(ConstGlobal.DeviceLevel_High);
			 }
			 else if(lowDeviceNames.hasOwnProperty(ConstGlobal.DeviceInfo.DeviceName))
			 {
				 setDeviceLevel(ConstGlobal.DeviceLevel_Low);
			 }
			 else
			 {
				 setDeviceLevel(ConstGlobal.DeviceLevel_Normal);
			 }
		}
		/**
		 * 设置设备等级 
		 * @param level
		 * 
		 */
		public static function setDeviceLevel(level:String):void
		{
			ConstGlobal.DeviceLevel = level;
//			AssetManagerUtil.autoDisposedelayCache = true;
			switch(ConstGlobal.DeviceLevel)
			{
				case ConstGlobal.DeviceLevel_Normal:
//					AssetManagerUtil.resourcedelayCacheTime = resourcedelayCacheTime;
					break;
				
				case ConstGlobal.DeviceLevel_High:
//					AssetManagerUtil.resourcedelayCacheTime = 2 * resourcedelayCacheTime;
					break;
				
				case ConstGlobal.DeviceLevel_Low:
//					AssetManagerUtil.resourcedelayCacheTime = 0.5 * resourcedelayCacheTime;
					break;
			}
		}
	}
}