package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_world_boss_battle_round;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	/**
	 +------------------------------------------------------------------------------
	 * 世界boss波次配置列表
	 * {"roundid"=>array(json , josn)}
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-19 上午10:35:05  
	 +------------------------------------------------------------------------------
	 */
	public class CJWorldBossBattleRoundPropertyList extends SDataBase
	{
		private static var _o:CJWorldBossBattleRoundPropertyList;
		
		public function CJWorldBossBattleRoundPropertyList()
		{
			super("CJWorldBossBattleRoundPropertyList");
			_initData();
		}
		
		public static function get o():CJWorldBossBattleRoundPropertyList
		{
			if(_o == null)
				_o = new CJWorldBossBattleRoundPropertyList();
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonWorldBossBattleRound) as Array;
			var length:int = obj.length;
			for(var i:int = 0 ; i < length ; i++)
			{
				var config:Json_world_boss_battle_round = new Json_world_boss_battle_round();
				config.loadFromJsonObject(obj[i]);
				if(!this.dataContains.hasOwnProperty(config.roundid))
				{
					this.dataContains[config.roundid] = [];
				}
				this.dataContains[config.roundid][] = config;
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
		 * 获取怪物的波次系列的配置 
		 */		
		public function getRoundConfigListByRoundid(roundid:int):Array
		{
			if(roundid == 0)
			{
				return null;
			}
			return this.getData(String(roundid));
		}
	}
}