package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 +------------------------------------------------------------------------------
	 * 阵营接口类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-20 上午9:09:02  
	 +------------------------------------------------------------------------------
	 */
	public class SocketCommand_camp
	{
		/**
		 * 获取推荐阵营
		 */
		public static function calcRecommendCampid():void
		{
			SocketManager.o.call(ConstNetCommand.CS_GET_RECOMMENDEDCAMP);
		}
		
		/**
		 * 加入阵营
		 */
		public static function joinCamp(campid:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_JOINCAMP , campid);
		}
		
		/**
		 * 获取当前加入的阵营
		 */
		public static function getCurrentCampid():void
		{
			SocketManager.o.call(ConstNetCommand.CS_GET_CURRENTCAMP);
		}
	}
}