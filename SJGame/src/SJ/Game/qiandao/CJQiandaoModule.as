package SJ.Game.qiandao
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	
	/**
	 * 签到模块
	 * @author bb
	 */	
	public class CJQiandaoModule extends CJModuleSubSystem
	{
		private var _qiandaolLayer:CJQiandaoLayer;
		
		/** 资源分组名 */
		private static const _RES_QIANDAO_GROUP_NAME:String = "CJQiandaoResource";
		
		public function CJQiandaoModule()
		{
		}
		
		override public function getPreloadResource():Array
		{
			return [];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			//添加加载动画
			CJLoadingLayer.show();
			
			//加载强化层的布局文件和图片资源
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RES_QIANDAO_GROUP_NAME, getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					CJLoadingLayer.close();
					//进入模块时添加
					_qiandaolLayer = new CJQiandaoLayer();
					CJLayerManager.o.addToModuleLayerFadein(_qiandaolLayer);
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			CJLayerManager.o.removeFromLayerFadeout(_qiandaolLayer);
			
			// 移除加载的资源
			AssetManagerUtil.o.disposeAssetsByGroup(_RES_QIANDAO_GROUP_NAME);
			this._qiandaolLayer = null;
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
	}
}