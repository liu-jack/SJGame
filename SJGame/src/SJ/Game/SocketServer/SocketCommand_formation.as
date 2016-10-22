package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFormation;

	/**
	 +------------------------------------------------------------------------------
	 * @name 阵型rpc接口
	 * @comment 1.更改阵型 2.设置主将技能
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-9 上午10:32:12  
	 +------------------------------------------------------------------------------
	 */
	public class SocketCommand_formation
	{
		public function SocketCommand_formation()
		{
		}
		
		/**
		 * 更改用户阵型
		 */		
		public static function changeFormation(heroid:String , posfrom:int , posto:int):void
		{
			var formationList:Array = CJDataManager.o.DataOfFormation.currentFormationData;
			SocketManager.o.callunlock(ConstNetCommand.CS_FORMATION_CHANGE ,heroid,posfrom,posto);
		}
		
		/**
		 * 获取用户上次阵型
		 */		
		public static function getLastFormation():void
		{
			SocketManager.o.call(ConstNetCommand.CS_FORMATION_LAST);
		}
		
		/**
		 * 设置主角战斗技能 
		 * @param skillid 技能id
		 */		
		public static function setRoleBattleSkill(skillid:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_SET_PLAYER_SKILL , skillid);
		}
		
		/**
		 * 获取用户主角的所有技能
		 */
		public static function getUserSkillList():void
		{
			SocketManager.o.call(ConstNetCommand.CS_GET_PLAYER_SKILL_LIST);
		}
		
		/**
		 * 增加主角技能
		 * @param:skillid 技能的配置id
		 */
		public static function addPlayerSkill(skillid:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_ADD_PLAYER_SKILL , skillid);
		}
	}
}