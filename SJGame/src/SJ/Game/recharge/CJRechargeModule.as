package SJ.Game.recharge
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;

	/**
	 * 充值模块
	 * @author zhengzheng
	 * 
	 */	
	public class CJRechargeModule extends CJModuleSubSystem
	{
		/*资源标志符*/
		private static const _RESOURCE_TYPE:String = "CJRechargeModuleResource";
		private var _rechargeLayer:CJRechargeLayer;
		
		public function CJRechargeModule()
		{
		}
		
		override public function getPreloadResource():Array
		{
			return [];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			
			CJLoadingLayer.show();
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RESOURCE_TYPE , getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					//移除加载动画
					CJLoadingLayer.close();
					//进入模块时添加充值层
					_rechargeLayer = new CJRechargeLayer();
					CJLayerManager.o.addToModuleLayerFadein(_rechargeLayer);
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			//退出模块时去除充值层
			CJLayerManager.o.removeFromLayerFadeout(_rechargeLayer);
			//移除加载的充值层的资源
			AssetManagerUtil.o.disposeAssetsByGroup(_RESOURCE_TYPE);
			_rechargeLayer = null;
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
	}
}