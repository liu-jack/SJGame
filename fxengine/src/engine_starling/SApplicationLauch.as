package engine_starling
{
	
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import engine_starling.display.SAutoSizeImage;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.Logger;
	import engine_starling.utils.SErrorUtil;
	import engine_starling.utils.SManufacturerUtils;
	import engine_starling.utils.SMuiscChannel;
	import engine_starling.utils.SPlatformUtils;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	/**
	 * 启动器 
	 * @author Administrator
	 * 
	 */
	public class SApplicationLauch
	{
		private static var _ins:SApplicationLauch = null;
		/**
		 * 启动程序 
		 * @param mainApplication
		 * @param mainSprite
		 * @param viewRect
		 * @param startupBitmap
		 * @param startupHDBitmap
		 * @return 
		 * 
		 */
		public static function Lauch(mainApplication:Class,mainSprite:DisplayObject,lauchParams:SApplicationLauchParams = null,viewRect:Rectangle = null):SApplicationLauch
		{
			if(_ins == null)
			{
				_ins = new SApplicationLauch();
				_ins._UncaughtErrorEvent(mainSprite);
				_ins.runApplication(mainApplication,mainSprite.stage,lauchParams,viewRect);
			}
			return _ins;
		}
		
		public static function closeBackground():void
		{
			if(_ins == null)
			{
				return;
			}
			var bg:Bitmap = _ins.mStarling.nativeStage.getChildByName("app_background") as Bitmap;
			if (bg)
			{
				_ins.mStarling.nativeStage.removeChild(bg);
				bg.bitmapData.dispose();
				
			}
			bg = _ins.mStarling.nativeStage.getChildByName("logo") as Bitmap;
			if (bg)
			{
				_ins.mStarling.nativeStage.removeChild(bg);
				bg.bitmapData.dispose();
				
			}
			
		}
		
		/**
		 * 淡出logo 
		 * @param time
		 * @param onfinish
		 * @param onfinishParams
		 * 
		 */
		public static function fadeoutLogo(time:Number = 0.5,onfinish:Function = null,onfinishParams:Array = null):void
		{
			var bg:Bitmap = _ins.mStarling.nativeStage.getChildByName("logo") as Bitmap;
			if(bg == null)
			{
				if (onfinish != null)
				{
					onfinish.apply(null,onfinishParams);
				}
			}
			else
			{
				var fadeout:Tween = new Tween(bg,time);
				fadeout.animate("alpha",0.001);
				fadeout.onComplete = onfinish;
				fadeout.onCompleteArgs = onfinishParams;
				
				Starling.juggler.add(fadeout);
			}
		}
		
		
		public function SApplicationLauch()
		{
			super();
		}
		
		private function _UncaughtErrorEvent(mainSprite:DisplayObject):void
		{
			mainSprite.loaderInfo.uncaughtErrorEvents.addEventListener(
				UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
		}
		
		
		private function uncaughtErrorHandler(event:UncaughtErrorEvent):void
		{
			
			event.preventDefault();
			
			if (event.error is Error)
			{
				
				
				var error:Error = event.error as Error;			
				Logger.getInstance(SApplicationLauch).error("errorId:" + error.errorID +"\n errorname:" +error.name + "\n errormsg:" + error.message + "\n stack:" + error.getStackTrace());
				SErrorUtil.reportError(error);
				
				SPlatformUtils.exit();
				
			}
			else if (event.error is ErrorEvent)
			{
				event.stopImmediatePropagation();
				var errorEvent:ErrorEvent = event.error as ErrorEvent;
				// do something with the error
			}
			else
			{
				// a non-Error, non-ErrorEvent type was thrown and uncaught
			}
			
			
		}
	
		
		
		/**
		 * 日志管理器 
		 */
		private var _logger:Logger = Logger.getInstance(SApplicationLauch);

		
		private var mStarling:Starling;
		private var mGlobalvol:Number = 0;

		/**
		 * 启动应用 
		 * @param mainApplication 主应用程序类
		 * @param mstage 舞台
		 * @param lauchParams 扩展启动参数
		 * @param viewRect 可视区域
		 * 
		 */
		public function runApplication(mainApplication:Class,mstage:Stage,lauchParams:SApplicationLauchParams = null,viewRect:Rectangle = null):void
		{
			// This project requires the sources of the "demo" project. Add them either by 
			// referencing the "demo/src" directory as a "source path", or by copying the files.
			// The "media" folder of this project has to be added to its "source paths" as well, 
			// to make sure the icon and startup images are added to the compiled mobile app.
			
			// set general properties
//			mstage = mstage == null?stage:mstage;
			
			var stageWidth:int  = SApplicationConfig.o.stageWidth;
			var stageHeight:int = SApplicationConfig.o.stageHeight;
			
			_logger.info("config width:{0},height:{1}",stageWidth,stageHeight);
			
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			var android:Boolean = SManufacturerUtils.getManufacturerType() == SManufacturerUtils.TYPE_ANDROID?true:false;
			
			Starling.multitouchEnabled = false;  // useful on mobile devices
			Starling.handleLostContext = !iOS;  // not necessary on iOS. Saves a lot of memory!
			
			
//			Starling.handleLostContext = false;
			
			// create a suitable viewport for the screen size
			// 
			// we develop the game in a *fixed* coordinate system of 320x480; the game might 
			// then run on a device with a different resolution; for that case, we zoom the 
			// viewPort to the optimal size for any display and load the optimal textures.
					
			//目标区域
			var destviewRect:Rectangle = viewRect;
			if(destviewRect == null)
				destviewRect = new Rectangle(0,0,mstage.fullScreenWidth,mstage.fullScreenHeight);
			
			var ispixelPerfect:Boolean = destviewRect.width/destviewRect.height == SApplicationConfig.o.stageWidth/SApplicationConfig.o.stageHeight?true:false;
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				destviewRect, 
				ScaleMode.SHOW_ALL, iOS);
			
			
			viewPort.width = viewPort.width;
			viewPort.height = viewPort.height;
			viewPort.x = viewPort.x;
			viewPort.y = viewPort.y;
			
			_logger.info("screenRect:{0} viewPort:{1}",destviewRect,viewPort);
			if(destviewRect.width > viewPort.width)
				SAutoSizeImage.offset = 1;
			
			
			
			
			// create the AssetManager, which handles all required assets for this resolution
			
			var scaleFactor:int = viewPort.width < 480 ? 1 : 2; // midway between 320 and 640
			var appDir:File = File.applicationDirectory;
			var assets:AssetManager = new AssetManager(scaleFactor);
			var filePath:String = File.applicationStorageDirectory.nativePath + "/" + SApplicationConfig.o.resourceCachePath;
			var fileCache:File = new File(filePath);
			
			
			_logger.info("scaleFactor:{0}",scaleFactor);
			_logger.info("appDir:{0}",appDir.nativePath + SApplicationConfig.o.resourceLocalBasePath);
			_logger.info("cacheDir:{0}",fileCache.nativePath);
			_logger.info("userdataDir:{0}",File.applicationStorageDirectory.nativePath + "/");
			
			assets.verbose = Capabilities.isDebugger;
			

			
			
			// While Stage3D is initializing, the screen will be blank. To avoid any flickering, 
			// we display a startup image now and remove it below, when Starling is ready to go.
			// This is especially useful on iOS, where "Default.png" (or a variant) is displayed
			// during Startup. You can create an absolute seamless startup that way.
			// 
			// These are the only embedded graphics in this app. We can't load them from disk,
			// because that can only be done asynchronously - i.e. flickering would return.
			// 
			// Note that we cannot embed "Default.png" (or its siblings), because any embedded
			// files will vanish from the application package, and those are picked up by the OS!
			

			
			
//			var background:Bitmap = null;
//			if(lauchParams!= null &&  lauchParams.startupBitmap != null && lauchParams.startupHDBitmap != null)
//			{
//				background = scaleFactor == 1 ? lauchParams.startupBitmap :  lauchParams.startupHDBitmap;
//				var backgroundfill:Bitmap = scaleFactor == 1 ? lauchParams.backgroundfillBitmap :  lauchParams.backgroundfillBitmapHD;
//				background.x = viewPort.x;
//				background.y = viewPort.y;
//				background.width  = viewPort.width;
//				background.height = viewPort.height;
//				background.smoothing = true;
//				background.name = "app_background";
//				mstage.addChildAt(background,0);
//				
//				if (backgroundfill != null)
//				{
//					backgroundfill.width = Math.round(backgroundfill.width * viewPort.width / (stageWidth * scaleFactor));
//					backgroundfill.height = Math.round(backgroundfill.height * viewPort.height / (stageHeight * scaleFactor));
//					backgroundfill.x = Math.floor((destviewRect.width - backgroundfill.width) /2);
//					
//					backgroundfill.y = Math.floor((destviewRect.height - backgroundfill.height) /2);
//					backgroundfill.smoothing = true;
//					mstage.addChildAt(backgroundfill,0);
//				}
//				
//
//			}
//			
//			
//			var logo:Bitmap = null;
//			if(lauchParams!= null && lauchParams.startupLogoHD != null)
//			{
//				logo = lauchParams.startupLogoHD;
//				logo.name = "logo";
//				logo.x = viewPort.x;
//				logo.y = viewPort.y;
//				logo.width  = viewPort.width;
//				logo.height = viewPort.height;
//				logo.smoothing = true;
//				mstage.addChild(logo);
//			}
			
			
			
			// launch Starling
			
			mStarling = new Starling(mainApplication, mstage, viewPort);
			mStarling.stage.stageWidth  = stageWidth;  // <- same size on all devices!
			mStarling.stage.stageHeight = stageHeight; // <- same size on all devices!
			mStarling.simulateMultitouch  = false;
			mStarling.enableErrorChecking = false;
		
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, function():void
			{
				SApplication.StarlingInstance = mStarling;
				var game:SApplication = mStarling.root as SApplication;
				mStarling.start();
				game.appLauched( assets);
				
			});
			
			// When the game becomes inactive, we pause Starling; otherwise, the enter frame event
			// would report a very long 'passedTime' when the app is reactivated. 
			mGlobalvol = SMuiscChannel.global_volume;
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.ACTIVATE, function (e:*):void { onActivate(); });
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.DEACTIVATE, function (e:*):void { onDeactivate(); });
		}
		
		
		/**
		 * 后台是否继续渲染
		 * 主要为xiaomi设置。如果不明白 保持默认值 
		 */
		public static var suspendRendering:Boolean = true;
		
		protected function onActivate():void
		{
			mStarling.start();
			SMuiscChannel.global_volume = mGlobalvol;
		}
		protected function onDeactivate():void
		{
			mGlobalvol = SMuiscChannel.global_volume;
			SMuiscChannel.global_volume = 0;
			if(SPlatformUtils.isReleaseBuild())
			{
				AssetManagerUtil.o.removeUnusedResource();
			}

			mStarling.stop(suspendRendering);
		}
	}
}