package SJ.Game.data
{
	import SJ.Game.data.config.CJWorldBossBattleMonsterConfigList;
	import SJ.Game.data.json.Json_world_boss_battle_monster_info;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	/**
	 +------------------------------------------------------------------------------
	 * 世界boss单个怪物数据类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-19 上午11:50:47  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfWorldBossMonsterData extends SDataBaseRemoteData
	{
		private var _guid:int = 0;
		private var _monsterinfoId:int = 0;
		private var _lefthp:int = 0;
		private var _maxhp:int = 0;
		private var _leftmovetime:int = 0;
		private var _totalmovetime:int = 0;
		private var _monsterConfig:Json_world_boss_battle_monster_info;
		
		public function CJDataOfWorldBossMonsterData()
		{
			super("CJDataOfWorldBossMonsterData");
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

		public function get guid():int
		{
			return _guid;
		}

		public function set guid(value:int):void
		{
			_guid = value;
		}

		public function get monsterinfoId():int
		{
			return _monsterinfoId;
		}

		public function set monsterinfoId(value:int):void
		{
			if(value == _monsterinfoId)
			{
				return;
			}
			_monsterinfoId = value;
			_monsterConfig = CJWorldBossBattleMonsterConfigList.o.getMonsterGroupByid(_monsterinfoId);
		}

		public function get lefthp():int
		{
			return _lefthp;
		}

		public function set lefthp(value:int):void
		{
			_lefthp = value;
		}

		public function get maxhp():int
		{
			return _maxhp;
		}

		public function set maxhp(value:int):void
		{
			_maxhp = value;
		}

		public function get leftmovetime():int
		{
			return _leftmovetime;
		}

		public function set leftmovetime(value:int):void
		{
			_leftmovetime = value;
		}

		public function get totalmovetime():int
		{
			return _totalmovetime;
		}

		public function set totalmovetime(value:int):void
		{
			_totalmovetime = value;
		}

		public function get monsterConfig():Json_world_boss_battle_monster_info
		{
			return _monsterConfig;
		}
	}
}