package engine_starling
{
	/**
	 * 程序配置 
	 * @author caihua
	 * 
	 */
	public final class SApplicationConfig
	{
		public function SApplicationConfig()
		{
		}
		
		private static var _ins:SApplicationConfig = null;
		public static function get o():SApplicationConfig
		{
			if(_ins == null)
				_ins = new SApplicationConfig();
			return _ins;
		}
		
				
		protected var _stageWidth:int  = 480;

		/**
		 * 设计舞台宽度 
		 */
		public function get stageWidth():int
		{
			return _stageWidth;
		}

		/**
		 * @private
		 */
		public function set stageWidth(value:int):void
		{
			_stageWidth = value;
		}

		protected var _stageHeight:int  = 320;

		/**
		 * 设计舞台高度 
		 */
		public function get stageHeight():int
		{
			return _stageHeight;
		}

		/**
		 * @private
		 */
		public function set stageHeight(value:int):void
		{
			_stageHeight = value;
		}
		
		
		private var _resourceLocalBasePath:String = "appResource/";
		
		/**
		 * 资源本地位置 
		 */
		public function get resourceLocalBasePath():String
		{
			return _resourceLocalBasePath;
		}
		
		/**
		 * @private
		 */
		public function set resourceLocalBasePath(value:String):void
		{
			_resourceLocalBasePath = value;
		}
		
		private var _resourceRemoteBasePath:String = "https://www.google.com/images/srpr/";
		
		/**
		 * 资源远程位置 
		 */
		public function get resourceRemoteBasePath():String
		{
			return _resourceRemoteBasePath;
		}
		
		/**
		 * @private
		 */
		public function set resourceRemoteBasePath(value:String):void
		{
			_resourceRemoteBasePath = value;
		}
		
		private var _resourceRemoteMd5FilePath:String = "https://www.google.com/images/srpr/";
		
		private var _resourceCachePath:String = "AppCacheResource/";
		
		/**
		 * 资源缓存位置 
		 */
		public function get resourceCachePath():String
		{
			return _resourceCachePath;
		}
		
		/**
		 * @private
		 */
		public function set resourceCachePath(value:String):void
		{
			_resourceCachePath = value;
		}
		
		/**
		 * 数据缓存位置 
		 * @return 
		 * 
		 */
		public function get resourceDataCachePath():String
		{
			return _resourceCachePath+"database/";
		}
		
		private var _alwayloadFromRemoteOrApp:Boolean = false;

		/**
		 * 总是从远程 或者安装目录加载文件
		 * default false 
		 */
		public function get alwayloadFromRemoteOrApp():Boolean
		{
			return _alwayloadFromRemoteOrApp;
		}

		/**
		 * @private
		 */
		public function set alwayloadFromRemoteOrApp(value:Boolean):void
		{
			_alwayloadFromRemoteOrApp = value;
		}

		/**
		 * 远程校验MD5文件地址,不走CDN的地址 
		 */
		public function get resourceRemoteMd5FilePath():String
		{
			return _resourceRemoteMd5FilePath;
		}

		/**
		 * @private
		 */
		public function set resourceRemoteMd5FilePath(value:String):void
		{
			_resourceRemoteMd5FilePath = value;
		}
		
		

		
	}
}