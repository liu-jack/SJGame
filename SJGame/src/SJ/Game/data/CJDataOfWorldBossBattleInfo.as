package SJ.Game.data
{
	import engine_starling.data.SDataBaseRemoteData;
	
	/**
	 +------------------------------------------------------------------------------
	 * 世界boss战斗中的数据
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-19 上午11:42:06  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfWorldBossBattleInfo extends SDataBaseRemoteData
	{
		private var _battleGUID : int = 0;
		private var _isStart : int = 0;
		private var _currentround:int = 0;
		private var _currentroundlefttime : int = 0;
		private var _worldbuf : int = 0;
		private var _gateside0hp : int = 0;
		private var _gateside0players : int = 0;
		private var _gateside1hp : int = 0;
		private var _gateside1players : int = 0;
		private var _gatebasehp : int = 0;
		
		public function CJDataOfWorldBossBattleInfo()
		{
			super("CJDataOfWorldBossBattleInfo");
		}

		/**
		 * 刷新数据
		 */ 
		public function reset(data:Object):void
		{
			for(var key:* in data)
			{
				if(this.hasOwnProperty(key))
				{
					this[key] = data[key];
				}
			}
		}
		
		public function get battleGUID():int
		{
			return _battleGUID;
		}

		public function set battleGUID(value:int):void
		{
			_battleGUID = value;
		}

		public function get isStart():int
		{
			return _isStart;
		}

		public function get currentround():int
		{
			return _currentround;
		}

		public function set currentround(value):void
		{
			_currentround = value;
		}

		public function get currentroundlefttime():int
		{
			return _currentroundlefttime;
		}

		public function set currentroundlefttime(value:int):void
		{
			_currentroundlefttime = value;
		}

		public function get worldbuf():int
		{
			return _worldbuf;
		}

		public function set worldbuf(value:int):void
		{
			_worldbuf = value;
		}

		public function get gateside0hp():int
		{
			return _gateside0hp;
		}

		public function set gateside0hp(value:int):void
		{
			_gateside0hp = value;
		}

		public function get gateside0players():int
		{
			return _gateside0players;
		}

		public function set gateside0players(value:int):void
		{
			_gateside0players = value;
		}

		public function get gateside1hp():int
		{
			return _gateside1hp;
		}

		public function set gateside1hp(value:int):void
		{
			_gateside1hp = value;
		}

		public function get gateside1players():int
		{
			return _gateside1players;
		}

		public function set gateside1players(value:int):void
		{
			_gateside1players = value;
		}

		public function get gatebasehp():int
		{
			return _gatebasehp;
		}

		public function set gatebasehp(value:int):void
		{
			_gatebasehp = value;
		}
	}
}