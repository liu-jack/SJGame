package SJ.Game.firstrecharge
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;

	/**
	 * 首次充值模块
	 * @author zhengzheng
	 * 
	 */	
	public class CJFirstRechargeModule extends CJModuleSubSystem
	{
		/*资源标志符*/
		private static const _RESOURCE_TYPE:String = "CJFirstRechargeModuleResource";
		private var _firstRechargeLayer:CJFirstRechargeLayer;
		
		public function CJFirstRechargeModule()
		{
		}
		
		override public function getPreloadResource():Array
		{
			return [
//				"resourceui_shouchong.xml"
			];
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
					//进入模块时添加首次充值层
					var firstRechargeXml:XML = AssetManagerUtil.o.getObject("shouchong.sxml") as XML;
					_firstRechargeLayer = SFeatherControlUtils.o.genLayoutFromXML(firstRechargeXml, CJFirstRechargeLayer) as CJFirstRechargeLayer;
					CJLayerManager.o.addToModuleLayerFadein(_firstRechargeLayer);
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			//退出模块时去除充值层
			CJLayerManager.o.removeFromLayerFadeout(_firstRechargeLayer);
			//移除加载的充值层的资源
			AssetManagerUtil.o.disposeAssetsByGroup(_RESOURCE_TYPE);
			_firstRechargeLayer = null;
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
	}
}