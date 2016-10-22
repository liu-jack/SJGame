/**
* gen by tools!
* time:Thu Oct 10 18:10:56 GMT+0800 2013
* from:主角升阶.csv
* to:role_stage_level.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_role_stage_level extends SDataBaseJson
	{
		public function Json_role_stage_level()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _name:* = null;
		public function get name():*{return _name;}
		public function set name(value:*):void{_name=value;}

		private var _type:* = null;
		public function get type():*{return _type;}
		public function set type(value:*):void{_type=value;}

		private var _stage:* = null;
		public function get stage():*{return _stage;}
		public function set stage(value:*):void{_stage=value;}

		private var _maxforcesoul:* = null;
		public function get maxforcesoul():*{return _maxforcesoul;}
		public function set maxforcesoul(value:*):void{_maxforcesoul=value;}

		private var _level:* = null;
		public function get level():*{return _level;}
		public function set level(value:*):void{_level=value;}

		private var _forcesoul:* = null;
		public function get forcesoul():*{return _forcesoul;}
		public function set forcesoul(value:*):void{_forcesoul=value;}

	}
}
