package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstDynamic;
	import SJ.Common.Constants.ConstFuben;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFuben;

	/**
	 *  副本
	 * @author yongjun
	 * 
	 */
	public class SocketCommand_fuben
	{
		public function SocketCommand_fuben()
		{
		}
		
		/**
		 * 切换关卡
		 * @param fid 副本ID
		 * @param gid 关卡ID
		 * 
		 */
		public static function enterGuanKa(fid:int,gid:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FUBEN_ENTERGUANKA,fid,gid);
		}
		/**
		 *购买体力 
		 * @param goldnum
		 * 
		 */
		public static function buyVit():void
		{
			SocketManager.o.call(ConstNetCommand.CS_FUBEN_BUYVIT);
		}
		
		/**
		 *获取副本关卡可进入情况 
		 * @param fid
		 * 
		 */
		public static function getFubenInfo(fid:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FUBEN_GETFUBENINFO,fid);
		}
		
		/**
		 * 
		 * 加载战报
		 */
		public static function startBattle(fid:int,gid:int,battleid:int,fromtype:String= "",callback:Function = null):void
		{
			
			if(fromtype == ConstFuben.FUBEN_ACT)
			{
				SocketManager.o.callUnlockWithRtn(ConstNetCommand.CS_ACTFUBEN_BATTLE,callback,false,fid,gid,battleid);
			}
			else
			{
				SocketManager.o.callUnlockWithRtn(ConstNetCommand.CS_FUBEN_BATTLESTART,callback,false,fid,gid,battleid);
			}
		}
		/**
		 * 关卡战斗获取武将阵型信息
		 * 
		 */		
		public static function getheroformation():void
		{
			SocketManager.o.callunlock(ConstNetCommand.CS_FUBEN_BATTLEHEROINFO);
		}
		/**
		 * 领取关卡通关奖励 
		 * @param fid
		 * @param itemid
		 * 
		 */
		public static function getboxaward(fid:int,gid:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FUBEN_GUANKABOXAWARD,fid,gid);
		}
		/**
		 * 副本复活 
		 * @param heroid
		 * 
		 */
		public static function relive(heroid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FUBEN_RELIVE,heroid);
		}
		
		public static function exit():void
		{
			SocketManager.o.callunlock(ConstNetCommand.CS_FUBEN_EXIT);
		}
		
		/**
		 * 副本获取副本助战好友 
		 * 
		 */
		public static function getInviteHeros():void
		{
			SocketManager.o.call(ConstNetCommand.CS_FUBEN_GET_INVITE_HEROS);
		}
		/**
		 * 选择副本出战好友
		 * 
		 */
		public static function selectInviteHeros(uid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FUBEN_SELECT_INVITE_HEROS, uid);
		}
		/**
		 * 刷新副本出战好友列表
		 * 
		 */
		public static function flushInviteHeros():void
		{
			SocketManager.o.call(ConstNetCommand.CS_FUBEN_FLUSH_INVITE_HEROS);
		}
		/**
		 * 保存副本助战武将阵型 
		 * 
		 */
		public static function saveInviteHeroFormation(formationindex:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FUBEN_SAVE_INVITE_HERO_FORMATION, formationindex);
		}
		/**
		 * 随机宝箱奖励
		 */
		public static function randAwarditem(fid:int,gid:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FUBEN_PASS_RAND_AWARD,fid,gid);
		}
		/**
		 * 随机宝箱奖励
		 */
		public static function awarditem(fid:int,gid:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FUBEN_PASS_GET_AWARD,fid,gid);
		}
		
		/**
		 * 获取所有副本信息
		 */
		public static function getAllFubenInfo():void
		{
			SocketManager.o.call(ConstNetCommand.CS_FUBEN_GETALL_FUBENINFO);
		}
		/**
		 * 切换关卡
		 * @param fid 副本ID
		 * @param gid 关卡ID
		 * 
		 */
		public static function enterActGuanKa(aid:int,gid:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FUBEN_ENTERACTFBGUANKA,aid,gid);
		}
		/**
		 * 活动副本信息 
		 * 
		 */
		public static function getActFbInfo():void
		{
			SocketManager.o.call(ConstNetCommand.CS_ACTFUBEN_GETALL_FUBENINFO);
		}
	}
}