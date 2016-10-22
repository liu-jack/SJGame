package SJ.Game.transferAbility
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Common.Constants.ConstTransferAbility;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.data.CJDataOfTransferAbility;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;

	/**
	 * 传功模块
	 * @author zhengzheng
	 * 
	 */	
	public class CJTransferAbilityModule extends CJModulePopupBase
	{
		/*资源标志符*/
		private static const _RESOURCE_TYPE:String = "CJTransferAbilityModuleResource";
		private var _transferAbilityLayer:CJTransferAbilityLayer;
		
		public function CJTransferAbilityModule()
		{
			super("CJTransferAbilityModule");
		}
		
		override public function getPreloadResource():Array
		{
			return ["resourceui_card_common.xml",
				ConstResource.sResHeroPropertys,
				ConstResource.sResSxmlTransferAbility,
				ConstResource.sResSxmlTransferAbilityHero
			];
		}
		
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			CJLoadingLayer.show();
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RESOURCE_TYPE , getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress= r;
				if(r == 1)
				{
					//移除加载动画
					CJLoadingLayer.close();
					//进入模块时添加传功界面
					var transferAbilityXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlTransferAbility) as XML;
					_transferAbilityLayer = SFeatherControlUtils.o.genLayoutFromXML(transferAbilityXml, CJTransferAbilityLayer) as CJTransferAbilityLayer;
					CJLayerManager.o.addToModuleLayerFadein(_transferAbilityLayer);
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			ConstTransferAbility.clear();
			CJDataOfTransferAbility.o.dispose();
			for (var i:int = 0; i < _transferAbilityLayer.arrayHero.length; i++) 
			{
				if (_transferAbilityLayer.arrayHero[i].npc)
				{
					_transferAbilityLayer.arrayHero[i].npc.removeFromParent(true);
					_transferAbilityLayer.arrayHero[i].diposeShowData(i);
				}
			}
			//退出模块时去除动态层
//			_transferAbilityLayer.removeFromParent(true);
			CJLayerManager.o.removeFromLayerFadeout(_transferAbilityLayer);
			//移除加载的动态层的资源
			AssetManagerUtil.o.disposeAssetsByGroup(_RESOURCE_TYPE);
			_transferAbilityLayer = null;
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
	}
}