/**
* gen by tools!
* time:Mon May 20 21:38:02 GMT+0800 2013
* from:功能点配置.csv
* to:function_point_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_function_point_setting extends SDataBaseJson
	{
		public function Json_function_point_setting()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _name:* = null;
		public function get name():*{return _name;}
		public function set name(value:*):void{_name=value;}

		private var _openlevel:* = null;
		public function get openlevel():*{return _openlevel;}
		public function set openlevel(value:*):void{_openlevel=value;}

	}
}
