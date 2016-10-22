package SJ.Game.vip
{
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	/**
	 * VIP特权模块
	 * @author longtao
	 * 
	 */
	public class CJVipPrivilegeModule extends CJModulePopupBase
	{
		private var _Layer:CJVipPrivilegeLayer;
		
		public function CJVipPrivilegeModule()
		{
			super("CJVipPrivilegeModule");
		}
		
		override public function getPreloadResource():Array
		{
			return ["vipPrivilegeLayout.sxml",
				]
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			//添加加载动画
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJVipPrivilegeModuleResource", getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					//移除加载动画
					CJLoadingLayer.close();
					
					var s:XML = AssetManagerUtil.o.getObject("vipPrivilegeLayout.sxml") as XML;
					_Layer = SFeatherControlUtils.o.genLayoutFromXML(s, CJVipPrivilegeLayer) as CJVipPrivilegeLayer;
					
					CJLayerManager.o.addToModuleLayerFadein(_Layer);
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
//			_Layer.removeFromParent(true);
			CJLayerManager.o.removeFromLayerFadeout(_Layer);
			_Layer = null;
			
			AssetManagerUtil.o.disposeAssetsByGroup("CJVipPrivilegeModuleResource");
			super._onExit(params);
		}
		
		override protected function _onInit(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onInit(params);
		}
		
	}
}