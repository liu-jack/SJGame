package SJ.Game.mainUI
{
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.CJDataOfScene;
	import SJ.Game.data.config.CJDataOfFuncIndicatePropertyList;
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	import SJ.Game.data.config.CJDataOfMainSceneProperty;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.funcopen.CJFuncOpenChecker;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLayerRandomBackGround;
	import SJ.Game.layer.CJLoadingSceneLayer;
	import SJ.Game.task.CJTaskNavigation;
	
	import engine_starling.SApplication;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import starling.core.Starling;

	/**
	 * @modified caihua 2013/06/21 - 去除重复数据加载，整理数据加载方式
	 * @author zhengzheng
	 * 主界面模块
	 */	
	public class CJMainUiModule extends CJModuleSubSystem
	{
		private var _mainUiLayer:CJMainUiLayer;
		private var _mainLayer:CJMainSceneLayer;
		private var _mapid:int;
		private var _mapInfo:Object;
		private var _cjTaskNavigation:CJTaskNavigation;
		
		public function CJMainUiModule()
		{
		}
		
		override public function getPreloadResource():Array
		{
			return [];
		}
		
		
		
		private var _params:Object
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			CJLayerRandomBackGround.Show(CJLayerManager.o.rootLayer.normalLayer);
			var loadingSceneLayer:CJLoadingSceneLayer = new CJLoadingSceneLayer();
			loadingSceneLayer.show();
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJMainUiModuleResource0" , getPreloadResource());
			AssetManagerUtil.o.loadQueue(function(r:Number):void
			{
				loadingSceneLayer.loadingprogress = r;
				if(r == 1)
				{
					_params = params;
					initUi();
					loadingSceneLayer.close();
					
					// 添加主角回复体力Push监听
					CJDataManager.o.DataOfRole.addLocalNotification();
				}
			})
			
		}

		private function enterScene():void
		{
			//加载主界面层的布局文件和图片资源
			CJLayerRandomBackGround.Show(CJLayerManager.o.rootLayer.normalLayer);
			var loadingSceneLayer:CJLoadingSceneLayer = new CJLoadingSceneLayer();
			loadingSceneLayer.show();
			
			AssetManagerUtil.o.loadPrepareInQueue("CJMainUiModuleResource0",
				"resourceui_card_common.xml",
				this._mapInfo.path);
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				loadingSceneLayer.loadingprogress = r;
				if(r == 1)
				{
					_cjTaskNavigation = new CJTaskNavigation();
					//进入模块时添加主界面层
					var zhujiemianXml:XML = AssetManagerUtil.o.getObject("zhujiemianLayout.sxml") as XML;
					_mainUiLayer = SFeatherControlUtils.o.genLayoutFromXML(zhujiemianXml,CJMainUiLayer) as CJMainUiLayer;
					_mainLayer = new CJMainSceneLayer;
					//将场景地图信息传给地图层
					_mainLayer.mapInfo = _mapInfo;
					//第一次进入游戏设置所在场景ID
					CJDataOfScene.o.sceneid = _mapInfo.id;
					CJDataOfScene.o.isInMainCity = true;
					
					CJLayerManager.o.addToScreenLayer(_mainLayer);
					CJLayerManager.o.addToScreenLayer(_mainUiLayer);
					
					if(!CJDataManager.o.DataOfNotice.hasAutoShown)
					{
						//发最新公告
						Starling.juggler.delayCall(function():void
						{
							CJDataManager.o.DataOfNotice.hasAutoShown = true;
							SApplication.moduleManager.enterModule('CJNoticeModule');
						},
						2);
					}
					
					
//					初始化配置数据
					CJDataOfMainSceneProperty.o;
					CJFuncOpenChecker.o;
					CJDataOfFuncPropertyList.o;
					CJDataOfFuncIndicatePropertyList.o;
					
					loadingSceneLayer.close();
					
//					检测是否有开启
					
					if(CJDataManager.o.DataOfFuncList.needOpenFunctionAfterReturnToTown != -1 && CJDataOfScene.o.isTown())
					{
						//移除所有其他层
						CJLayerManager.o.removeAllModuleLayer();
						var currentLevel:int = int(CJDataManager.o.DataOfHeroList.getMainHero().level);
						CJFuncOpenChecker.o.checkTriggerFunction(currentLevel);
					}
				}
			});
		}
		
		private function initUi():void
		{
			var data:Object = this._params
			if(data && data.hasOwnProperty("cityid"))
			{
				_mapInfo = CJDataOfMainSceneProperty.o.getPropertyById(int(data.cityid));
			}
			else
			{
				var role:CJDataOfRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole;
				var sceneId:int = int(role.last_map);
				if(sceneId == 0)
				{
					sceneId = CJDataOfScene.RELIVE_CITY_ID;
				}
				_mapInfo  = CJDataOfMainSceneProperty.o.getPropertyById(sceneId);
			}
			if(_params &&_params.hasOwnProperty("fromscreen"))
			{
				_mapInfo.fromscreen = _params.fromscreen
			}
			enterScene();
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
//			_mainLayer.dispose();
			//退出模块时去除主界面层
			if(_mainUiLayer)
			{
				_mainUiLayer.removeAllEventlisteners();
				_mainUiLayer.removeFromParent(true);
				_mainUiLayer = null;
			}
			if(_mainLayer)
			{
				_mainLayer.removeFromParent(true);
				_mainLayer = null;
			}
			_cjTaskNavigation.dispose();
			_cjTaskNavigation = null;
			CJDataOfScene.o.isInMainCity = false;
			//移除加载的主界面层的资源
			AssetManagerUtil.o.disposeAssetsByGroup("CJMainUiModuleResource0");
			AssetManagerUtil.o.disposeAssetsByGroup("CJMainUiModuleResource1");
			// 去除监听
			CJEventDispatcher.o.removeEventListeners(CJEvent.EVENT_OLREWARD_TICK)
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
	}
}