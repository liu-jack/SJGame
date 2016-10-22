package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 * 酒馆网络操作
	 * @author longtao
	 * 
	 */
	public class SocketCommand_stageLevel
	{
		public function SocketCommand_stageLevel()
		{
		}
		
		/**
		 * 获取主角武星信息
		 */
		public static function get_stagelevel_info():void
		{
			SocketManager.o.call(ConstNetCommand.CS_STAGELEVEL_GET_INFO);
		}
		
		/**
		 * 激活武星
		 */
		public static function activate_force_star():void
		{
			SocketManager.o.call(ConstNetCommand.CS_STAGELEVEL_ACTIVATE_FORCE_STAR);
		}
		
	}
}