/**
* gen by tools!
* time:Thu Oct 10 18:10:56 GMT+0800 2013
* from:vip经验.csv
* to:vip_exp_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_vip_exp_setting extends SDataBaseJson
	{
		public function Json_vip_exp_setting()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _viplevel:* = null;
		public function get viplevel():*{return _viplevel;}
		public function set viplevel(value:*):void{_viplevel=value;}

		private var _vipexp:* = null;
		public function get vipexp():*{return _vipexp;}
		public function set vipexp(value:*):void{_vipexp=value;}

	}
}
