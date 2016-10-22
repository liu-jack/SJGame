package SJ.Game.data.config
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_guanka_battle_config;
	
	import engine_starling.utils.AssetManagerUtil;
	
	public class CJDataOfGuankaBattleProperty
	{
		private var _confDict:Dictionary;
		private var _cacheDict:Dictionary;
		public function CJDataOfGuankaBattleProperty()
		{
			_initData();
		}
		private static var _o:CJDataOfGuankaBattleProperty;
		public static function get o():CJDataOfGuankaBattleProperty
		{
			if(_o == null)
				_o = new CJDataOfGuankaBattleProperty();
			return _o;
		}
		private function _initData():void
		{
			_confDict = new Dictionary;
			_cacheDict = new Dictionary;
			var guankaBattleConf:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonGuankaBattleConfig) as Array;
			var jsonObj:Json_guanka_battle_config = new Json_guanka_battle_config;
			for(var i:String in guankaBattleConf)
			{
				jsonObj.loadFromJsonObject(guankaBattleConf[i])
				_confDict[guankaBattleConf[i].id] = guankaBattleConf[i];
			}
		}
		public function getPropertyById(id:int):Json_guanka_battle_config
		{
			if(_cacheDict.hasOwnProperty(id))
			{
				return _cacheDict[id];
			}
			var guankaBattleConfig:Json_guanka_battle_config = new Json_guanka_battle_config;
			guankaBattleConfig.loadFromJsonObject(_confDict[id]);
			if(guankaBattleConfig.startstory)
			{
				guankaBattleConfig.startstory = guankaBattleConfig.startstory.split("|");
			}
			if(guankaBattleConfig.endstory)
			{
				guankaBattleConfig.endstory = guankaBattleConfig.endstory.split("|");
			}
			_cacheDict[id] = guankaBattleConfig;
			return guankaBattleConfig;
		}
		/**
		 * 获取副本战斗中的NPC
		 * @return 
		 * 
		 */	
		private var _battleNpc:Dictionary = new Dictionary;
		public function getAllBattleNpc():Dictionary
		{
			var isEmpty:Boolean = false;
			for each(npcid in _battleNpc)
			{
				isEmpty = true;
				break;
			}
			if(isEmpty)
			{
				return _battleNpc
			}
			for(var i:String in this._confDict)
			{
				var npcid:int = getNpcid(this._confDict[i].pos0);
				_battleNpc[npcid] = this._confDict[i].id;
				var npcid1:int = getNpcid(this._confDict[i].pos1);
				_battleNpc[npcid1] = this._confDict[i].id;
				var npcid2:int = getNpcid(this._confDict[i].pos2);
				_battleNpc[npcid2] = this._confDict[i].id;
				var npcid3:int = getNpcid(this._confDict[i].pos3);
				_battleNpc[npcid3] = this._confDict[i].id;
				var npcid4:int = getNpcid(this._confDict[i].pos4);
				_battleNpc[npcid4] = this._confDict[i].id;
				var npcid5:int = getNpcid(this._confDict[i].pos5);
				_battleNpc[npcid5] = this._confDict[i].id;
			}
			return _battleNpc;
		}
		
		private function getNpcid(npcstr:String):int
		{
			if(npcstr == null) return 0;
			return npcstr.split("&")[0]
		}

		public function getBattleNpc(id:int):Array
		{
			var info:Json_guanka_battle_config = this.getPropertyById(id);
			return [getNpcid(info.pos0),getNpcid(info.pos1),getNpcid(info.pos2),getNpcid(info.pos3),getNpcid(info.pos4),getNpcid(info.pos5)]
		}
	}
}