package SJ.Game.data
{
	/**
	 * 进入的关卡数据
	 * @author zhengzheng
	 * 
	 */	
	public class CJDataOfEnterGuanqia
	{
		/**
		 * 副本ID
		 */		
		private var _fubenId:int;
		/**
		 * 关卡ID
		 */	
		private var _guanqiaId:int;
		/**
		 * 关卡的第一次战斗ID
		 */		
		private var _firstFightId:int;
		/**
		 * 助战玩家是不是好友
		 */		
		private var _isFriend:int;
		/**
		 * 助战玩家的id
		 */		
		private var _assistantUid:String;
		public function CJDataOfEnterGuanqia()
		{
		}
		
		private static var _o:CJDataOfEnterGuanqia;
		public static function get o():CJDataOfEnterGuanqia
		{
			if(_o == null)
			{
				_o = new CJDataOfEnterGuanqia();
			}
			return _o;
		}

		/**
		 * 副本ID
		 */
		public function get fubenId():int
		{
			return _fubenId;
		}

		/**
		 * @private
		 */
		public function set fubenId(value:int):void
		{
			_fubenId = value;
		}

		/**
		 * 关卡ID
		 */
		public function get guanqiaId():int
		{
			return _guanqiaId;
		}

		/**
		 * @private
		 */
		public function set guanqiaId(value:int):void
		{
			_guanqiaId = value;
		}

		/**
		 * 关卡的第一次战斗ID
		 */
		public function get firstFightId():int
		{
			return _firstFightId;
		}

		/**
		 * @private
		 */
		public function set firstFightId(value:int):void
		{
			_firstFightId = value;
		}

		/**
		 * 助战玩家是不是好友
		 */
		public function get isFriend():int
		{
			return _isFriend;
		}

		/**
		 * @private
		 */
		public function set isFriend(value:int):void
		{
			_isFriend = value;
		}

		/**
		 * 助战玩家的id
		 */
		public function get assistantUid():String
		{
			return _assistantUid;
		}

		/**
		 * @private
		 */
		public function set assistantUid(value:String):void
		{
			_assistantUid = value;
		}
		
		public function clear():void
		{
			_fubenId = 0;
			_guanqiaId = 0;
			_firstFightId = 0;	
			_isFriend = 0;
			_assistantUid = null;
		}

		
	}
}