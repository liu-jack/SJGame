package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_world_boss_hurt_buf_setting;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	/**
	 +------------------------------------------------------------------------------
	 * 世界Boss伤血增加buff
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-19 上午11:27:33  
	 +------------------------------------------------------------------------------
	 */
	public class CJWorldBossHurtBuff extends SDataBase
	{
		private static var _o:CJWorldBossHurtBuff;
		
		public function CJWorldBossHurtBuff()
		{
			super("CJWorldBossHurtBuff");
			_initData();
		}
		
		public static function get o():CJWorldBossHurtBuff
		{
			if(_o == null)
				_o = new CJWorldBossHurtBuff();
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonWorldBossHurtBuff) as Array;
			var length:int = obj.length;
			for(var i:int = 0 ; i < length ; i++)
			{
				var config:Json_world_boss_hurt_buf_setting = new Json_world_boss_hurt_buf_setting();
				config.loadFromJsonObject(obj[i]);
				this.dataContains[config.no1hurtmin] = config;
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
		 * 获取伤血对应增加的Buff
		 */		
		public function getRoundConfigListByRoundid(hurt:Number):Json_world_boss_hurt_buf_setting
		{
			var addBuff:Number = 0;
			for(var hurtMin:String in this.dataContains)
			{
				var config:Json_world_boss_hurt_buf_setting = this.dataContains[hurtMin];
				if(hurt >= hurtMin)
				{
					addBuff = config.worldbufeffect;
				}
			}
			return addBuff;
		}
	}
}