/**
* gen by tools!
* time:Thu Oct 10 18:11:00 GMT+0800 2013
* from:酒馆刷新钱数配置.csv
* to:wine_refresh_propertys.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_wine_refresh_propertys extends SDataBaseJson
	{
		public function Json_wine_refresh_propertys()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _silver:* = null;
		public function get silver():*{return _silver;}
		public function set silver(value:*):void{_silver=value;}

		private var _gold:* = null;
		public function get gold():*{return _gold;}
		public function set gold(value:*):void{_gold=value;}

	}
}
