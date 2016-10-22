/**
* gen by tools!
* time:Thu Oct 10 18:10:56 GMT+0800 2013
* from:世界boss全体伤血修复主城配置.csv
* to:world_boss_hurt_repair_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_world_boss_hurt_repair_setting extends SDataBaseJson
	{
		public function Json_world_boss_hurt_repair_setting()
		{
		}
		private var _hurtmin:* = null;
		public function get hurtmin():*{return _hurtmin;}
		public function set hurtmin(value:*):void{_hurtmin=value;}

		private var _repairvalue:* = null;
		public function get repairvalue():*{return _repairvalue;}
		public function set repairvalue(value:*):void{_repairvalue=value;}

	}
}
