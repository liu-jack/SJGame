package SJ.Game.strategy
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	/**
	 * 攻略系统模块
	 * @author zhengzheng
	 * 
	 */	
	public class CJStrategyModule extends CJModulePopupBase
	{
		private var _strategyLayer:CJStrategyLayer;
		
		/** 资源分组名 */
		private static const _RES_GROUP_NAME:String = "CJStrategyModuleResource";
			
		public function CJStrategyModule()
		{
			super("CJStrategyModule");
		}
		
		override public function getPreloadResource():Array
		{
			return [
				ConstResource.sResXmlItem_1
			];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			
			//添加加载动画
			CJLoadingLayer.show();
			//加载布局文件和图片资源
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RES_GROUP_NAME, getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					//移除加载动画
					CJLoadingLayer.close();
					
					//进入模块时添加攻略层
					var strategyXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlStrategy) as XML;
					_strategyLayer = SFeatherControlUtils.o.genLayoutFromXML(strategyXml, CJStrategyLayer) as CJStrategyLayer;
					CJLayerManager.o.addToModuleLayerFadein(_strategyLayer);
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			//退出模块时去除攻略层
			CJLayerManager.o.removeFromLayerFadeout(_strategyLayer);
			//移除加载的攻略层的资源
			AssetManagerUtil.o.disposeAssetsByGroup(_RES_GROUP_NAME);
			this._strategyLayer = null;
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
	}
}