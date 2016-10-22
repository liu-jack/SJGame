/**
* gen by tools!
* time:Thu Oct 10 18:10:56 GMT+0800 2013
* from:pk战斗QTE显示.csv
* to:pk_qte_location.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_pk_qte_location extends SDataBaseJson
	{
		public function Json_pk_qte_location()
		{
		}
		private var _posid:* = null;
		public function get posid():*{return _posid;}
		public function set posid(value:*):void{_posid=value;}

		private var _postiontype:* = null;
		public function get postiontype():*{return _postiontype;}
		public function set postiontype(value:*):void{_postiontype=value;}

		private var _postionx:* = null;
		public function get postionx():*{return _postionx;}
		public function set postionx(value:*):void{_postionx=value;}

		private var _postiony:* = null;
		public function get postiony():*{return _postiony;}
		public function set postiony(value:*):void{_postiony=value;}

	}
}
