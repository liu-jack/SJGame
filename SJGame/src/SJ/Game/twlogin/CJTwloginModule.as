package SJ.Game.twlogin
{
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingSceneLayer;
	import SJ.Game.login.CJLoginLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	
	public class CJTwloginModule extends CJModuleSubSystem
	{
		private var _loginLayer:CJTwloginLayer
		public function CJTwloginModule()
		{
			super();
		}
		override public function getPreloadResource():Array
		{
			return ["resourceui_twlogin.xml","twlogin.json"];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			
			//			CJLayerRandomBackGround.Show(CJLayerManager.o.rootLayer.normalLayer);
			var loadingSceneLayer:CJLoadingSceneLayer = new CJLoadingSceneLayer();
			loadingSceneLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJLoginModuleResource",getPreloadResource());
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				loadingSceneLayer.loadingprogress = r;
				if(r == 1)
				{
					loadingSceneLayer.close();
					
					//					if (!CONFIG::tech)
					//					CJLayerRandomBackGround.Show(CJLayerManager.o.rootLayer.normalLayer);
					_loginLayer = SFeatherControlUtils.o.genLayoutFromcocosJson(AssetManagerUtil.o.getObject("twlogin.json"),CJTwloginLayer) as CJTwloginLayer;
					//					_loginLayer = SFeatherControlUtils.genLayoutFromXMLHelp("loginLayout.sxml",CJLoginLayer);
					//					_loginLayer.visible = false;
					
					
					CJLayerManager.o.addToScreenLayer(_loginLayer);
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			_loginLayer.removeFromParent(true);
			_loginLayer = null;
			//			CJLayerManager.o.removeModuleLayer(_testLayer);
			AssetManagerUtil.o.disposeAssetsByGroup("CJLoginModuleResource");
			// TODO Auto Generated method stub
			super._onExit(params);
		}
		
		override protected function _onInit(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onInit(params);
		}
	}
}