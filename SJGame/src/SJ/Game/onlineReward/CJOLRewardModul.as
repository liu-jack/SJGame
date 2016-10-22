package SJ.Game.onlineReward
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	public class CJOLRewardModul extends SJ.Game.CJModulePopupBase
	{
		private var _layer:CJOLRewardLayer;
		
		public function CJOLRewardModul()
		{
			super("CJOLRewardModul");
		}
		
		override public function getPreloadResource():Array
		{
			return [ConstResource.sResXmlItem_1];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJOLRewardModulResource", getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(_onProgress);
			
		}
		
		private function _onProgress(r:Number):void
		{
			//设置加载动画的进度
			CJLoadingLayer.loadingprogress = r;
			if(r == 1)
			{
				//移除加载动画
				CJLoadingLayer.close();
				
				var s:XML = AssetManagerUtil.o.getObject("onlineRewardLayout.sxml") as XML;
				_layer = SFeatherControlUtils.o.genLayoutFromXML(s,CJOLRewardLayer) as CJOLRewardLayer;
				CJLayerManager.o.addToModuleLayerFadein(_layer);
				_layer.addAllListener();
			}
		}
		
		
		override protected function _onExit(params:Object=null):void
		{
			_layer.removeAllListener(); // 移除监听
			CJLayerManager.o.removeFromLayerFadeout(_layer);
			_layer = null;
			
			AssetManagerUtil.o.disposeAssetsByGroup("CJOLRewardModulResource");
			super._onExit(params);
		}

	}
}