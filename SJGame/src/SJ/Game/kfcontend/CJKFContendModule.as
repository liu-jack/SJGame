package SJ.Game.kfcontend
{
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	
	/**
	 * 开服争霸
	 * @author bianbo
	 * 
	 */	
	public class CJKFContendModule extends CJModulePopupBase
	{
		// 
		private var _kfLayer:CJKFContendLayer;
		
		public function CJKFContendModule()
		{
			super("CJKFContendModule");
		}
		
		override public function getPreloadResource():Array
		{
			return [
//				"resourceui_kfcontend.xml"
			];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			//添加加载动画
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJKFContendResource", getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					//移除加载动画
					CJLoadingLayer.close();
					_kfLayer = new CJKFContendLayer();
					
					CJLayerManager.o.addToModuleLayerFadein(_kfLayer);
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			CJLayerManager.o.removeFromLayerFadeout(_kfLayer);
			
			AssetManagerUtil.o.disposeAssetsByGroup("CJKFContendResource");
			_kfLayer = null;			
		}
		
		override protected function _onInit(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onInit(params);
		}
		
	}
}