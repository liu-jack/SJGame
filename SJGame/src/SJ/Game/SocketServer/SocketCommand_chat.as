package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 * 聊天接口 
	 * @author caihua
	 */
	public class SocketCommand_chat
	{
		/**
		 * 聊天
		 */
		public static function chat(chattype:int,message:String,chattoguid:String):void
		{
			SocketManager.o.callunlock(ConstNetCommand.CS_CHAT,chattype , message , chattoguid);
		}
		
		/**
		 * 获取最后的聊天记录
		 */
		public static function getLastMsg():void
		{
			SocketManager.o.callunlock(ConstNetCommand.CS_GET_LAST_MSG);
		}
		
	}
}