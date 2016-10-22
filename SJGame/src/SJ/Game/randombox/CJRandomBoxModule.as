package SJ.Game.randombox
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfEquipmentbar;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;

	/**
	 * 
	 * @author sangxu
	 * @date   2013-09-09
	 * 背包模块
	 */	
	public class CJRandomBoxModule extends CJModulePopupBase
	{
		
		private var _boxLayer:CJRandomBoxLayer;
		/** 资源分组名 */
		private static const _RES_BOX_GROUP_NAME:String = "CJRandomBoxModuleResource";
		public function CJRandomBoxModule()
		{
			super("CJRandomBoxModule");
		}
		
		override public function getPreloadResource():Array
		{
			return [
//					"resourceui_randombox.xml",
					ConstResource.sResXmlItem_1
			];
		}
		
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			CJLoadingLayer.show();
//			//添加加载动画
			//加载背包层的布局文件和图片资源
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RES_BOX_GROUP_NAME, getPreloadResource());

			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				
				if(r == 1)
				{
					//移除加载动画
					CJLoadingLayer.close();
					//进入模块时添加背包层
					var beibaoXml:XML = AssetManagerUtil.o.getObject("randomboxLayout.sxml") as XML;
					_boxLayer = SFeatherControlUtils.o.genLayoutFromXML(beibaoXml, CJRandomBoxLayer) as CJRandomBoxLayer;
					_boxLayer.setItemId(params.itemid);
					CJLayerManager.o.addToModuleLayerFadein(_boxLayer);
					
					CJDataOfItemProperty.o;
//					//处理指引
//					if(CJDataManager.o.DataOfFuncList.isIndicating)
//					{
//						CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
//					}
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			//退出模块时去除背包层
			CJLayerManager.o.removeFromLayerFadeout(_boxLayer);
			//移除加载的背包层的资源
			AssetManagerUtil.o.disposeAssetsByGroup(_RES_BOX_GROUP_NAME);
			this._boxLayer = null;
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
	}
}