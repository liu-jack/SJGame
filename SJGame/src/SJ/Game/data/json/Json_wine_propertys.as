/**
* gen by tools!
* time:Thu Oct 10 18:11:00 GMT+0800 2013
* from:酒馆配置.csv
* to:wine_propertys.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_wine_propertys extends SDataBaseJson
	{
		public function Json_wine_propertys()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _describe:* = null;
		public function get describe():*{return _describe;}
		public function set describe(value:*):void{_describe=value;}

		private var _limitlevel:* = null;
		public function get limitlevel():*{return _limitlevel;}
		public function set limitlevel(value:*):void{_limitlevel=value;}

	}
}
