package SJ.Game.winebar
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	/**
	 * 酒馆武将宝典模块
	 * @author longtao
	 */
	public class CJWinebarDictModule extends CJModulePopupBase
	{
		// 
		private var _winebarDictLayer:CJWinebarDictLayer;
		
		public function CJWinebarDictModule()
		{
			super("CJWinebarDictModule");
		}
		
		override public function getPreloadResource():Array
		{
			return ["winebarDictLayout.sxml",
				"resourceui_card_common.xml",
				ConstResource.sResSkillSetting,
				ConstResource.sResJSHeroDict];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onEnter(params);
			
			//添加加载动画
//			var loading:CJLoadingLayer = CJLoadingLayer.o;
//			CJLayerManager.o.addToModal(loading);
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJWinebarDictResource", getPreloadResource());
//				"winebarDictLayout.sxml",
//				"resourceui_common.xml", 
//				"resourceui_card_common.xml",
//				ConstResource.sResSkillSetting,
//				ConstResource.sResJSHeroDict);
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				
				if(r == 1)
				{
					//移除加载动画
//					CJLayerManager.o.disposeFromModal(loading);
					CJLoadingLayer.close();
					
					var s:XML = AssetManagerUtil.o.getObject("winebarDictLayout.sxml") as XML;
					_winebarDictLayer = SFeatherControlUtils.o.genLayoutFromXML(s,CJWinebarDictLayer) as CJWinebarDictLayer;
					
					CJLayerManager.o.addModuleLayer(_winebarDictLayer);
				}
			});
			
		}
		
		override protected function _onExit(params:Object=null):void
		{
			// TODO Auto Generated method stub
			_winebarDictLayer.removeFromParent(true);
			_winebarDictLayer = null;
			
			AssetManagerUtil.o.disposeAssetsByGroup("CJWinebarDictResource");
			super._onExit(params);
		}
		
		override protected function _onInit(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onInit(params);
		}
		
	}
}