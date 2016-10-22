/**
* gen by tools!
* time:Thu Oct 10 18:11:00 GMT+0800 2013
* from:购买体力配置.csv
* to:buyvit_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_buyvit_setting extends SDataBaseJson
	{
		public function Json_buyvit_setting()
		{
		}
		private var _nums:* = null;
		public function get nums():*{return _nums;}
		public function set nums(value:*):void{_nums=value;}

		private var _cost:* = null;
		public function get cost():*{return _cost;}
		public function set cost(value:*):void{_cost=value;}

	}
}
