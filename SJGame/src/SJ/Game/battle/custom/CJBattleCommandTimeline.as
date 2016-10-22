package SJ.Game.battle.custom
{
	import SJ.Common.Constants.ConstBattle;
	import SJ.Game.battle.CJBattleMananger;
	import SJ.Game.battle.CJBattlePlayerData;
	import engine_starling.commandSys.core.SCommandBase;
	import engine_starling.commandSys.core.SCommandBaseData;
	
	import engine_starling.utils.Logger;
	
	/**
	 * 战斗时间片 
	 * @author caihua
	 * 
	 */
	public class CJBattleCommandTimeline extends SCommandBase
	{
		public function CJBattleCommandTimeline()
		{
			super(ConstBattle.CommandTimeLine, CJBattleCommandTimelineData);
		}
		
		override protected function execute(battleData:SCommandBaseData):void
		{
			Logger.log("CJBattleCommandTimeline:",battleData.commandQueueName);
			var data:CJBattleCommandTimelineData = battleData as CJBattleCommandTimelineData;
			var dataOfBattle:CJBattlePlayerData = CJBattleMananger.o.battleDataByPlayerName(data.playerName);
			
			if(dataOfBattle.playerBaseData.isPlayer)
			{
//				dataOfBattle.playerSprite.attack();
				if(dataOfBattle.playerBaseData.isSelf)
				{
				_executeSelf();
				}
			}
			else
			{
				if(dataOfBattle.playerBaseData.isSelf)
				{

				}
				
			}
			executeFinish();
				
		}
		
		private function _executeSelf():void
		{
			//show Qte
			
//			var qte:CJBattleQTELayer = new CJBattleQTELayer();
//			CJMapManager.o.qteLayer.addChild(qte);
//			
//			Starling.juggler.delayCall(function ():void
//			{
//				qte.removeFromParent();
//			},3);
		}
		
		
	}
}