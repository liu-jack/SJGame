package SJ.Game.worldboss
{
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.data.CJDataOfScene;
	import SJ.Game.data.config.CJDataOfMainSceneProperty;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.utils.AssetManagerUtil;
	
	/**
	 +------------------------------------------------------------------------------
	 * 世界Boss模块
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-19 上午9:47:55  
	 +------------------------------------------------------------------------------
	 */
	public class CJWorldBossModule extends CJModuleSubSystem
	{
		private var _params:Object;
		private var _worldBossMainLayer:CJWorldBossLayer;
		public static const MODULE_RESOURCE_NAME:String = "CJWorldBossModuleResource";
		
		public function CJWorldBossModule()
		{
		}
		
		override public function getPreloadResource():Array
		{
			//预加载的地图
			var sceneConfig:Object = CJDataOfMainSceneProperty.o.getPropertyById(this._params.sceneId);
			return [sceneConfig.path 
//				, ConstResource.sResXmlWorldBoss
			];
		}
		
		
		override protected function _onEnter(params:Object=null):void
		{
			_params = params;
			if(!_params)
			{
				_params = {"sceneId":104};
			}
			super._onEnter(params);
			CJLoadingLayer.show();
			AssetManagerUtil.o.loadPrepareInQueueWithArray(MODULE_RESOURCE_NAME,getPreloadResource());
			AssetManagerUtil.o.loadQueue(function(r:Number):void
			{
				if(r == 1)
				{
					CJLoadingLayer.close();
					_worldBossMainLayer = new CJWorldBossLayer();
					CJLayerManager.o.addToModalLayerFadein(_worldBossMainLayer);
					_worldBossMainLayer.enterSceneId = _params.sceneId;
					CJDataOfScene.o.sceneid = _params.sceneId;
				}
			})
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			CJLayerManager.o.removeFromLayerFadeout(_worldBossMainLayer);
			_worldBossMainLayer = null;
			AssetManagerUtil.o.disposeAssetsByGroup(MODULE_RESOURCE_NAME);
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
	}
}