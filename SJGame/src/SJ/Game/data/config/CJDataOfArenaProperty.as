package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_arena_box_setting;
	import SJ.Game.data.json.Json_fuben_config;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	public class CJDataOfArenaProperty
	{
		private var _dataDict:Array;
		public function CJDataOfArenaProperty()
		{
			_initData();
		}
		
		private static var _o:CJDataOfArenaProperty;
		public static function get o():CJDataOfArenaProperty
		{
			if(_o == null)
				_o = new CJDataOfArenaProperty();
			return _o;
		}
		
		private function _initData():void
		{
			_dataDict = new Array;
			var fubenConf:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonBoxSetting) as Array;
			for(var i:String in fubenConf)
			{
				var jsonObj:Json_arena_box_setting = new Json_arena_box_setting;
				jsonObj.loadFromJsonObject(fubenConf[i])
				_dataDict.push(jsonObj);
			}
		}
		
		/**
		 * 获得所有宝箱列表
		 */ 
		public function getAllTreasureList():Array
		{
			return _dataDict;
		}
		
		/**
		 * 根据ID获取配置数据 
		 * @param id
		 * @return 
		 * 
		 */
		public function getPropertyById(id:int):Json_arena_box_setting
		{
			var info:Json_arena_box_setting;
			for(var i:String in this._dataDict)
			{
				if(id ==int(this._dataDict[i].id))
				{
					info = this._dataDict[i];
				}
			}
			return info;
		}
		
		/**
		 * 根据排行ID，获取奖励配置
		 * @param id
		 * @param page
		 * @return 
		 * 
		 */
		public function getConfigByRankid(rankId:int):Json_arena_box_setting
		{
			var info:Json_arena_box_setting;
			for(var i:String in this._dataDict)
			{
				if(rankId >=int(this._dataDict[i].rankstart) && rankId<=int(this._dataDict[i].rankend))
				{
					info = this._dataDict[i];
				}
			}
			return info;
		}
	}
}