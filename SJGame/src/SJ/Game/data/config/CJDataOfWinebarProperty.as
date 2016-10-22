package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_wine_propertys;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	import lib.engine.utils.CObjectUtils;

	/**
	 * 酒馆静态数据管理
	 * @author longtao
	 * 
	 */
	public class CJDataOfWinebarProperty
	{
		
		private static var _o:CJDataOfWinebarProperty;
		
		public static function get o():CJDataOfWinebarProperty
		{
			if(_o == null)
				_o = new CJDataOfWinebarProperty();
			return _o;
		}
		
		private var _dataDict:Dictionary;
		
		public function CJDataOfWinebarProperty()
		{
			_initData();
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonWinebar) as Array;
			if(obj == null)
			{
				return;
			}
			_dataDict = new Dictionary();
			var length:int = obj.length;
			for(var i:int=0 ; i < length ; i++)
			{
				var data:Json_wine_propertys = new Json_wine_propertys();
				data.loadFromJsonObject(obj[i]);
				//此处的id是策划配置的id
				_dataDict[obj[i]['id']] = data;
			}
		}
		
		public function getData(winebarid:String):Json_wine_propertys
		{
			var tData:Json_wine_propertys = _dataDict[winebarid] as Json_wine_propertys;
			return CObjectUtils.clone(tData) as Json_wine_propertys;
		}
	}
}