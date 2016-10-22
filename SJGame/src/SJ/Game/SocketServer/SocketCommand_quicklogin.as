package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstServerList;

	/**
	 * 快速登录rpc
	 * @author longtao
	 * 
	 */
	public final class SocketCommand_quicklogin
	{
		public function SocketCommand_quicklogin()
		{
		}
		
		/**
		 * 快速登录
		 * @param macAddr 设备Mac地址
		 * @note 该mac地址已被MD5加密
		 */
		public static function quicklogin(macAddr:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_QUICKLOGIN_QUICKLOGIN, macAddr);
		}
		/**
		 * 快速登录2.0
		 * @param macAddr 设备Mac地址
		 * @note 该mac地址已被MD5加密
		 */
		public static function quicklogin20(authorizationcode:String, channelUserId:String):void
		{
			
			SocketManager.o.callunlock(ConstNetCommand.CS_QUICKLOGIN_QUICKLOGIN20, authorizationcode,ConstGlobal.CHANNEL,channelUserId,ConstGlobal.ServerSetting.id);
		}
		
		/**
		 * 第三方创建帐号 
		 * @param username 用户名
		 * @param password 密码
		 * @param platformid 渠道ID
		 * 
		 */
		public static function thirdpartycreate(username:String,password:String,callback:Function):void
		{
			SocketManager.o.callUnlockWithRtn(ConstNetCommand.CS_QUICKLOGIN_THIRDPARTYCREATE,callback,false, username,password,ConstGlobal.CHANNEL);
		}
		
		/**
		 * 第三方用户登录 
		 * @param username
		 * @param password
		 * @param platformid
		 * 
		 */
		public static function thirdpartylogin(username:String,password:String,callback:Function):void
		{
			SocketManager.o.callUnlockWithRtn(ConstNetCommand.CS_QUICKLOGIN_THIRDPARTYLOGIN,callback,false, username,password,ConstGlobal.CHANNEL);
		}
		
		/**
		 * 解绑快速注册关系列表对应关系
		 * @note 仅仅删除快速注册表中，玩家机器与账号的绑定关系，不对已存在数据进行操作
		 */
		public static function unbind_quick_account20(authorizationcode:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_ACCOUNT_QUICK_ACCOUNT, authorizationcode);
		}
		
	}
}