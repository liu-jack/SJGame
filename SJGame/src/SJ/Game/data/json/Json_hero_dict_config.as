/**
* gen by tools!
* time:Thu Oct 10 18:10:58 GMT+0800 2013
* from:武将宝典.csv
* to:hero_dict_config.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_hero_dict_config extends SDataBaseJson
	{
		public function Json_hero_dict_config()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _herotid:* = null;
		public function get herotid():*{return _herotid;}
		public function set herotid(value:*):void{_herotid=value;}

	}
}
