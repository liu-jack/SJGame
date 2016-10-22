package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 * 武将标签网络操作
	 * @author longtao
	 */
	public class SocketCommand_herotag
	{
		public function SocketCommand_herotag()
		{
		}
		
		/**
		 * 获取武将标签信息
		 */
		public static function get_herotag():void
		{
			SocketManager.o.call(ConstNetCommand.CS_HERO_TAG_GET);
		}
		
		/**
		 * 添加武将标签
		 */
		public static function add_herotag(index:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_HERO_TAG_ADD, index);
		}
	}
}