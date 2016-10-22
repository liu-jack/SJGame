package SJ.Game.Notice
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	
	/**
	 +------------------------------------------------------------------------------
	 * 公告模块
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-10-9 下午3:52:56  
	 +------------------------------------------------------------------------------
	 */
	public class CJNoticeModule extends CJModuleSubSystem
	{
		/*资源标志符*/
		private static const _RESOURCE_TYPE:String = "CJNoticeModuleResource";
		/*模块名*/
		private static const _MOUDLE_NAME:String = "CJNoticeModule";
		private var _mainLayer:CJNoticeLayer = null;
		private var loading:CJLoadingLayer;
		
		public function CJNoticeModule()
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
				SocketManager.o.callwithRtn(ConstNetCommand.CS_GET_NEWEST_NOTICE , _initUi);
			}
		}
		
		private function _initUi(message:SocketMessage):void
		{
			_mainLayer = new CJNoticeLayer();
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