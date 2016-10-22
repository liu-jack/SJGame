package SJ.Game.battle.custom
{
	import SJ.Common.Constants.ConstBattle;
	import engine_starling.commandSys.core.SCommandBaseData;
	
	public class CJBattleCommandNpcBattleData extends SCommandBaseData
	{
		public function CJBattleCommandNpcBattleData()
		{
			super(ConstBattle.CommandNpcBattle);
		}
		
		/**
		 * 战斗NPC名称 
		 */
		private var _battleNpcName:Array;
		
		private var _attackInterval:Number;

		/**
		 * 攻击间隔 秒 
		 */
		public function get attackInterval():Number
		{
			return _attackInterval;
		}

		/**
		 * @private
		 */
		public function set attackInterval(value:Number):void
		{
			_attackInterval = value;
		}

	}
}