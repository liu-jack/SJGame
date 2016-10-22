package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_hero_dict_config;
	
	import engine_starling.utils.AssetManagerUtil;

	/**
	 * 武将宝典
	 * @author longtao
	 * 
	 */
	public class CJDataOfHeroDictConfig
	{
		private static var _o:CJDataOfHeroDictConfig;
		
		public static function get o():CJDataOfHeroDictConfig
		{
			if(_o == null)
				_o = new CJDataOfHeroDictConfig();
			return _o;
		}
		
		/// {id:herotid}
		private var _data:Array;
		
		public function CJDataOfHeroDictConfig()
		{
			_initData();
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJSHeroDict) as Array;
			if(obj == null)
			{
				return;
			}
			_data = new Array;
			var length:int = obj.length;
			for(var i:int=0 ; i < length ; i++)
			{
				var data:Json_hero_dict_config = new Json_hero_dict_config();
				data.loadFromJsonObject(obj[i]);
				//此处的id是策划配置的id
				_data.push(String(data.herotid));
			}
		}
		
		/** 获取数据 **/
		public function getData():Array
		{
			return _data;
		}
		
	}
}