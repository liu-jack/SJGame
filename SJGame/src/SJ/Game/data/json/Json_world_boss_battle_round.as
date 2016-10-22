/**
* gen by tools!
* time:Thu Oct 10 18:10:56 GMT+0800 2013
* from:世界boss怪物波次配置.csv
* to:world_boss_battle_round.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_world_boss_battle_round extends SDataBaseJson
	{
		public function Json_world_boss_battle_round()
		{
		}
		private var _roundid:* = null;
		public function get roundid():*{return _roundid;}
		public function set roundid(value:*):void{_roundid=value;}

		private var _monsterinfoid:* = null;
		public function get monsterinfoid():*{return _monsterinfoid;}
		public function set monsterinfoid(value:*):void{_monsterinfoid=value;}

		private var _monstermovetime:* = null;
		public function get monstermovetime():*{return _monstermovetime;}
		public function set monstermovetime(value:*):void{_monstermovetime=value;}

		private var _roundflushtime:* = null;
		public function get roundflushtime():*{return _roundflushtime;}
		public function set roundflushtime(value:*):void{_roundflushtime=value;}

		private var _dieawardexp:* = null;
		public function get dieawardexp():*{return _dieawardexp;}
		public function set dieawardexp(value:*):void{_dieawardexp=value;}

		private var _dieawardgold:* = null;
		public function get dieawardgold():*{return _dieawardgold;}
		public function set dieawardgold(value:*):void{_dieawardgold=value;}

		private var _dieawardsilver:* = null;
		public function get dieawardsilver():*{return _dieawardsilver;}
		public function set dieawardsilver(value:*):void{_dieawardsilver=value;}

		private var _dieawarditem:* = null;
		public function get dieawarditem():*{return _dieawarditem;}
		public function set dieawarditem(value:*):void{_dieawarditem=value;}

		private var _killawardexp:* = null;
		public function get killawardexp():*{return _killawardexp;}
		public function set killawardexp(value:*):void{_killawardexp=value;}

		private var _killawardgold:* = null;
		public function get killawardgold():*{return _killawardgold;}
		public function set killawardgold(value:*):void{_killawardgold=value;}

		private var _killawardsilver:* = null;
		public function get killawardsilver():*{return _killawardsilver;}
		public function set killawardsilver(value:*):void{_killawardsilver=value;}

		private var _killawarditem:* = null;
		public function get killawarditem():*{return _killawarditem;}
		public function set killawarditem(value:*):void{_killawarditem=value;}

	}
}
