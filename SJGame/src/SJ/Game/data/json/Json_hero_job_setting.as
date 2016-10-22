/**
* gen by tools!
* time:Thu Oct 10 18:10:58 GMT+0800 2013
* from:武将职业配置.csv
* to:hero_job_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_hero_job_setting extends SDataBaseJson
	{
		public function Json_hero_job_setting()
		{
		}
		private var _jobid:* = null;
		public function get jobid():*{return _jobid;}
		public function set jobid(value:*):void{_jobid=value;}

		private var _hp:* = null;
		public function get hp():*{return _hp;}
		public function set hp(value:*):void{_hp=value;}

		private var _pattack:* = null;
		public function get pattack():*{return _pattack;}
		public function set pattack(value:*):void{_pattack=value;}

		private var _pdef:* = null;
		public function get pdef():*{return _pdef;}
		public function set pdef(value:*):void{_pdef=value;}

		private var _mattack:* = null;
		public function get mattack():*{return _mattack;}
		public function set mattack(value:*):void{_mattack=value;}

		private var _mdef:* = null;
		public function get mdef():*{return _mdef;}
		public function set mdef(value:*):void{_mdef=value;}

	}
}
