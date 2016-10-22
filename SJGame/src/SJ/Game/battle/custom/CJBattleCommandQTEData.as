package SJ.Game.battle.custom
{
	import SJ.Common.Constants.ConstBattle;

	public class CJBattleCommandQTEData extends CJBattleCommandPlayerData
	{
		public function CJBattleCommandQTEData()
		{
			super(ConstBattle.CommandQTE);
//			d = 5;
			during = 5;
		}
	}
}