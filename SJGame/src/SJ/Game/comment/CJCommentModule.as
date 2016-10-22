package SJ.Game.comment
{
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	/**
	 * 评论活动模块
	 * @author zhengzheng
	 * 
	 */	
	public class CJCommentModule extends CJModuleSubSystem
	{
		private var _layer:CJCommentLayer;
		
		public function CJCommentModule()
		{
		}
		
		override public function getPreloadResource():Array
		{	
			return [];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onEnter(params);
			CJLoadingLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJCommentModuleResource",getPreloadResource());
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					CJLoadingLayer.close();
					_layer = new CJCommentLayer();
					CJLayerManager.o.addToModuleLayerFadein(_layer);
				}
			});
			
		}
		
		override protected function _onExit(params:Object=null):void
		{
			CJLayerManager.o.removeFromLayerFadeout(_layer);
			_layer = null;
			AssetManagerUtil.o.disposeAssetsByGroup("CJCommentModuleResource");
			
			super._onExit(params);
		}
		
	}
}