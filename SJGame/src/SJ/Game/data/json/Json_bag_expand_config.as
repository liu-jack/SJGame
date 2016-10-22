/**
* gen by tools!
* time:Thu Oct 10 18:11:00 GMT+0800 2013
* from:道具容器扩充配置.csv
* to:bag_expand_config.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_bag_expand_config extends SDataBaseJson
	{
		public function Json_bag_expand_config()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _containertype:* = null;
		public function get containertype():*{return _containertype;}
		public function set containertype(value:*):void{_containertype=value;}

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
