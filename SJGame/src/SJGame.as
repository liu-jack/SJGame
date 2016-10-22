package
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	
	import SJ.MainApplication;
	
	import engine_starling.SApplicationLauch;
	import engine_starling.SApplicationLauchParams;
	import engine_starling.utils.Logger;
	import engine_starling.utils.SPlatformUtils;
	
	[SWF(width = 960, height = 640, backgroundColor = 0xFFFFFF, frameRate = 30)]
	public class SJGame extends Sprite
	{
		private var _lauch:SApplicationLauch;
				
		[Embed(source="startupres/startupHD.png")]
		private static var BackgroundHD:Class;
		
		[Embed(source="startupres/backgroundfillHD.png")]
		private static var BackgroundFillHD:Class;
		
		[Embed(source="startupres/startup_logoHD1.png")]
		private static var LogoHD:Class;
		
		
		public static var as3Root:Sprite;
		
		
		public function SJGame()
		{
			super();
			
			as3Root = this;
			
			if(SPlatformUtils.isReleaseBuild())
			{
				Logger.enable = false;
			}
			var params:SApplicationLauchParams  = new SApplicationLauchParams();
			params.startupBitmap = new BackgroundHD();
			params.startupHDBitmap = new BackgroundHD();
			params.backgroundfillBitmap = new BackgroundFillHD();
			params.backgroundfillBitmapHD = new BackgroundFillHD();
			params.startupLogo = new LogoHD();
			params.startupLogoHD = new LogoHD();
			
			BackgroundHD = null;
			BackgroundFillHD = null;
			LogoHD = null;
			
			SApplicationLauch.Lauch(MainApplication,this,params);
			
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
	}
}