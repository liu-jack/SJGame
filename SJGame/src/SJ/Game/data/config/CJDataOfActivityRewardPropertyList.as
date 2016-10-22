package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_activity_reward_setting;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;

	/**
	 +------------------------------------------------------------------------------
	 * 活跃度静态配置表
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-25 上午10:03:40  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfActivityRewardPropertyList extends SDataBase
	{
		private static var _o:CJDataOfActivityRewardPropertyList;
		
		public function CJDataOfActivityRewardPropertyList()
		{
			super("CJDataOfActivityRewardPropertyList");
			_initData();
		}
		
		public static function get o():CJDataOfActivityRewardPropertyList
		{
			if(_o == null)
				_o = new CJDataOfActivityRewardPropertyList();
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonActivityReward) as Array;
			var length:int = obj.length;
			for(var i:int = 0 ; i < length ; i++)
			{
				var config:Json_activity_reward_setting = new Json_activity_reward_setting();
				config.loadFromJsonObject(obj[i]);
				this.setData(config.id , config);
			}
		}
		
		/**
		 * 获取所有的配置列表
		 */		
		public function getAllTempateList():Dictionary
		{
			return this._dataContains;
		}
		
		/**
		 * 获取单个奖励的配置 
		 */		
		public function getConfigById(id:int):Json_activity_reward_setting
		{
			return this.getData(String(id));
		}
	}
}