package SJ.Game.battle.custom
{
	import SJ.Common.Constants.ConstBattle;
	import engine_starling.commandSys.core.SCommandBase;
	
	public class CJBattleCommandNpcBattleStart extends SCommandBase
	{
		public function CJBattleCommandNpcBattleStart()
		{
			super(ConstBattle.CommandNpcBattleStart, CJBattleCommandNpcBattleStartData);
		}
	}
}