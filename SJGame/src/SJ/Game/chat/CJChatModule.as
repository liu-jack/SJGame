package SJ.Game.chat
{
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.SApplicationConfig;
	import engine_starling.utils.AssetManagerUtil;
	
	/**
	 +------------------------------------------------------------------------------
	 * 聊天模块入口
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-8 下午12:04:13  
	 +------------------------------------------------------------------------------
	 */
	public class CJChatModule extends CJModulePopupBase
	{
		/*资源标志符*/
		private static const _RESOURCE_TYPE:String = "CJChatModuleResource";
		/*模块名*/
		private static const _MOUDLE_NAME:String = "CJChatModule";
		
		private var _mainLayer:CJChatLayer = null;

		private var loading:CJLoadingLayer;
		
		private var _params:Object;
		
		public function CJChatModule()
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
			this._params = params;
			this._loadResource();
			CJDataManager.o.DataOfChat.loadFromRemote();
		}
		
		/**
		 * 退出模块，销毁layer与资源数据
		 * @param params
		 */
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			//移除模块相关layer
			CJLayerManager.o.removeFromLayerFadeout(_mainLayer);
			_mainLayer = null;
			//销毁资源
			AssetManagerUtil.o.disposeAssetsByGroup(_RESOURCE_TYPE);
			
			CJEventDispatcher.o.removeEventListeners(CJEvent.EVENT_RICH_TEXT_CLICK_EVENT);
			CJEventDispatcher.o.removeEventListeners("namemenuclicked");
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
				_mainLayer = new CJChatLayer(this._params);
				_mainLayer.width = SApplicationConfig.o.stageWidth;
				_mainLayer.height = SApplicationConfig.o.stageHeight;
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