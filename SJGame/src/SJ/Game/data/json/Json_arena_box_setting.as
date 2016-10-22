/**
* gen by tools!
* time:Thu Oct 10 18:10:59 GMT+0800 2013
* from:竞技场宝箱配置.csv
* to:arena_box_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_arena_box_setting extends SDataBaseJson
	{
		public function Json_arena_box_setting()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _name:* = null;
		public function get name():*{return _name;}
		public function set name(value:*):void{_name=value;}

		private var _rankstart:* = null;
		public function get rankstart():*{return _rankstart;}
		public function set rankstart(value:*):void{_rankstart=value;}

		private var _rankend:* = null;
		public function get rankend():*{return _rankend;}
		public function set rankend(value:*):void{_rankend=value;}

		private var _silvermin:* = null;
		public function get silvermin():*{return _silvermin;}
		public function set silvermin(value:*):void{_silvermin=value;}

		private var _silvermax:* = null;
		public function get silvermax():*{return _silvermax;}
		public function set silvermax(value:*):void{_silvermax=value;}

		private var _creditmin:* = null;
		public function get creditmin():*{return _creditmin;}
		public function set creditmin(value:*):void{_creditmin=value;}

		private var _creditmax:* = null;
		public function get creditmax():*{return _creditmax;}
		public function set creditmax(value:*):void{_creditmax=value;}

		private var _awardparams:* = null;
		public function get awardparams():*{return _awardparams;}
		public function set awardparams(value:*):void{_awardparams=value;}

		private var _fontcolor:* = null;
		public function get fontcolor():*{return _fontcolor;}
		public function set fontcolor(value:*):void{_fontcolor=value;}

	}
}
