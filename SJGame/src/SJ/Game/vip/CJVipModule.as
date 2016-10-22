package SJ.Game.vip
{
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	public class CJVipModule extends CJModulePopupBase
	{
		// 
		private var _vipLayer:CJVipLayer;
		
		public function CJVipModule()
		{
			super("CJVipModule");
		}
		
		override public function getPreloadResource():Array
		{
			return ["vipLayout.sxml"]
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			//添加加载动画
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJVipModuleResource", getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					//移除加载动画
					CJLoadingLayer.close();
					
					var s:XML = AssetManagerUtil.o.getObject("vipLayout.sxml") as XML;
					_vipLayer = SFeatherControlUtils.o.genLayoutFromXML(s, CJVipLayer) as CJVipLayer;
					
					CJLayerManager.o.addToModuleLayerFadein(_vipLayer);
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			CJLayerManager.o.removeFromLayerFadeout(_vipLayer);
//			_vipLayer.removeFromParent(true);
			_vipLayer = null;
			
			AssetManagerUtil.o.disposeAssetsByGroup("CJVipModuleResource");
			super._onExit(params);
		}
		
		override protected function _onInit(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onInit(params);
		}
		
	}
}