/**
* gen by tools!
* time:Thu Oct 10 18:10:56 GMT+0800 2013
* from:主城NPC配置.csv
* to:scene_npc_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_scene_npc_setting extends SDataBaseJson
	{
		public function Json_scene_npc_setting()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _npcid:* = null;
		public function get npcid():*{return _npcid;}
		public function set npcid(value:*):void{_npcid=value;}

		private var _npcx:* = null;
		public function get npcx():*{return _npcx;}
		public function set npcx(value:*):void{_npcx=value;}

		private var _npcy:* = null;
		public function get npcy():*{return _npcy;}
		public function set npcy(value:*):void{_npcy=value;}

	}
}
