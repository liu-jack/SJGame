package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 * 武将星级网络操作
	 * @author longtao
	 * 
	 */
	public class SocketCommand_herostar
	{
		public function SocketCommand_herostar()
		{
		}
		
		/**
		 * 获取武将列表
		 */
		public static function get_herostarInfo():void
		{
			SocketManager.o.call(ConstNetCommand.CS_HEROSTAR_INFO);
		}
		
		/**
		 * 获取武将列表
		 */
		public static function upgrade(heroid:String, upgradetype:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_HEROSTAR_UPGRADE, heroid, upgradetype);
		}
	}
}