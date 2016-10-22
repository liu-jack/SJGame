package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_daily_task_setting;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	/**
	 +------------------------------------------------------------------------------
	 * 每日任务静态配置表
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-10-2 上午10:03:40  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfDailyTaskPropertyList extends SDataBase
	{
		private static var _o:CJDataOfDailyTaskPropertyList;
		
		public function CJDataOfDailyTaskPropertyList()
		{
			super("CJDataOfDailyTaskPropertyList");
			_initData();
		}
		
		public static function get o():CJDataOfDailyTaskPropertyList
		{
			if(_o == null)
				_o = new CJDataOfDailyTaskPropertyList();
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonDailyTask) as Array;
			var length:int = obj.length;
			for(var i:int = 0 ; i < length ; i++)
			{
				var config:Json_daily_task_setting = new Json_daily_task_setting();
				config.loadFromJsonObject(obj[i]);
				this.setData(config.dailytaskid , config);
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
		 * 获取进度的配置 
		 */		
		public function getConfigById(dailytaskid:int):Json_daily_task_setting
		{
			return this.getData(String(dailytaskid));
		}
	}
}