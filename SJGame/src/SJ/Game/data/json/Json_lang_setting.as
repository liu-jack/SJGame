/**
* gen by tools!
* time:Thu Oct 10 18:11:00 GMT+0800 2013
* from:语言配置.csv
* to:lang_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_lang_setting extends SDataBaseJson
	{
		public function Json_lang_setting()
		{
		}
		private var _languageid:* = null;
		public function get languageid():*{return _languageid;}
		public function set languageid(value:*):void{_languageid=value;}

		private var _zn:* = null;
		public function get zn():*{return _zn;}
		public function set zn(value:*):void{_zn=value;}

		private var _en:* = null;
		public function get en():*{return _en;}
		public function set en(value:*):void{_en=value;}

	}
}
