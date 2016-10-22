/**
* gen by tools!
* time:Thu Oct 10 18:10:58 GMT+0800 2013
* from:掉落配置.csv
* to:drop_award_config.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_drop_award_config extends SDataBaseJson
	{
		public function Json_drop_award_config()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _itemtemplateid:* = null;
		public function get itemtemplateid():*{return _itemtemplateid;}
		public function set itemtemplateid(value:*):void{_itemtemplateid=value;}

		private var _weight:* = null;
		public function get weight():*{return _weight;}
		public function set weight(value:*):void{_weight=value;}

		private var _count:* = null;
		public function get count():*{return _count;}
		public function set count(value:*):void{_count=value;}

	}
}
