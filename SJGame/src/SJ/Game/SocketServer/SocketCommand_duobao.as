package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	public class SocketCommand_duobao
	{
		
		public static function gettreasureforfind():void
		{
			SocketManager.o.call(ConstNetCommand.CS_DUOBAO_GET_TREASURE_FOR_FIND);
		}
		
		public static function find():void
		{
			SocketManager.o.call(ConstNetCommand.CS_DUOBAO_FIND);
		}
		
		public static function gettreasureformerge():void
		{
			SocketManager.o.call(ConstNetCommand.CS_DUOBAO_GET_TREASURE_FOR_MERGE);
		}
		
		public static function merge(treasureId:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_DUOBAO_MERGE, treasureId);
		}
		
		public static function collect(treasureId:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_DUOBAO_COLLECT, treasureId);
		}
		
		public static function getLootList(treasurePartId: String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_DUOBAO_GET_LOOT_LIST, treasurePartId);
		}
		
		public static function lootTreasurePart(userId: String, treasurePartId: String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_DUOBAO_LOOT_TREASURE_PART, userId, treasurePartId);
		}
		
		/**
		 * 雇佣好友武将
		 */ 
		public static function tryEmploy(frienduid:String , heroid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_DUOBAO_TRYEMPLOY, frienduid , heroid);
		}
		
		/**
		 * 同意雇佣
		 */ 
		public static function agreeEmploy(frienduid:String , heroid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_DUOBAO_AGREE, frienduid , heroid);
		}
		
		/**
		 * 拒绝雇佣
		 */ 
		public static function rejectEmploy(frienduid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_DUOBAO_REJECT , frienduid);
		}
		
		/**
		 * 获取我的雇佣数据
		 */ 
		public static function getEmployData():void
		{
			SocketManager.o.call(ConstNetCommand.CS_DUOBAO_GETMYEMPLOYDATA);
		}
		
		/**
		 * 获取我的雇佣申请数据
		 */ 
		public static function getEmployApplyList():void
		{
			SocketManager.o.call(ConstNetCommand.CS_DUOBAO_EMPLOYAPPLY);
		}
		
		/**
		 * 保存阵型数据
		 */ 
		public static function saveEmployHeroFormation(formationIndex:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_DUOBAO_SAVEEMPLOYFORMATION , formationIndex);
		}
	}
}