package SJ.Game.data
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_formation;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.config.CJDataOfSkillPropertyList;
	import SJ.Game.data.json.Json_skill_setting;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	import engine_starling.utils.Logger;
	
	import starling.events.Event;

	/**
	 +------------------------------------------------------------------------------
	 * @name 用户所有技能表 保存CJDataOfUserSkill对象
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-11 下午6:00:43  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfUserSkillList extends SDataBaseRemoteData
	{
		public static const DATA_KEY:String = "userSkillList";

		private var _skillDao:CJDataOfUserSkill;
		
		public function CJDataOfUserSkillList()
		{
			super("CJDataOfUserSkillList");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , _onLoadComplete);
		}
		
		override protected function _onloadFromRemote(params:Object = null):void
		{
			//读取上次阵型数据
			SocketCommand_formation.getUserSkillList();
			super._onloadFromRemote(params);
		}
		
		private function _saveSkill(skillData:Object):void
		{
			_skillDao = new CJDataOfUserSkill();
			_skillDao.heroid = skillData.heroid;
			_skillDao.skillid1 = skillData.skillid1;
			_skillDao.skillid2 = skillData.skillid2;
			_skillDao.skillid3 = skillData.skillid3;
			_skillDao.skillid4 = skillData.skillid4;
			_skillDao.skillid5 = skillData.skillid5;
			_skillDao.selecteskill = skillData.selectskill;
		}
		
		/**
		 * 读取阵型数据返回
		 */		
		private function _onLoadComplete(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage;
			if(msg.getCommand() != ConstNetCommand.CS_GET_PLAYER_SKILL_LIST)
			{
				return;
			}
			var retCode:int = msg.params(0)
			if(retCode == 1)
			{
				Logger.log("------------------->" , "skill data inited");
				var data:Object = msg.retparams;
				this._saveSkill(data);
				this._onloadFromRemoteComplete();
			}
		}
		
		/**
		 * 取得当前出战技能的技能id
		 */		
		public function getCurrentSkill():int
		{
			return _skillDao.selecteskill;
		}
		
		/**
		 * 设置主角战斗技能 
		 */		
		public function setBattleSkill(skillId:int):void
		{
			var _canSetSkill:Boolean = false;
			
			for(var i:int = 1 ; i<= 5 ;  i++)
			{
				if(this._skillDao["skillid"+i] == skillId)
				{
					_canSetSkill = true;
				}
			}
			
			if(!_canSetSkill)
			{
				return;
			}
			
			//发送请求
			SocketCommand_formation.setRoleBattleSkill(skillId);
			this._skillDao.selecteskill = skillId;
		}
		
		
		/**
		 * 获得所有的技能
		 * skillid => Json_skill_setting
		 */ 
		public function getAllSkill():Dictionary
		{
			var temp:Dictionary = new Dictionary();
			for(var i: int = 1 ; i <= 5 ;i++)
			{
				var skillid:int = this._skillDao["skillid"+i];
				if(skillid != 0)
				{
					var skillConfig:Json_skill_setting = CJDataOfSkillPropertyList.o.getProperty(skillid);
					temp[skillid] = skillConfig;
				}
			}
			return temp;
		}

		public function get skillDao():CJDataOfUserSkill
		{
			return _skillDao;
		}
	}
}