package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import SJ.Game.data.json.Json_bag_property_setting;
	/**
	 * 容器配置数据
	 * @author sangxu
	 * 
	 */	
	public class CJDataOfBagProperty extends SDataBase
	{
		
		public function CJDataOfBagProperty()
		{
			super("CJDataOfBagSetting");
			
		}
		
		private static var _o:CJDataOfBagProperty;
		public static function get o():CJDataOfBagProperty
		{
			if(_o == null)
			{
				_o = new CJDataOfBagProperty();
				_o._initData();
			}
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResBagPropSetting) as Array;
//			_dataDict = new Dictionary();
			var length:int = obj.length;
			for(var i:int=0;i<length;i++)
			{
				var bagProp:Json_bag_property_setting = new Json_bag_property_setting();
				bagProp.loadFromJsonObject(obj[i]);
				//此处的id是策划配置的id
				this.setData(obj[i]['id'], bagProp);
//				_dataDict[parseInt(obj[i]['id'])] = bagProp;
			}
			
		}
		
		/**
		 * 获取容器配置
		 */
		public function getBagType(bagType : int) : Json_bag_property_setting
		{
			return this.getData(String(bagType));
		}
	}
}