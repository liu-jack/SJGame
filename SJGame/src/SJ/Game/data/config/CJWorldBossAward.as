package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_world_boss_award;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	/**
	 +------------------------------------------------------------------------------
	 * 世界Boss排行榜奖励配置列表信息
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-19 上午11:13:06  
	 +------------------------------------------------------------------------------
	 */
	public class CJWorldBossAward extends SDataBase
	{
		private static var _o:CJWorldBossAward;
		
		public function CJWorldBossAward()
		{
			super("CJWorldBossAward");
			_initData();
		}
		
		public static function get o():CJWorldBossAward
		{
			if(_o == null)
				_o = new CJWorldBossAward();
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonWorldBossAward) as Array;
			var length:int = obj.length;
			for(var i:int = 0 ; i < length ; i++)
			{
				var config:Json_world_boss_award = new Json_world_boss_award();
				config.loadFromJsonObject(obj[i]);
				this.dataContains[config.rankstart] = config;
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
		public function getRewardConfigByRank(rank:int):Json_world_boss_award
		{
			if(rank <= 0)
			{
				return null;
			}
			for(var rankStart:String in this.dataContains)
			{
				var config:Json_world_boss_award = this.dataContains[rankStart];
				if(int(rankStart) <= rank && config.rankend >=rank)
				{
					return config;
				}
			}
			return null;
		}
	}
}