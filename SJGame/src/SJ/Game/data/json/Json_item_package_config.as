/**
* gen by tools!
* time:Thu Oct 10 18:11:00 GMT+0800 2013
* from:道具礼包配置.csv
* to:item_package_config.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_item_package_config extends SDataBaseJson
	{
		public function Json_item_package_config()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _packageitemid:* = null;
		public function get packageitemid():*{return _packageitemid;}
		public function set packageitemid(value:*):void{_packageitemid=value;}

		private var _itemid:* = null;
		public function get itemid():*{return _itemid;}
		public function set itemid(value:*):void{_itemid=value;}

		private var _itemcount:* = null;
		public function get itemcount():*{return _itemcount;}
		public function set itemcount(value:*):void{_itemcount=value;}

	}
}
