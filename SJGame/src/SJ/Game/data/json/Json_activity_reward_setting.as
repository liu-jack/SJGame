/**
* gen by tools!
* time:Thu Oct 10 18:10:59 GMT+0800 2013
* from:活跃度奖励配置表.csv
* to:activity_reward_setting.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_activity_reward_setting extends SDataBaseJson
	{
		public function Json_activity_reward_setting()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _rewardid:* = null;
		public function get rewardid():*{return _rewardid;}
		public function set rewardid(value:*):void{_rewardid=value;}

		private var _needscore:* = null;
		public function get needscore():*{return _needscore;}
		public function set needscore(value:*):void{_needscore=value;}

	}
}
