package SJ.Game.SocketServer
{
	import flash.desktop.NativeApplication;
	import flash.system.Capabilities;
	
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstOnlineDebug;
	import SJ.Game.utils.SNetWorkUtils;
	
	import engine_starling.utils.SManufacturerUtils;
	import engine_starling.utils.SPlatformUtils;
	import engine_starling.utils.SStringUtils;

	/**
	 * 帐号网络操作 
	 * @author caihua
	 * 
	 */
	public class SocketCommand_account
	{
		public function SocketCommand_account()
		{
			
		}
		/**
		 * 登录操作 
		 * @param username 用户名
		 * @param password 密码 需要外部MD5加密
		 * 
		 */
		public static function login(username:String,password:String):void
		{
			
//			var md5:MD5 = new MD5;
//			var bytes:ByteArray = new ByteArray;
//			bytes.writeUTFBytes(password);
//			var hashString:String = Hex.fromArray(md5.hash(bytes));
//			,channel,channelName,device,deviceType,version,clientVersion,clientMac
			
			CONFIG::CHANNELID_0{
				if(ConstOnlineDebug.isDebug)
				{
					if( !SStringUtils.isEmpty(ConstOnlineDebug.debugUserName))
					{
						username = ConstOnlineDebug.debugUserName;
						password = ConstOnlineDebug.debugPassword;
					}
				}
			}
			
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespace();
			var channel:String = ConstGlobal.CHANNEL;
			var channelName:String = ConstGlobal.CHANNELNAME;
			
			SocketManager.o.call(ConstNetCommand.CS_LOGIN,username,password,
				channel,channelName,ConstGlobal.DeviceInfo.DeviceName == null?"Unknown":ConstGlobal.DeviceInfo.DeviceName,
				SManufacturerUtils.getManufacturerType(),Capabilities.os,SPlatformUtils.getApplicationVersion(),SNetWorkUtils.hardAddress);
		}
		
		/**
		 * 登出操作 
		 * 
		 */
		public static function logout():void
		{
			SocketManager.o.call(ConstNetCommand.CS_LOGOUT);
		}
		
		/**
		 * 创建帐号 
		 * @param username 用户名
		 * @param password 密码  未加密
		 * 
		 */
		public static function create_account(username:String,password:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_ACCOUNT_CREATE,username,password);
		}
		
		/**
		 * 解绑快速注册关系列表对应关系
		 * @note 仅仅删除快速注册表中，玩家机器与账号的绑定关系，不对已存在数据进行操作
		 */
		public static function unbind_quick_account(mac:String, channelUserId:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_ACCOUNT_QUICK_ACCOUNT, mac,ConstGlobal.CHANNEL, channelUserId);
		}
		
		/**
		 * 获取服务器的状态
		 */
		public static function getServerStatus():void
		{
			SocketManager.o.callunlock(ConstNetCommand.CS_ACCOUNT_GET_SERVER_STATUS);
		}
	}
}