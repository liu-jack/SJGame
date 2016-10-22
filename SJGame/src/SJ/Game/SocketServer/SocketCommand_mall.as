package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 * 商城
	 * @author sangxu
	 * 
	 */
	public class SocketCommand_mall
	{
		public function SocketCommand_mall()
		{
			
		}
		/**
		 * 获取商城道具
		 * @param itemType	商城道具类型
		 * 
		 */		
		public static function getItems(itemType:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_MALL_GETITEMS, itemType);
		}
		
		/**
		 * 获取商城全部道具
		 * @param itemType
		 * 
		 */		
		public static function getAllItems():void
		{
			SocketManager.o.call(ConstNetCommand.CS_MALL_GETALLITEMS);
		}
		
		/**
		 * 购买商城道具
		 * @param itemid	商城道具id
		 * @param count		购买数量
		 * 
		 */			
		public static function buyitem(itemid:int, count:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_MALL_BUYITEM, itemid, count);
		}
	}
}