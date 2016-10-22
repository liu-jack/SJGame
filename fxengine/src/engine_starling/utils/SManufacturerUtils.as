package engine_starling.utils
{
	import flash.system.Capabilities;
	
	
	/**
	 * 设备相关Utils
	 * @author sangxu
	 * 
	 */
	public class SManufacturerUtils
	{
		/** 支持的设备数组 */
		public static const _supportManufacturer:Array = 
			[TYPE_IOS, 
			 TYPE_ANDROID, 
			 TYPE_WINDOWS];
		
		/** 系统类型 - 苹果 "Adobe iOS" */
		public static const TYPE_IOS:String = "iOS";
		/** 系统类型 - 安卓 "Android Linux" */
		public static const TYPE_ANDROID:String = "Android";
		/** 系统类型 - Windows "Adobe Windows" */
		public static const TYPE_WINDOWS:String = "Windows";
		/** 系统类型 - 其他 */
		public static const TYPE_OTHERS:String = "Others";
		
		public function SManufacturerUtils()
		{
		}
		
		/**
		 * 获取设备系统类型
		 * @return 当前设备类型, 返回类型为本类中常量TYPE_XXX, 若非现有常量所列类型则返回其他TYPE_OTHERS
		 * 
		 */
		public static function getManufacturerType():String
		{
			var isType : Boolean = false;
			for each (var type:String in _supportManufacturer)
			{
				isType = _isManufacturer(type);
				if (isType)
				{
					return type;
				}
			}
			return SManufacturerUtils.TYPE_OTHERS;
		}
		
		/**
		 * 根据设备数组返回设备类型
		 * @param manufacturers 设备类型数组, 数组元素须由本类中TYPE_XXX构成, 若非现有常量所列类型则返回其他TYPE_OTHERS
		 * @return 当前设备类型
		 * 
		 */
		public static function getTypeByManufacturers(manufacturers:Array):String
		{
			var isType : Boolean = false;
			for (var type:String in manufacturers)
			{
				isType = _isManufacturer(type);
				if (isType)
				{
					return type;
				}
			}
			return SManufacturerUtils.TYPE_OTHERS;
		}
		
		/**
		 * 判断是否为该类型系统
		 */
		private static function _isManufacturer(type:String):Boolean
		{
			
			return Capabilities.manufacturer.indexOf(type) != -1;
		}
	}
}