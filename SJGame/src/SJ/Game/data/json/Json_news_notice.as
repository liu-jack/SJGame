/**
* gen by tools!
* time:Thu Oct 10 18:10:58 GMT+0800 2013
* from:有新消息提醒配置.csv
* to:news_notice.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_news_notice extends SDataBaseJson
	{
		public function Json_news_notice()
		{
		}
		private var _noticeid:* = null;
		public function get noticeid():*{return _noticeid;}
		public function set noticeid(value:*):void{_noticeid=value;}

		private var _modulename:* = null;
		public function get modulename():*{return _modulename;}
		public function set modulename(value:*):void{_modulename=value;}

		private var _icon:* = null;
		public function get icon():*{return _icon;}
		public function set icon(value:*):void{_icon=value;}

	}
}
