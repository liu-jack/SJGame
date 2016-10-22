package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_world_boss_hurt_repair_setting;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	/**
	 +------------------------------------------------------------------------------
	 * 世界boss伤血回复配置列表
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-19 上午11:22:05  
	 +------------------------------------------------------------------------------
	 */
	public class CJWorldBossRepairConfigList extends SDataBase
	{
		private static var _o:CJWorldBossRepairConfigList;
		
		public function CJWorldBossRepairConfigList()
		{
			super("CJWorldBossRepairConfigList");
			_initData();
		}
		
		public static function get o():CJWorldBossRepairConfigList
		{
			if(_o == null)
				_o = new CJWorldBossRepairConfigList();
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonWorldBossHurtRepair) as Array;
			var length:int = obj.length;
			for(var i:int = 0 ; i < length ; i++)
			{
				var config:Json_world_boss_hurt_repair_setting = new Json_world_boss_hurt_repair_setting();
				config.loadFromJsonObject(obj[i]);
				this.dataContains[config.hurtmin] = config;
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
		 * 获取伤血对应回复的血量
		 */		
		public function getRoundConfigListByRoundid(hurt:Number):Json_world_boss_hurt_repair_setting
		{
			var realRepair:Number = 0;
			for(var hurtMin:String in this.dataContains)
			{
				var config:Json_world_boss_hurt_repair_setting = this.dataContains[hurtMin];
				if(hurt >= hurtMin)
				{
					realRepair = config.repairvalue
				}
			}
			return realRepair;
		}
	}
}