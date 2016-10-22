package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_activity_progress_setting;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;

	/**
	 +------------------------------------------------------------------------------
	 * 活跃度静态配置表
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-25 上午10:03:40  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfActivityPropertyList extends SDataBase
	{
		private static var _o:CJDataOfActivityPropertyList;
		private var _totalScore:int = 0;
		
		public function CJDataOfActivityPropertyList()
		{
			super("CJDataOfActivityPropertyList");
			_initData();
		}
		
		public static function get o():CJDataOfActivityPropertyList
		{
			if(_o == null)
				_o = new CJDataOfActivityPropertyList();
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonActivity) as Array;
			var length:int = obj.length;
			for(var i:int = 0 ; i < length ; i++)
			{
				var config:Json_activity_progress_setting = new Json_activity_progress_setting();
				config.loadFromJsonObject(obj[i]);
				if(int(config.isopen))
				{
					_totalScore += int(config.addscore) * int(config.count) ;
					this.setData(config.activitykey , config);
				}
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
		 * 总活跃度
		 */
		public function getTotalScore():int
		{
			return _totalScore;
		}
		
		/**
		 * 获取进度的配置 
		 */		
		public function getConfigByKey(key:String):Json_activity_progress_setting
		{
			return this.getData(String(key));
		}
	}
}