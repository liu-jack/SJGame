/**
* gen by tools!
* time:Thu Oct 10 18:10:58 GMT+0800 2013
* from:武将训练经验.csv
* to:hero_train_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_hero_train_setting extends SDataBaseJson
	{
		public function Json_hero_train_setting()
		{
		}
		private var _level:* = null;
		public function get level():*{return _level;}
		public function set level(value:*):void{_level=value;}

		private var _silver:* = null;
		public function get silver():*{return _silver;}
		public function set silver(value:*):void{_silver=value;}

		private var _gold2:* = null;
		public function get gold2():*{return _gold2;}
		public function set gold2(value:*):void{_gold2=value;}

		private var _gold5:* = null;
		public function get gold5():*{return _gold5;}
		public function set gold5(value:*):void{_gold5=value;}

		private var _exp:* = null;
		public function get exp():*{return _exp;}
		public function set exp(value:*):void{_exp=value;}

	}
}
