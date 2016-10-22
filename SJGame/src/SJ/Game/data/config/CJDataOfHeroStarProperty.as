package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_hero_star_config;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;

	public class CJDataOfHeroStarProperty
	{
		private static var _o:CJDataOfHeroStarProperty;
		
		public static function get o():CJDataOfHeroStarProperty
		{
			if(_o == null)
				_o = new CJDataOfHeroStarProperty();
			return _o;
		}
		
		private var _dataDict:Dictionary;
		
		public function CJDataOfHeroStarProperty()
		{
			_initData();
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonHeroStarConfig) as Array;
			if(obj == null)
			{
				return;
			}
			_dataDict = new Dictionary();
			var length:int = obj.length;
			for(var i:int=0 ; i < length ; i++)
			{
				var data:Json_hero_star_config = new Json_hero_star_config();
				data.loadFromJsonObject(obj[i]);
				//
				var key:String = obj[i].starlevel+"|"+obj[i].quality;
				_dataDict[key] = data;
			}
		}
		
		/**
		 * 获取武将星级信息
		 * @param herostarlevel 武将星级
		 * @param quality		武将品质
		 * @return 武将星级信息
		 * 
		 */
		public function getHerostarConfig(herostarlevel:String, quality:String):Json_hero_star_config
		{
			var key:String = herostarlevel+"|"+quality;
			return _dataDict[key];
		}
	}
}