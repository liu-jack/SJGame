package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_buyvit_setting;
	
	import engine_starling.utils.AssetManagerUtil;
	
	public class CJDataOfBuyVitProperty
	{
		private var _dataDict:Array;
		public function CJDataOfBuyVitProperty()
		{
			_initData();
		}
		
		private static var _o:CJDataOfBuyVitProperty;
		public static function get o():CJDataOfBuyVitProperty
		{
			if(_o == null)
				_o = new CJDataOfBuyVitProperty();
			return _o;
		}
		
		private function _initData():void
		{
			_dataDict = new Array;
			var buyvitConf:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonBuyVitConfig) as Array;
			for(var i:String in buyvitConf)
			{
				var jsonObj:Json_buyvit_setting = new Json_buyvit_setting;
				jsonObj.loadFromJsonObject(buyvitConf[i])
				_dataDict.push(jsonObj);
			}
		}
		/**
		 * 根据ID获取配置数据 
		 * @param id
		 * @return 
		 * 
		 */
		public function getPropertyByNum(nums:int):Json_buyvit_setting
		{
			var info:Json_buyvit_setting;
			for(var i:String in this._dataDict)
			{
				if(nums >=int(this._dataDict[i].nums))
				{
					info = this._dataDict[i];
				}
			}
			return info;
		}
		
		public function getNeedCost(nums:int):Number
		{
			var conf:Json_buyvit_setting = getPropertyByNum(nums);
			return conf.cost;
		}
	}
}