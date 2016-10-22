package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	/**
	 * 首充礼包网络操作
	 * @author zhengzheng
	 * 
	 */
	public class SocketCommand_firstrecharge
	{
		public function SocketCommand_firstrecharge()
		{
		}
		
		/**
		 * 获取首次充值礼包奖励
		 */
		public static function getGiftBag():void
		{
			SocketManager.o.callunlock(ConstNetCommand.CS_FIRST_RECHARGE_GET_GIFT_BAG);
		}
	}
}