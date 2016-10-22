package SJ.Game.pilerecharge
{
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	/**
	 * 累积充值
	 * @author longtao
	 * 
	 */
	public class CJPileRechargeModule extends CJModulePopupBase
	{
		private var _Layer:CJPileRechargeLayer;
		
		public function CJPileRechargeModule()
		{
			super("CJPileRechargeModule");
		}
		
		override public function getPreloadResource():Array
		{
			return [
				"pileRechargeLayout.sxml",
//				"resourceui_shouchong.xml"
			];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("resouce_pileRecharge", getPreloadResource()); 
			
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				
				if(r == 1)
				{
					//移除加载动画
					//					CJLayerManager.o.disposeFromModal(loading);
					CJLoadingLayer.close();
					
					var s:XML = AssetManagerUtil.o.getObject("pileRechargeLayout.sxml") as XML;
					_Layer = SFeatherControlUtils.o.genLayoutFromXML(s,CJPileRechargeLayer) as CJPileRechargeLayer;
					CJLayerManager.o.addToModuleLayerFadein(_Layer);
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
//			_Layer.removeFromParent(true);
			CJLayerManager.o.removeFromLayerFadeout(_Layer);
			_Layer = null;
			// 释放资源
			AssetManagerUtil.o.disposeAssetsByGroup("resouce_pileRecharge");
			// TODO Auto Generated method stub
			super._onExit(params);
		}
		
		
	}
}