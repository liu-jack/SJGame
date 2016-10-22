/**
* gen by tools!
* time:Thu Oct 10 18:10:56 GMT+0800 2013
* from:全局配置.csv
* to:global_config.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_global_config extends SDataBaseJson
	{
		public function Json_global_config()
		{
		}
		private var _key:* = null;
		public function get key():*{return _key;}
		public function set key(value:*):void{_key=value;}

		private var _value:* = null;
		public function get value():*{return _value;}
		public function set value(value:*):void{_value=value;}

	}
}
