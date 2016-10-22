package SJ.Game.data
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_achievement_setting;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	/**
	 * 夺宝
	 * @author changmiao
	 * 
	 */	
	public class CJDataOfAchievement extends SDataBase
	{
		private static var _o:CJDataOfAchievement;
		private var _achievementSetting:Object = new Object();
		public var achievementCount: int;
		
		public function CJDataOfAchievement()
		{
			super("CJDataOfAchievement");
			_initData();
		}
		
		public static function get o():CJDataOfAchievement
		{
			if(_o == null)
				_o = new CJDataOfAchievement();
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonAchievementSetting) as Array;
			var length:int = obj.length;
			var i:int;
			achievementCount = length;
			for(i = 0 ; i < length ; i++)
			{
				//var ajson:Json_achievement_setting = new Json_achievement_setting();
				//ajson.loadFromJsonObject(obj[i]);
				_achievementSetting[obj[i]["id"]] = obj[i];
			}		
		}
		
		public function getAchievementById(id: int):Json_achievement_setting
		{
			var ajson:Json_achievement_setting = new Json_achievement_setting();
			ajson.loadFromJsonObject(_achievementSetting["" + id]);
			return ajson;
		}
		
	
	}
}
