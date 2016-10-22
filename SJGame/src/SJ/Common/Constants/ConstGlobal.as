package SJ.Common.Constants
{
	import com.kaixin001.fxane.ADeviceInfo;
	
	import SJ.Game.data.json.Json_serverlist;

	/**
	 *  全局性配置
	 * @author yongjun
	 * 
	 */
	public class ConstGlobal
	{
		public function ConstGlobal()
		{
		}
		/***** 语言标识      中文CN 英文EN*****/
		public static const LANG:String = "CN";
		/***** 发布版本服务器IP ****/
		/**
		 * 默认获取Md5文件的地址.用于
		 * 1.第一次安装程序
		 * 2.配置删除 
		 */
		public static var Default_MD5_Path:String = "http://xzoo.kaixin009.com/img/zipd/xzoo/remoteResource/";
		/**
		 * 默认资源CDN路径 
		 */
		public static var Default_Resource_Path:String = "http://xzoo.kaixin009.com/img/zipd/xzoo/remoteResource/";

		/**
		 * 服务器全局配置 
		 */
		public static var ServerSetting:Json_serverlist = new Json_serverlist();
		
		
		
		
		/**
		 * 平台ID 
		 */
		public static const CHANNELID:String = ConstPlatformId.getCHANNELID();
		/**
		 * 0  内部测试
		 * 1  开心网
		 * 2 91助手(破解版)
		 * 3 app-store
		 * 4 91助手 Android版本
		 * 5 同步推
		 */
		public static const CHANNEL:String = ConstPlatformId.PlatformIds[CHANNELID];
		public static const CHANNELNAME:String = ConstPlatformId.PlatformDesc[CHANNELID];
		
		
		/**
		 * 服务器分组ID
		 * 0 内网服务器
		 * 1 外网公用服务器
		 * 2. 测试服务器
		 * .... 定制 
		 */
		public static const ServerGroupId:int = ConstPlatformId.PlatformServerGroupId[CHANNELID];
		/**
		 * 审核服务器ID 
		 */
		public static const ServerVerifyId:int = ConstPlatformId.PlatformServerVerifyId[CHANNELID];
		
		
		
		/**
		 * 收发包网络流量 
		 */
		public static var net_cmd_bytes:Number = 0;
		
		/**
		 * 网络下载资源流量 
		 */
		public static var net_download_bytes:Number = 0;
		
		
		/**
		 * 设备信息 
		 */
		public static var DeviceInfo:ADeviceInfo;
		
		/**
		 * 高级设备 
		 */
		public static const DeviceLevel_High:String = "DeviceLevel_High";
		/**
		 * 普通设备 
		 */
		public static const DeviceLevel_Normal:String = "DeviceLevel_Normal";
		/**
		 * 低级设备 
		 */
		public static const DeviceLevel_Low:String = "DeviceLevel_Low";
		
		/**
		 * 当前设备类型 
		 */
		public static var DeviceLevel:String = DeviceLevel_Normal;
	}
}