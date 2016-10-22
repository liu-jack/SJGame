/**
* gen by tools!
* time:Thu Oct 10 18:10:57 GMT+0800 2013
* from:屏蔽字配置.csv
* to:mask_word_config.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_mask_word_config extends SDataBaseJson
	{
		public function Json_mask_word_config()
		{
		}
		private var _maskword:* = null;
		public function get maskword():*{return _maskword;}
		public function set maskword(value:*):void{_maskword=value;}

	}
}
