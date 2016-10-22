package SJ.Game.loader
{
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLayerRandomBackGround;
	import SJ.Game.layer.CJLoadingSceneLayer;
	
	import engine_starling.SApplication;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.Logger;
	
	import flash.system.System;
	
	import lib.engine.iface.IFacadeModule;
	import lib.engine.utils.functions.Assert;
	
	import starling.core.Starling;
	
	public class CJLoaderMoudle extends CJModuleSubSystem
	{
		private var _modulelist:Array;
		private var _moduleparams:Array;
		private var _resourcelist:Array;
		private var _fullresourcelist:Array;

		public function CJLoaderMoudle()
		{
		}
		
		/**
		 * 进入主城助手类 
		 * @param params
		 * @param continueloaded 是否继续后台加载
		 */
		public static function helper_enterMainUI(params:Object = null,continueloaded:Boolean = true):void
		{
//			CJLoaderMoudle.loadModuleWithResource(["CJMainUiModule"],
//				["CJMainUiModule",
//				 "CJBagModule",
//				"CJHeroPropertyUIModule",
//				"CJFormationModule",
//				"CJNPCDialogModule",
//				"CJEnhanceModule",
//				"CJWinebarModule",
//				"CJWinebarDictModule",
//				"CJWinebarHeroModule",
//				"CJTaskModule",
//				"CJHorseModule",
//				"CJJewelModule",
//				"CJHeroStarModule",
//				"CJFriendModule",
//				"CJChatModule",
//				"CJStageLevelModule",
//				"CJStageShowModule",
//				"CJRankModule",
//				"CJMoneyTreeModule",
//				"CJHeroTrainModule",
//				"CJNPCTaskDialogMoudle",
//				"CJCampModule",
//				"CJFuncListModule",
//				"CJFunctionOpenModule",
//				"CJRechargeModule",
//				"CJDynamicModule",
//				"CJArenaModule",
//				"CJMallModule",
//				"CJDynamicModule",
//				"CJOLRewardModul",],
//				[params]);
			var continueResource:Array = null;
			if(false)
			{
				continueResource = ["CJBagModule",
					"CJHeroPropertyUIModule",
					"CJFormationModule",
					"CJNPCDialogModule",
					"CJEnhanceModule",
					"CJWinebarModule",
					"CJWinebarDictModule",
					"CJWinebarHeroModule",
					"CJTaskModule",
					"CJHorseModule",
					"CJJewelModule",
					"CJHeroStarModule",
					"CJFriendModule",
					"CJChatModule",
					"CJStageLevelModule",
					"CJStageShowModule",
					"CJRankModule",
					"CJMoneyTreeModule",
					"CJHeroTrainModule",
					"CJNPCTaskDialogMoudle",
					"CJCampModule",
					"CJFuncListModule",
					"CJFunctionOpenModule",
					"CJRechargeModule",
					"CJDynamicModule",
					"CJArenaModule",
					"CJMallModule",
					"CJDynamicModule",
					"CJOLRewardModul"]
			}
			
			
			CJLoaderMoudle.loadModuleWithResource(["CJMainUiModule"],
				["CJMainUiModule","CJFubenModule"],
				[params],
				continueResource);
		}
		
		public static function helper_enterWorld(params:Object = null):void
		{
			CJLoaderMoudle.loadModuleWithResource(["CJWorldModule"],
				["CJWorldModule"],
				[params]);
		}
		
		/**
		 * 进入副本战斗 
		 * @param params
		 * 
		 */
		public static function helper_enterFubenBattle(params:Object = null):void
		{
			CJLoaderMoudle.loadModuleWithResource(["CJFubenBattleBaseModule"],
				["CJFubenBattleBaseModule","CJFubenBattleModule"],
				[params]);
		}

		/**
		 * 加载模块和资源 ,这个点应该是整体loading 的点
		 * @param entermodules 需要进入的模块
		 * @param resourceModules 需要加载的模块资源(min)
		 * @param entermoduleparams 进入模块参数
		 * @param moduleFullResource 需要加载资源 (full)
		 * 
		 */
		public static function loadModuleWithResource(entermodules:Array,resourceModules:Array,entermoduleparams:Array = null,modulefullresource:Array = null):void
		{
			//退出上一次的这个模块
			SApplication.moduleManager.exitModule("CJLoaderMoudle");
			System.pauseForGCIfCollectionImminent(0);
			System.gc();
			var resourcelist:Array = new Array();
			//解析modulelist中的资源
			var length:uint = resourceModules.length;
			for (var i:int=0;i<length;i++)
			{
				var module:IFacadeModule =  SApplication.moduleManager.getModule(resourceModules[i]);
				if (module is CJModuleSubSystem)
				{
					var cjmodule:CJModuleSubSystem = module as CJModuleSubSystem;
					var singleResourceList:Array = cjmodule.getPreloadResource();
					var singleResourceListlength:uint = singleResourceList.length;
					for (var j:int = 0;j<singleResourceListlength;j++)
					{
						if(resourcelist.indexOf(singleResourceList[j]) == -1)
						{
							resourcelist.push(singleResourceList[j]);
						}
							
					}
				}
			}
			
			if (entermoduleparams == null)
				entermoduleparams = new Array();
			
			if (entermoduleparams.length != entermodules.length)
			{
				var loopcount:int = entermodules.length - entermoduleparams.length;
				Assert(loopcount>0,"加载模块中,填充数组错误 loopcount:" + loopcount);
				for(i=0;i<loopcount;i++)
				{
					entermoduleparams.push(null);
				}
			}
			
			var resourcefulllist:Array = new Array();
			//解析modulelist中的资源
			if(modulefullresource == null)
			{
				length = 0;
			}
			else
			{
				length = modulefullresource.length;
			}
			
			for ( i=0;i<length;i++)
			{
				 module =  SApplication.moduleManager.getModule(modulefullresource[i]);
				if (module is CJModuleSubSystem)
				{
					 cjmodule = module as CJModuleSubSystem;
					 singleResourceList = cjmodule.getPreloadResource();
					 singleResourceListlength = singleResourceList.length;
					for ( j = 0;j<singleResourceListlength;j++)
					{
						if(resourcefulllist.indexOf(singleResourceList[j]) == -1)
						{
							resourcefulllist.push(singleResourceList[j]);
						}
						
					}
				}
			}
			var params:Object = {"modulevec":entermodules,"resourcelist":resourcelist,
				"entermoduleparams":entermoduleparams,"modulefullresource":resourcefulllist};
			
			SApplication.moduleManager.enterModule("CJLoaderMoudle",params);
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			_modulelist = params.modulevec.concat();
			_resourcelist = params.resourcelist.concat();
			_moduleparams = params.entermoduleparams;
			_fullresourcelist = params.modulefullresource;
			
			if(_resourcelist.length == 0)
			{
				for (var i:int =0;i<_modulelist.length;i++)
				{
					SApplication.moduleManager.enterModule(_modulelist[i],_moduleparams[i]);
				}
			}
			else
			{
				CJLayerRandomBackGround.Show(CJLayerManager.o.rootLayer.normalLayer);
				var loadingSceneLayer:CJLoadingSceneLayer = new CJLoadingSceneLayer();
				loadingSceneLayer.show();
				AssetManagerUtil.o.loadPrepareInQueueWithArray("CJLoaderModuleResource",_resourcelist);
				AssetManagerUtil.o.loadQueue(function(r:Number):void
				{
					loadingSceneLayer.loadingprogress = r;
					if(r == 1)
					{
						for (var i:int =0;i<_modulelist.length;i++)
						{
							SApplication.moduleManager.enterModule(_modulelist[i],_moduleparams[i]);
						}
						loadingSceneLayer.close();
						CJLayerRandomBackGround.Close();
						
						//加载后续资源
						if(_fullresourcelist!= null && _fullresourcelist.length != 0)
						{
							Starling.juggler.delayCall(_loadfullResource,0.1,_fullresourcelist)
						}
					}
				})
			}
			
			function _loadfullResource(resourceArray:Array):void
			{
				AssetManagerUtil.o.loadPrepareInQueueWithArray("CJLoaderModuleResourceFull",resourceArray);
				AssetManagerUtil.o.loadQueue(function(r:Number):void
				{
					if (r == 1.0)
					{
						Logger.log("CJLoaderModule","load full resource complete");
					}
				});
			}
			
		}
		
		override protected function _onExit(params:Object=null):void
		{
			if(_modulelist == null)
				return;
			
			for (var i:int =0;i<_modulelist.length;i++)
			{
				SApplication.moduleManager.exitModule(_modulelist[i]);
			}
			
			if(_resourcelist.length != 0)
			{
				AssetManagerUtil.o.disposeAssetsByGroup("CJLoaderModuleResource");
			}
			
			//不清除full资源
//			if(_fullresourcelist!= null && _fullresourcelist.length != 0)
//			{
//				AssetManagerUtil.o.disposeAssetsByGroup("CJLoaderModuleResourceFull");
//			}
			//清除无用资源
			//慢慢GC
			AssetManagerUtil.o.removeUnusedResource();
			
			_modulelist = null;
			_resourcelist = null;
			_fullresourcelist = null;
			super._onExit(params);
		}
	}
}