/**
* gen by tools!
* time:Thu Oct 10 18:10:57 GMT+0800 2013
* from:客户端预加载资源列表.csv
* to:client_predownload.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_client_predownload extends SDataBaseJson
	{
		public function Json_client_predownload()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _res:* = null;
		public function get res():*{return _res;}
		public function set res(value:*):void{_res=value;}

		private var _level:* = null;
		public function get level():*{return _level;}
		public function set level(value:*):void{_level=value;}

	}
}
