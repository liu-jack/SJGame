package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_treasureconfig;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;

	/**
	 +------------------------------------------------------------------------------
	 * 灵丸数据配置信息列表
	 * templateid => Json_treasureconfig
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-31 14:03:40  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfTreasurePropertyList extends SDataBase
	{
		private static var _o:CJDataOfTreasurePropertyList;
		
		public function CJDataOfTreasurePropertyList()
		{
			super("CJDataOfTreasurePropertyList");
			_initData();
		}
		
		public static function get o():CJDataOfTreasurePropertyList
		{
			if(_o == null)
				_o = new CJDataOfTreasurePropertyList();
			return _o;
		}
		
		/**
		 * treasureid => Json_treasureconfig
		 */		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonTreasureDataConfig) as Array;
			var length:int = obj.length;
			for(var i:int = 0 ; i < length ; i++)
			{
				var treasuerConfig:Json_treasureconfig = new Json_treasureconfig();
				treasuerConfig.loadFromJsonObject(obj[i]);
				this.setData(treasuerConfig.templateid , treasuerConfig);
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
		 * 获取聚灵templateid的配置 
		 * @param templateid：灵丸的配置id
		 * @return Json_treasureconfig
		 */		
		public function getTreasureConfigByTemplateid(templateid:int):Json_treasureconfig
		{
			return this.getData(String(templateid));
		}
	}
}