package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 * 累积充值
	 * @author longtao
	 * 
	 */
	public class SocketCommand_pileRecharge
	{
		public function SocketCommand_pileRecharge()
		{
		}
		
		/**
		 * 获取累计充值信息
		 * @param func 回调
		 */
		public static function getInfo(func:Function):void
		{
			SocketManager.o.callwithRtn(ConstNetCommand.CS_PILE_RECHARGE_GETINFO, func);
		}
	}
}