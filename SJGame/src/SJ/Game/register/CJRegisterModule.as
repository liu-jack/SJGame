package SJ.Game.register
{
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.layer.CJLayerManager;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;

	/**
	 * 注册帐号模块
	 * @author longtao 
	 * 
	 */
	public class CJRegisterModule extends CJModuleSubSystem
	{
		private var _registerLayer:CJRegisterLayer;
		
		public function CJRegisterModule()
		{
		}
		
		override public function getPreloadResource():Array
		{
			return ["registerLayout.sxml"];
		}
		
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJLoginModuleResource",getPreloadResource());
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				if(r == 1)
				{
					_registerLayer = SFeatherControlUtils.genLayoutFromXMLHelp("registerLayout.sxml",CJRegisterLayer);
					CJLayerManager.o.addToScreenLayer(_registerLayer);
				}
			});
			
		}
		
		override protected function _onExit(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onExit(params);
			_registerLayer.removeFromParent(true);
			_registerLayer = null;
		}
		
		override protected function _onInit(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onInit(params);
		}
	}
}