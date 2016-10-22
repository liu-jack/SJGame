/**
* gen by tools!
* time:Thu Oct 10 18:10:59 GMT+0800 2013
* from:活跃度配置表.csv
* to:activity_progress_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_activity_progress_setting extends SDataBaseJson
	{
		public function Json_activity_progress_setting()
		{
		}
		private var _activityid:* = null;
		public function get activityid():*{return _activityid;}
		public function set activityid(value:*):void{_activityid=value;}

		private var _activitykey:* = null;
		public function get activitykey():*{return _activitykey;}
		public function set activitykey(value:*):void{_activitykey=value;}

		private var _condition:* = null;
		public function get condition():*{return _condition;}
		public function set condition(value:*):void{_condition=value;}

		private var _count:* = null;
		public function get count():*{return _count;}
		public function set count(value:*):void{_count=value;}

		private var _addscore:* = null;
		public function get addscore():*{return _addscore;}
		public function set addscore(value:*):void{_addscore=value;}

		private var _isopen:* = null;
		public function get isopen():*{return _isopen;}
		public function set isopen(value:*):void{_isopen=value;}

		private var _index:* = null;
		public function get index():*{return _index;}
		public function set index(value:*):void{_index=value;}

		private var _activityname:* = null;
		public function get activityname():*{return _activityname;}
		public function set activityname(value:*):void{_activityname=value;}

	}
}
