/**
* gen by tools!
* time:Thu Oct 10 18:11:01 GMT+0800 2013
* from:音效配置.csv
* to:sound_effect_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_sound_effect_setting extends SDataBaseJson
	{
		public function Json_sound_effect_setting()
		{
		}
		private var _soundid:* = null;
		public function get soundid():*{return _soundid;}
		public function set soundid(value:*):void{_soundid=value;}

		private var _res:* = null;
		public function get res():*{return _res;}
		public function set res(value:*):void{_res=value;}

	}
}
