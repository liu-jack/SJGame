package SJ.Game.battle
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.SocketServer.SocketCommand_battle;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.map.CJBattleMapManager;
	
	import engine_starling.SApplication;
	import engine_starling.utils.AssetManagerUtil;
	
	import starling.events.Event;
	
	public class CJBattleModule extends CJModuleSubSystem
	{
		private var _battleLayer:CJBattleLayer;
		
		private var _battleReply:CJBattleReplayManager;
		public function CJBattleModule()
		{
		}
		
		override protected function _onInitAfter(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onInitAfter(params);
			
		}
		
		
		
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			//加载通关层的布局文件资源
			AssetManagerUtil.o.loadPrepareInQueue("CJbattleModuleResource0", "battleResultLayout.sxml", "battleTongguanLayout.sxml",
				"exampleLayout.sxml");
			//加载通关层的动画、音乐文件资源
			AssetManagerUtil.o.loadPrepareInQueue("CJbattleModuleResource1",ConstResource.sResJsonBattleFormation,
				ConstResource.sResJsonQteFormation,ConstResource.sResHeroPropertys,
				ConstResource.sResJsonSkill,"anim_skill.anims",ConstResource.sResQTEEffect,"test_anim_simple.anim",
				ConstResource.sResBattleCmds,ConstResource.sResAnimsguanyu,"exampleLayout.sxml","anim_battle.anims",
				"anim_zhaoyun.anims",ConstResource.sResSkillSetting,
				"anim_dongzhuo.anims", "anim_battle_result.anims");
			//加载通关层的图片文件资源
			AssetManagerUtil.o.loadPrepareInQueue("CJbattleModuleResource1",
				"resource_skillnames_0.xml");
			
			AssetManagerUtil.o.loadQueue(function (r:Number):void
			{
				if(r == 1)
				{
					//进入模块时添加战斗层
					var battleType:int = params["battletype"];
					if(battleType == 0)
					{
						//初始化战斗播放器
						_battleReply = new CJBattleReplayManager();
						_testBattle();
					}
					else if(battleType == 1)
					{
						//初始化战斗播放器
						_battleReply = new CJBattleReplayManager();
						_testBattleNpc("1000");
//						CJBattleMananger.test_pkBoss();
					}
					else if(battleType == 2)
					{
						CJBattleMananger.testPk1v1Player();
					}
					else if(battleType == 3)
					{
						CJBattleMananger.testPk1v1Boss();
					}
					_battleLayer = new CJBattleLayer(_battleReply);
					SApplication.rootNode.addChild(CJBattleMapManager.o.rootMapLayer);
					CJBattleMapManager.o.debugLayer.addChild(_battleLayer);
		//			SApplication.UIRootNode.addChild(_battleLayer);
				}
			});
		}
		private function _testBattle():void
		{
			SocketCommand_battle.battle();
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,
				function _onSocket(e:Event):void
				{
					var msg:SocketMessage = e.data as SocketMessage
					if(msg.getCommand() == ConstNetCommand.CS_BATTLE)
					{
						SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onSocket);
						var jsonString:String = msg.retparams[0]
						
						
						_battleReply.setbattleJson(jsonString);
						_battleReply.play();
					}
					
				});
		}
		private function _testBattleNpc(battleId:String):void
		{
			SocketCommand_battle.battlenpc(battleId);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,
				function _onSocket(e:Event):void
				{
					var msg:SocketMessage = e.data as SocketMessage
					if(msg.getCommand() == ConstNetCommand.CS_BATTLENPC)
					{
						SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onSocket);
						var jsonString:String = msg.retparams[0]
						
						_battleReply.setbattleJson(jsonString);
						_battleReply.play();
					}
					
				});
		}
		override protected function _onExit(params:Object=null):void
		{
			_battleReply.dispose();
			_battleReply = null;

			// TODO Auto Generated method stub
			CJBattleMapManager.o.removeAllChildren();
			CJBattleMapManager.purgeInstance();
			_battleLayer = null;
			//移除加载的战斗层的资源
			AssetManagerUtil.o.disposeAssetsByGroup("CJbattleModuleResource1");
			super._onExit(params);
		}
		
		override protected function _onInit(params:Object=null):void
		{
			// TODO Auto Generated method stub
			super._onInit(params);
		}
		
		
	}
}