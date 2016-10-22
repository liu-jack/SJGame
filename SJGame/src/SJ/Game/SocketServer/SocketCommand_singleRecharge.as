package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 * 单笔充值
	 * @author sangxu
	 * 
	 */
	public class SocketCommand_singleRecharge
	{
		public function SocketCommand_singleRecharge()
		{
		}
		
		/**
		 * 获取单笔充值信息
		 * @param func 回调
		 */
		public static function getSingleRechargeInfo(callback:Function = null):void
		{
			SocketManager.o.callwithRtn(ConstNetCommand.CS_SINGLE_RECHARGE_GETINFO, callback);
		}
	}
}