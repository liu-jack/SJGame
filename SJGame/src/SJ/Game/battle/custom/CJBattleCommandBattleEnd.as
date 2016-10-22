package SJ.Game.battle.custom
{
	import SJ.Common.Constants.ConstBattle;
	import SJ.Game.battle.CJBattlePlayerData;
	import SJ.Game.battle.CJBattleReplayManager;
	import SJ.Game.battle.CJBattleResultLayer;
	import SJ.Game.map.CJBattleMapManager;
	
	import engine_starling.commandSys.core.SCommandBase;
	import engine_starling.commandSys.core.SCommandBaseData;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import feathers.core.FeathersControl;
	
	public class CJBattleCommandBattleEnd extends SCommandBase
	{
		
		

		
		public function CJBattleCommandBattleEnd()
		{
			super(ConstBattle.CommandBattleEnd, CJBattleCommandBattleEndData);
		}
		
		override protected function execute(battleData:SCommandBaseData):void
		{
			// TODO Auto Generated method stub
			
			//查询所有NPC,并按照速度排序
//			var _vectorOfPlayerData:Vector.<CJBattlePlayerData> = CJBattleMananger.o.getAllPlayerbattleData();
//			var length:int = 0;
//			var isWin:Boolean = false;
//			var isTongguan:Boolean = false;
//			length = _vectorOfPlayerData.length;
//			for(var i:int = 0;i<length;i++)
//			{
//				if(!_vectorOfPlayerData[i].playerBaseData.isDead())
//				{
//					_vectorOfPlayerData[i].playerSprite.win();
//					//判断获胜者是不是自己
//					if(_vectorOfPlayerData[i].playerBaseData.isSelf )
//					{
//						isWin = true;
//						isTongguan = true;
//					}
//				}
//			}
//			"params"	Object (@184ed731)	
//			losealiveids	[] (@1845fe21)	
//			length	0	
//			victory	1	
//			victoryaliveids	[] (@1845dd01)	
//			[0]	"216175330854576130"	
//			[1]	"216175330854576133"	
//			[2]	"216175330854576129"	
//			length	3	

			var mgr:CJBattleReplayManager = battleData.params["mgr"];
			var params:Object = battleData.params["params"];
			
			cmdOwner.mJuggler.delayCall(executeEndImmediately,0.01);
			return;
			
//			var victory:Boolean = Boolean(parseInt(params.victory));
//			
//			//播发胜利或者失败动画
//			var victoryids:Array = params.victoryaliveids as Array;
//			for each(var heroid:String in victoryids)
//			{
//				var player:CJBattlePlayerData =	mgr.getPlayer(heroid);
//				player.playerSprite.win();
//			}
//			var loseids:Array = params.losealiveids as Array;
//			for each(heroid in loseids)
//			{
//				player = mgr.getPlayer(heroid);
//				player.playerSprite.lose()
//			}
//			cmdOwner.mJuggler.delayCall(executeEndImmediately,1);
//			return;
////			executeEndImmediately();
//			
//			var award:Object = mgr.battleAwards;
//			
////			"award"	Object (@18f010e9)	
////			award	Object (@18f01161)	
////			exp	100 [0x64]	
////			gold	300 [0x12c]	
////			sliver	200 [0xc8]	
//			
//			var exp:int,gold:int,sliver:int = 0;
//			exp = parseInt(award.award.exp);
//			gold = parseInt(award.award.gold);
//			sliver = parseInt(award.award.sliver);
//
//			var s:XML = AssetManagerUtil.o.getObject("battleResultLayout.sxml") as XML;
//			var winLayer:FeathersControl = SFeatherControlUtils.o.genLayoutFromXML(s,CJBattleResultLayer);
//			var battleResultLayer:CJBattleResultLayer = winLayer as CJBattleResultLayer;
//			//战斗结束层选择显示胜利或者失败(通关后，会随之显示通关动画)
//			//zhengzheng ++
//			battleResultLayer.juggler = cmdOwner.mJuggler;
//			var _tongguanParams:Object = {"jingYan":exp,"yinLiang":sliver,"ganWu":gold};
//			battleResultLayer.tongguanParams = _tongguanParams;
//			battleResultLayer.showBattleResult(victory,victory);
//			CJBattleMapManager.o.topLayer.addChild(winLayer);
//			
//			super.execute(battleData);
			
			
		}
		
		
	}
}