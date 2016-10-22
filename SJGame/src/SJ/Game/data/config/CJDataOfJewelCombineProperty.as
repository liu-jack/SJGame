package SJ.Game.data.config
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_jewel_combine_config;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	/**
	 * @author zhengzheng
	 * 宝石合成配置数据
	 */
	public class CJDataOfJewelCombineProperty extends SDataBase
	{
		public function CJDataOfJewelCombineProperty()
		{
			super("CJDataOfJewelCombineProperty");
		}
		
		private static var _o:CJDataOfJewelCombineProperty;
		public static function get o():CJDataOfJewelCombineProperty
		{
			if(_o == null)
			{
				_o = new CJDataOfJewelCombineProperty();
				_o._initData();
			}
			return _o;
		}
		
		private var _dataDict:Dictionary;
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonJewelCombineConfig) as Array;
			var length:int = obj.length;
			var jewelCombine:Json_jewel_combine_config = new Json_jewel_combine_config();
			_dataDict = new Dictionary();
			for(var i:int=0;i<length;i++)
			{
				jewelCombine.loadFromJsonObject(obj[i]);
				_dataDict[parseInt(obj[i]['srcjewelid'])] = obj[i];
			}
		}
		
		public function getJewelCombineInfo(id:int):Json_jewel_combine_config
		{
			var jewelCombine:Json_jewel_combine_config = new Json_jewel_combine_config();
			if (_dataDict.hasOwnProperty(String(id)))
			{
				jewelCombine.loadFromJsonObject(_dataDict[id]);
				return jewelCombine;
			}
			else
			{
				return null;
			}
		}
		
	}
}