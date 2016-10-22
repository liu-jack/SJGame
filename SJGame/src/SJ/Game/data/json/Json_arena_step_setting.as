/**
* gen by tools!
* time:Thu Oct 10 18:10:59 GMT+0800 2013
* from:竞技场排行间隔配置.csv
* to:arena_step_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_arena_step_setting extends SDataBaseJson
	{
		public function Json_arena_step_setting()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _rankstart:* = null;
		public function get rankstart():*{return _rankstart;}
		public function set rankstart(value:*):void{_rankstart=value;}

		private var _rankend:* = null;
		public function get rankend():*{return _rankend;}
		public function set rankend(value:*):void{_rankend=value;}

		private var _step:* = null;
		public function get step():*{return _step;}
		public function set step(value:*):void{_step=value;}

	}
}
