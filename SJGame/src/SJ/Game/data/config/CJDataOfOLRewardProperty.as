package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_online_reward_setting;
	
	import engine_starling.utils.AssetManagerUtil;

	/**
	 * 被动技能配置数据
	 * @author longtao
	 * 
	 */	
	public class CJDataOfOLRewardProperty
	{
		//数据
		private var _obj:Object;
		
		public function CJDataOfOLRewardProperty()
		{
		}
		
		private static var _o:CJDataOfOLRewardProperty;
		public static function get o():CJDataOfOLRewardProperty
		{
			if(_o == null)
			{
				_o = new CJDataOfOLRewardProperty();
				_o._initData();
			}
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonOLReward) as Array;
			if (obj == null)
				return;
			_obj = new Object;
			var length:int = obj.length;
			for(var i:int=0; i < length; i++)
			{
				var js:Json_online_reward_setting = new Json_online_reward_setting();
				js.loadFromJsonObject(obj[i]);
				//此处的id是策划配置的id
				_obj[ obj[i]['id'] ] = js;
			}
		}
		
		/**
		 * 获取数据
		 */
		public function getData(id : String):Json_online_reward_setting
		{
			return _obj[id] as Json_online_reward_setting
		}
	}
}