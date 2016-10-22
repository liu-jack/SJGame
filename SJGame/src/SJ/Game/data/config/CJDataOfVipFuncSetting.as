package SJ.Game.data.config
{
	import SJ.Game.data.json.Json_vip_function_setting;
	
	import engine_starling.utils.AssetManagerUtil;
	
	/**
	 * VIP功能数据
	 * @author longtao
	 * 
	 */	
	public class CJDataOfVipFuncSetting
	{
		//数据
		private var _obj:Object;
		
		public function CJDataOfVipFuncSetting()
		{
		}
		
		private static var _o:CJDataOfVipFuncSetting;
		public static function get o():CJDataOfVipFuncSetting
		{
			if(_o == null)
			{
				_o = new CJDataOfVipFuncSetting();
				_o._initData();
			}
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject("vip_function_setting.json") as Array;
			if (obj == null)
				return;
			_obj = new Object;
			var length:int = obj.length;
			for(var i:int=0; i < length; i++)
			{
				var js:Json_vip_function_setting = new Json_vip_function_setting();
				js.loadFromJsonObject(obj[i]);
				//此处的id是策划配置的id
				var viplevel:String = obj[i]['viplevel']
				_obj[viplevel] = js;
			}
		}
		
		/**
		 * 获取数据
		 */
		public function getData(viplevel : String):Json_vip_function_setting
		{
			return _obj[viplevel] as Json_vip_function_setting;
		}
		
		/**
		 * 返回某字段的所有数据
		 * @param field				"fb_vit"
		 * @param startVipLevel		起始vip等级
		 * @param endVipLevel		最后一个vip等级
		 * @return obj{viplevel:value}
		 * @note	传入startVipLevel=0 endVipLevel=12 则object中有13个 vip0~vip12
		 */
		public function getOneFieldData(field:String, startVipLevel:uint=0, endVipLevel:uint=0xFFFF):Object
		{
			var obj:Object = new Object;
			
			if (startVipLevel > endVipLevel)
				return obj;
			
			var maxVipLevelLimit:uint = uint(CJDataOfGlobalConfigProperty.o.getData("VIP_MAX_LEVEL"));
			endVipLevel = endVipLevel <= maxVipLevelLimit ? endVipLevel : maxVipLevelLimit;
			
			for (var i:uint=startVipLevel; i<=endVipLevel; ++i)
			{
				var jsVipFunc:Json_vip_function_setting = getData(String(i));
				if(!jsVipFunc.hasOwnProperty(field))
				{
					return null;
				}
				var value:String = jsVipFunc[field];
				if(!value)
					return obj;
				
				obj[i] = value;
			}
			
			return obj;
		}
	}
}