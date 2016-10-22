package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	
	/**
	 +------------------------------------------------------------------------------
	 * 功能点开启接口类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-25 下午12:08:42  
	 +------------------------------------------------------------------------------
	 */
	public class SocketCommand_funcpoint
	{
		/**
		 * 获取所有的功能点列表
		 */		
		public static function getAllFunctionList():void
		{
			SocketManager.o.call(ConstNetCommand.CS_FUNCITON_GETALL);
		}
		
		/**
		 * 新增功能点开启
		 */		
		public static function addOpenFunciton(funcitonid:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FUNCITON_OPEN , funcitonid);
		}
		
		/**
		 * 完成功能点开启引导
		 */		
		public static function completeFuncitonIndicate(funcitonid:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_FUNCITON_INDICATE_COMPLETE , funcitonid);
		}
	}
}