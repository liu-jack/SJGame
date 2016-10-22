package SJ.Game.battle.custom
{
	import SJ.Common.Constants.ConstBattle;
	
	import engine_starling.commandSys.core.SCommandBase;
	import engine_starling.commandSys.core.SCommandBaseData;
	
	public class CJBattleCommandBattleOrder extends SCommandBase
	{
		public function CJBattleCommandBattleOrder()
		{
			super(ConstBattle.CommandBattleOrder, CJBattleCommandBattleOrderData);
		}
		
		override protected function execute(battleData:SCommandBaseData):void
		{
			// TODO Auto Generated method stub
//			super.execute(battleData);
			executeEndImmediately();
		}
		
		
	}
}