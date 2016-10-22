package fxengine
{
	/**
	 * 引擎配置 
	 * @author caihua
	 * 
	 */
	public class FXEngineConfig
	{
		public function FXEngineConfig()
		{
		}
		
		private static var _o:FXEngineConfig = null;
		
		public static function get o():FXEngineConfig
		{
			if(_o == null)
			{
				_o = new FXEngineConfig();
			}
			return _o;
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

		private var _resourceRemoteBasePath:String = "http://www.game.com/resource";

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

		private var _resourceCachePath:String = "AppDownloadResource/";

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
		
		
		
	}
}