package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_hero_upper_limit_config;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import lib.engine.utils.CObjectUtils;
	
	/**
	 * 武将标签限制配置表
	 * @author longtao
	 */
	public class CJDataOfHeroTagProperty
	{
		private static var _o:CJDataOfHeroTagProperty;
		public static function get o():CJDataOfHeroTagProperty
		{
			if(_o == null)
				_o = new CJDataOfHeroTagProperty();
			return _o;
		}
		
		private var _dataArr:Array;
		
		public function CJDataOfHeroTagProperty()
		{
			_initData();
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonHeroUpperLimit) as Array;
			if(obj == null)
			{
				return;
			}
			_dataArr = new Array();
			var length:int = obj.length;
			for(var i:int=0 ; i < length ; i++)
			{
				var data:Json_hero_upper_limit_config = new Json_hero_upper_limit_config();
				data.loadFromJsonObject(obj[i]);
				//此处的id是策划配置的id
				_dataArr[parseInt(obj[i]['id'])] = data;
			}
		}
		
		/**
		 * 获取武将标签限制字典
		 * @return 
		 * @note 索引从0开始
		 */
		public function get heroTagArr():Array
		{
			return CObjectUtils.clone(_dataArr);
		}
		
		/**
		 * 获取相应武将标签限制实例
		 * @param id
		 * @return 
		 * @索引从0开始,配置表也要从0开始配置
		 */
		public function getHeroUpperJS(id:int):Json_hero_upper_limit_config
		{
			return CObjectUtils.clone(_dataArr[id]);
		}
	}
}