package SJ.Game.battle.custom
{
	import SJ.Common.Constants.ConstBattle;
	
	import flash.utils.Dictionary;

	public class CJBattleCommandStandByData extends CJBattleCommandPlayerData
	{
		public function CJBattleCommandStandByData()
		{
			super(ConstBattle.CommandStandBy);
		}
		
//		override public function convertFromJson(jsonObject:Object):void
//		{
//			
//			super.convertFromJson(jsonObject);
//			_x = jsonObject["x"];
//			_y = jsonObject["y"];
//		}
		
		
		
		private var _x:int;

		/**
		 *  位置
		 */
		public function get x():int
		{
			return _x;
		}

		/**
		 * @private
		 */
		public function set x(value:int):void
		{
			_x = value;
		}
//		
//		private var _y:int = 0;
//
//		/**
//		 * Y 
//		 */
//		public function get y():int
//		{
//			return _y;
//		}
//
//		/**
//		 * @private
//		 */
//		public function set y(value:int):void
//		{
//			_y = value;
//		}
//		
//		private var _scaleX:Number = 1;
//
//		/**
//		 * x缩放 
//		 */
//		public function get scaleX():Number
//		{
//			return _scaleX;
//		}
//
//		/**
//		 * @private
//		 */
//		public function set scaleX(value:Number):void
//		{
//			_scaleX = value;
//		}
		
		
		private var _playerContains:Dictionary;

		/**
		 * 玩家容器 
		 */
		public function get playerContains():Dictionary
		{
			return _playerContains;
		}

		/**
		 * @private
		 */
		public function set playerContains(value:Dictionary):void
		{
			_playerContains = value;
		}
		

		
		
		
		
		
	}
}