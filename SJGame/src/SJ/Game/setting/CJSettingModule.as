package SJ.Game.setting
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.CJModulePopupBase;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import starling.core.Starling;
	
	/**
	 * 设置模块
	 * @author longtao
	 * 
	 */
	public class CJSettingModule extends CJModulePopupBase
	{
		private var _settingLayer:CJSettingLayer;
		
		public function CJSettingModule()
		{
			super("CJSettingModule");
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
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJSettingModuleResource", getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				if(r == 1)
				{
					CJLoadingLayer.close();
					
					var s:XML = AssetManagerUtil.o.getObject("settingLayout.sxml") as XML;
					_settingLayer = SFeatherControlUtils.o.genLayoutFromXML(s,CJSettingLayer) as CJSettingLayer;
					_settingLayer.addAllEventListener();
					CJLayerManager.o.addToModuleLayerFadein(_settingLayer);
				}
			});
		}
		
		override protected function _onExit(params:Object=null):void
		{
			_settingLayer.removeAllEventListener();
			CJLayerManager.o.removeFromLayerFadeout(_settingLayer);
			_settingLayer = null;
			
			AssetManagerUtil.o.disposeAssetsByGroup("CJSettingModuleResource");
			super._onExit(params);
		}
		
		override protected function _onInit(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onInit(params);
		}
	}
}