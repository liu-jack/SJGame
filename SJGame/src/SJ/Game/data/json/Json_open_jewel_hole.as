/**
* gen by tools!
* time:Thu Oct 10 18:10:57 GMT+0800 2013
* from:宝石镶嵌孔扩充配置.csv
* to:open_jewel_hole.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_open_jewel_hole extends SDataBaseJson
	{
		public function Json_open_jewel_hole()
		{
		}
		private var _number:* = null;
		public function get number():*{return _number;}
		public function set number(value:*):void{_number=value;}

		private var _costtype:* = null;
		public function get costtype():*{return _costtype;}
		public function set costtype(value:*):void{_costtype=value;}

		private var _costprice:* = null;
		public function get costprice():*{return _costprice;}
		public function set costprice(value:*):void{_costprice=value;}

	}
}
