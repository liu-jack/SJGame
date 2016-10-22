package SJ.Game.mall
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;

	/**
	 * 商城模块
	 * @author sangxu
	 * @date:2013-06-28
	 */	
	public class CJMallModule extends CJModuleSubSystem
	{
		private var _mallLayer:CJMallLayer;
		
		/** 资源分组名 */
		private static const _RES_MALL_GROUP_NAME:String = "CJMallMoudleResource1"
		
		public function CJMallModule()
		{
		}
		
		override public function getPreloadResource():Array
		{
			return [
				ConstResource.sResXmlItem_1
			];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			//添加加载动画
			CJLoadingLayer.show();
			
			//加载强化层的布局文件和图片资源
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RES_MALL_GROUP_NAME, getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					CJLoadingLayer.close();
					//进入模块时添加商城层
					_mallLayer = new CJMallLayer();
					CJLayerManager.o.addToModuleLayerFadein(_mallLayer);
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			CJLayerManager.o.removeFromLayerFadeout(_mallLayer);
			// 移除加载的资源
			AssetManagerUtil.o.disposeAssetsByGroup(_RES_MALL_GROUP_NAME);
			this._mallLayer = null;
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
	}
}