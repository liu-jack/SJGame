package SJ.Game.enhanceequip
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	public class CJEnhanceModule extends CJModulePopupBase
	{
		private var _enhanceLayer:CJEnhanceLayer;
		
		/** 资源分组名 */
		private static const _RES_BAG_GROUP_NAME:String = "CJEnhanceModuleResource";
			
		public function CJEnhanceModule()
		{
			super("CJEnhanceModule");
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
			
			var pageType:int = 0;
			var heroId:String = "";
			if (params != null)
			{
				pageType = params.hasOwnProperty("pagetype") ? params["pagetype"] : 0;
				heroId = params.hasOwnProperty("heroid") ? String(params["heroid"]) : "";
			}
			
			//添加加载动画
			CJLoadingLayer.show();
			//加载强化层的布局文件和图片资源
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RES_BAG_GROUP_NAME, getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					//移除加载动画
					CJLoadingLayer.close();
					
					//进入模块时添加背包层
					var enhanceXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlEnhanceConfig) as XML;
					_enhanceLayer = SFeatherControlUtils.o.genLayoutFromXML(enhanceXml, CJEnhanceLayer) as CJEnhanceLayer;
					_enhanceLayer.setPageType(pageType);
					_enhanceLayer.setOpenHeroId(heroId);
					CJLayerManager.o.addToModuleLayerFadein(_enhanceLayer);
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			//退出模块时去除背包层
			CJLayerManager.o.removeFromLayerFadeout(_enhanceLayer);
			_enhanceLayer.removeAllEventListener();
			//移除加载的背包层的资源
			AssetManagerUtil.o.disposeAssetsByGroup(_RES_BAG_GROUP_NAME);
			this._enhanceLayer = null;
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
	}
}