package SJ.Game.battle.custom
{
	import SJ.Common.Constants.ConstBattle;

	public class CJBattleCommandCreatePlayerData extends CJBattleCommandPlayerData
	{
		public function CJBattleCommandCreatePlayerData()
		{
			super(ConstBattle.CommandCreatePlayer);
		}
		
		
		
		private var _playerid:int = 0;

		/**
		 * 玩家ID 
		 */
		public function get playerid():int
		{
			return _playerid;
		}

		/**
		 * @private
		 */
		public function set playerid(value:int):void
		{
			_playerid = value;
		}
		


	}
}