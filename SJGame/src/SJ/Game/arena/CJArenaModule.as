package SJ.Game.arena
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	
	/**
	 *   副本模块
	 * @author yongjun
	 * 
	 */
	public class CJArenaModule extends CJModuleSubSystem
	{
		public function CJArenaModule()
		{
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
		override public function getPreloadResource():Array
		{
			// TODO Auto Generated method stub
			return [ConstResource.sResJsonGlobalConfig];
		}
		private var _arenaLayer:CJArenaLayer
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJArenaModuleResource0",getPreloadResource());
			AssetManagerUtil.o.loadQueue(function(r:Number):void
			{
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					CJLoadingLayer.close();
					_arenaLayer = new CJArenaLayer;
					CJLayerManager.o.addToModuleLayerFadein(_arenaLayer);
				}
			})
		}
		
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			_arenaLayer.clear();
			CJLayerManager.o.removeFromLayerFadeout(_arenaLayer);
			_arenaLayer = null;
			AssetManagerUtil.o.disposeAssetsByGroup("CJArenaModuleResource0")
			
		}
	}
}