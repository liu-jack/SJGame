package SJ.Game.winebar
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
	
	/**
	 * 酒馆武将信息模块
	 * @author longtao
	 * 
	 */
	public class CJWinebarHeroModule extends CJModulePopupBase
	{
		private var _winbarHeroLayer:CJWinebarHeroLayer;
		
		public function CJWinebarHeroModule()
		{
			super("CJWinebarHeroModule");
		}
		
		override public function getPreloadResource():Array
		{
			return ["winebarHeroLayout.sxml",
				ConstResource.sResSkillSetting];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onEnter(params);
			
			//添加加载动画
//			var loading:CJLoadingLayer = CJLoadingLayer.o;
//			CJLayerManager.o.addToModal(loading);
			
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJWinebarHeroModuleResource", getPreloadResource());
//				"winebarHeroLayout.sxml",
//				"resourceui_common.xml", 
//				"resourceui_winebar.xml",
//				ConstResource.sResSkillSetting);
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					//移除加载动画
//					CJLayerManager.o.disposeFromModal(loading);
					CJLoadingLayer.close();
					
					var s:XML = AssetManagerUtil.o.getObject("winebarHeroLayout.sxml") as XML;
					_winbarHeroLayer = SFeatherControlUtils.o.genLayoutFromXML(s, CJWinebarHeroLayer) as CJWinebarHeroLayer;
					_winbarHeroLayer.index = params[0];
					_winbarHeroLayer.templateid = params[1];
					_winbarHeroLayer.heroState = params[2];
//					CJLayerManager.o.addModuleLayer(_winbarHeroLayer);
					CJLayerManager.o.addModuleLayer(_winbarHeroLayer);
				}
			});
			
		}
		
		override protected function _onExit(params:Object=null):void
		{
			// TODO Auto Generated method stub
			_winbarHeroLayer.removeFromParent(true);
			_winbarHeroLayer = null;
			AssetManagerUtil.o.disposeAssetsByGroup("CJWinebarHeroModuleResource");
			super._onExit(params);
		}
		
		override protected function _onInit(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onInit(params);
		}
	}
}