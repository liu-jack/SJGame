/**
* gen by tools!
* time:Thu Oct 10 18:10:59 GMT+0800 2013
* from:竞技场奖励配置.csv
* to:arena_award_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_arena_award_setting extends SDataBaseJson
	{
		public function Json_arena_award_setting()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _silver:* = null;
		public function get silver():*{return _silver;}
		public function set silver(value:*):void{_silver=value;}

		private var _credit:* = null;
		public function get credit():*{return _credit;}
		public function set credit(value:*):void{_credit=value;}

	}
}
