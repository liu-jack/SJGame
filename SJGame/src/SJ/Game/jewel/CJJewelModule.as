package SJ.Game.jewel
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	public class CJJewelModule extends CJModulePopupBase
	{
		private var _jewelLayer:CJJewelLayer;
		
		/** 资源分组名 */
		private static const _RES_JEWEL_GROUP_NAME:String = "CJJewelModuleResource";
			
		public function CJJewelModule()
		{
			super("CJJewelModule");
		}
		
		override public function getPreloadResource():Array
		{
			return [ConstResource.sResXmlItem_1
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
			
//			var loading:CJLoadingLayer = CJLoadingLayer.o;
			//添加加载动画
//			CJLayerManager.o.addToModal(loading);
			CJLoadingLayer.show();
			//加载强化层的布局文件和图片资源
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RES_JEWEL_GROUP_NAME, getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					//移除加载动画
//					CJLayerManager.o.disposeFromModal(loading);
					CJLoadingLayer.close();
					//进入模块时添加背包层
					var jewelXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlJewelConfig) as XML;
					_jewelLayer = SFeatherControlUtils.o.genLayoutFromXML(jewelXml, CJJewelLayer) as CJJewelLayer;
					_jewelLayer.setPageType(pageType);
					_jewelLayer.setOpenHeroId(heroId);
					CJLayerManager.o.addToModuleLayerFadein(_jewelLayer);
					
					//处理指引
					if(CJDataManager.o.DataOfFuncList.isIndicating)
					{
						CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
					}
					
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			// 退出模块时去除宝石层
			CJLayerManager.o.removeFromLayerFadeout(_jewelLayer);
			// 移除加载的宝石层的资源
			AssetManagerUtil.o.disposeAssetsByGroup(_RES_JEWEL_GROUP_NAME);
			this._jewelLayer = null;
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
	}
}