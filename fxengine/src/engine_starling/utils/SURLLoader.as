package engine_starling.utils
{
	public class SURLLoader
	{
		/**
		 * 下载管理器 
		 * 
		 */
		public function SURLLoader()
		{
			_loader = new SAssetsCache();
		}
		
		private var _loader:SAssetsCache;
		
		
		public function loadAllPics():void
		{
			var suffix:String = "atf";
			switch(SManufacturerUtils.getManufacturerType())
			{
				case SManufacturerUtils.TYPE_IOS:
					suffix = "atfi";
					break;
				case SManufacturerUtils.TYPE_ANDROID:
					suffix = "atfa";
					break;
			}
			var res:Array = _loader.getRemoteResource(suffix);
			next(null);
			
			function next(params:SAssetsCacheLoadParams):void
			{
				var filename:String = res.pop();
				if(filename != null)
				{
					_loader.loadDataFromCacheOrURL(filename,next,true,true);
					Logger.log("SURLLoader","background load resource:" + filename);
				}
				else
				{
					Logger.log("SURLLoader","background load resource finish");
				}
			}

			
		}
	}
}