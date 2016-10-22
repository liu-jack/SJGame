package SJ.Game.heroStar
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import starling.core.Starling;
	
	/**
	 * 武将星级显示模块
	 * @author longtao
	 */
	public class CJHeroStarModule extends CJModulePopupBase
	{
		private var _heroStarLayer:CJHeroStarLayer;
		
		public function CJHeroStarModule()
		{
			super("CJHeroStarModule");
		}
		
		override public function getPreloadResource():Array
		{
			return [
				ConstResource.sResXmlItem_1,"resourceui_stagelevel.xml"
				];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			
			//添加加载动画
//			var loading:CJLoadingLayer = CJLoadingLayer.o;
//			CJLayerManager.o.addToModal(loading);
			
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("resouce_HeroStarUI", getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				
				if(r == 1)
				{
					//移除加载动画
//					CJLayerManager.o.disposeFromModal(loading);
					CJLoadingLayer.close();
					
					var s:XML = AssetManagerUtil.o.getObject("herostarLayout.sxml") as XML;
					_heroStarLayer = SFeatherControlUtils.o.genLayoutFromXML(s,CJHeroStarLayer) as CJHeroStarLayer;
					_heroStarLayer.startheroid = params as String;
					CJLayerManager.o.addToModuleLayerFadein(_heroStarLayer);
					_heroStarLayer.addAnimate(Starling.juggler);
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			CJLayerManager.o.removeFromLayerFadeout(_heroStarLayer);
			// 释放资源
			AssetManagerUtil.o.disposeAssetsByGroup("resouce_HeroStarUI");
			_heroStarLayer.removeAnimate(Starling.juggler);
			_heroStarLayer = null;
			// TODO Auto Generated method stub
			super._onExit(params);
		}
		
	}
}