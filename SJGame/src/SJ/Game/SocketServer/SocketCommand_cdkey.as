package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	public class SocketCommand_cdkey
	{
		public function SocketCommand_cdkey()
		{
		}
		
		/**
		 * 清空所有训练中武将CD
		 * @param func 回调函数
		 */
		public static function activate(func:Function, cdkey:String):void
		{
			SocketManager.o.callwithRtn(ConstNetCommand.CS_CDKEY_ACTIVATE, func, false, cdkey);
		}
	}
}