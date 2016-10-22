package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 * 酒馆网络操作
	 * @author longtao
	 * 
	 */
	public class SocketCommand_winebar
	{
		public function SocketCommand_winebar()
		{
		}
		
		/**
		 * 获取酒馆状态
		 * @param winebarid
		 */
		public static function get_winbarInfo(winebarid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_WINEBAR_GETINFO, winebarid);
		}
		
		/**
		 * 刷新酒馆
		 * @param winebarid
		 * 
		 */
		public static function refresh(winebarid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_WINEBAR_REFRESH, winebarid);
		}
		
		/**
		 * 开始抽取武将
		 * 
		 */
		public static function startpick():void
		{
			SocketManager.o.call(ConstNetCommand.CS_WINEBAR_STARTPICK);
		}
		
		/**
		 * 抽取武将
		 * @param index 选择索引
		 * 
		 */
		public static function picking(index:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_WINEBAR_PICKING, index);
		}
		
		/**
		 * 雇佣武将
		 * @param index 选择索引
		 * 
		 */
		public static function employ_hero(index:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_WINEBAR_EMPLOY_HERO, index);
		}
	}
}