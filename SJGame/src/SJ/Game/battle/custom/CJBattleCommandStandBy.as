package SJ.Game.battle.custom
{
	import SJ.Common.Constants.ConstBattle;
	import SJ.Game.battle.CJBattlePlayerData;
	import SJ.Game.battle.CJBattleReplayManager;
	import SJ.Game.battle.data.CJBattleFormationData;
	import SJ.Game.map.CJBattleMapManager;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.commandSys.core.SCommandBase;
	import engine_starling.commandSys.core.SCommandBaseData;
	
	import feathers.controls.Label;
	
	import flash.geom.Point;
	import flash.utils.describeType;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 开始动作 
	 * @author caihua
	 * 
	 */
	public class CJBattleCommandStandBy extends SCommandBase
	{
		public function CJBattleCommandStandBy()
		{
			super(ConstBattle["CommandStandBy"],CJBattleCommandStandByData);
		}
		private var _npccount:int = 0
		
		
		override protected function execute(battleData:SCommandBaseData):void
		{
			_npccount = 0;
			var data:CJBattleCommandStandByData = battleData as CJBattleCommandStandByData;
			var mgr:CJBattleReplayManager = data.params["mgr"];
			var params:Object = data.params["params"];
		
			var heros:Object = params["player0"]["battleheros"];
			var otherheros:Object = params["player1"]["battleheros"];
			for each(var heroinfo:Object in heros)
			{
				_npccount++;
			}
			for each(var heroinfo:Object in otherheros)
			{
				_npccount++;
			}
//			_npccount = heros.length + otherheros.length;
			_addPlayer(heros,true);
			_addPlayer(otherheros,false);
			
			function _addPlayer(battleheros:Object,isSelf:Boolean):void
			{
				for each(var heroinfo:Object in battleheros)
				{
					var player:CJBattlePlayerData = mgr.addPlayer(heroinfo,isSelf);
					_addPlayerToMap(player);
				}
			}
			
			function _addPlayerToMap(player:CJBattlePlayerData):void
			{
				var pos:Point = null;
				var posIndex:int = 0;
				var formationData:CJBattleFormationData = ConstBattle.sBattleFormationData[player.playerBaseData.formationId];
				var scaleX:Number = 1.0;
				if(player.playerBaseData.isSelf)
				{
					pos = formationData.getSelfNpcPos(player.playerBaseData.formationindex);
				}
				else
				{
					scaleX = -1;
					pos = formationData.getOtherNpcPos(player.playerBaseData.formationindex);
				}
				
				var playerSprite:CJPlayerNpc = new CJPlayerNpc(player.playerBaseData,cmdOwner.mJuggler);
				
				player.playerSprite = playerSprite;
				
				playerSprite.x = pos.x;
				playerSprite.y = pos.y;
				playerSprite.scaleX = scaleX;
				playerSprite.hideAllTitle();
				//添加npc索引
				playerSprite.npcId = player.playerBaseData.name;
				playerSprite.addEventListener(TouchEvent.TOUCH,function onTouch(e:TouchEvent):void
				{
					var touch:Touch = e.getTouch(playerSprite,TouchPhase.BEGAN);
					if(touch)
					{
						playerSprite.showBattleTips();
					}
				});
				
				
				
				
				
				playerSprite.onloadResourceCompleted = function(npc:CJPlayerNpc):void{
					
					npc.sort();
					npc.idle();
					_npccount --;
					
					if(_npccount == 0)
					{
						executeEndImmediately()
					}
				}
					
				CJBattleMapManager.o.playerLayer.addChild(playerSprite);
			}
//			"params"	Object (@1706e539)	
//			player0	Object (@1706e4f1)	
//			battleheros	Object (@1706e491)	
//			216175330854576129	Object (@1706d989)	
//			blood	"100"	
//			crit	"5000"	
//			cure	"100"	
//			dodge	"100"	
//			formationindex	"0"	
//			genius	"2"	
//			heroid	"216175330854576129"	
//			hit	"9000"	
//			hp	"40800"	
//			inchurt	"100"	
//			level	"3"	
//			mattack	"2400"	
//			mcrit	"5000"	
//			mdef	"600"	
//			mimmuno	"100"	
//			mpassthrough	"9000"	
//			mtoughness	"100"	
//			pattack	"3300"	
//			pdef	"1500"	
//			reducehurt	"100"	
//			skill1	"4"	
//			skill1startround	"2"	
//			skill2	"0"	
//			speed	"1200"	
//			templateid	"2"	
//			toughness	"100"	
//			userid	"216175330484267009"	
//			216175330854576130	Object (@1706e449)	
//			216175330854576132	Object (@170eaf11)	
//			player1	Object (@17c0cd79)	

			return;
			
//			for each(var player:CJBattlePlayerData in data.playerContains)
//			{
//				var pos:Point = null;
//				var posIndex:int = 0;
//				var formationData:CJBattleFormationData = ConstBattle.sBattleFormationData[player.playerBaseData.formationId];
//				var scaleX:Number = 1.0;
//				if(player.playerBaseData.isSelf)
//				{
//
//						
//						pos = formationData.getSelfNpcPos(player.playerBaseData.formationindex);
//
//				}
//				else
//				{
//					
//						scaleX = -1;
//						pos = formationData.getOtherNpcPos(player.playerBaseData.formationindex);
//
//
//				}
//				
//				
//				var playerSprite:CJPlayerNpc = new CJPlayerNpc(player.playerBaseData,cmdOwner.mJuggler);
//				playerSprite.x = pos.x;
//				playerSprite.y = pos.y;
//				playerSprite.scaleX = scaleX;
//				//添加npc索引
//				playerSprite.npcId = player.playerBaseData.name;
//				_npccount ++;
//				
//				CJBattleMapManager.o.playerLayer.addChild(playerSprite);
//				playerSprite.onloadResourceCompleted = function(npc:CJPlayerNpc){
//					npc.sort();
//					npc.idle();
//					_npccount --;
//					
//					if(_npccount == 0)
//					{
//						executeEndImmediately()
//					}
//				}
//				
//			}
			
			
//			this.executeFinish();
		}
		
		
		
		
	}
}