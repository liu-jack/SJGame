package SJ.Game.data.config
{
	import SJ.Game.data.json.Json_vip_exp_setting;
	
	import engine_starling.utils.AssetManagerUtil;

	/**
	 * VIP经验设置
	 * @author longtao
	 * 
	 */
	public class CJDataOfVipExpSetting
	{
		//数据
		private var _obj:Object;
		
		public function CJDataOfVipExpSetting()
		{
		}
		
		private static var _o:CJDataOfVipExpSetting;
		public static function get o():CJDataOfVipExpSetting
		{
			if(_o == null)
			{
				_o = new CJDataOfVipExpSetting();
				_o._initData();
			}
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject("vip_exp_setting.json") as Array;
			if (obj == null)
				return;
			_obj = new Object;
			var length:int = obj.length;
			for(var i:int=0; i < length; i++)
			{
				var js:Json_vip_exp_setting = new Json_vip_exp_setting();
				js.loadFromJsonObject(obj[i]);
				//此处的id是策划配置的id
				var viplevel:String = obj[i]['viplevel']
				_obj[viplevel] = js;
			}
		}
		
		/**
		 * 获取数据
		 * 返回vip升级经验
		 */
		public function getData(viplevel : String):Json_vip_exp_setting
		{
			return _obj[viplevel] as Json_vip_exp_setting
		}

	}
}