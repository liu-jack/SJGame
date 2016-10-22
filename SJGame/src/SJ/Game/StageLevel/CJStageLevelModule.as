package SJ.Game.StageLevel
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
	 * 主角升阶模块
	 * @author longtao
	 * 
	 */
	public class CJStageLevelModule extends CJModulePopupBase
	{
		/** 升阶layer **/
		private var _stageLevelLayer:CJStageLevelLayer;
		
		public function CJStageLevelModule()
		{
			super("CJStageLevelModule");
		}
		
		override public function getPreloadResource():Array
		{
			return [
				"resourceui_stagelevel.xml",
//				"resourceui_stagelevelmonster1.xml",
//				"resourceui_stagelevelmonster2.xml",
				];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onEnter(params);
			//添加加载动画
//			var loading:CJLoadingLayer = CJLoadingLayer.o;
//			CJLayerManager.o.addToModal(loading);
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJStageLevelModuleResource", getPreloadResource());
//				"stageLevelLayout.sxml",
//				"resourceui_common.xml",
//				"resourceui_stagelevel.xml",
//				"anim_stagelevel.anims",
//				ConstResource.sResJsonStageLevel,
//				ConstResource.sResJsonForceStar);
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					//移除加载动画
//					CJLayerManager.o.disposeFromModal(loading);
					CJLoadingLayer.close();
					
					var s:XML = AssetManagerUtil.o.getObject("stageLevelLayout.sxml") as XML;
					_stageLevelLayer = SFeatherControlUtils.o.genLayoutFromXML(s,CJStageLevelLayer) as CJStageLevelLayer;
					
					CJLayerManager.o.addModuleLayer(_stageLevelLayer);
					
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			// TODO Auto Generated method stub
			_stageLevelLayer.removeFromParent(true);
			_stageLevelLayer = null;
			
			AssetManagerUtil.o.disposeAssetsByGroup("CJStageLevelModuleResource");
			super._onExit(params);
		}
		
	}
}