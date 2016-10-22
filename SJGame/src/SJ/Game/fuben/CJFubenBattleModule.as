package SJ.Game.fuben
{
	import SJ.Common.Constants.ConstBattle;
	import SJ.Common.Constants.ConstDynamic;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketCommand_scene;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.battle.CJBattleReplayManager;
	import SJ.Game.controls.CJMapUtil;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.core.TalkingDataService;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfEnterGuanqia;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.CJDataOfScene;
	import SJ.Game.data.config.CJDataOfGuankaProperty;
	import SJ.Game.data.json.Json_fuben_guanka_config;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJTipLayer;
	import SJ.Game.map.CJBattleMapManager;
	import SJ.Game.task.CJTaskEvent;
	import SJ.Game.task.CJTaskEventHandler;
	
	import engine_starling.SApplication;
	import engine_starling.commandSys.core.SCommandBaseData;
	import engine_starling.utils.AssetManagerUtil;
	
	import starling.events.Event;
	
	/**
	 *   副本战斗模块
	 * @author yongjun
	 * 
	 */
	public class CJFubenBattleModule extends CJModuleSubSystem
	{
		public function CJFubenBattleModule()
		{
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
		//副本战斗界面
		private var _fuBattleLayer:CJFubenBattleLayer
		//战斗通关界面
		private var _fuBattlePassLayer:CJFubenGuankaPassLayer;
		
		private var _battleReply:CJBattleReplayManager
		
		override public function getPreloadResource():Array
		{
			// TODO Auto Generated method stub
			return [];
		}
		
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			//取出关卡配置
			var guankaConfig:Json_fuben_guanka_config = CJDataOfGuankaProperty.o.getPropertyById(params["gid"]);
			//关卡背景
			params.guankaConf = guankaConfig;
			
			_battleReply = new CJBattleReplayManager();
			_fuBattleLayer = new CJFubenBattleLayer(_battleReply);
			var startcallback:Function = params["startcallback"];
			_battleReply.onCmdFinishCallBack = function (cmd:SCommandBaseData):void
			{
				if(cmd.commandId == ConstBattle.CommandStandBy)
				{
					if(startcallback != null)
					{
						startcallback();
					}
				}
			};
			
			//加到模块层
			_currentGid = params['gid'];
			_currentZid = params['battleid'];
			_currentFid = params['fid'];
			if(guankaConfig)
			{
				TalkingDataService.o.messionBegin(CJLang(guankaConfig.name));		
			}
			
			_initBattleUI(params['battleString']);
			battleStart(params['fid'],params['gid'],params['battleid'],params['battleString']);
		}
		
		//当前战斗ID
		private var _currentZid:int
		private var _currentGid:int
		private var _currentFid:int
		private var _currentBattleData:Object

		protected function _initBattleUI(battleString:String):void
		{
			var titleLayer:CJFubenBattleTitleLayer = new CJFubenBattleTitleLayer();
			titleLayer.setCurrentZid(_currentZid);
			titleLayer.countBattleeffect(battleString);
			CJBattleMapManager.o.topLayer.addChild(titleLayer);
		}
		
		private function battleStart(fid:int,gid:int,battleId:int,battleString:String):void
		{	
			_battleReply.setbattleJson(battleString);
			_battleReply.play(battleEnd);
			
			CJBattleMapManager.o.debugLayer.addChild(_fuBattleLayer);
			
			_currentBattleData = _battleReply.battleJsonObject;
			if (_currentBattleData.hasOwnProperty("showfast"))
			{
				_fuBattleLayer.showFast(true);
			}
			else
			{
				_fuBattleLayer.showFast(false);
			}
			if(_currentBattleData["battleindex"] == 1||_currentBattleData["battleindex"] == 2)
			{
				_battleReply.isShowBattleStartAnims = false;
			}
			
			if(_battleReply.battleResult == ConstBattle.BattleResultSuccess && _currentBattleData.hasOwnProperty("award"))
			{
				var guankaNpcs:Array = CJDataOfGuankaProperty.o.getGuankaNpcs(_currentGid)
				//战斗结束给任务派发结果
				var battleRvt:Event = new Event(CJEvent.EVENT_TASK_ACTION_EXECUTED,false,{'ret':_battleReply.battleResult,'npcidlist':guankaNpcs , type:CJTaskEvent.TASK_EVENT_HUNT})
				CJTaskEventHandler.o.dispatchEvent(battleRvt)
				SocketCommand_role.get_role_info();
				SocketCommand_hero.get_heros();
			}
		
		}
		/**
		 * 战斗结束 
		 * @param battleManager
		 * 
		 */
		private function battleEnd(battleManager:CJBattleReplayManager):void
		{
			if(battleManager.battleResult == ConstBattle.BattleResultSuccess)
			{
				var evt:Event = new Event(CJEvent.EVENT_GUANKABATTLE_COMPLETE,false,{'ret':battleManager.battleResult,'zid':_currentZid,'gid':_currentGid,'fid':_currentFid,'battleData':_currentBattleData});
				CJEventDispatcher.o.dispatchEvent(evt);
				var guankaConfig:Json_fuben_guanka_config = CJDataOfGuankaProperty.o.getPropertyById(_currentGid);
				if(guankaConfig)
				{
					TalkingDataService.o.missionCompleted(CJLang(guankaConfig.name));	
				}
				SApplication.moduleManager.exitModule("CJFubenBattleModule");
			}
			else
			{
				var tip:CJTipLayer = new CJTipLayer(_onFail);
				guankaConfig = CJDataOfGuankaProperty.o.getPropertyById(_currentGid);
				if(!guankaConfig)
				{
					tip.text = CJLang("FUBEN_BATTLE_FAILED");
				}
				else
				{
					tip.text =  CJLang(guankaConfig.failtext);
					TalkingDataService.o.missionFailed(CJLang(guankaConfig.name));
				}
				tip.addToModal();
				
				function _onFail():void
				{
					SApplication.moduleManager.exitModule("CJFubenBattleModule");
					SApplication.moduleManager.exitModule("CJFubenBattleBaseModule");
					
					var prams:Object = {cityid:CJDataOfScene.o.fromSceneId};
					SApplication.moduleManager.exitModule("CJFubenBattleBaseModule");
					var last_mapid:int = (CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole).last_map;
					//改变场景
					SocketCommand_scene.changeScene(last_mapid , function(msg:SocketMessage):void
					{
						var command:String = msg.getCommand();
						if(command == ConstNetCommand.CS_SCENE_CHANGE)
						{
							//成功就回城
							var retCode:int = msg.params(0)
							if(retCode == 0)
							{
								CJMapUtil.enterMainCity();
							}
						}
					}
					);
				}
			}

		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			_battleReply = null;

			CJBattleMapManager.o.removeAllChildren();
			_fuBattleLayer.removeFromParent(true);
			_fuBattleLayer = null;
			AssetManagerUtil.o.removeUnusedResource();
			//移除加载的战斗层的资源
//			AssetManagerUtil.o.disposeAssetsByGroup("CJFubenBattleModuleResource");
			var dataEnterGuanqia:CJDataOfEnterGuanqia = CJDataOfEnterGuanqia.o;
			//助战玩家不是好友，提示添加好友
			if (!ConstDynamic.isAddFriendDialogPopup && dataEnterGuanqia.isFriend == 0 && dataEnterGuanqia.assistantUid)
			{
				ConstDynamic.isAddFriendDialogPopup = true;
			}
			//好友助战成功，提示赠送好友体力
			else if(_currentBattleData.hasOwnProperty("award") && dataEnterGuanqia.isFriend == 1 && dataEnterGuanqia.assistantUid)
			{
				ConstDynamic.isRewardVitDialogPopup = true;
			}
			_currentBattleData = null;
		}
	}
}