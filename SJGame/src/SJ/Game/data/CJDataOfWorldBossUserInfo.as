package SJ.Game.data
{
	import engine_starling.data.SDataBaseRemoteData;
	
	/**
	 +------------------------------------------------------------------------------
	 * 世界Boss用户相关数据 - 伤害累积，
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-19 上午10:14:18  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfWorldBossUserInfo extends SDataBaseRemoteData
	{
		private var _worldBossId:int = 0;
		private var _hurtnum:Number = 0;
		private var _entercolddown:int = 0;
		private var _battlecolddown:int = 0;
		private var _changesidecolddown:int = 0;
		private var _reliveleftfreetimes:int = 0;
		private var _relivetimes:int = 0;
		private var _relivecolddown:int = 0;
		private var _addbufcount:int = 0;
		private var _addbufeffect:int = 0;
		private var _worldbuff:int = 0;
		private var _repairlefttime:int = 0;
		private var _repaircolddown:int = 0;
		
		public function CJDataOfWorldBossUserInfo()
		{
			super("CJDataOfWorldBossUserInfo");
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

		public function get worldBossId():int
		{
			return _worldBossId;
		}

		public function set worldBossId(value:int):void
		{
			_worldBossId = value;
		}

		public function get hurtnum():Number
		{
			return _hurtnum;
		}

		public function set hurtnum(value:Number):void
		{
			_hurtnum = value;
		}

		public function get entercolddown():int
		{
			return _entercolddown;
		}

		public function set entercolddown(value:int):void
		{
			_entercolddown = value;
		}

		public function get battlecolddown():int
		{
			return _battlecolddown;
		}

		public function set battlecolddown(value:int):void
		{
			_battlecolddown = value;
		}

		public function get changesidecolddown():int
		{
			return _changesidecolddown;
		}

		public function set changesidecolddown(value:int):void
		{
			_changesidecolddown = value;
		}

		public function get reliveleftfreetimes():int
		{
			return _reliveleftfreetimes;
		}

		public function set reliveleftfreetimes(value:int):void
		{
			_reliveleftfreetimes = value;
		}

		public function get relivetimes():int
		{
			return _relivetimes;
		}

		public function set relivetimes(value:int):void
		{
			_relivetimes = value;
		}

		public function get relivecolddown():int
		{
			return _relivecolddown;
		}

		public function set relivecolddown(value:int):void
		{
			_relivecolddown = value;
		}

		public function get addbufcount():int
		{
			return _addbufcount;
		}

		public function set addbufcount(value:int):void
		{
			_addbufcount = value;
		}

		public function get addbufeffect():int
		{
			return _addbufeffect;
		}

		public function set addbufeffect(value:int):void
		{
			_addbufeffect = value;
		}

		public function get worldbuff():int
		{
			return _worldbuff;
		}

		public function set worldbuff(value:int):void
		{
			_worldbuff = value;
		}

		public function get repairlefttime():int
		{
			return _repairlefttime;
		}

		public function set repairlefttime(value:int):void
		{
			_repairlefttime = value;
		}

		public function get repaircolddown():int
		{
			return _repaircolddown;
		}

		public function set repaircolddown(value:int):void
		{
			_repaircolddown = value;
		}
	}
}