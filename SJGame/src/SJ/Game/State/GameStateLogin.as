package SJ.Game.State
{
	import SJ.MainApplication;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.Platform.ISPlatfrom;
	import SJ.Game.Platform.SPlatformEvents;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfPlatformReceipt;
	import SJ.Game.data.json.Json_client_predownload;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLayerRandomBackGround;
	import SJ.Game.layer.CJLoadingSceneLayer;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.utils.SApplicationUtils;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationLauch;
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.Logger;
	import engine_starling.utils.SStringUtils;
	
	import lib.engine.iface.game.IGameState;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	
	public class GameStateLogin implements IGameState
	{
		private var loadingStyle:String = CJLayerRandomBackGround.status_NormalLoad;
		public function GameStateLogin()
		{
		}
		
		public function getStateName():String
		{
			return "GameStateLogin";
		}
		
		public function onEnterState(params:Object = null):void
		{
			var firstloadarray:Array = new Array();
			_getFristLoadingResource(firstloadarray);
			
			
			//如果是从网络第一次加载资源,需要额外下载配置资源
			if(loadingStyle == CJLayerRandomBackGround.status_netLoad)
			{
				AssetManagerUtil.o.loadPrepareInQueueWithArray("resourcecommonnet",firstloadarray);
				_loadNewResouceByRemote();
			}
			else
			{
				//正常加载资源
				_loadResouceNormal();
			}
			
			
			
		}
		
		public function onExitState(params:Object = null):void
		{
			if(loadingStyle == CJLayerRandomBackGround.status_netLoad)
			{
				AssetManagerUtil.o.disposeAssetsByGroup("resourcecommonnet",true);
			}
			SApplication.moduleManager.exitModule("CJLoaderMoudle");
		}
		/**
		 * 获取首次资源加载列表，并确定加载方式 
		 * @param preloadResource
		 * @return 
		 * 
		 */
		private function _getFristLoadingResource(preloadResource:Array):Array
		{
			var proloadObjects:Object = AssetManagerUtil.o.getObject("client_predownload.json");
			//合并加载列表
			var proloadObjectsString:String = "";
			for each(var res:Object in proloadObjects)
			{
				proloadObjectsString += res.res;
			}
			
			
			//只显示一次 女人界面,除非更新 client_predownload
			var loadingData:SDataBase = new SDataBase("loadingData");
			loadingData.loadFromCache();
			var md5String:String = SStringUtils.md5String(proloadObjectsString);
			if(loadingData.getData("currentmd5","") != md5String ||
				loadingData.getData("loadfinish",0) == 0)
			{
				Logger.log("GameStateLogin","md5String f:" + proloadObjectsString +"do:" + loadingData.getData("currentmd5","")+"dn:" + md5String);
				loadingData.setData("currentmd5",md5String);
				loadingData.setData("loadfinish",0);
				loadingData.saveToCache();
				loadingStyle = CJLayerRandomBackGround.status_netLoad;
				
				var jsonD:Json_client_predownload = new Json_client_predownload();
				for each (var singleDownload:Object in proloadObjects)
				{
					jsonD.loadFromJsonObject(singleDownload);
					if (jsonD.level == 1)
					{
						preloadResource.push(jsonD.res);
					}
				}
			}
			
			return preloadResource;
		}
		private function getPreloaderResource():Array
		{
			var preloadResource:Array = ["resource_common_hero.xml"];
			//不管是否是第一次加载,都加载这个图片
			preloadResource.push(ConstResource.sResXmlCommonAnimsZip);
			preloadResource.push(ConstResource.sResXmlCommonSxmlZip);
			preloadResource.push(ConstResource.sResXmlCommonMp3bg);
			preloadResource.push(ConstResource.sResXmlCommonMp3dongwu);
			preloadResource.push(ConstResource.sResXmlCommonMp3ren);
			preloadResource.push(ConstResource.sResXmlCommonMp3uisound);
			preloadResource.push(ConstResource.sResXmlCommonUIEffect);
			preloadResource.push(ConstResource.sResXmlCommonNew1);
//			preloadResource.push(ConstResource.sResXmlCommonNew2);
//			preloadResource.push(ConstResource.sResXmlCommonNew3);
			preloadResource.push("resourceui_resloading0.xml");
			preloadResource.push("resourceui_resloading1.xml");
			
			preloadResource.push(ConstResource.sResXmlItem_1);
			
			
			
			
			return 	preloadResource;
		}
		
		/**
		 * 从远程加载新的资源 
		 * 
		 */
		private function _loadNewResouceByRemote():void
		{
			AssetManagerUtil.o.loadPrepareInQueueWithArray("resourcecommon",getPreloaderResource());
			CJLayerRandomBackGround.Show(CJLayerManager.o.rootLayer.normalLayer,loadingStyle);
			SApplicationLauch.closeBackground();
			var loadingSceneLayer:CJLoadingSceneLayer = new CJLoadingSceneLayer();
			loadingSceneLayer.show();
			AssetManagerUtil.o.loadQueue(function (f:Number):void
			{
	
				loadingSceneLayer.loadingprogress = f;
				if(f == 1)
				{	
				
					var loadingData:SDataBase = new SDataBase("loadingData");
					loadingData.loadFromCache();
					loadingData.setData("loadfinish",1);
					loadingData.saveToCache();
					loadingSceneLayer.close();
			
				
				
					Starling.juggler.delayCall(_ResouceLoaded,0.01);
				}
			});
		}
		/**
		 * 正常加载资源 
		 * 
		 */
		private function _loadResouceNormal():void
		{
			//首先加载loading 条需要资源
			AssetManagerUtil.o.loadPrepareInQueueWithArray("resourcecommonloading",["resourceui_resloading0.xml","resourceui_resloading1.xml"]);
			AssetManagerUtil.o.loadQueue(function (f:Number):void
			{
				if(f == 1)
				{
					//继续加载common资源,
					Starling.juggler.delayCall(_loadResouceNormalCommon,0.01);
				}
			});
				
		}
		
		/**
		 * 正常加载后续的资源 
		 * 
		 */
		private function _loadResouceNormalCommon():void
		{
			AssetManagerUtil.o.loadPrepareInQueueWithArray("resourcecommon",getPreloaderResource());
			//显示普通加载页面
			CJLayerRandomBackGround.Show(CJLayerManager.o.rootLayer.normalLayer,loadingStyle);
			var loadingSceneLayer:CJLoadingSceneLayer = new CJLoadingSceneLayer();
			loadingSceneLayer.show();
			
			AssetManagerUtil.o.loadQueue(function (f:Number):void
			{
				loadingSceneLayer.loadingprogress = f;
				if(f == 1)
				{
					loadingSceneLayer.close();
					Starling.juggler.delayCall(_ResouceLoaded,0.01);
				}
			});
		}
		
		/**
		 * 资源加载完成 
		 * 
		 */
		private function _ResouceLoaded():void
		{
			var iPlatform:ISPlatfrom = (SApplication.appInstance as MainApplication).platform;
			iPlatform.addEventListener(SPlatformEvents.EventInited,_onPlatform);
			iPlatform.addEventListener(SPlatformEvents.EventLogined,_onPlatform);
			iPlatform.addEventListener(SPlatformEvents.EventLogout,_onPlatform);
			iPlatform.addEventListener(SPlatformEvents.EventBuy,_onPlatform);
			
			iPlatform.startup(null);
		}
		/**
		 * 是否已经登录,只允许登录外部的平台,不能来回的搞.主要就是针对91IOS一次, 
		 * @return 
		 * 
		 */
		private var _logined:Boolean = false;
		private function _onPlatform(e:Event):void
		{
			var iPlatform:ISPlatfrom = (SApplication.appInstance as MainApplication).platform;
			if(e.type == SPlatformEvents.EventInited)
			{
				iPlatform.login(null);
			}
			else if(e.type == SPlatformEvents.EventLogined)
			{
				var succ:Boolean = Boolean(e.data.ret);
				if(succ)
				{
					if(_logined == false)
					{
						Logger.log("_onPlatform","Login succ!");
						_logined = true;
						_changeToStateSelfLogin();
					}
					else
					{
						Logger.log("_onPlatform","Login Duplication");
						CJMessageBox(CJLang("LOGIN_CHANGE_ACCOUNT_SUCC"),function ():void
						{
							SApplicationUtils.exit();
						});
					}
					
				}
				else
				{
					Logger.log("_onPlatform","Login failed");
					iPlatform.clearcache();
					CJMessageBox(CJLang("LOGIN_RESET_CLIENT"),function ():void
					{
						SApplicationUtils.exit();
					});
				}
			}
			else if(e.type == SPlatformEvents.EventBuy)
			{
				//处理收到后的票据
				var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
				dataReceipt.clearVerifyreceiptTimes();
				dataReceipt.checkAndSend();
			}
			else if(e.type == SPlatformEvents.EventLogout)
			{
				CJMessageBox(CJLang("LOGIN_LOGOUT_ACCOUNT_SUCC"),function ():void
				{
					SApplicationUtils.exit();
				});
			}
		}
		
		
		/**
		 * 切换到下一个窗台 
		 * 
		 */
		private function _changeToStateSelfLogin():void
		{
			Starling.juggler.delayCall(SApplication.stateManager.ChangeState,0.01,"GameStateSelfLogin",{remoteloaded:loadingStyle});
		}
		
	}
}