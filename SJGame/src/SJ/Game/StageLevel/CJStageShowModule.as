package SJ.Game.StageLevel
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	/**
	 * 展示武星信息
	 * @author longtao
	 * 
	 */
	public class CJStageShowModule extends CJModulePopupBase
	{
		/** 展示武星信息 **/
		private var _stageShowLayer:CJStageShowLayer;
		
		public function CJStageShowModule()
		{
			super("CJStageShowModule");
		}
		
		override public function getPreloadResource():Array
		{
			return [
				"resourceui_stagelevel.xml"];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onEnter(params);
			//添加加载动画
//			var loading:CJLoadingLayer = CJLoadingLayer.o;
//			CJLayerManager.o.addToModal(loading);
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJStageShowModuleResource", getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					//移除加载动画
//					CJLayerManager.o.disposeFromModal(loading);
					CJLoadingLayer.close();
					
					var s:XML = AssetManagerUtil.o.getObject("stageShowLayout.sxml") as XML;
					_stageShowLayer = SFeatherControlUtils.o.genLayoutFromXML(s,CJStageShowLayer) as CJStageShowLayer;
					_stageShowLayer.curforceStar = params.forceStarIndex;
					
					CJLayerManager.o.addToModuleLayerFadein(_stageShowLayer);
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			CJLayerManager.o.removeFromLayerFadeout(_stageShowLayer);
			_stageShowLayer.exit();
			_stageShowLayer = null;
			
			AssetManagerUtil.o.disposeAssetsByGroup("CJStageShowModuleResource");
			super._onExit(params);
		}

		
	}
}