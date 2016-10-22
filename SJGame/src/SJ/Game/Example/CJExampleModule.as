package SJ.Game.Example
{
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.layer.CJLayerManager;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	public class CJExampleModule extends CJModuleSubSystem
	{
		private var _exampleLayer:CJExampleLayer;
		public function CJExampleModule()
		{
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			
			AssetManagerUtil.o.loadPrepareInQueue("CJExampleModuleResource","exampleLayout.sxml");
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				if(r == 1)
				{
					var s:XML = AssetManagerUtil.o.getObject("exampleLayout.sxml") as XML;
					_exampleLayer = SFeatherControlUtils.o.genLayoutFromXML(s,CJExampleLayer) as CJExampleLayer;
					CJLayerManager.o.addModuleLayer(_exampleLayer);
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			AssetManagerUtil.o.disposeAssetsByGroup("CJExampleModuleResource");
			CJLayerManager.o.removeModuleLayer(_exampleLayer);
			// TODO Auto Generated method stub
			super._onExit(params);
		}
		
		
	}
}