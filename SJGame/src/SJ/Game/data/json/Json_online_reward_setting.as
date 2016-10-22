/**
* gen by tools!
* time:Thu Oct 10 18:10:57 GMT+0800 2013
* from:在线奖励配置.csv
* to:online_reward_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_online_reward_setting extends SDataBaseJson
	{
		public function Json_online_reward_setting()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _title:* = null;
		public function get title():*{return _title;}
		public function set title(value:*):void{_title=value;}

		private var _describe:* = null;
		public function get describe():*{return _describe;}
		public function set describe(value:*):void{_describe=value;}

		private var _onlinetime:* = null;
		public function get onlinetime():*{return _onlinetime;}
		public function set onlinetime(value:*):void{_onlinetime=value;}

		private var _giftbagid:* = null;
		public function get giftbagid():*{return _giftbagid;}
		public function set giftbagid(value:*):void{_giftbagid=value;}

	}
}
