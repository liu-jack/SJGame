package SJ.Game.achievement
{
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	
	/**
	 * 里程碑模块
	 * @author changmiao
	 * 
	 */
	public class CJAchievementModule extends CJModulePopupBase
	{
		private var _Layer:CJAchievementLayer;
		public function CJAchievementModule()
		{
			super("CJAchievementModule");
		}
		
		override public function getPreloadResource():Array
		{
			return []
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			//添加加载动画
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJAchievementResource", getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					//移除加载动画
					CJLoadingLayer.close();
					
					_Layer = new CJAchievementLayer();
					_Layer.width = 428;
					_Layer.height = 287;	
					CJLayerManager.o.addToModuleLayerFadein(_Layer);
					
					//处理指引
					if(CJDataManager.o.DataOfFuncList.isIndicating)
					{
						CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
					}
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			CJLayerManager.o.removeFromLayerFadeout(_Layer);
			_Layer = null;
			
			AssetManagerUtil.o.disposeAssetsByGroup("CJAchievementResource");
			super._onExit(params);
		}
		
		override protected function _onInit(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onInit(params);
		}
		
	}
}
