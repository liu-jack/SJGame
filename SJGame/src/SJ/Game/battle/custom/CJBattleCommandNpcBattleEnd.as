package SJ.Game.battle.custom
{
	import SJ.Common.Constants.ConstBattle;
	import engine_starling.commandSys.core.SCommandBase;
	
	public class CJBattleCommandNpcBattleEnd extends SCommandBase
	{
		public function CJBattleCommandNpcBattleEnd()
		{
			super(ConstBattle.CommandNpcBattleEnd, CJBattleCommandNpcBattleEndData);
			
		}
	}
}