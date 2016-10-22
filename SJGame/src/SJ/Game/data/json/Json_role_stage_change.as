/**
* gen by tools!
* time:Thu Oct 10 18:10:56 GMT+0800 2013
* from:主角升阶主角变化.csv
* to:role_stage_change.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_role_stage_change extends SDataBaseJson
	{
		public function Json_role_stage_change()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _stagelevel:* = null;
		public function get stagelevel():*{return _stagelevel;}
		public function set stagelevel(value:*):void{_stagelevel=value;}

		private var _job:* = null;
		public function get job():*{return _job;}
		public function set job(value:*):void{_job=value;}

		private var _sex:* = null;
		public function get sex():*{return _sex;}
		public function set sex(value:*):void{_sex=value;}

		private var _oldtid:* = null;
		public function get oldtid():*{return _oldtid;}
		public function set oldtid(value:*):void{_oldtid=value;}

		private var _newtid:* = null;
		public function get newtid():*{return _newtid;}
		public function set newtid(value:*):void{_newtid=value;}

	}
}
