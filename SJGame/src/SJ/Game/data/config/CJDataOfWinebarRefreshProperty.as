package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_wine_refresh_propertys;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	import lib.engine.utils.CObjectUtils;

	/**
	 * 
	 * @author longtao
	 * 
	 */
	public class CJDataOfWinebarRefreshProperty
	{
		private static var _o:CJDataOfWinebarRefreshProperty;
		
		public static function get o():CJDataOfWinebarRefreshProperty
		{
			if(_o == null)
				_o = new CJDataOfWinebarRefreshProperty();
			return _o;
		}
		
		private var _dataDict:Dictionary;
		public function CJDataOfWinebarRefreshProperty()
		{
			_initData();
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonWinebarRefresh) as Array;
			if(obj == null)
			{
				return;
			}
			_dataDict = new Dictionary();
			var length:int = obj.length;
			for(var i:int=0 ; i < length ; i++)
			{
				var data:Json_wine_refresh_propertys = new Json_wine_refresh_propertys();
				data.loadFromJsonObject(obj[i]);
				//此处的id是策划配置的id
				_dataDict[obj[i]['id']] = data;
			}
		}
		
		public function getData(level:String):Json_wine_refresh_propertys
		{
			var tData:Json_wine_refresh_propertys = _dataDict[level] as Json_wine_refresh_propertys;
			return CObjectUtils.clone(tData) as Json_wine_refresh_propertys;
		}
	}
}