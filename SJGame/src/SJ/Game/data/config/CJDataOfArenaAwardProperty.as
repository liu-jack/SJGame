package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_arena_award_setting;
	import SJ.Game.data.json.Json_fuben_config;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	public class CJDataOfArenaAwardProperty
	{
		private var _dataDict:Dictionary;
		private var _maxrankid:int = 1;
		public function CJDataOfArenaAwardProperty()
		{
			_initData();
		}
		
		private static var _o:CJDataOfArenaAwardProperty;
		public static function get o():CJDataOfArenaAwardProperty
		{
			if(_o == null)
				_o = new CJDataOfArenaAwardProperty();
			return _o;
		}
		
		private function _initData():void
		{
			_dataDict = new Dictionary;
			var fubenConf:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonArenaAwardSetting) as Array;
			for(var i:String in fubenConf)
			{
				var jsonObj:Json_arena_award_setting = new Json_arena_award_setting;
				jsonObj.loadFromJsonObject(fubenConf[i])
				_dataDict[jsonObj.id] = jsonObj;
				if(jsonObj.id>_maxrankid)
				{
					_maxrankid = jsonObj.id;
				}
			}
		}
		/**
		 * 根据ID获取配置数据 
		 * @param id
		 * @return 
		 * 
		 */
		public function getPropertyById(id:int):Json_arena_award_setting
		{
			var info:Json_arena_award_setting;
			if(_dataDict.hasOwnProperty(id))
			{
				info = this._dataDict[id];
			}
			if(id > _maxrankid)
			{
				info =  this._dataDict[_maxrankid];
			}
			return info;
		}
	}
}