/**
* gen by tools!
* time:Thu Oct 10 18:10:57 GMT+0800 2013
* from:升级配置表.csv
* to:upgrade_config.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_upgrade_config extends SDataBaseJson
	{
		public function Json_upgrade_config()
		{
		}
		private var _level:* = null;
		public function get level():*{return _level;}
		public function set level(value:*):void{_level=value;}

		private var _needexp:* = null;
		public function get needexp():*{return _needexp;}
		public function set needexp(value:*):void{_needexp=value;}

		private var _defweight:* = null;
		public function get defweight():*{return _defweight;}
		public function set defweight(value:*):void{_defweight=value;}

		private var _hp:* = null;
		public function get hp():*{return _hp;}
		public function set hp(value:*):void{_hp=value;}

		private var _pattack:* = null;
		public function get pattack():*{return _pattack;}
		public function set pattack(value:*):void{_pattack=value;}

		private var _mattack:* = null;
		public function get mattack():*{return _mattack;}
		public function set mattack(value:*):void{_mattack=value;}

		private var _pdef:* = null;
		public function get pdef():*{return _pdef;}
		public function set pdef(value:*):void{_pdef=value;}

		private var _mdef:* = null;
		public function get mdef():*{return _mdef;}
		public function set mdef(value:*):void{_mdef=value;}

		private var _trans:* = null;
		public function get trans():*{return _trans;}
		public function set trans(value:*):void{_trans=value;}

	}
}
