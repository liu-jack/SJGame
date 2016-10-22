package SJ.Game.camp
{
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	
	/**
	 +------------------------------------------------------------------------------
	 * 阵营模块入口
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-8 下午12:04:13  
	 +------------------------------------------------------------------------------
	 */
	public class CJCampModule extends CJModuleSubSystem
	{
		/*资源标志符*/
		private static const _RESOURCE_TYPE:String = "CJCampModuleResource";
		/*模块名*/
		private static const _MOUDLE_NAME:String = "CJCampModule";
		private var _mainLayer:CJCampLayer = null;
		private var loading:CJLoadingLayer;
		
		public function CJCampModule()
		{
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
		
		override public function getPreloadResource():Array
		{
			return [];
		}
		
		/**
		 *进入模块，确定显示的layer 
		 * @param params
		 */
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			this._loadResource();
		}
		
		/**
		 * 退出模块，销毁layer与资源数据
		 * @param params
		 */
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			CJLayerManager.o.removeFromLayerFadeout(_mainLayer);
			AssetManagerUtil.o.disposeAssetsByGroup(_RESOURCE_TYPE);
			CJEventDispatcher.o.removeEventListeners("get_recommend_succ");
		}
		
		private function _loadResource():void
		{
			CJLoadingLayer.show();
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RESOURCE_TYPE 
				,getPreloadResource());
			AssetManagerUtil.o.loadQueue(_loadingHandler);
		}
		
		private function _loadingHandler(progress:Number):void
		{
			CJLoadingLayer.loadingprogress = progress;
			if(progress == 1)
			{
				CJLoadingLayer.close();
				_mainLayer = new CJCampLayer();
				CJLayerManager.o.addToModuleLayerFadein(_mainLayer);
				
			}
		}
		
		public static function get RESOURCE_TYPE():String
		{
			return _RESOURCE_TYPE;
		}
		
		public static function get MOUDLE_NAME():String
		{
			return _MOUDLE_NAME;
		}
	}
}