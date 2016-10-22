package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_world_boss_battle_monster_info;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	/**
	 +------------------------------------------------------------------------------
	 * 世界Boss怪物配置列表
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-19 上午11:10:01  
	 +------------------------------------------------------------------------------
	 */
	public class CJWorldBossBattleMonsterConfigList extends SDataBase
	{
		private static var _o:CJWorldBossBattleMonsterConfigList;
		
		public function CJWorldBossBattleMonsterConfigList()
		{
			super("CJWorldBossBattleMonsterConfigList");
			_initData();
		}
		
		public static function get o():CJWorldBossBattleMonsterConfigList
		{
			if(_o == null)
				_o = new CJWorldBossBattleMonsterConfigList();
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonWorldBossMonsterInfo) as Array;
			var length:int = obj.length;
			for(var i:int = 0 ; i < length ; i++)
			{
				var config:Json_world_boss_battle_monster_info = new Json_world_boss_battle_monster_info();
				config.loadFromJsonObject(obj[i]);
				this.setData(config.id , config);
			}
		}
		
		/**
		 * 获取所有的配置列表
		 */		
		public function getAllTempateList():Dictionary
		{
			return this._dataContains;
		}
		
		/**
		 * 获取怪物的配置 
		 */		
		public function getMonsterGroupByid(id:int):Json_world_boss_battle_monster_info
		{
			if(id == 0)
			{
				return null;
			}
			return this.getData(String(id));
		}
	}
}