/**
* gen by tools!
* time:Thu Oct 10 18:10:58 GMT+0800 2013
* from:摇钱树配置.csv
* to:money_tree_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_money_tree_setting extends SDataBaseJson
	{
		public function Json_money_tree_setting()
		{
		}
		private var _level:* = null;
		public function get level():*{return _level;}
		public function set level(value:*):void{_level=value;}

		private var _exp:* = null;
		public function get exp():*{return _exp;}
		public function set exp(value:*):void{_exp=value;}

		private var _levelupsliver:* = null;
		public function get levelupsliver():*{return _levelupsliver;}
		public function set levelupsliver(value:*):void{_levelupsliver=value;}

		private var _levelupgold:* = null;
		public function get levelupgold():*{return _levelupgold;}
		public function set levelupgold(value:*):void{_levelupgold=value;}

		private var _basesliver:* = null;
		public function get basesliver():*{return _basesliver;}
		public function set basesliver(value:*):void{_basesliver=value;}

	}
}
