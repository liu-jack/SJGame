/**
* gen by tools!
* time:Thu Oct 10 18:10:57 GMT+0800 2013
* from:客户端升级配置.csv
* to:client_upgrade_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_client_upgrade_setting extends SDataBaseJson
	{
		public function Json_client_upgrade_setting()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _channelid:* = null;
		public function get channelid():*{return _channelid;}
		public function set channelid(value:*):void{_channelid=value;}

		private var _curverbose:* = null;
		public function get curverbose():*{return _curverbose;}
		public function set curverbose(value:*):void{_curverbose=value;}

		private var _upgradeverbose:* = null;
		public function get upgradeverbose():*{return _upgradeverbose;}
		public function set upgradeverbose(value:*):void{_upgradeverbose=value;}

		private var _forceupgrade:* = null;
		public function get forceupgrade():*{return _forceupgrade;}
		public function set forceupgrade(value:*):void{_forceupgrade=value;}

	}
}
