/**
* gen by tools!
* time:Thu Oct 10 18:11:01 GMT+0800 2013
* from:骑术表.csv
* to:rideskill.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_rideskill extends SDataBaseJson
	{
		public function Json_rideskill()
		{
		}
		private var _rideskilllevel:* = null;
		public function get rideskilllevel():*{return _rideskilllevel;}
		public function set rideskilllevel(value:*):void{_rideskilllevel=value;}

		private var _upgradeexp:* = null;
		public function get upgradeexp():*{return _upgradeexp;}
		public function set upgradeexp(value:*):void{_upgradeexp=value;}

		private var _goldbonus:* = null;
		public function get goldbonus():*{return _goldbonus;}
		public function set goldbonus(value:*):void{_goldbonus=value;}

		private var _woodbonus:* = null;
		public function get woodbonus():*{return _woodbonus;}
		public function set woodbonus(value:*):void{_woodbonus=value;}

		private var _waterbonus:* = null;
		public function get waterbonus():*{return _waterbonus;}
		public function set waterbonus(value:*):void{_waterbonus=value;}

		private var _firebonus:* = null;
		public function get firebonus():*{return _firebonus;}
		public function set firebonus(value:*):void{_firebonus=value;}

		private var _eartchbonus:* = null;
		public function get eartchbonus():*{return _eartchbonus;}
		public function set eartchbonus(value:*):void{_eartchbonus=value;}

	}
}
