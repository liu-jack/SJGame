/**
* gen by tools!
* time:Thu Oct 10 18:10:58 GMT+0800 2013
* from:武将天赋.csv
* to:genius_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_genius_setting extends SDataBaseJson
	{
		public function Json_genius_setting()
		{
		}
		private var _geniusid:* = null;
		public function get geniusid():*{return _geniusid;}
		public function set geniusid(value:*):void{_geniusid=value;}

		private var _geniusname:* = null;
		public function get geniusname():*{return _geniusname;}
		public function set geniusname(value:*):void{_geniusname=value;}

		private var _genius_e0:* = null;
		public function get genius_e0():*{return _genius_e0;}
		public function set genius_e0(value:*):void{_genius_e0=value;}

		private var _genius_ev0:* = null;
		public function get genius_ev0():*{return _genius_ev0;}
		public function set genius_ev0(value:*):void{_genius_ev0=value;}

	}
}
