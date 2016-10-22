package SJ.Game.data.config
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_fuben_guanka_config;
	
	import engine_starling.utils.AssetManagerUtil;
	
	public class CJDataOfGuankaProperty
	{
		private var _listDict:Dictionary;
		private var _cacheDict:Dictionary;
		public function CJDataOfGuankaProperty()
		{
			_initData();
		}
		private static var _o:CJDataOfGuankaProperty;
		public static function get o():CJDataOfGuankaProperty
		{
			if(_o == null)
				_o = new CJDataOfGuankaProperty();
			return _o;
		}
		
		private function _initData():void
		{
			_listDict = new Dictionary;
			_cacheDict = new Dictionary;
			var guankaConf:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonGuankaConfig) as Array;
			var jsonObj:Json_fuben_guanka_config = new Json_fuben_guanka_config;
			for(var i:String in guankaConf)
			{
				jsonObj.loadFromJsonObject(guankaConf[i])
				_listDict[guankaConf[i].id] = guankaConf[i];
			}
		}
		public function getGidByZid(zid:int):int
		{
			var gid:int = 0
			for(var i:String in _listDict)
			{
				var jsonObj:Object = _listDict[i];
				if(jsonObj.zid1 == zid || jsonObj.zid2 == zid || jsonObj.zid3 == zid )
				{
					gid = jsonObj.id;
					break;
				}
			}
			return gid;
		}
		
		public function getPropertyById(id:int):Json_fuben_guanka_config
		{
			if(_cacheDict.hasOwnProperty(id))
			{
				return _cacheDict[id];
			}
			var fubenGuankaConfig:Json_fuben_guanka_config = new Json_fuben_guanka_config;
			fubenGuankaConfig.loadFromJsonObject(_listDict[id]);
			fubenGuankaConfig.dropitems = fubenGuankaConfig.dropitems.split("&");
			if(fubenGuankaConfig.enterstory != undefined)
			{
				fubenGuankaConfig.enterstory = fubenGuankaConfig.enterstory.split("|");
			}
			_cacheDict[id] = fubenGuankaConfig;
			return fubenGuankaConfig;
		}

		public function getGuankaNpcs(id:int):Array
		{
			var list:Array = new Array
			var conf:Json_fuben_guanka_config = this.getPropertyById(id);
			if (conf.zid1)
			{
				var npc:Array = CJDataOfGuankaBattleProperty.o.getBattleNpc(int(conf.zid1))
				list = list.concat(npc);	
			}
			if (conf.zid2)
			{
				var npc2:Array = CJDataOfGuankaBattleProperty.o.getBattleNpc(int(conf.zid2))
				list = list.concat(npc2);
			}
			if (conf.zid3)
			{
				var npc3:Array = CJDataOfGuankaBattleProperty.o.getBattleNpc(int(conf.zid3))
				list = list.concat(npc3);	
			}
			var newList:Array = new Array
			for(var i:String in list)
			{
				if(int(list[i]) == 0)
				{
					continue;
				}
				newList.push(list[i])
			}
			return newList;
		}
		public function getBgimg(id:int):String
		{
			var info2:Json_fuben_guanka_config = this.getPropertyById(id);
			var name:String =  info2.bgimg.split(".")[0];
			var nameArr:Array = name.split("_");
			return "guankabg_"+nameArr[1];
		}
		/**
		 * 
		 * @param id 关卡ID
		 * @param index 第几波怪
		 * @return 
		 * 
		 */
		public function getnpcPos(id:int,index:int):Point
		{
			var info:Json_fuben_guanka_config = this.getPropertyById(id);
			var pos:Point = new Point
			var arr:Array;
			switch(index)
			{
				case 0:
					arr = info.zid1pos.split("_");
					break;
				case 1:
					arr = info.zid2pos.split("_");
					break;
				case 2:
					arr = info.zid3pos.split("_");
					break;

			}
			pos.x = arr[0];
			pos.y = arr[1];
			return pos;
		}
	}
}