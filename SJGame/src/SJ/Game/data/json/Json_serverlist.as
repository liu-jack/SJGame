/**
* gen by tools!
* time:Thu Oct 10 18:11:00 GMT+0800 2013
* from:选择服务器列表.csv
* to:serverlist.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_serverlist extends SDataBaseJson
	{
		public function Json_serverlist()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _groupid:* = null;
		public function get groupid():*{return _groupid;}
		public function set groupid(value:*):void{_groupid=value;}

		private var _groupname:* = null;
		public function get groupname():*{return _groupname;}
		public function set groupname(value:*):void{_groupname=value;}

		private var _defaultserver:* = null;
		public function get defaultserver():*{return _defaultserver;}
		public function set defaultserver(value:*):void{_defaultserver=value;}

		private var _recommend:* = null;
		public function get recommend():*{return _recommend;}
		public function set recommend(value:*):void{_recommend=value;}

		private var _servername:* = null;
		public function get servername():*{return _servername;}
		public function set servername(value:*):void{_servername=value;}

		private var _serverip:* = null;
		public function get serverip():*{return _serverip;}
		public function set serverip(value:*):void{_serverip=value;}

		private var _serverport:* = null;
		public function get serverport():*{return _serverport;}
		public function set serverport(value:*):void{_serverport=value;}

		private var _servermaxuser:* = null;
		public function get servermaxuser():*{return _servermaxuser;}
		public function set servermaxuser(value:*):void{_servermaxuser=value;}

		private var _cdnurl:* = null;
		public function get cdnurl():*{return _cdnurl;}
		public function set cdnurl(value:*):void{_cdnurl=value;}

		private var _md5url:* = null;
		public function get md5url():*{return _md5url;}
		public function set md5url(value:*):void{_md5url=value;}

		private var _channel:* = null;
		public function get channel():*{return _channel;}
		public function set channel(value:*):void{_channel=value;}

		private var _isclose:* = null;
		public function get isclose():*{return _isclose;}
		public function set isclose(value:*):void{_isclose=value;}

	}
}
