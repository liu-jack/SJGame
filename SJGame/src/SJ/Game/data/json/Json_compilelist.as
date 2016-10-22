/**
* gen by tools!
* time:Thu Oct 10 18:10:59 GMT+0800 2013
* from:编译开关配置.csv
* to:compilelist.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_compilelist extends SDataBaseJson
	{
		public function Json_compilelist()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _channelid:* = null;
		public function get channelid():*{return _channelid;}
		public function set channelid(value:*):void{_channelid=value;}

		private var _version:* = null;
		public function get version():*{return _version;}
		public function set version(value:*):void{_version=value;}

		private var _isonverify:* = null;
		public function get isonverify():*{return _isonverify;}
		public function set isonverify(value:*):void{_isonverify=value;}

	}
}
