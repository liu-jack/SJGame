package SJ
{
	import com.kaixin001.fxane.AlertEvent;
	import com.kaixin001.fxane.HelloAne;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import GameConsole.ConsoleApplication;
	
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstOnlineDebug;
	import SJ.Common.Constants.ConstPlatformId;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.Example.CJExampleModule;
	import SJ.Game.NPCDialog.CJNPCDialogModule;
	import SJ.Game.NPCDialog.CJNPCTaskDialogMoudle;
	import SJ.Game.Notice.CJNoticeModule;
	import SJ.Game.Platform.ISPlatfrom;
	import SJ.Game.ServerList.CJServerList;
	import SJ.Game.SocketServer.SocketCommand_record;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.StageLevel.CJStageLevelModule;
	import SJ.Game.StageLevel.CJStageShowModule;
	import SJ.Game.State.GameStateGaming;
	import SJ.Game.State.GameStateLogin;
	import SJ.Game.State.GameStateSelfLogin;
	import SJ.Game.achievement.CJAchievementModule;
	import SJ.Game.activity.CJActivityModule;
	import SJ.Game.arena.CJArenaBattleModule;
	import SJ.Game.arena.CJArenaModule;
	import SJ.Game.bag.CJBagModule;
	import SJ.Game.battle.CJBattleModule;
	import SJ.Game.camp.CJCampModule;
	import SJ.Game.cdkey.CJCDKeyModule;
	import SJ.Game.chat.CJChatModule;
	import SJ.Game.comment.CJCommentModule;
	import SJ.Game.core.PushService;
	import SJ.Game.core.TalkingDataService;
	import SJ.Game.create.CJCreateModule;
	import SJ.Game.dailytask.CJDailyTaskModule;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.json.Json_serverlist;
	import SJ.Game.duobao.CJDuoBaoBattleModule;
	import SJ.Game.duobao.CJDuoBaoModule;
	import SJ.Game.dynamics.CJDynamicModule;
	import SJ.Game.enhanceequip.CJEnhanceModule;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.firstrecharge.CJFirstRechargeModule;
	import SJ.Game.formation.CJFormationModule;
	import SJ.Game.friends.CJFriendModule;
	import SJ.Game.fristBattle.CJFristBattleModule;
	import SJ.Game.fuben.CJActiveFbModule;
	import SJ.Game.fuben.CJFubenBattleBaseModule;
	import SJ.Game.fuben.CJFubenBattleModule;
	import SJ.Game.fuben.CJFubenModule;
	import SJ.Game.funcopen.CJFunctionOpenModule;
	import SJ.Game.funcpoint.CJFuncListModule;
	import SJ.Game.funcpoint.CJPractiseModule;
	import SJ.Game.funcpoint.CJSplendidActivityModule;
	import SJ.Game.heroPropertyUI.CJHeroPropertyUIModule;
	import SJ.Game.heroStar.CJHeroStarModule;
	import SJ.Game.herotrain.CJHeroTrainModule;
	import SJ.Game.horse.CJHorseModule;
	import SJ.Game.jewel.CJJewelModule;
	import SJ.Game.kfcontend.CJKFContendModule;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.loader.CJLoaderMoudle;
	import SJ.Game.login.CJLoginModule;
	import SJ.Game.mainUI.CJMainUiModule;
	import SJ.Game.mall.CJMallModule;
	import SJ.Game.moneytree.CJMoneyTreeModule;
	import SJ.Game.onlineReward.CJOLRewardModul;
	import SJ.Game.pilerecharge.CJPileRechargeModule;
	import SJ.Game.qiandao.CJQiandaoModule;
	import SJ.Game.randombox.CJRandomBoxModule;
	import SJ.Game.rank.CJRankModule;
	import SJ.Game.recharge.CJRechargeModule;
	import SJ.Game.register.CJRegisterModule;
	import SJ.Game.reward.CJRewardModule;
	import SJ.Game.selectServer.CJSelectServerModule;
	import SJ.Game.setting.CJSettingModule;
	import SJ.Game.setting.CJSettingUtils;
	import SJ.Game.strategy.CJStrategyModule;
	import SJ.Game.task.CJTaskModule;
	import SJ.Game.transferAbility.CJTransferAbilityModule;
	import SJ.Game.twlogin.CJTwloginModule;
	import SJ.Game.upgrade.CJClientUpgradeModule;
	import SJ.Game.utils.SAdUtils;
	import SJ.Game.utils.SApplicationUtils;
	import SJ.Game.utils.SCompileUtils;
	import SJ.Game.utils.SNetWorkUtils;
	import SJ.Game.vip.CJVipModule;
	import SJ.Game.vip.CJVipPrivilegeModule;
	import SJ.Game.winebar.CJWinebarDictModule;
	import SJ.Game.winebar.CJWinebarHeroModule;
	import SJ.Game.winebar.CJWinebarModule;
	import SJ.Game.world.CJWorldModule;
	import SJ.Game.worldboss.CJWorldBossModule;
	import SJ.Game.worldmap.CJWorldMapModule;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.SApplicationLauch;
	import engine_starling.Events.AssetEvent;
	import engine_starling.display.SScale3Plane;
	import engine_starling.display.SScale9Plane;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.Logger;
	import engine_starling.utils.SAssetsCache;
	import engine_starling.utils.SEventUtils;
	import engine_starling.utils.SMuiscChannel;
	import engine_starling.utils.SPlatformUtils;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.List;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	
	public class MainApplication extends SApplication
	{
		public function MainApplication()
		{
			super();
		}
	
		private var _platform:ISPlatfrom;
		private var _logger:Logger = Logger.getInstance(MainApplication);
		[Embed(source="../startupres/startup_logoHD.png")]
		private static var _self_LogoHD:Class;
		
		
		override protected function _onInitBefore():void
		{
			
			CONFIG::CHANNELID_0{
				
				if(ConstOnlineDebug.isDebug)
				{
					_logger.info("attention!! online debug is Open!!");
				}
			};
			
			
			//预加载的Class
			{ImageLoader,Label,List,SScale3Plane,SScale9Plane};
//			{ACocosLTest}
			
			ConstGlobal.DeviceInfo = HelloAne.o.getDeviceInfo();
			//设置设备等级
			CJSettingUtils.setDeviceLevel(ConstGlobal.DeviceLevel_Normal);
			SMuiscChannel.global_volume = 1;
			
			_buildUrlPath();
			_platform = ISPlatfrom.builder(ConstGlobal.CHANNELID);
			//预加载class
			super._onInitBefore();
		}
		
		
		private function _buildUrlPath():void
		{
			var ver:String = SPlatformUtils.getApplicationVersion();
			ver = ver.replace( /\./g,"_");
			// 初始化下载地址 
			switch(ConstGlobal.CHANNELID)
			{
				case ConstPlatformId.ID_DEBUG:
					ConstGlobal.Default_MD5_Path = "http://xzoo.kaixin009.com/img/zipd/xzoo/remoteResource/";//BianBo
					ConstGlobal.Default_Resource_Path = "http://xzoo.kaixin009.com/img/zipd/xzoo/remoteResource/";
					break;
				case ConstPlatformId.ID_DEBUGONLINE:
					//外网测试
					ConstGlobal.Default_MD5_Path = "http://sjres.kaixin001.com.cn/"+ ver +"/";
					ConstGlobal.Default_Resource_Path = "http://wg.imghb.com/shenjiang/"+ ver +"/";
					break;
				case ConstPlatformId.ID_KAIXIN:
					//1  开心网
					ConstGlobal.Default_MD5_Path = "http://sjres.kaixin001.com.cn/"+ ver +"/";
					ConstGlobal.Default_Resource_Path = "http://wg.imghb.com/shenjiang/"+ ver +"/";
					break;
				
				case ConstPlatformId.ID_91IOS:
					//2 91助手(破解版)
					ConstGlobal.Default_MD5_Path = "http://sjres.kaixin001.com.cn/"+ ver +"/";
					ConstGlobal.Default_Resource_Path = "http://wg.imghb.com/shenjiang/"+ ver +"/";
					break;
				
				case ConstPlatformId.ID_APPSTORE:
					//3 app-store
					ConstGlobal.Default_MD5_Path = "http://sjres.kaixin001.com.cn/"+ ver +"/";
					ConstGlobal.Default_Resource_Path = "http://wg.imghb.com/shenjiang/"+ ver +"/";
					break;
				
				case ConstPlatformId.ID_91ANDROID:
					//91助手 Android版本
					ConstGlobal.Default_MD5_Path = "http://sjres.kaixin001.com.cn/"+ ver +"/";
					ConstGlobal.Default_Resource_Path = "http://wg.imghb.com/shenjiang/"+ ver +"/";
					break;
				case ConstPlatformId.ID_TONGBU:
					//同步推
					ConstGlobal.Default_MD5_Path = "http://sjres.kaixin001.com.cn/"+ ver +"/";
					ConstGlobal.Default_Resource_Path = "http://wg.imghb.com/shenjiang/"+ ver +"/";
					break;
				case ConstPlatformId.ID_IOSKUAIYONG:
					//快用
					ConstGlobal.Default_MD5_Path = "http://sjres.kaixin001.com.cn/"+ ver +"/";
					ConstGlobal.Default_Resource_Path = "http://wg.imghb.com/shenjiang/"+ ver +"/";
					break;
				case ConstPlatformId.ID_ANDRIODMARKET:
					//安卓市场
					ConstGlobal.Default_MD5_Path = "http://sjres.kaixin001.com.cn/"+ ver +"/";
					ConstGlobal.Default_Resource_Path = "http://wg.imghb.com/shenjiang/"+ ver +"/";
					break;
				case ConstPlatformId.ID_IOSUC:
					//UC
					ConstGlobal.Default_MD5_Path = "http://sjres.kaixin001.com.cn/"+ ver +"/";
					ConstGlobal.Default_Resource_Path = "http://wg.imghb.com/shenjiang/"+ ver +"/";
					break;
				case ConstPlatformId.ID_ANDRIODUC:
					//UC安卓
					ConstGlobal.Default_MD5_Path = "http://sjres.kaixin001.com.cn/"+ ver +"/";
					ConstGlobal.Default_Resource_Path = "http://wg.imghb.com/shenjiang/"+ ver +"/";
					break;
				case ConstPlatformId.ID_9SPLAY:
					//台湾
					ConstGlobal.Default_MD5_Path = "http://sjres.kaixin001.com.cn/"+ ver +"/";
					ConstGlobal.Default_Resource_Path = "http://wg.imghb.com/shenjiang/"+ ver +"/";
					break;
				default:
					ConstGlobal.Default_MD5_Path = "http://sjres.kaixin001.com.cn/"+ ver +"/";
					ConstGlobal.Default_Resource_Path = "http://wg.imghb.com/shenjiang/"+ ver +"/";
					break;
			}
			
			CONFIG::CHANNELID_0{
				
				if(ConstOnlineDebug.isDebug)
				{
					if (!SStringUtils.isEmpty(ConstOnlineDebug.debugResourceURL))
					{
						ConstGlobal.Default_MD5_Path = ConstGlobal.Default_Resource_Path = ConstOnlineDebug.debugResourceURL;
					}
				}
			}
				
		}
		override protected function _onInitAfter():void
		{
			//init socket 
			SocketManager.o = new SocketManager();
			
			CJDataManager.o;
			//初始化统计
			TalkingDataService.o;
			
			//屏蔽home meun
//			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN,_handle_KeyDown);
			super._onInitAfter();
		}
		
//		private function _handle_KeyDown(e:KeyboardEvent):void
//		{
//			//andriod 取消返回键
//			var manufactory:String = SManufacturerUtils.getManufacturerType();
//			if(manufactory == SManufacturerUtils.TYPE_ANDROID)
//			{
//				return;
//			}
//			switch(e.keyCode)
//			{
//				case Keyboard.BACK: // user hit the back button on Android device
//				case Keyboard.MENU:
//				case 0x1000016:
//				case 0x1000012:
//				{  
//					
//					e.preventDefault();
//					e.stopImmediatePropagation();
//					break;
//				}
//			}
//		}
		
		override protected function _onInitResource(assets:AssetManager):void
		{
			//下载资源之前,就需要读到配置,
			//而且要防止删除配置的操作
			CJServerList.loadDefaultResSetting();
			SApplicationConfig.o.resourceRemoteBasePath = ConstGlobal.ServerSetting.cdnurl;
			SApplicationConfig.o.resourceRemoteMd5FilePath = ConstGlobal.ServerSetting.md5url;
			SApplicationConfig.o.resourceLocalBasePath = "appRuntimeResource/";
			var appDir:File = File.applicationDirectory;
			assets.enqueue(
				appDir.resolvePath("appResource")
			);
			
			SAssetsCache.enableRemoteFileVerify = true;
			AssetManagerUtil.o;
			AssetManagerUtil.o.addEventListener(AssetEvent.INIT_COMPLETE,function _e(e:*,data:Object):void
			{
				if(data.code == 0)
				{
					var ret:String = HelloAne.o.Alert("网络不给力~","无法下载配置文件！亲~，查查网络配置吧","重试","重启客户端");
					HelloAne.o.addEventListener(AlertEvent.Click,function _e(e:AlertEvent):void
					{
						HelloAne.o.removeEventListener(AlertEvent.Click,_e);
						var i:int = e.index;
						if(i == 0)//重试
						{
							_logger.error("AssetManagerUtil init Error!");
							Starling.juggler.delayCall(AssetManagerUtil.o.init,1);
						}
						else 
						{
							SApplicationUtils.exit();
						}
					});
					
				}
				else
				{
					AssetManagerUtil.o.removeEventListeners(AssetEvent.INIT_COMPLETE);
					_loadResource();
				}
			});
			AssetManagerUtil.o.init();
			Logger.log("mainApplication","_onInitResource CHANNEL_ID:" + ConstGlobal.CHANNEL +" DESC:" + ConstGlobal.CHANNELNAME +" ServerGroup:" + ConstGlobal.ServerGroupId);
			super._onInitResource(assets);
		}
		
		override protected function _onInitGameState():void
		{
			stateManager.RegisterGameState(new GameStateLogin());
			stateManager.RegisterGameState(new GameStateGaming());
			stateManager.RegisterGameState(new GameStateSelfLogin());
			
			//注册系统
			moduleManager.register(new CJLoaderMoudle);
			moduleManager.register(new CJClientUpgradeModule()); //升级模块
			
			moduleManager.register(new CJLoginModule);	// 登录  add by longtao
			moduleManager.register(new CJRegisterModule);	// 注册帐号  add by longtao
			moduleManager.register(new CJCreateModule);	// 创建角色  add by longtao
			moduleManager.register(new CJMainUiModule);	// 主界面模块   add by zhengzheng
			moduleManager.register(new CJHeroPropertyUIModule);	// 武将属性界面   add by longtao
			moduleManager.register(new CJBagModule);	// 创建背包模块   add by zhengzheng
			moduleManager.register(new CJExampleModule);	// 老版战斗测试   add by longtao
			moduleManager.register(new CJBattleModule);
			moduleManager.register(new CJFormationModule);
			moduleManager.register(new CJNPCDialogModule);
			moduleManager.register(new CJWorldModule);
			moduleManager.register(new CJEnhanceModule);	// 注册强化模块 add by sangxu
			moduleManager.register(new CJWinebarModule);	//酒馆模块 add by longtao
			moduleManager.register(new CJWinebarDictModule);	//武将宝典 add by longtao
			moduleManager.register(new CJWinebarHeroModule);	//酒馆武将展示模块 add by longtao
			moduleManager.register(new CJTaskModule);	
			moduleManager.register(new CJHorseModule);
			moduleManager.register(new CJFubenModule);
			moduleManager.register(new CJFubenBattleModule);
			moduleManager.register(new CJFubenBattleBaseModule);
			moduleManager.register(new CJJewelModule);	// 注册宝石模块	add by sangxu
			moduleManager.register(new CJHeroStarModule); // 武将星级 add by longtao
//			moduleManager.register(new CJTreasureModule); //灵丸
			moduleManager.register(new CJFriendModule); //注册好友模块  add by zhengzheng
			moduleManager.register(new CJChatModule);
			moduleManager.register(new CJStageLevelModule); // 主角升阶 add by longtao
			moduleManager.register(new CJStageShowModule); // 主角升星展示 add by longtao
			moduleManager.register(new CJRankModule); //注册排行榜模块  add by zhengzheng
			
			moduleManager.register(new CJMoneyTreeModule); // 摇钱树模块 add by sangxu
			moduleManager.register(new CJHeroTrainModule); // 武将训练 add by longtao
			moduleManager.register(new CJNPCTaskDialogMoudle) //NPC任务剧情对话  add by yongjun
			moduleManager.register(new CJCampModule);
			moduleManager.register(new CJFuncListModule);
			moduleManager.register(new CJFunctionOpenModule);
			moduleManager.register(new CJRechargeModule);//注册充值模块  add by zhengzheng
			moduleManager.register(new CJDynamicModule);//注册动态模块  add by zhengzheng
			moduleManager.register(new CJArenaModule);//注册竞技场模块 add by yongjun
			moduleManager.register(new CJMallModule);	// 商城模块 add by sangxu
			moduleManager.register(new CJOLRewardModul); // 在线奖励 add by longtao
			moduleManager.register(new CJArenaBattleModule); 
			moduleManager.register(new CJSettingModule); // 设置模块 add by longtao
			moduleManager.register(new CJSelectServerModule); // 选择服务器模块 add by longtao
			moduleManager.register(new CJActiveFbModule);
			moduleManager.register(new CJTransferAbilityModule); // 传功模块 add by zhengzheng
			moduleManager.register(new CJFristBattleModule); //开场战斗
			moduleManager.register(new CJRandomBoxModule); // 随机宝箱模块 add by sangxu
			
			moduleManager.register(new CJActivityModule);
			moduleManager.register(new CJWorldBossModule);
			moduleManager.register(new CJSplendidActivityModule);
			moduleManager.register(new CJVipModule); // VIP展示 add by longtao
			moduleManager.register(new CJVipPrivilegeModule); // VIP特权 add by longtao
			moduleManager.register(new CJDailyTaskModule);
			moduleManager.register(new CJPractiseModule);
			moduleManager.register(new CJNoticeModule);
			moduleManager.register(new CJQiandaoModule);//每日签到
			moduleManager.register(new CJCDKeyModule);
			moduleManager.register(new CJFirstRechargeModule); //首次充值
			moduleManager.register(new CJPileRechargeModule); //累积充值
			moduleManager.register(new CJWorldMapModule);//新世界地图
			moduleManager.register(new CJKFContendModule); //开服争霸
			moduleManager.register(new CJDuoBaoModule);//夺宝奇兵
			moduleManager.register(new CJDuoBaoBattleModule);//夺宝奇兵	
			moduleManager.register(new CJCommentModule);//评论活动
			
			moduleManager.register(new CJRewardModule);
			moduleManager.register(new CJStrategyModule);//攻略系统
			moduleManager.register(new CJAchievementModule);//里程碑
			moduleManager.register(new CJTwloginModule);
//			moduleManager.registerClass(CJTestLuaModule);
		}
		
		override protected function _onAppLauched():void
		{
			//设置帧数
			Starling.current.nativeStage.frameRate = 30;
			CONFIG::CHANNELID_0 {ConsoleApplication.registerConsole(CJLayerManager.o.rootLayer.normalLayer);}
				
			if(SPlatformUtils.isDebug())
			{
				Logger.log("runMode","debug");
				Starling.current.showStats = true;
			}
			else
			{
				Logger.log("runMode","release");
				Starling.current.showStats = false;
			}
			
			// 增加白色的logo底图
			_addwritelogobackground();
			// 关闭第一个闪屏 kaixinlogin
			SApplicationLauch.closeBackground();
			//初始化,第二个闪屏
			Starling.juggler.delayCall(_flashlogo2show,0.01,_loadGlobalJson);
			
		}
		/**
		 * 增加logo白色底 
		 * 
		 */
		private var _writebg:Bitmap;
		private function _addwritelogobackground():void
		{
			var bgdiplayobject:DisplayObject = StarlingInstance.nativeStage.getChildByName("app_background");
			var bgdisplayidx:int = StarlingInstance.nativeStage.getChildIndex(bgdiplayobject);
			_writebg = new Bitmap(new BitmapData(1,1,false,0xFFFFFFFF));
			_writebg.x = StarlingInstance.viewPort.x;
			_writebg.y = StarlingInstance.viewPort.y;
			_writebg.width  = StarlingInstance.viewPort.width;
			_writebg.height = StarlingInstance.viewPort.height;
			StarlingInstance.nativeStage.addChildAt(_writebg,bgdisplayidx + 1);
		}
		/**
		 * 第二次logo闪屏 
		 * 
		 */
		private function _flashlogo2show(finish:Function):void
		{
			var icon2:Bitmap = new _self_LogoHD();
			_self_LogoHD = null;
			
			icon2.name = "flashlogo2";
			icon2.x = StarlingInstance.viewPort.x;
			icon2.y = StarlingInstance.viewPort.y;
			icon2.width  = StarlingInstance.viewPort.width;
			icon2.height = StarlingInstance.viewPort.height;
			icon2.alpha = 0.01
			StarlingInstance.nativeStage.addChild(icon2);
			
			var t:Tween = new Tween(icon2,1);
			t.animate("alpha",0.99);
			t.onComplete = function():void{
				if (finish != null)
				{
					finish();
				}
			}
			Starling.juggler.add(t);
		}
		
		private function _flashlogo2close(finish:Function):void
		{
			
			if(StarlingInstance.nativeStage.getChildByName("flashlogo2") == null)
				return;
			
			var icon2:Bitmap = StarlingInstance.nativeStage.getChildByName("flashlogo2") as Bitmap;
			var t:Tween = new Tween(icon2,1);
			t = new Tween(icon2,1);
			t.animate("alpha",0.01);
			t.onComplete = function():void
			{
				//删除白色底
				StarlingInstance.nativeStage.removeChild(_writebg);
				_writebg.bitmapData.dispose();
				_writebg = null;
				//删除logo
				StarlingInstance.nativeStage.removeChild(icon2);
				icon2.bitmapData.dispose();
				if (finish != null){
					finish();
				}
			}
				
			Starling.juggler.add(t);
		}
		private function _loadGlobalJson():void
		{
			var proloadResource:Array = [];
			proloadResource.push(ConstResource.sResXmlCommonJsonZip);
			AssetManagerUtil.o.loadPrepareInQueueWithArray("commom_Config_Json",proloadResource);
			AssetManagerUtil.o.loadQueue(function (f:Number):void
			{
				if(f == 1)
				{	
					Starling.juggler.delayCall(_loadGlobalJsoncomplete,0.2);
				}
			});
		}
		
		/**
		 * 加载完成全局基础配置
		 */
		private function _loadGlobalJsoncomplete():void
		{
			// 系统设置信息
			var isMusicPlay:Boolean = CJDataManager.o.DataOfSetting.isMusicPlay;
			// 设置音乐开关
			if (!isMusicPlay) SMuiscChannel.global_volume = 0.0;
			// 设置是否显示其他玩家
			if (!CJDataManager.o.DataOfSetting.isShowOthers)// 不显示
				CJEventDispatcher.o.dispatchEvent(new Event(CJEvent.EVENT_SCENEPLAYERMANAGER_RESETANDPAUSE));
			
			//初始化
			CJServerList.getServerList();
			CONFIG::CHANNELID_0{
				
				if(ConstOnlineDebug.isDebug)
				{
					if(ConstGlobal.ServerSetting == null)
					{
						ConstGlobal.ServerSetting = new Json_serverlist();
						
						ConstGlobal.ServerSetting.cdnurl = ConstGlobal.Default_Resource_Path;
						ConstGlobal.ServerSetting.md5url = ConstGlobal.Default_MD5_Path;
						
					}
					if (!SStringUtils.isEmpty(ConstOnlineDebug.debugResourceURL))
					{
						ConstGlobal.ServerSetting.cdnurl = ConstGlobal.ServerSetting.md5url = ConstOnlineDebug.debugResourceURL;
					}
					if (!SStringUtils.isEmpty(ConstOnlineDebug.debugServerIp))
					{
						ConstGlobal.ServerSetting.serverip = ConstOnlineDebug.debugServerIp;
					}
					ConstGlobal.ServerSetting.serverport = 9001;
				}
				else
				{
					CJServerList.loadServerList();
				}
			};
			CONFIG::CHANNELID_UN0{
				CJServerList.loadServerList();
			};
			
			PushService.o;
			Starling.juggler.delayCall(_loadBaseResources,0.01);
			Logger.log("mainApplication",JSON.stringify(ConstGlobal.ServerSetting));
			
			
		}
		/**
		 * 加载基础资源，
		 * 
		 */
		private function _loadBaseResources():void
		{
			var proloadResource:Array = [];
			proloadResource.push(ConstResource.sResXmlCommonNew0);
			AssetManagerUtil.o.loadPrepareInQueueWithArray("commom_Config",proloadResource);
			AssetManagerUtil.o.loadQueue(function (f:Number):void
			{
				if(f == 1)
				{	
					Starling.juggler.delayCall(_loadBaseResourcescomplete,0.001);
				}
			});
			
		}
		
		private function _loadBaseResourcescomplete():void
		{
			_flashlogo2close(_enter);
			
			function _enter():void{
				if(!SNetWorkUtils.WIFIEnable)
				{
					CJConfirmMessageBox(CJLang("NET_WORK_NOWIFI")
						,function ():void{
							_doConnect();
						},function():void
						{
							SApplicationUtils.exit();
						},
						CJLang("COMMON_TRUE"),
						CJLang("COMMON_CANCEL"));	
				}
				else 
				{
					_doConnect();
				}
			}
		}
				
		/**
		 * 发起链接 
		 * 
		 */
		private function _doConnect():void
		{
			if(SNetWorkUtils._3GEnable || SNetWorkUtils.WIFIEnable)
			{
				SocketManager.o.addEventListener(CJSocketEvent.SocketConnectError,_onerror);
				SocketManager.o.addEventListener(CJSocketEvent.SocketServerError,_onerror);
				SEventUtils.addEventListenerOnce(SocketManager.o,CJSocketEvent.SocketEventConnect,_onconnect);
				
				function _onerror(e:starling.events.Event):void
				{
					var s:SocketManager = e.target as SocketManager;
					if(e.type == CJSocketEvent.SocketConnectError)
					{
						CJConfirmMessageBox(CJLang("NET_WORK_ERROR")
							,function ():void{
								s.reconnect();
							},function():void
							{
								SApplicationUtils.exit();
							},
							CJLang("NET_WORK_WAIT"),
							CJLang("NET_WORK_KILL"));
					}
					else if(e.type == CJSocketEvent.SocketServerError)
					{
						var message:SocketMessage = e.data as SocketMessage;
						var url:String = message.rpcHelperObject.url;
						CJMessageBox(message.rpcHelperObject.msg,function():void{
							if(SStringUtils.isEmpty(url))
							{
								SApplicationUtils.exit();
							}
							else
							{
								navigateToURL(new URLRequest(url));
								Starling.juggler.delayCall(function():void
								{
									SApplicationUtils.exit();
								},2);
							}
						});
					}
				}
				
				function _onconnect(e:starling.events.Event):void
				{
					SocketCommand_record.clientsetup();
					//是否在屏蔽列表中
					if(SCompileUtils.o.isBlackDevice())
					{
						SocketCommand_record.clientActionBlackDeviceUser();
						
						var ret:String = HelloAne.o.Alert("设备不给力~",CJLang("BLACKDEVICETIPS"),"退出");
						HelloAne.o.addEventListener(AlertEvent.Click,function _e(e:AlertEvent):void
						{
							HelloAne.o.removeEventListener(AlertEvent.Click,_e);
							SApplicationUtils.exit();
						});
					}
					else
					{
						SAdUtils.ADCallBack();
						//第一次启动客户端。
						if(!CJDataManager.o.DataOfSetting.isSendAdCallback)
						{
							SocketCommand_record.clientActionfristStartup();
						}
						stateManager.ChangeState("GameStateLogin");
					}
				}
				
				SocketManager.o.connect(ConstGlobal.ServerSetting.serverip,ConstGlobal.ServerSetting.serverport);
				
			}
			else
			{
				CJConfirmMessageBox(CJLang("NET_WORK_ERROR")
					,function ():void{
						Starling.juggler.delayCall(_doConnect,1);
					},function():void
					{
						SApplicationUtils.exit();
					},
					CJLang("NET_WORK_WAIT"),
					CJLang("NET_WORK_KILL"));	
				
			}
		}
		

		/**
		 * 平台接入SDK 
		 */
		public function get platform():ISPlatfrom
		{
			return _platform;
		}
		
		
	}
				
				
}