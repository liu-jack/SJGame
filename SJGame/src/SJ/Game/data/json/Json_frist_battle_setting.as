/**
* gen by tools!
* time:Thu Oct 10 18:10:57 GMT+0800 2013
* from:开场战斗配置.csv
* to:frist_battle_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_frist_battle_setting extends SDataBaseJson
	{
		public function Json_frist_battle_setting()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _battlebg:* = null;
		public function get battlebg():*{return _battlebg;}
		public function set battlebg(value:*):void{_battlebg=value;}

		private var _battlesound:* = null;
		public function get battlesound():*{return _battlesound;}
		public function set battlesound(value:*):void{_battlesound=value;}

	}
}
