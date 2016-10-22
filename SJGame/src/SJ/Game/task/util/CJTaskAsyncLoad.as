package SJ.Game.task.util
{
	import SJ.Game.event.CJEventDispatcher;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import feathers.core.FeathersControl;

	/**
	 +------------------------------------------------------------------------------
	 * @comment 异步资源加载
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-21 上午11:20:24  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskAsyncLoad extends FeathersControl
	{
		private static var INSTANCE:CJTaskAsyncLoad = null;
		private var _loadCompleteEvent:String
		private var _resourceGroupName:String;
		
		public function CJTaskAsyncLoad()
		{
		}
		
		public static function get o():CJTaskAsyncLoad
		{
			if (INSTANCE == null)
			{
				INSTANCE = new CJTaskAsyncLoad();
			}
			return INSTANCE;
		}
		
		/**
		 * 异步加载资源
		 * @param resource : 加载的资源的名称
		 * @param type : 加载完成发出的事件
		 */		
		public function asyncLoad(resource:String , type:String = ""):void
		{
			if(type != "")
			{
				this._loadCompleteEvent = type;
			}
			_resourceGroupName = resource + Math.random()*1000000;
			
			AssetManagerUtil.o.loadPrepareInQueue(_resourceGroupName , resource);
			AssetManagerUtil.o.loadQueue(_LoadComplete);
		}
		
		private function _LoadComplete(p:Number):void
		{
			if(int(p) == 1)
			{
				CJEventDispatcher.o.dispatchEventWith(_loadCompleteEvent);
			}
		}

		public function get resourceGroupName():String
		{
			return _resourceGroupName;
		}
		
		override public function dispose():void
		{
			AssetManagerUtil.o.disposeAssetsByGroup(_resourceGroupName);
			super.dispose();
		}
	}
}