package SJ.Game.SocketServer
{
	import flash.system.Capabilities;
	
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.utils.SNetWorkUtils;
	
	import engine_starling.utils.SManufacturerUtils;
	import engine_starling.utils.SPlatformUtils;

	/**
	 * 记录网络操作
	 * @author longtao
	 * 
	 */
	public class SocketCommand_record
	{
		public function SocketCommand_record()
		{
		}
		
		/**
		 * 记录客户端错误日志 - 批量
		 * 
		 */
		public static function clienterrorall(datainfo:String):void
		{
			SocketManager.o.callunlock(ConstNetCommand.CS_CLIENT_ERROR_ALL, datainfo);
		}
		
		/**
		 * 记录客户端错误日志 - 单独一条
		 * 
		 */
		public static function clienterror(datainfo:String):void
		{
			SocketManager.o.callunlock(ConstNetCommand.CS_CLIENT_ERROR, datainfo);
		}
		
		
		/**
		 * 客户端启动登录统计 
		 * 
		 */
		public static function clientsetup():void
		{
			var channel:String = ConstGlobal.CHANNEL;
			var channelName:String = ConstGlobal.CHANNELNAME;
			
			SocketManager.o.callunlock(ConstNetCommand.CS_CLIENT_STARTUP
				,channel
				,channelName
				,SManufacturerUtils.getManufacturerType()
				,ConstGlobal.DeviceInfo.DeviceName == null?"Unknown":ConstGlobal.DeviceInfo.DeviceName
				,Capabilities.os
				,SPlatformUtils.getApplicationVersion()
				,SNetWorkUtils.hardAddress);
		}
		
		/**
		 * 客户端行为统计 
		 * @param actionName 操作关键字
		 * @param actionParams 操作参数
		 * 
		 */
		[inline]
		private static function _clientAction(actionName:String,actionParams:String):void
		{
			var channel:String = ConstGlobal.CHANNEL;
			var channelName:String = ConstGlobal.CHANNELNAME;
			SocketManager.o.callunlock(ConstNetCommand.CS_CLIENT_RECORD_ACTION
				,actionName
				,actionParams
				,channel
				,channelName
				,SManufacturerUtils.getManufacturerType()
				,ConstGlobal.DeviceInfo.DeviceName == null?"Unknown":ConstGlobal.DeviceInfo.DeviceName
				,Capabilities.os
				,SPlatformUtils.getApplicationVersion()
				,SNetWorkUtils.hardAddress);
		}
		
		/**
		 * 统计被拒绝用户 
		 * 
		 */
		public static function clientActionBlackDeviceUser():void
		{
			_clientAction("AC_BLACKDEIVICE","");
		}
		/**
		 * 客户端首次启动 
		 * 
		 */
		public static function clientActionfristStartup():void
		{
			_clientAction("AC_CLIENTFRISTSTARTUP","");
		}
	}
}