package SJ.Game.fristBattle
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.SocketServer.SocketCommand_battle;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.battle.CJBattleReplayManager;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.json.Json_frist_battle_setting;
	import SJ.Game.layer.CJLayerRandomBackGround;
	import SJ.Game.layer.CJLoadingSceneLayer;
	import SJ.Game.map.CJBattleMapManager;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SMuiscNode;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SMuiscChannel;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	public class CJFristBattleModule extends CJModuleSubSystem
	{
		public function CJFristBattleModule()
		{
		}
		private var _battleSetting:Json_frist_battle_setting;
		private var _finishfunction:Function;
		private var _bgmuisc:SMuiscNode;
		private var _battleString:String;
		override public function getPreloadResource():Array
		{
			var res:Array = ["resource_skillnames_0.xml","resource_common_hero.xml"];
			
			var battleSettings:Object = AssetManagerUtil.o.getObject(ConstResource.sResJsonFristBattleSetting);
			_battleSetting = new Json_frist_battle_setting();
			_battleSetting.loadFromJsonObject(battleSettings[0]);
			res.push(_battleSetting.battlebg);
			
			res = res.concat(CJFristBattleDialogLayer.getdailogResource(0));
			res = res.concat(CJFristBattleDialogLayer.getdailogResource(1));
			
			//加载主角的资源
			var heroList:CJDataOfHeroList = CJDataManager.o.getData("CJDataOfHeroList") as CJDataOfHeroList;
			var playerdata:CJPlayerData = new CJPlayerData();
			playerdata.templateId = heroList.getMainHero().templateid;
			res = res.concat(CJPlayerNpc.getLoadResourceList(playerdata,CJPlayerNpc.LEVEL_LOD_0));
			
			return res;
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			if(params != null)
			{
				_finishfunction = params.finish;
			}

			
			var res:Array = getPreloadResource();
			var loadlayer:CJLoadingSceneLayer = new CJLoadingSceneLayer();
			loadlayer.show();
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJFristBattleModuleResource0",res);
			_bgmuisc = new SMuiscNode(SMuiscChannel.SMuiscChannelCreateByName(String(_battleSetting.battlesound)));
			_bgmuisc.loop = true;
			SApplication.rootNode.addChild(_bgmuisc);
			AssetManagerUtil.o.loadQueue(function(r:Number):void
			{
				loadlayer.loadingprogress = r;
				if(r == 1)
				{
					loadlayer.close();
					Starling.juggler.delayCall(_enterbattle,0.1);
				}
			});
			super._onEnter(params);
		}
		
		override protected function _onExit(params:Object=null):void
		{
			AssetManagerUtil.o.disposeAssetsByGroup("CJFristBattleModuleResource0");
			_battleSetting = null;
			
			CJDataManager.o.DataOfAccounts.fristbattleplayed = true;
			CJDataManager.o.DataOfAccounts.saveToCache();
			
			_bgmuisc.removeFromParent(true);
			_bgmuisc = null;
			
			super._onExit(params);
			if(_finishfunction != null)
			{
				_finishfunction();
				_finishfunction = null;
			}
			
			
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
		
		
		protected function _initBattleUI():void
		{	
			//中间回合背景
			var roundBg:SImage = new SImage(SApplication.assets.getTexture("zhandouui_huihekuang"));
			roundBg.x = (SApplicationConfig.o.stageWidth - roundBg.width) / 2;
			roundBg.y = 0;
			CJBattleMapManager.o.topLayer.addChild(roundBg);
		}
		
		private function _startbattle():void
		{
			var bgtexturename:String = "guankabg_" + ((_battleSetting.battlebg as String).split(".")[0] as String).split("_").pop() + "_0001";
			var texture:Texture = AssetManagerUtil.o.getTexture(bgtexturename);
			CJBattleMapManager.o.backgroundLayer.addChild(new Image(texture));
			
			
			var dailog:CJFristBattleDialogLayer = new CJFristBattleDialogLayer();
			dailog.dialoggroupid = 0;
			CJBattleMapManager.o.topLayer.addChild(dailog);
			dailog.addEventListener(Event.COMPLETE,function _e(e:Event):void
			{
				e.target.removeEventListener(e.type,_e);
				dailog.visible = false;
				dailog.removeFromParent(true);
				
				var _battleReply:CJBattleReplayManager = new CJBattleReplayManager();
//				_battleReply.isShowBattleStartAnims = false;
				_battleReply.setbattleJson(_battleString);
				_battleReply.play(_battleend);
				//					Starling.juggler.delayCall(_battleReply.playtoend,2);
			});
			
			function _battleend(m:*):void
			{
				CJBattleMapManager.o.removeAllChildren();
				//播放第二段对话
				var dailog:CJFristBattleDialogLayer = new CJFristBattleDialogLayer();
				dailog.dialoggroupid = 1;
				CJBattleMapManager.o.topLayer.addChild(dailog);
				dailog.addEventListener(Event.COMPLETE,function _e(e:Event):void
				{
					e.target.removeEventListener(e.type,_e);
					dailog.visible = false;
					dailog.removeFromParent(true);
					CJBattleMapManager.o.rootMapLayer.removeFromParent();
					
					Starling.juggler.delayCall(SApplication.moduleManager.exitModule,0.01,"CJFristBattleModule");
					
				});
			}
		}
	
		private function _enterbattle():void
		{
			SocketCommand_battle.fristbattleplayer(function (msg:SocketMessage):void
			{
				var code:int = msg.retcode;
				_battleString = msg.retparams[0]
				SApplication.rootNode.addChild(CJBattleMapManager.o.rootMapLayer);
				
				Starling.juggler.delayCall(_loadbattleRes,0.01);
				
			});
			
			
		}
		
		private function _loadbattleRes():void
		{
			//loading 战斗资源
			var loadlayer:CJLoadingSceneLayer = new CJLoadingSceneLayer();
			loadlayer.show();
			var res:Array = CJBattleReplayManager.getBattleResource(_battleString);
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJFristBattleModuleResource0",res);
			AssetManagerUtil.o.loadQueue(function(r:Number):void
			{
				loadlayer.loadingprogress = r;
				if(r == 1)
				{
					loadlayer.close();
					
					CJLayerRandomBackGround.Close();
					_initBattleUI();
					Starling.juggler.delayCall(_startbattle,0.1);
				}
			});
		}
		
		
	}
}