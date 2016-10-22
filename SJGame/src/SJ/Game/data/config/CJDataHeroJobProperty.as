package SJ.Game.data.config
{
	
	import SJ.Game.data.json.Json_hero_job_setting;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;

	/**
	 +------------------------------------------------------------------------------
	 * @name 武将职业配置
	 +------------------------------------------------------------------------------
	 * @author	sangxu
	 * @date 	2013-07-11
	 +------------------------------------------------------------------------------
	 */
	public class CJDataHeroJobProperty extends SDataBase
	{
		
		public function CJDataHeroJobProperty()
		{
			super("CJDataHeroJobProperty");
			
		}
		
		private static var _o:CJDataHeroJobProperty;
		public static function get o():CJDataHeroJobProperty
		{
			if(_o == null)
			{
				_o = new CJDataHeroJobProperty();
				_o._initData();
			}
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject("hero_job_setting.json") as Array;
			var length:int = obj.length;
			for(var i:int=0;i<length;i++)
			{
				var prop:Json_hero_job_setting = new Json_hero_job_setting();
				prop.loadFromJsonObject(obj[i])
				this.setData(obj[i]['jobid'], prop);
			}
			
		}
		
		/**
		 * 获取武将职业配置
		 */
		public function getHeroJob(jobId : int) : Json_hero_job_setting
		{
			return this.getData(String(jobId));
		}
	}
}