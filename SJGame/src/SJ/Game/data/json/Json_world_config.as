/**
* gen by tools!
* time:Thu Oct 10 18:10:56 GMT+0800 2013
* from:世界地图.csv
* to:world_config.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_world_config extends SDataBaseJson
	{
		public function Json_world_config()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _itemid:* = null;
		public function get itemid():*{return _itemid;}
		public function set itemid(value:*):void{_itemid=value;}

		private var _type:* = null;
		public function get type():*{return _type;}
		public function set type(value:*):void{_type=value;}

		private var _name:* = null;
		public function get name():*{return _name;}
		public function set name(value:*):void{_name=value;}

		private var _icon:* = null;
		public function get icon():*{return _icon;}
		public function set icon(value:*):void{_icon=value;}

		private var _posx:* = null;
		public function get posx():*{return _posx;}
		public function set posx(value:*):void{_posx=value;}

		private var _posy:* = null;
		public function get posy():*{return _posy;}
		public function set posy(value:*):void{_posy=value;}

	}
}
