package SJ.Game.battle.custom
{
	import SJ.Common.Constants.ConstBattle;
	import engine_starling.commandSys.core.SCommandBase;
	import engine_starling.commandSys.core.SCommandBaseData;

	public class CJBattleCommandCreatePlayer extends SCommandBase
	{
		public function CJBattleCommandCreatePlayer()
		{
			super(ConstBattle.CommandCreatePlayer,CJBattleCommandCreatePlayerData);
		}
		
		
		override protected function execute(battleData:SCommandBaseData):void
		{
			// TODO Auto Generated method stub
			super.execute(battleData);
		}
		
		
	}
}