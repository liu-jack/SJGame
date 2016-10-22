/**
* gen by tools!
* time:Fri Dec 13 18:57:19 GMT+0800 2013
* from:攻略系统配置.csv
* to:strategy_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_strategy_setting extends SDataBaseJson
	{
		public function Json_strategy_setting()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _type:* = null;
		public function get type():*{return _type;}
		public function set type(value:*):void{_type=value;}

		private var _description:* = null;
		public function get description():*{return _description;}
		public function set description(value:*):void{_description=value;}

		private var _star:* = null;
		public function get star():*{return _star;}
		public function set star(value:*):void{_star=value;}

		private var _modulename:* = null;
		public function get modulename():*{return _modulename;}
		public function set modulename(value:*):void{_modulename=value;}

		private var _index:* = null;
		public function get index():*{return _index;}
		public function set index(value:*):void{_index=value;}

	}
}
