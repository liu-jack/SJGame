/**
* gen by tools!
* time:Thu Oct 10 18:10:56 GMT+0800 2013
* from:世界boss奖励配置.csv
* to:world_boss_award.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_world_boss_award extends SDataBaseJson
	{
		public function Json_world_boss_award()
		{
		}
		private var _rankstart:* = null;
		public function get rankstart():*{return _rankstart;}
		public function set rankstart(value:*):void{_rankstart=value;}

		private var _rankend:* = null;
		public function get rankend():*{return _rankend;}
		public function set rankend(value:*):void{_rankend=value;}

		private var _awardexp:* = null;
		public function get awardexp():*{return _awardexp;}
		public function set awardexp(value:*):void{_awardexp=value;}

		private var _awardgold:* = null;
		public function get awardgold():*{return _awardgold;}
		public function set awardgold(value:*):void{_awardgold=value;}

		private var _awardsilver:* = null;
		public function get awardsilver():*{return _awardsilver;}
		public function set awardsilver(value:*):void{_awardsilver=value;}

		private var _awarditem:* = null;
		public function get awarditem():*{return _awarditem;}
		public function set awarditem(value:*):void{_awarditem=value;}

	}
}
