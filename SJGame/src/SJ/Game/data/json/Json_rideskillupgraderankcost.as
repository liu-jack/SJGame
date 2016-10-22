/**
* gen by tools!
* time:Thu Oct 10 18:11:01 GMT+0800 2013
* from:骑术升阶消耗表.csv
* to:rideskillupgraderankcost.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_rideskillupgraderankcost extends SDataBaseJson
	{
		public function Json_rideskillupgraderankcost()
		{
		}
		private var _riderank:* = null;
		public function get riderank():*{return _riderank;}
		public function set riderank(value:*):void{_riderank=value;}

		private var _costgold:* = null;
		public function get costgold():*{return _costgold;}
		public function set costgold(value:*):void{_costgold=value;}

	}
}
