/**
* gen by tools!
* time:Thu Oct 10 18:10:58 GMT+0800 2013
* from:携带武将上限条件配置.csv
* to:hero_upper_limit_config.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_hero_upper_limit_config extends SDataBaseJson
	{
		public function Json_hero_upper_limit_config()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _describe:* = null;
		public function get describe():*{return _describe;}
		public function set describe(value:*):void{_describe=value;}

		private var _level:* = null;
		public function get level():*{return _level;}
		public function set level(value:*):void{_level=value;}

		private var _gold:* = null;
		public function get gold():*{return _gold;}
		public function set gold(value:*):void{_gold=value;}

	}
}
