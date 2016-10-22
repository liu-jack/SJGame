/**
* gen by tools!
* time:Thu Oct 10 18:10:55 GMT+0800 2013
* from:NPC配置.csv
* to:npc_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_npc_setting extends SDataBaseJson
	{
		public function Json_npc_setting()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _name:* = null;
		public function get name():*{return _name;}
		public function set name(value:*):void{_name=value;}

		private var _animation:* = null;
		public function get animation():*{return _animation;}
		public function set animation(value:*):void{_animation=value;}

		private var _talk:* = null;
		public function get talk():*{return _talk;}
		public function set talk(value:*):void{_talk=value;}

		private var _halficon:* = null;
		public function get halficon():*{return _halficon;}
		public function set halficon(value:*):void{_halficon=value;}

		private var _functionid:* = null;
		public function get functionid():*{return _functionid;}
		public function set functionid(value:*):void{_functionid=value;}

	}
}
