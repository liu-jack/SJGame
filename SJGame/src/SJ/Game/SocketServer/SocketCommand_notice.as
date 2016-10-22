package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	
	import com.hurlant.crypto.hash.MD5;
	import com.hurlant.util.Hex;
	
	import flash.utils.ByteArray;

	/**
	 * 获取最新公告
	 * @author caihua
	 */
	public class SocketCommand_notice
	{
		/**
		 * 获取最新的公告
		 */
		public static function getLatestNoitce():void
		{
			SocketManager.o.callunlock(ConstNetCommand.CS_GET_NEWEST_NOTICE);
		}
		
	}
}