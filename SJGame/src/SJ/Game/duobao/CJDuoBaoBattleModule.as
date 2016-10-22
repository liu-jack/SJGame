package SJ.Game.duobao
{
	import SJ.Common.Constants.ConstBattle;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.battle.CJBattleReplayManager;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfVipFuncSetting;
	import SJ.Game.data.json.Json_vip_function_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLayerRandomBackGround;
	import SJ.Game.layer.CJLoadingLayer;
	import SJ.Game.layer.CJLoadingSceneLayer;
	import SJ.Game.map.CJBattleMapManager;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	public class CJDuoBaoBattleModule extends CJModuleSubSystem
	{
		private static const _RES_DUOBAO_BATTLE_GROUP_NAME:String = "CJDuobaoBattleResource";
		public function CJDuoBaoBattleModule()
		{
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
		//背景层
		private var _bgLayer:CJDuoBaoBattleBgLayer;
		//战斗通关界面
		
		private var _battleReply:CJBattleReplayManager;
		
		override public function getPreloadResource():Array
		{
			var res:Array = new Array();
			res = res.concat(["resourceui_card_common.xml",
				"resource_skillnames_0.xml","resource_common_hero.xml"]);
			
			res = res.concat(CJBattleReplayManager.getBattleResource(JSON.stringify(_battleObject)));
			return res;
		}
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			_battleObject = params.battleret;
			
			CJLayerRandomBackGround.Show(CJLayerManager.o.rootLayer.normalLayer);
			var loading:CJLoadingSceneLayer = new CJLoadingSceneLayer();
			loading.show();
			
			AssetManagerUtil.o.loadPrepareInQueueWithArray(_RES_DUOBAO_BATTLE_GROUP_NAME, getPreloadResource());
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				//设置加载动画的进度
				CJLoadingLayer.loadingprogress = r;
				if(r == 1)
				{
					loading.close();
					CJLayerRandomBackGround.Close();
					_onEnterEnd(params);
				}
			});

		}
		private var _battleResultObj:Object;
		private var _battleObject:Object;
		private var _targetObject:Object;
		private var _usereward:int;
		
		private var _treasurePartId:int;
		private var _isVectory:Boolean;
		
		private function _onEnterEnd(params:Object):void
		{
			_targetObject = params.targetinfo;
			_treasurePartId = params.treasureId;
			_usereward = params.usereward;
			_isVectory = params.isVectory;
				
			_initBattleUI(JSON.stringify(_battleObject));
			_battleStart(_battleObject);
		}
		
		protected function _initBattleUI(battleString:String):void
		{
			if(_targetObject)
			{
				var titleLayer:CJDuoBaoBattleTitleLayer = new CJDuoBaoBattleTitleLayer
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
			_bgLayer = new CJDuoBaoBattleBgLayer();
			//添加到战斗背景层
			CJBattleMapManager.o.backgroundLayer.addChild(_bgLayer)
			
			var role:CJDataOfRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole
			var vip:int = role.vipLevel;
			var vipConf:Json_vip_function_setting = CJDataOfVipFuncSetting.o.getData(String(vip));
			
			var _topLayer:CJDuoBaoBattleTopLayer = new CJDuoBaoBattleTopLayer(_battleReply);
			_topLayer.showFast(int(vipConf.arena_quickfinish));		
			CJBattleMapManager.o.debugLayer.addChild(_topLayer);
			
			//设置大小
			CJBattleMapManager.o.rootMapLayer.width = Starling.current.stage.stageWidth;
			//
			CJBattleMapManager.o.rootMapLayer.height = Starling.current.stage.stageHeight;
			//加到模态
			CJLayerManager.o.addToScreenLayer(CJBattleMapManager.o.rootMapLayer);
			
			var jsonString:String = JSON.stringify(_battleObject)
			_battleResultObj = {}
			_battleResultObj["usereward"] = _usereward;
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
			
			var resultLayer:CJDuoBaoBattleResultLayer
			if(_isVectory)
			{
				CJSubDuoBaoLayer._tooltipPartId = _treasurePartId;

				resultLayer = new CJDuoBaoBattleResultLayer;
				_battleResultObj["result"] = 0;
				resultLayer.updateAward(_battleResultObj);
				CJLayerManager.o.addModuleLayer(resultLayer);
			}
			else
			{
				resultLayer = new CJDuoBaoBattleResultLayer;
				_battleResultObj["result"] = 1;
				resultLayer.updateAward(_battleResultObj);
				CJLayerManager.o.addModuleLayer(resultLayer);
			}
			SocketCommand_role.get_role_info();
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			_battleObject = null;
			_battleReply = null;
			_bgLayer.removeFromParent(true);
			_bgLayer = null;
			AssetManagerUtil.o.removeUnusedResource();
			//CJBattleMapManager.o.rootMapLayer.removeFromParent(true);
			CJBattleMapManager.o.removeAllChildren();
			AssetManagerUtil.o.disposeAssetsByGroup(_RES_DUOBAO_BATTLE_GROUP_NAME);
		}
	}
}