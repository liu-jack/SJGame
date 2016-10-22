package SJ.Game.cdkey
{
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	public class CJCDKeyModule extends CJModuleSubSystem
	{
		private var _layer:CJCDKeyLayer;
		
		public function CJCDKeyModule()
		{
		}
		
		override public function getPreloadResource():Array
		{	
			return [];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onEnter(params);
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJCDKeyModuleResource",getPreloadResource());
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					CJLoadingLayer.close();
					_layer = SFeatherControlUtils.genLayoutFromXMLHelp("cdkeyLayout.sxml",CJCDKeyLayer);
					CJLayerManager.o.addToModuleLayerFadein(_layer);
				}
			});
			
		}
		
		override protected function _onExit(params:Object=null):void
		{
			// TODO Auto Generated method stub
//			_layer.removeFromParent(true);
			CJLayerManager.o.removeFromLayerFadeout(_layer);
			_layer = null
			AssetManagerUtil.o.disposeAssetsByGroup("CJCDKeyModuleResource");
			
			super._onExit(params);
		}
		
	}
}