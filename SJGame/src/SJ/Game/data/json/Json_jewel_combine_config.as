/**
* gen by tools!
* time:Thu Oct 10 18:10:57 GMT+0800 2013
* from:宝石合成配置.csv
* to:jewel_combine_config.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_jewel_combine_config extends SDataBaseJson
	{
		public function Json_jewel_combine_config()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _srcjewelid:* = null;
		public function get srcjewelid():*{return _srcjewelid;}
		public function set srcjewelid(value:*):void{_srcjewelid=value;}

		private var _desjewelid:* = null;
		public function get desjewelid():*{return _desjewelid;}
		public function set desjewelid(value:*):void{_desjewelid=value;}

		private var _needjewelnum:* = null;
		public function get needjewelnum():*{return _needjewelnum;}
		public function set needjewelnum(value:*):void{_needjewelnum=value;}

	}
}
