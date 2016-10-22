package SJ.Game.dailytask
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	/**
	 +------------------------------------------------------------------------------
	 * 每日任务模块
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-10-2 上午10:46:06   
	 +------------------------------------------------------------------------------
	 */
	public class CJDailyTaskModule extends CJModulePopupBase
	{
		/*资源标志符*/
		private static const _RESOURCE_TYPE:String = "CJDailyTaskModuleResource";
		/*模块名*/
		private static const _MOUDLE_NAME:String = "CJDailyTaskModule";
		private var _mainLayer:CJDailyTaskLayer = null;
		
		public function CJDailyTaskModule()
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
			CJLoadingLayer.loadingprogress = progress;
			if(progress == 1)
			{
				CJLoadingLayer.close();
				SocketManager.o.callwithRtn(ConstNetCommand.CS_DAILYTASK_GETALL , _initUi);
			}
		}
		
		private function _initUi(message:SocketMessage):void
		{
			var sxml:XML = AssetManagerUtil.o.getObject("dailyTask.sxml") as XML;
			_mainLayer = SFeatherControlUtils.o.genLayoutFromXML(sxml , CJDailyTaskLayer) as CJDailyTaskLayer;
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