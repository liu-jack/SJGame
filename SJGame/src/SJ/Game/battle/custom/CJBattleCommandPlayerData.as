package SJ.Game.battle.custom
{
	import engine_starling.commandSys.core.SCommandBaseData;
	
	/**
	 * 玩家数据基类 
	 * @author caihua
	 * 
	 */
	public class CJBattleCommandPlayerData extends SCommandBaseData
	{
		public function CJBattleCommandPlayerData(commandId:int)
		{
			super(commandId);
		}
		
		private var _playerName:String;

		/**
		 * 玩家名称,这里是个魔术方法,设置队列名称
		 */
		public function get playerName():String
		{
//			return commandQueueName;
			return _playerName;
		}

		/**
		 * @private
		 */
		public function set playerName(value:String):void
		{
			_playerName = value;
//			commandQueueName = value;
		}
		
		
		private var _playerAnimName:String;

		/**
		 * 角色动画名称 
		 */
		public function get playerAnimName():String
		{
			return _playerAnimName;
		}

		/**
		 * @private
		 */
		public function set playerAnimName(value:String):void
		{
			_playerAnimName = value;
		}

		
	}
}