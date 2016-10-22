package SJ.Game.arena
{
	import SJ.Common.Constants.ConstBattle;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.SocketServer.SocketCommand_arena;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.battle.CJBattleReplayManager;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfVipFuncSetting;
	import SJ.Game.data.json.Json_vip_function_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLayerRandomBackGround;
	import SJ.Game.layer.CJLoadingSceneLayer;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.map.CJBattleMapManager;
	
	import engine_starling.SApplication;
	import engine_starling.utils.AssetManagerUtil;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 *   竞技场战斗模块
	 * @author yongjun
	 * 
	 */
	public class CJArenaBattleModule extends CJModuleSubSystem
	{
		public function CJArenaBattleModule()
		{
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
		//副本战斗界面
		private var _arenaBattleLayer:CJArenaBattleBgLayer
		//战斗通关界面
		
		private var _battleReply:CJBattleReplayManager
		
		override public function getPreloadResource():Array
		{
			var res:Array = new Array();
			res = res.concat([ConstResource.sResJsonBattleFormation,
				ConstResource.sResJsonQteFormation,ConstResource.sResHeroPropertys,
				ConstResource.sResJsonSkill,"anim_skill.anims","anim_battle.anims",
				ConstResource.sResSkillSetting,"anim_battle_result.anims",
				"resource_skillnames_0.xml","resource_common_hero.xml"]);
			
			res = res.concat(CJBattleReplayManager.getBattleResource(String(_battleObject[0])));
			return res;
		}
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			_onEnterEnd(params);
		}
		private var _battleResultObj:Object;
		private var _battleObject:Object;
		private var _targetObject:Object;
		private function _onEnterEnd(params:Object):void
		{
			_battleObject = params.battleret;
			_targetObject = params.targetinfo;
			
			CJLayerRandomBackGround.Show(CJLayerManager.o.rootLayer.normalLayer);
			var loading:CJLoadingSceneLayer = new CJLoadingSceneLayer();
			loading.show();
			
			//加载通关层的布局文件资源
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJArenaBattleModuleResource0",getPreloadResource());
			AssetManagerUtil.o.loadQueue(function(r:Number):void
			{
				loading.loadingprogress = r;
				if(r == 1)
				{
					loading.close();
					CJLayerRandomBackGround.Close();
					_initBattleUI(_battleObject[0]);
					_battleStart(_battleObject);
				}
			});
		}
		
		protected function _initBattleUI(battleString:String):void
		{
			if(_targetObject)
			{
				var titleLayer:CJArenaBattleTitleLayer = new CJArenaBattleTitleLayer
				titleLayer.setHeroObj(_targetObject);
				titleLayer.countBattleeffect(battleString);
				CJBattleMapManager.o.topLayer.addChild(titleLayer);
			}
		}
		
		private function _battleStart(battleObject:Object):void
		{
			//派发暂停刷新玩家列表事件
			CJEventDispatcher.o.dispatchEvent(new Event(CJEvent.EVENT_SCENEPLAYERMANAGER_RESETANDPAUSE));
			
			_battleReply = new CJBattleReplayManager();
			//竞技场战斗背景层
			_arenaBattleLayer = new CJArenaBattleBgLayer();
			//添加到战斗背景层
			CJBattleMapManager.o.backgroundLayer.addChild(_arenaBattleLayer)
				
			var role:CJDataOfRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole
			var vip:int = role.vipLevel;
			var vipConf:Json_vip_function_setting = CJDataOfVipFuncSetting.o.getData(String(vip));

			var _arenaBattleTopLayer:CJArenaBattleTopLayer = new CJArenaBattleTopLayer(_battleReply);
			_arenaBattleTopLayer.showFast(int(vipConf.arena_quickfinish));		
			CJBattleMapManager.o.debugLayer.addChild(_arenaBattleTopLayer);
				
			//设置大小
			CJBattleMapManager.o.rootMapLayer.width = Starling.current.stage.stageWidth;
			//
			CJBattleMapManager.o.rootMapLayer.height = Starling.current.stage.stageHeight;
			//加到模态
			CJLayerManager.o.addToScreenLayer(CJBattleMapManager.o.rootMapLayer);
			
			var jsonString:String = battleObject[0]
			_battleResultObj = {}
			_battleResultObj["result"] = battleObject[1]
			_battleResultObj["award"] = battleObject[2]
			if (battleObject[2])
				_battleResultObj["isspeaker"] = battleObject[2]['isspeaker']
			_battleReply.setbattleJson(jsonString);
//			_battleReply.play(battleEnd);
			
			Starling.juggler.delayCall(_battleReply.play,1,battleEnd);
		}
		
		
		/**
		 * 战斗结束 
		 * @param battleManager
		 * 
		 */
		private function battleEnd(battleManager:CJBattleReplayManager):void
		{
			CJEventDispatcher.o.dispatchEvent(new Event(CJEvent.EVENT_SCENEPLAYERMANAGER_FLASH));
			
			if(battleManager.battleResult == ConstBattle.BattleResultSuccess)
			{
				if(_battleResultObj["result"] == undefined)
				{
					SApplication.moduleManager.exitModule("CJArenaBattleModule");
					return;
				}
				var resultLayer:CJArenaResult = new CJArenaResult;
				resultLayer.updateAward(_battleResultObj);
				CJLayerManager.o.addModuleLayer(resultLayer);
			}
			else
			{
				CJMessageBox(CJLang("FUBEN_BATTLE_FAILED"),function():void
				{
					SApplication.moduleManager.exitModule("CJArenaBattleModule");
					SApplication.moduleManager.enterModule("CJArenaModule");
				});
			}
			CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false, {"key":CJActivityEventKey.ACTIVITY_ARENACHALLENGE});
			SocketCommand_role.get_role_info();
			SocketCommand_hero.get_heros();
			//战斗结束如果击败了第一名，需要请求发送大喇叭
			if(_battleResultObj["isspeaker"] == 1)
			{
				SocketCommand_arena.tospeaker();
			}
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			_battleObject = null;
			_battleReply = null;
			_arenaBattleLayer.removeFromParent(true);
			_arenaBattleLayer = null;
			AssetManagerUtil.o.removeUnusedResource();
			//CJBattleMapManager.o.rootMapLayer.removeFromParent(true);
			CJBattleMapManager.o.removeAllChildren();
			//移除加载的战斗层的资源
			AssetManagerUtil.o.disposeAssetsByGroup("CJArenaBattleModuleResource0");
		}
	}
}