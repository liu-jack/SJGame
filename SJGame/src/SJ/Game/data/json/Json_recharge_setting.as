/**
* gen by tools!
* time:Thu Oct 10 18:10:56 GMT+0800 2013
* from:充值配置.csv
* to:recharge_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_recharge_setting extends SDataBaseJson
	{
		public function Json_recharge_setting()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _rmbnum:* = null;
		public function get rmbnum():*{return _rmbnum;}
		public function set rmbnum(value:*):void{_rmbnum=value;}

		private var _goldnum:* = null;
		public function get goldnum():*{return _goldnum;}
		public function set goldnum(value:*):void{_goldnum=value;}

	}
}
