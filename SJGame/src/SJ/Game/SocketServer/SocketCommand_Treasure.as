package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 +------------------------------------------------------------------------------
	 * 聚灵RPC调用
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-31 下午9:19:13  
	 +------------------------------------------------------------------------------
	 */
	public class SocketCommand_Treasure
	{
		public function SocketCommand_Treasure()
		{
		}
		
		/**
		 * 获取灵丸
		 */		
		public static function getTreasure(num:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_TREASURE_GETTREASURE , num);
		}
		
		/**
		 * 转化单个灵丸
		 * @treasureid : 灵丸id
		 * @heroid :如果从武将身上直接转化，则传入武将id
		 */		
		public static function transferSingal(treasureid:String , heroid:String = ""):void
		{
			SocketManager.o.call(ConstNetCommand.CS_TREASURE_TRANSFERSINGAL , treasureid ,  heroid);
		}
		
		/**
		 * 转化所有灵丸 
		 * @param taskid
		 */		
		public static function transferAll():void
		{
			SocketManager.o.call(ConstNetCommand.CS_TREASURE_TRANSFERALL);
		}
		
		/**
		 * 灵丸升级 
		 */		
		public static function treasureUplevel(treasureid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_TREASURE_TREASUREUPLEVEL , treasureid);
		}
		
		/**
		 *兑换灵丸 
		 */		
		public static function exchangeTreasure(templateid:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_TREASURE_EXCHANGETREASURE , templateid);
		}
		
		/**
		 *穿戴灵丸
		 * @treasureid : 灵丸id
		 * @heroid : 武将的id
		 */		
		public static function putontreasure(treasureid:String , heroid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_TREASURE_PUTONTREASURE);
		}
		
		/**
		 * 取消穿戴灵丸
		 * @treasureid : 灵丸id
		 * @heroid : 武将的id
		 */	
		public static function takeofftreasure(treasureid:String , heroid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_TREASURE_TAKEOFFTREASURE);
		}
		
		/**
		 * 获取所有武将的灵丸信息
		 */	
		public static function getAllHeroTreasureList():void
		{
			SocketManager.o.call(ConstNetCommand.CS_TREASURE_GETALLTREASURELIST);
		}
		
		/**
		 * 获取用户所有的灵丸信息
		 */		
		public static function getAllTreasureList():void
		{
			SocketManager.o.call(ConstNetCommand.CS_TREASURE_GETALLHEROTREASURELIST);
		}
		
		/**
		 * 获取聚灵用户信息
		 */		
		public static function getTreasureUserInfo():void
		{
			SocketManager.o.call(ConstNetCommand.CS_TREASURE_GETUSERINFO);
		}
		
		/**
		 * 移动灵丸到用户背包
		 */		
		public static function moveTreasureToUserBag():void
		{
			SocketManager.o.call(ConstNetCommand.CS_TREASURE_MOVETREASURETOUSERBAG);
		}
	}
}