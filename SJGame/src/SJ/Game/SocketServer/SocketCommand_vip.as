package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 * vip
	 * @author longtao
	 * 
	 */
	public class SocketCommand_vip
	{
		public function SocketCommand_vip()
		{
			
		}
		
		/**
		 * 登出操作 
		 * 
		 */
		public static function get_info(func:Function=null):void
		{
			SocketManager.o.callwithRtn(ConstNetCommand.CS_VIP_INFO, func);
		}
	}
}