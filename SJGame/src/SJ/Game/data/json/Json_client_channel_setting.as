/**
* gen by tools!
* time:Thu Oct 10 18:10:59 GMT+0800 2013
* from:神将渠道列表配置.csv
* to:client_channel_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_client_channel_setting extends SDataBaseJson
	{
		public function Json_client_channel_setting()
		{
		}
		private var _channelid:* = null;
		public function get channelid():*{return _channelid;}
		public function set channelid(value:*):void{_channelid=value;}

		private var _channelname:* = null;
		public function get channelname():*{return _channelname;}
		public function set channelname(value:*):void{_channelname=value;}

		private var _upgradeurlios:* = null;
		public function get upgradeurlios():*{return _upgradeurlios;}
		public function set upgradeurlios(value:*):void{_upgradeurlios=value;}

		private var _upgradeurlandroid:* = null;
		public function get upgradeurlandroid():*{return _upgradeurlandroid;}
		public function set upgradeurlandroid(value:*):void{_upgradeurlandroid=value;}

	}
}
