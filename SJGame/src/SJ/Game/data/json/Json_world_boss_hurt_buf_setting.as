/**
* gen by tools!
* time:Thu Oct 10 18:10:56 GMT+0800 2013
* from:世界boss第一名伤血增加buff配置.csv
* to:world_boss_hurt_buf_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_world_boss_hurt_buf_setting extends SDataBaseJson
	{
		public function Json_world_boss_hurt_buf_setting()
		{
		}
		private var _no1hurtmin:* = null;
		public function get no1hurtmin():*{return _no1hurtmin;}
		public function set no1hurtmin(value:*):void{_no1hurtmin=value;}

		private var _worldbufeffect:* = null;
		public function get worldbufeffect():*{return _worldbufeffect;}
		public function set worldbufeffect(value:*):void{_worldbufeffect=value;}

	}
}
