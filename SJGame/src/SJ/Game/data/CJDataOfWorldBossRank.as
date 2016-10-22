package SJ.Game.data
{
	import engine_starling.data.SDataBaseRemoteData;
	
	/**
	 +------------------------------------------------------------------------------
	 * 世界Boss排行榜数据
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-19 上午10:22:03  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfWorldBossRank extends SDataBaseRemoteData
	{
		private var _rankid:int = 0;
		private var _uid:int = 0;
		private var _name:int = 0;
		private var _level:int = 0;
		private var _battlelevel:int = 0;
		private var _camp:int = 0;
		private var _guildname:int = 0;
		private var _lastrankid:int = 0;
		private var _hurtnum:Number = 0;
		
		public function CJDataOfWorldBossRank()
		{
			super("CJDataOfWorldBossRank");
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

		public function get rankid():int
		{
			return _rankid;
		}

		public function set rankid(value:int):void
		{
			_rankid = value;
		}

		public function get uid():int
		{
			return _uid;
		}

		public function set uid(value:int):void
		{
			_uid = value;
		}

		public function get name():int
		{
			return _name;
		}

		public function set name(value:int):void
		{
			_name = value;
		}

		public function get level():int
		{
			return _level;
		}

		public function set level(value:int):void
		{
			_level = value;
		}

		public function get battlelevel():int
		{
			return _battlelevel;
		}

		public function set battlelevel(value:int):void
		{
			_battlelevel = value;
		}

		public function get camp():int
		{
			return _camp;
		}

		public function set camp(value:int):void
		{
			_camp = value;
		}

		public function get guildname():int
		{
			return _guildname;
		}

		public function set guildname(value:int):void
		{
			_guildname = value;
		}

		public function get lastrankid():int
		{
			return _lastrankid;
		}

		public function set lastrankid(value:int):void
		{
			_lastrankid = value;
		}

		public function get hurtnum():Number
		{
			return _hurtnum;
		}

		public function set hurtnum(value:Number):void
		{
			_hurtnum = value;
		}
	}
}