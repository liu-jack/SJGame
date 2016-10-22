package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_awardbox_config;
	import SJ.Game.data.json.Json_fuben_config;
	import SJ.Game.data.json.Json_fuben_guanka_config;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.geom.Point;
	
	public class CJDataOfAwardBoxProperty
	{
		private var _dataDict:Array;
		public function CJDataOfAwardBoxProperty()
		{
			_initData();
		}
		private static var _o:CJDataOfAwardBoxProperty;
		public static function get o():CJDataOfAwardBoxProperty
		{
			if(_o == null)
				_o = new CJDataOfAwardBoxProperty();
			return _o;
		}
		
		private function _initData():void
		{
			_dataDict = new Array;
			var guankaConf:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonAwardBox) as Array;
			for(var i:String in guankaConf)
			{
				var jsonObj:Json_awardbox_config = new Json_awardbox_config;
				jsonObj.loadFromJsonObject(guankaConf[i])
				_dataDict.push(jsonObj);
			}
		}
		
		public function getPropertyById(id:int):Json_awardbox_config
		{
			var info:Json_awardbox_config;
			for(var i:String in this._dataDict)
			{
				if(id ==int(this._dataDict[i].id))
				{
					info = this._dataDict[i];
				}
			}
			return info;
		}
		
		public function getFiveAward(id:int):Array
		{
			var ids:Array = new Array
			var jsonAward:Json_awardbox_config = this.getPropertyById(id);
			if(!jsonAward)return ids;
			for(var i:int=1;i<6;i++)
			{
				var key:String = "itemtemplateid"+String(i);
				if(jsonAward.hasOwnProperty(key) && jsonAward[key] )
				{
					ids.push(jsonAward[key]);
				}
			}
			return ids;
		}
	}
}