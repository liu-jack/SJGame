package SJ.Game.data
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_treasure_addnumcost_setting;
	import SJ.Game.data.json.Json_treasure_effect_setting;
	import SJ.Game.data.json.Json_treasure_findlevel_setting;
	import SJ.Game.data.json.Json_treasure_part_setting;
	import SJ.Game.data.json.Json_treasure_setting;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	/**
	 * 夺宝
	 * @author changmiao
	 * 
	 */	
	public class CJDataOfDuoBao extends SDataBase
	{
		private static var _o:CJDataOfDuoBao;
		private var _treasureSettingCount:int;
		private var _treasureSetting:Object = new Object();
		private var _treasurePartSettingCount:int;
		private var _treasurePartSetting:Object = new Object();
		private var _treasureEffectSetting:Object = new Object();
		private var _treasureFindLevelSetting:Object = new Object();
		
		private var _treasureAddNumCostSetting:Object = new Object();
		
		public function CJDataOfDuoBao()
		{
			super("CJDataOfDuoBao");
			_initData();
		}
		
		public static function get o():CJDataOfDuoBao
		{
			if(_o == null)
				_o = new CJDataOfDuoBao();
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonTreasureSetting) as Array;
			var length:int = obj.length;
			_treasureSettingCount = length;
			var i:int;
			for(i = 0 ; i < length ; i++)
			{
				//var tjson:Json_treasure_setting = new Json_treasure_setting();
				//tjson.loadFromJsonObject(obj[i]);
				_treasureSetting[obj[i]["id"]] = obj[i];
			}
			
			obj = AssetManagerUtil.o.getObject(ConstResource.sResJsonTreasurePartSetting) as Array;
			length = obj.length;
			_treasurePartSettingCount = length;
			for(i = 0 ; i < length ; i++)
			{
				//var pjson:Json_treasure_part_setting = new Json_treasure_part_setting();
				//pjson.loadFromJsonObject(obj[i]);
				_treasurePartSetting[obj[i]["id"]] = obj[i];
			}
			
			obj = AssetManagerUtil.o.getObject(ConstResource.sResJsonTreasureEffectSetting) as Array;
			length = obj.length;
			for(i = 0 ; i < length ; i++)
			{
				//var ejson:Json_treasure_effect_setting = new Json_treasure_effect_setting();
				//ejson.loadFromJsonObject(obj[i]);
				_treasureEffectSetting[obj[i]["key"]] = obj[i];
			}
			
			obj = AssetManagerUtil.o.getObject(ConstResource.sResJsonTreasureFindLevelSetting) as Array;
			length = obj.length;
			for(i = 0 ; i < length ; i++)
			{
				//var fjson:Json_treasure_findlevel_setting = new Json_treasure_findlevel_setting();
				//fjson.loadFromJsonObject(obj[i]);
				_treasureFindLevelSetting[obj[i]["level"]] = obj[i];
			}		
			
			obj = AssetManagerUtil.o.getObject(ConstResource.sResJsonTreasureAddNumCost) as Array;
			length = obj.length;
			for(i = 0 ; i < length ; i++)
			{
				
				//var ajson:Json_treasure_addnumcost_setting = new Json_treasure_addnumcost_setting();
				//ajson.loadFromJsonObject(obj[i]);
				_treasureAddNumCostSetting[obj[i]["buyindex"]] = obj[i];
			}				
		}
		
		public function getTreasureCount():int
		{
			return _treasureSettingCount;
		}
		
		public function getTreasure(id:int):Json_treasure_setting
		{
			var tjson:Json_treasure_setting = new Json_treasure_setting();
			tjson.loadFromJsonObject(_treasureSetting["" + id]);
			return tjson;
			
		}
		
		/**
		 * 没有匹配数据，返回空字符串
		 * @param _openid 每个宝物的开启等级
		 * @return 
		 * 
		 */		
		public function getTreasureByOpenLV(_openid:int):String
		{
			var _tip:String="";
			var tjson:Json_treasure_setting = new Json_treasure_setting();
			for(var k:* in _treasureSetting)
			{			
				tjson.loadFromJsonObject(_treasureSetting[k]);
				if(tjson.openlevel == _openid)
				{
					var contant:String = CJLang("XUNBAO_BAOWU_OPENTIP");
					_tip = contant.replace("{value}", CJLang(tjson.treasurename));
					break;
				}
			}
			return _tip;
		}
		
		/**
		 * 跟怒宝物碎片id 获得碎片
		 * @param id
		 * @return 
		 */		
		public function getTreasurePartByID(id:int):Json_treasure_part_setting
		{
			var pjson:Json_treasure_part_setting = new Json_treasure_part_setting();
			pjson.loadFromJsonObject(_treasurePartSetting["" + id]);
			return pjson;
		}
		
		public function getTreasurePartsByTreasureID(id:int):Array
		{
			var arr:Array = new Array();
			for(var i:int = 1; i<=_treasurePartSettingCount; i++)
			{		
				var js:Json_treasure_part_setting = new Json_treasure_part_setting();
				js.loadFromJsonObject(_treasurePartSetting["" + i]);
				if(int(js.treasuregroup) == id)
				{
					arr.push(js);
				}
			}
			return arr;
		}
		
		public function getTreasureFindExpByLevel(level:int):int
		{
			var fjson:Json_treasure_findlevel_setting = new Json_treasure_findlevel_setting();
			fjson.loadFromJsonObject(_treasureFindLevelSetting["" + level]);
			return parseInt(fjson.exp);
		}
		
		/**
		 * 根据碎片等级获得寻宝时可获得的碎片数量
		 * @param level
		 * @return 
		 */		
		public function getEleNumByLevel(level:int):int
		{
			var fjson:Json_treasure_findlevel_setting = new Json_treasure_findlevel_setting();
			fjson.loadFromJsonObject(_treasureFindLevelSetting["" + level]);
			return parseInt(fjson.num);
		}
		
		/**
		 * 根据格子索引获得开启该格子所需最低等级
		 * @param index 1-5 
		 * @return 
		 */		
		public function getLevelByGridIndex(index:int):int
		{
			var targetLv:int=999;
			var fjson:Json_treasure_findlevel_setting = new Json_treasure_findlevel_setting();
			for(var k:* in _treasureFindLevelSetting)
			{
				fjson.loadFromJsonObject(_treasureFindLevelSetting[k]);
				if((fjson.num) == index)
				{
					if(int(k) < targetLv)targetLv = int(k);
				}
			}
			return targetLv;       
		}
		
		public function getTreasureEffectByID(key:String):Json_treasure_effect_setting
		{
			var ejson:Json_treasure_effect_setting = new Json_treasure_effect_setting();
			ejson.loadFromJsonObject(_treasureEffectSetting[key]);
			return ejson;
		}
		
		public function getTreasureFindCostByCount(count: int):int
		{
			//容错，如果超出上限，取值最后(贵)一个
			if(_treasureAddNumCostSetting[count] == null)
			{
				var t:int = 0;
				for(var k:* in _treasureAddNumCostSetting)
				{
					if(t<int(k))t=int(k);
				}
				return int(_treasureAddNumCostSetting[t].findcost);
			}
			else
			{
				return int(_treasureAddNumCostSetting[count].findcost);
			}
		}
		
		public function getTreasureLootCostByCount(count: int):int
		{
			var ajson:Json_treasure_addnumcost_setting = new Json_treasure_addnumcost_setting();
			ajson.loadFromJsonObject(_treasureAddNumCostSetting[count]);
			return int(ajson.lootcost);
		}
		
		public function getTreasureDescByID(id:int, level:int):String
		{
			var str:String = "";
			var jsonEffect: Json_treasure_effect_setting;	
			if(level == 0)
			{
				jsonEffect = getTreasureEffectByID(id + "_" + 1);
				if(jsonEffect.hpadd > 0)
				{
					str += CJLang("DUOBAO_ATTR_TIP_1") + "+0"; 
				}
				if(jsonEffect.pattackadd > 0)
				{
					if(str != "")
						str += ","
					str += CJLang("DUOBAO_ATTR_TIP_2") + "+0"; 
				}
				if(jsonEffect.pdefadd > 0)
				{
					if(str != "")
						str += ","
					str += CJLang("DUOBAO_ATTR_TIP_3") + "+0"; 
				}
				if(jsonEffect.mattack > 0)
				{
					if(str != "")
						str += ","
					str += CJLang("DUOBAO_ATTR_TIP_4") + "+0"; 
				}
				if(jsonEffect.mdefadd > 0)
				{
					if(str != "")
						str += ","
					str += CJLang("DUOBAO_ATTR_TIP_5") + "+0"; 
				}
				if(jsonEffect.speed > 0)
				{
					if(str != "")
						str += ","
					str += CJLang("DUOBAO_ATTR_TIP_6") + "+0"; 
				}
				return str;
			}
			if((level > 0) && (level <= getTreasure(id).maxlevel))
			{
				jsonEffect = getTreasureEffectByID(id + "_" + level);
				if(jsonEffect.hpadd > 0)
				{
					str += CJLang("DUOBAO_ATTR_TIP_1") + "+" + jsonEffect.hpadd; 
				}
				if(jsonEffect.pattackadd > 0)
				{
					if(str != "")
						str += ","
					str += CJLang("DUOBAO_ATTR_TIP_2") + "+" + jsonEffect.pattackadd; 
				}
				if(jsonEffect.pdefadd > 0)
				{
					if(str != "")
						str += ","
					str += CJLang("DUOBAO_ATTR_TIP_3") + "+" + jsonEffect.pdefadd; 
				}
				if(jsonEffect.mattack > 0)
				{
					if(str != "")
						str += ","
					str += CJLang("DUOBAO_ATTR_TIP_4") + "+" + jsonEffect.mattack; 
				}
				if(jsonEffect.mdefadd > 0)
				{
					if(str != "")
						str += ","
					str += CJLang("DUOBAO_ATTR_TIP_5") + jsonEffect.mdefadd; 
				}
				if(jsonEffect.speed > 0)
				{
					if(str != "")
						str += ","
					str += CJLang("DUOBAO_ATTR_TIP_6") + "+" + jsonEffect.speed; 
				}
			}	
			return str;
		}
		
		public function getTreasureSingleDescByID(id:int, level:int):String
		{
			var str:String = "";
			var jsonEffect: Json_treasure_effect_setting;
			if(level == 0)
			{
				jsonEffect = getTreasureEffectByID(id + "_" + 1);
				if(jsonEffect.hpadd > 0)
				{
					str += CJLang("DUOBAO_ATTR_TIP_7") + "+0\n";
				}
				if(jsonEffect.pattackadd > 0)
				{
					str += CJLang("DUOBAO_ATTR_TIP_8") + "+0\n";
				}
				if(jsonEffect.pdefadd > 0)
				{
					str += CJLang("DUOBAO_ATTR_TIP_9") + "+0\n"; 
				}
				if(jsonEffect.mattack > 0)
				{
					str += CJLang("DUOBAO_ATTR_TIP_10") + "+0\n"; 
				}
				if(jsonEffect.mdefadd > 0)
				{
					str += CJLang("DUOBAO_ATTR_TIP_11") + "+0\n"; 
				}
				if(jsonEffect.speed > 0)
				{
					str += CJLang("DUOBAO_ATTR_TIP_12") + "+0\n"; 
				}
				return str;
			}
			else
			{
				jsonEffect = getTreasureEffectByID(id + "_" + level);
				if(jsonEffect.hpadd > 0)
				{
					str += CJLang("DUOBAO_ATTR_TIP_7") + "+" + jsonEffect.hpadd + "\n"; 
				}
				if(jsonEffect.pattackadd > 0)
				{
					str += CJLang("DUOBAO_ATTR_TIP_8") + "+" + jsonEffect.pattackadd + "\n"; 
				}
				if(jsonEffect.pdefadd > 0)
				{
					str += CJLang("DUOBAO_ATTR_TIP_9") + "+" + jsonEffect.pdefadd + "\n"; 
				}
				if(jsonEffect.mattack > 0)
				{
					str +=CJLang("DUOBAO_ATTR_TIP_10") + "+" + jsonEffect.mattack + "\n"; 
				}
				if(jsonEffect.mdefadd > 0)
				{
					str += CJLang("DUOBAO_ATTR_TIP_11") + "+" + jsonEffect.mdefadd + "\n"; 
				}
				if(jsonEffect.speed > 0)
				{
					str += CJLang("DUOBAO_ATTR_TIP_12") + "+" + jsonEffect.speed + "\n"; 
				}
				return str;
			}
		}
		
	}
}