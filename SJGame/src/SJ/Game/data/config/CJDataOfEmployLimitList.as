package SJ.Game.data.config
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_employ_level_limit;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;

	/**
	 +------------------------------------------------------------------------------
	 * 任务静态配置列表类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-25 上午10:03:40  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfEmployLimitList extends SDataBase
	{
		private static var _o:CJDataOfEmployLimitList;
		
		public function CJDataOfEmployLimitList()
		{
			super("CJDataOfEmployLimitList");
			_initData();
		}
		
		public static function get o():CJDataOfEmployLimitList
		{
			if(_o == null)
				_o = new CJDataOfEmployLimitList();
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonEmployLimit) as Array;
			var length:int = obj.length;
			for(var i:int = 0 ; i < length ; i++)
			{
				var config:Json_employ_level_limit = new Json_employ_level_limit();
				config.loadFromJsonObject(obj[i]);
				this.setData(config.id , config);
			}
		}
		
		/**
		 * 获取所有的配置列表
		 */		
		public function getAllEmployLimitList():Dictionary
		{
			return this._dataContains;
		}
		
		/**
		 * 获取的配置 
		 */		
		public function getLimitConfigByLevel(level:int):Json_employ_level_limit
		{
			for each(var config:Json_employ_level_limit in this._dataContains)
			{
				if(config.userminlevel <= level && config.usermaxlevel >= level)
				{
					return config
				}
			}
			return null;
		}
	}
}