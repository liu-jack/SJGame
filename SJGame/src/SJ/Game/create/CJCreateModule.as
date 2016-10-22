package SJ.Game.create
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLayerRandomBackGround;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import starling.core.Starling;
	
	/**
	 * 创建角色模块
	 * @author longtao
	 * 
	 */
	public class CJCreateModule extends CJModuleSubSystem
	{
		private var _createLayer:CJCreateLayer;
		
		public function CJCreateModule()
		{
		}
		
		override public function getPreloadResource():Array
		{	
			return ["createLayout.sxml",ConstResource.sResJsonMaskWord, ConstResource.sResJsonNameConfig];
		}
		
		
		override protected function _onEnter(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onEnter(params);
			CJLoadingLayer.show();

			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJCreateModuleResource",getPreloadResource());
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					CJLoadingLayer.close();
					_createLayer = SFeatherControlUtils.genLayoutFromXMLHelp("createLayout.sxml",CJCreateLayer);
					CJLayerManager.o.addToScreenLayer(_createLayer);
					
					Starling.juggler.add(_createLayer);
					CJLayerRandomBackGround.Close();
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			// TODO Auto Generated method stub
			Starling.juggler.remove(_createLayer);
			_createLayer.removeFromParent(true);
			_createLayer = null
			AssetManagerUtil.o.disposeAssetsByGroup("CJCreateModuleResource");
			
			super._onExit(params);
		}
		
		override protected function _onInit(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onInit(params);
		}
		
	}
}