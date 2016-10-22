package SJ.Game.battle
{
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	
	import lib.engine.utils.CObjectUtils;

	/**
	 * 玩家战斗数据类 
	 * @author caihua
	 * 
	 */
	public class CJBattlePlayerData
	{
		public function CJBattlePlayerData(playerData:CJPlayerData)
		{
			_playerBaseData = CObjectUtils.clone(playerData);
		}
		private var _playerBaseData:CJPlayerData;

		/**
		 * 玩家原始数据 
		 */
		public function get playerBaseData():CJPlayerData
		{
			return _playerBaseData;
		}
		
		/**
		 * 玩家名称 
		 * 
		 */
		public function get playerName():String
		{
			return playerBaseData.name;
		}
		
		
		private var _playerSprite:CJPlayerNpc;

		/**
		 * 玩家精灵 
		 */
		public function get playerSprite():CJPlayerNpc
		{
			return _playerSprite;
		}

		/**
		 * @private
		 */
		public function set playerSprite(value:CJPlayerNpc):void
		{
			_playerSprite = value;
		}
		
		private var _moveAble:Boolean = true;

		/**
		 * 是否可以动 
		 */
		public function get moveAble():Boolean
		{
			return _moveAble;
		}

		/**
		 * @private
		 */
		public function set moveAble(value:Boolean):void
		{
			_moveAble = value;
		}
		
		
		/**
		 * 下一轮 
		 * 
		 */
		public function nextRound():void
		{
			_moveAble = true;
			_selectedSkill = -1;
		}
		
		
		private var _selectedSkill:int = -1;

		/**
		 * 选中的技能索引 
		 */
		public function get selectedSkill():int
		{
			return _selectedSkill;
		}

		/**
		 * @private
		 */
		public function set selectedSkill(value:int):void
		{
			_selectedSkill = value;
		}
		
		
		
		

	}
}