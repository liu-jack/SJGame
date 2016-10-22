package SJ.Game.selectServer
{
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	/**
	 * 选择服务器
	 * @author longtao
	 * 
	 */
	public class CJSelectServerModule extends CJModulePopupBase
	{
		private var _layer:CJSelectServerLayer;
		
		public function CJSelectServerModule()
		{
			super("CJSelectServerModule");
		}
		
		override public function getPreloadResource():Array
		{
			return ["selectServerLayout.sxml"];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			//添加加载动画
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJSelectServerModuleResource", getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				if(r == 1)
				{
					CJLoadingLayer.close();
					
					var s:XML = AssetManagerUtil.o.getObject("selectServerLayout.sxml") as XML;
					_layer = SFeatherControlUtils.o.genLayoutFromXML(s, CJSelectServerLayer) as CJSelectServerLayer;
					if (params && params.hasOwnProperty("beforeLogin"))
					{
						CJLayerManager.o.addToModal(_layer);
						_layer.btnListClose.visible = false;
						_layer.btnSelectClose.visible = false;
					}
					else
					{
						CJLayerManager.o.addToModuleLayerFadein(_layer);
					}
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			CJLayerManager.o.removeFromLayerFadeout(_layer);
			_layer = null;
			
			AssetManagerUtil.o.disposeAssetsByGroup("CJSelectServerModuleResource");
			super._onExit(params);
		}
	}
}