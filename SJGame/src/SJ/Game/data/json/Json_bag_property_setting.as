/**
* gen by tools!
* time:Thu Oct 10 18:11:00 GMT+0800 2013
* from:道具容器属性配置.csv
* to:bag_property_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_bag_property_setting extends SDataBaseJson
	{
		public function Json_bag_property_setting()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _maxcount:* = null;
		public function get maxcount():*{return _maxcount;}
		public function set maxcount(value:*):void{_maxcount=value;}

		private var _initcount:* = null;
		public function get initcount():*{return _initcount;}
		public function set initcount(value:*):void{_initcount=value;}

		private var _rownum:* = null;
		public function get rownum():*{return _rownum;}
		public function set rownum(value:*):void{_rownum=value;}

		private var _colnum:* = null;
		public function get colnum():*{return _colnum;}
		public function set colnum(value:*):void{_colnum=value;}

		private var _rowdist:* = null;
		public function get rowdist():*{return _rowdist;}
		public function set rowdist(value:*):void{_rowdist=value;}

		private var _coldist:* = null;
		public function get coldist():*{return _coldist;}
		public function set coldist(value:*):void{_coldist=value;}

	}
}
