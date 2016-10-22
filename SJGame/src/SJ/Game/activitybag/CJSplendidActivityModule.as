package SJ.Game.activitybag
{
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	
	/**
	 +------------------------------------------------------------------------------
	 * 功能点模块入口
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-20 下午15:04:13  
	 +------------------------------------------------------------------------------
	 */
	public class CJSplendidActivityModule extends CJModulePopupBase
	{
		/*资源标志符*/
		private static const _RESOURCE_TYPE:String = "CJSplendidActivityModuleResource";
		/*模块名*/
		private static const _MOUDLE_NAME:String = "CJSplendidActivityModule";
		private var _mainLayer:CJActivityBagLayer = null;
		private var loading:CJLoadingLayer;
		
		public function CJSplendidActivityModule()
		{
			super(_MOUDLE_NAME);
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
			CJLoadingLayer.show();
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
			_mainLayer = null;
			AssetManagerUtil.o.disposeAssetsByGroup(_RESOURCE_TYPE);
		}
		
		private function _loadResource():void
		{
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RESOURCE_TYPE , getPreloadResource());
			AssetManagerUtil.o.loadQueue(_loadingHandler);
		}
		
		private function _loadingHandler(progress:Number):void
		{
			if(progress == 1)
			{
				CJLoadingLayer.close();
				CJDataOfFuncPropertyList.o;
				this._initUi();
			}
		}
		
		private function _initUi():void
		{
			_mainLayer = new CJActivityBagLayer();
			_mainLayer.width = 320;
			_mainLayer.height = 190;
			CJLayerManager.o.addToModuleLayerFadein(_mainLayer);
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