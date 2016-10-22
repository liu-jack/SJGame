package SJ.Game.moneytree
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	public class CJMoneyTreeModule extends CJModulePopupBase
	{
		private var _moneyTreeLayer:CJMoneyTreeLayer;
		
		/** 资源分组名 */
		private static const _RES_MT_GROUP_NAME:String = "CJMoneyTreeModuleResource"; 
		
		public function CJMoneyTreeModule()
		{
			super("CJMoneyTreeModule");
		}
		
		override public function getPreloadResource():Array
		{
			return [
				
			];
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			CJLoadingLayer.show();
			//加载强化层的布局文件和图片资源
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RES_MT_GROUP_NAME, getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				if(r == 1)
				{
					//移除加载动画
					CJLoadingLayer.close();
					//进入模块时添加背包层
					var moneyTreeXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlMoneyTree) as XML;
					_moneyTreeLayer = SFeatherControlUtils.o.genLayoutFromXML(moneyTreeXml, CJMoneyTreeLayer) as CJMoneyTreeLayer;
					CJLayerManager.o.addToModuleLayerFadein(_moneyTreeLayer);
					
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
			super._onExit(params);
			// 退出模块时去除摇钱树层
			CJLayerManager.o.removeFromLayerFadeout(_moneyTreeLayer);
			// 移除加载的摇钱树层的资源
			AssetManagerUtil.o.disposeAssetsByGroup(_RES_MT_GROUP_NAME);
			this._moneyTreeLayer = null;
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
	}
}