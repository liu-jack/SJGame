package engine_starling.utils
{
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	import flash.system.Capabilities;

	public class SPlatformUtils
	{
		public function SPlatformUtils()
		{
		}
		
		/**
		 * Returns true if the user is running the app on a Debug Flash Player.
		 * Uses the Capabilities class
		 **/
		public static function isDebug() : Boolean
		{
			return Capabilities.isDebugger;
		}
		
		/**
		 * Returns true if the swf is built in debug mode
		 **/
		public static function isDebugBuild() : Boolean
		{
			return new Error().getStackTrace().search(/:[0-9]+]$/m) > -1;
		}
		
		/**
		 * Returns true if the swf is built in release mode
		 **/
		public static function isReleaseBuild() : Boolean
		{
			return !isDebug();
		}
		
		/**
		 * 退出程序 
		 * 
		 */
		public static function exit():void
		{
			var manufactory:String = SManufacturerUtils.getManufacturerType();
			
			if(manufactory == SManufacturerUtils.TYPE_IOS)
			{
				var crashingBitmaps:Array = []
				
				do {
					var bm:BitmapData = new BitmapData ( 2048, 2048, false);
					crashingBitmaps.push( bm );
				} while ( true );
			}
			else
			{
				NativeApplication.nativeApplication.exit();
			}
		}
		
		/**
		 * 从配置文件 获取程序版本号 
		 * @return 
		 * 
		 */
		public static function getApplicationVersion():String
		{
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespace();
			var appVersion:String = appXml.ns::versionNumber;
			return appVersion;
		}
		
		/**
		 * 从配置文件 获取程序名称 
		 * @return 
		 * 
		 */
		public static function getApplicationName():String
		{
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespace();
			var name:String = appXml.ns::name;
			return name;
		}
	}
}