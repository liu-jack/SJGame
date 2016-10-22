package SJ.Game.fuben
{
	import SJ.Common.Constants.ConstBattle;
	import SJ.Common.Constants.ConstFuben;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.SocketServer.SocketCommand_fuben;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.battle.CJBattleReplayManager;
	import SJ.Game.battle.data.CJBattleFormationData;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFuben;
	import SJ.Game.data.config.CJDataOfGuankaProperty;
	import SJ.Game.data.json.Json_fuben_guanka_config;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLayerRandomBackGround;
	import SJ.Game.layer.CJLoadingLayer;
	import SJ.Game.layer.CJLoadingSceneLayer;
	import SJ.Game.map.CJBattleMapManager;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 *   副本战斗基础模块
	 * @author yongjun
	 * 
	 */
	public class CJFubenBattleBaseModule extends CJModuleSubSystem
	{
		public function CJFubenBattleBaseModule()
		{
		}
		
		override protected function _onInit(params:Object=null):void
		{
			super._onInit(params);
		}
		private var _fuBattleLayer:CJFubenBattleBaseLayer
		private var _battleReply:CJBattleReplayManager
		
		override public function getPreloadResource():Array
		{
			// TODO Auto Generated method stub
			return ["resource_fuben.xml",ConstResource.sResXmlItem_1,
					"resourceui_card_common.xml",
					"resource_skillnames_0.xml","resource_common_hero.xml"];
		}
		
		
		override protected function _onEnter(params:Object=null):void
		{
			CJLoadingLayer.isShowHorse = false;
			super._onEnter(params);
			//派发暂停刷新玩家列表事件
			CJEventDispatcher.o.dispatchEvent(new Event(CJEvent.EVENT_SCENEPLAYERMANAGER_RESETANDPAUSE));
			
			if(params.hasOwnProperty("from"))
			{
				(CJDataManager.o.getData("CJDataOfFuben") as CJDataOfFuben).from = params['from']
				if(params['from'] == ConstFuben.FUBEN_ACT)
				{
					CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false, {"key":CJActivityEventKey.ACTIVITY_JOINACTIVITYFB});
				}
			}
			
			var guankaConfig:Json_fuben_guanka_config = CJDataOfGuankaProperty.o.getPropertyById(params["gid"]);
			//关卡背景
			params.guankaConf = guankaConfig;
			_onEnterEnd(params);
			
		}
		private var _enterparams:Object = null;
		
		private function _onEnterEnd(params:Object):void
		{
//			var loading:CJLoadingLayer = CJLoadingLayer.o;
			
			//加载武将阵型信息.首先获取武将信息
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,onHeroFormationLoad);
			SocketCommand_fuben.getheroformation();
			_enterparams = params;
		
			
		}
		
		private function _initFormation():void
		{
			//初始化阵型数据
			var formationInfo:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonBattleFormation) as Array;
			//目前支持3个阵型
			ConstBattle.sBattleFormationData = new Array();
			var length:int = formationInfo.length;
			for(var i:int = 0;i<length;i++)
			{
				var formationJson:Object = formationInfo[i];
				var formationId:int = formationJson["id"];
				//十位数是索引
				var formationType:int = formationJson["postiontype"];
				if(ConstBattle.sBattleFormationData[formationId] == null)
				{
					ConstBattle.sBattleFormationData[formationId] = new CJBattleFormationData();
				}
				var formationData:CJBattleFormationData = ConstBattle.sBattleFormationData[formationId];
				//添加进去位置
				formationData.addPos( formationJson["posid"],formationJson["postionx"]/2,formationJson["postiony"]/2,formationType);
			}
		}
		
		private function _loadResource(playersObject:Object):void 
		{
			var res:Array = [_enterparams.guankaConf.bgimg].concat(getPreloadResource());
			
			//添加英雄资源
			var playerData:CJPlayerData = new CJPlayerData();
			var i:int = 0;
			for each(var playerJsonInfo:Object in playersObject)
			{
				playerData.templateId = parseInt(playerJsonInfo.templateid);
				var npcRes:Array = CJPlayerNpc.getLoadResourceList(playerData,CJPlayerNpc.LEVEL_LOD_ALL);
				for (i = 0;i<npcRes.length;i++)
				{
					if(res.indexOf(npcRes[i]) == -1)
					{
						res.push(npcRes[i]);
					}
				}
			}
			//遍历战斗需要的NPC资源
			var npctemplateids:Array = CJDataOfGuankaProperty.o.getGuankaNpcs(_enterparams.gid)
			for each(var templateId:int in npctemplateids)
			{
				playerData.templateId = templateId;
				var npcRes:Array = CJPlayerNpc.getLoadResourceList(playerData,CJPlayerNpc.LEVEL_LOD_ALL);
				for (i = 0;i<npcRes.length;i++)
				{
					if(res.indexOf(npcRes[i]) == -1)
					{
						res.push(npcRes[i]);
					}
				}
			}
			
			
			CJLayerRandomBackGround.Show(CJLayerManager.o.rootLayer.normalLayer);
			var loadingSceneLayer:CJLoadingSceneLayer = new CJLoadingSceneLayer();
			loadingSceneLayer.show();
			AssetManagerUtil.o.loadPrepareInQueueWithArray("CJFubenBattleBaseModuleResource0",res);
			AssetManagerUtil.o.loadQueue(function(r:Number):void
			{
				CJLayerRandomBackGround.Show(CJLayerManager.o.rootLayer.normalLayer);
				loadingSceneLayer.loadingprogress = r;
				if(r == 1)
				{
					//放到战斗里面去close 否则有白屏现象
					loadingSceneLayer.close();
					
					Starling.juggler.delayCall(_createBattleLayer,0.1);
					
				}
			});
			
			function _createBattleLayer():void
			{
				_initFormation();
				//副本基础界面
				_fuBattleLayer = new CJFubenBattleBaseLayer();
				_fuBattleLayer.data = _enterparams;
				_fuBattleLayer.playerdatas = playersObject;
				CJBattleMapManager.o.backgroundLayer.addChild(_fuBattleLayer);


				//加到模块层
				CJLayerManager.o.addToScreenLayer(CJBattleMapManager.o.rootMapLayer);
			}
		}
		
		/**
		 *  
		 * @param e
		 * 
		 */
		private function onHeroFormationLoad(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage
			if(msg.getCommand() == ConstNetCommand.CS_FUBEN_BATTLEHEROINFO)
			{
				e.currentTarget.removeEventListener(CJSocketEvent.SocketEventData,onHeroFormationLoad)
				var rtnObject:Object = msg.retparams;
				
				_loadResource(rtnObject["battleheros"]);
//				
			}
		}
		
		override protected function _onExit(params:Object=null):void
		{
			CJLoadingLayer.isShowHorse = true;
			super._onExit(params);
			
			CJEventDispatcher.o.dispatchEvent(new Event(CJEvent.EVENT_SCENEPLAYERMANAGER_FLASH));
			
//			_fuBattleLayer.dispose();
			_fuBattleLayer.removeChildren(0,-1,true);
			_fuBattleLayer.removeFromParent(true);
			_fuBattleLayer = null;
			//移除加载的战斗层的资源
			AssetManagerUtil.o.disposeAssetsByGroup("CJFubenBattleBaseModuleResource0");
		}
	}
}