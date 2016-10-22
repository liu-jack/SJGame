package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_open_jewel_hole;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;

	/**
	 * 镶嵌开孔数据
	 * @author sangxu
	 * 
	 */	
	public class CJDataOfOpenJewelHoleProperty extends SDataBase
	{
		
		public function CJDataOfOpenJewelHoleProperty()
		{
			super("CJDataOfOpenJewelHoleProperty");
			
		}
		
		private static var _o:CJDataOfOpenJewelHoleProperty;
		public static function get o():CJDataOfOpenJewelHoleProperty
		{
			if(_o == null)
			{
				_o = new CJDataOfOpenJewelHoleProperty();
				_o._initData();
			}
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonOpenJewelHole) as Array;

			var length:int = obj.length;
			for(var i:int=0;i<length;i++)
			{
				var holeProp:Json_open_jewel_hole = new Json_open_jewel_hole();
				holeProp.loadFromJsonObject(obj[i]);
				this.setData(obj[i]['number'], holeProp);
			}
		}
		
		/**
		 * 获取镶嵌开孔配置
		 */
		public function getOpenProperty(number : int) : Json_open_jewel_hole
		{
			return this.getData(String(number));
		}
	}
}