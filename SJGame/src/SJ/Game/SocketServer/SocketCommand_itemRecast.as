package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	/**
	 @author	Weichao
	 2013-5-28
	 */
	
	public class SocketCommand_itemRecast
	{
		public function SocketCommand_itemRecast()
		{
			
		}
		/**
		 * 获取玩家所有武将装备位洗练信息
		 * 
		 */		
		public static function getEquipRecastInfo():void
		{
			SocketManager.o.call(ConstNetCommand.CS_ITEMRECAST_GETRECASTINFO);
		}
		/**
		 * 刷新装备位种类
		 * @param heroid
		 * @param position
		 * 
		 */		
		public static function recastPropertyKind(heroid:String, position:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_ITEMRECAST_PROPERTYKIND, heroid, position);
		}
		/**
		 * 洗练装备位数值
		 * @param heroid
		 * @param position
		 * 
		 */		
		public static function recastPropertyValue(heroid:String, position:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_ITEMRECAST_PROPERTYVALUE, heroid, position);
		}
	}
}