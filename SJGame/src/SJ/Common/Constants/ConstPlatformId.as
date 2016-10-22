package SJ.Common.Constants
{
	import flash.utils.Dictionary;
	
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;

	public final class ConstPlatformId
	{
		/**
		 * 0内网测试
		 * 1破解渠道公网服务器
		 * 2外网测试服务器
		 * 3审核服务器
		 * 4苹果渠道公网服务器 
		 * 
		 */
		public function ConstPlatformId()
		{
		}
		
		public static var PlatformDesc:Dictionary = new Dictionary();
		public static var PlatformServerGroupId:Dictionary = new Dictionary();
		public static var PlatformServerVerifyId:Dictionary = new Dictionary();
		public static var channelIdSignDict:Dictionary = new Dictionary();

		/**
		 * 苹果审核渠道 
		 */
		public static const PlatformVerifyID_AppStore:int = 3000;
		/**
		 * 破解渠道审核服务器 
		 */
		public static const PlatformVerifyID_Hack:int = 3001;
		/**
		 * 渠道ID 
		 */
		public static var PlatformIds:Dictionary = new Dictionary();
		/**
		 * 当前渠道是否走web充值
		 * @param channelid
		 * @return 
		 * 
		 */		
		public static function isWebChargeChannel():Boolean
		{
			var webChannles:String = CJDataOfGlobalConfigProperty.o.getData("WEB_CHARGE_CHANNELS");
			var webChannelArr:Array = webChannles.split("&");
			return webChannelArr.indexOf(PlatformIds[ConstGlobal.CHANNELID]) !=-1;
		}
		/**
		 * 根据编译选项CONFIG::CHANNELID 获取当前CHANNELID
		 * 给静态变量赋值,只会执行一次
		 */
		public static function getCHANNELID():String
		{		
			var CHANNELID:String = ID_DEBUG;
			
			if(CONFIG::CHANNELID == 0)
			{
				return ID_DEBUG;
			}
			
			for(var key:String in PlatformIds)
			{
				if(PlatformIds[key] == CONFIG::CHANNELID)
				{
					CHANNELID = key;
					break;
				}
			}
			return CHANNELID;
		}
		
		public static const ID_DEBUG:String = "ID_DEBUG";
		PlatformIds[ID_DEBUG] = "0";
		PlatformDesc[ID_DEBUG] = "DEBUG";
		PlatformServerGroupId[ID_DEBUG] = 0;
		PlatformServerVerifyId[ID_DEBUG] = PlatformVerifyID_Hack;
		
		public static const ID_DEBUGONLINE:String = "ID_DEBUGONLINE";
		PlatformIds[ID_DEBUGONLINE] = "0";
		PlatformDesc[ID_DEBUGONLINE] = "DEBUGONLINE";
		PlatformServerGroupId[ID_DEBUGONLINE] = 2;
		PlatformServerVerifyId[ID_DEBUGONLINE] = PlatformVerifyID_Hack;
			
		public static const ID_KAIXIN:String = "ID_KAIXIN";
		PlatformIds[ID_KAIXIN] = "1";
		PlatformDesc[ID_KAIXIN] = "KAIXIN";
		PlatformServerGroupId[ID_KAIXIN] = 1;
		PlatformServerVerifyId[ID_KAIXIN] = PlatformVerifyID_Hack;
		channelIdSignDict[ID_KAIXIN] = "c";
		
		
		public static const ID_91IOS:String = "ID_91IOS";
		PlatformIds[ID_91IOS] = "2";
		PlatformDesc[ID_91IOS] = "91IOS";
		PlatformServerGroupId[ID_91IOS] = 1;
		PlatformServerVerifyId[ID_91IOS] = PlatformVerifyID_Hack;
		
		public static const ID_APPSTORE:String = "ID_APPSTORE";
		PlatformIds[ID_APPSTORE] = "3";
		PlatformDesc[ID_APPSTORE] = "app-store";
		PlatformServerGroupId[ID_APPSTORE] = 4;
		PlatformServerVerifyId[ID_APPSTORE] = PlatformVerifyID_AppStore;
		
		public static const ID_91ANDROID:String = "ID_91ANDROID";
		PlatformIds[ID_91ANDROID] = "4";
		PlatformDesc[ID_91ANDROID] = "91ANDROID";
		PlatformServerGroupId[ID_91ANDROID] = 1;
		PlatformServerVerifyId[ID_91ANDROID] = PlatformVerifyID_Hack;
		
		public static const ID_TONGBU:String = "ID_TONGBU";
		PlatformIds[ID_TONGBU] = "5";
		PlatformDesc[ID_TONGBU] = "TONGBU";
		PlatformServerGroupId[ID_TONGBU] = 1;
		PlatformServerVerifyId[ID_TONGBU] = PlatformVerifyID_Hack;
		
//		public static const ID_KUAIYONG:String = "ID_KUAIYONG";
//		PlatformIds[ID_KUAIYONG] = "6";
//		PlatformDesc[ID_KUAIYONG] = "KUAIYONG";
//		PlatformServerGroupId[ID_KUAIYONG] = 1;
//		PlatformServerVerifyId[ID_KUAIYONG] = PlatformVerifyID_Hack;
		
		public static const ID_ANDRIODMARKET:String = "ID_ANDRIODMARKET";
		PlatformIds[ID_ANDRIODMARKET] = "7";
		PlatformDesc[ID_ANDRIODMARKET] = "ANDRIODMARKET";
		PlatformServerGroupId[ID_ANDRIODMARKET] = 1;
		PlatformServerVerifyId[ID_ANDRIODMARKET] = PlatformVerifyID_Hack;
		
		public static const ID_ANDRIODKAIXIN:String = "ID_ANDRIODKAIXIN";
		PlatformIds[ID_ANDRIODKAIXIN] = "8";
		PlatformDesc[ID_ANDRIODKAIXIN] = "KAIXINANDRIOD";
		PlatformServerGroupId[ID_ANDRIODKAIXIN] = 1;
		PlatformServerVerifyId[ID_ANDRIODKAIXIN] = PlatformVerifyID_Hack;
		channelIdSignDict[ID_ANDRIODKAIXIN] = "a";
		
		public static const ID_IOSUC:String = "ID_IOSUC";
		PlatformIds[ID_IOSUC] = "9";
		PlatformDesc[ID_IOSUC] = "UCIOS";
		PlatformServerGroupId[ID_IOSUC] = 1;
		PlatformServerVerifyId[ID_IOSUC] = PlatformVerifyID_Hack;
		
		public static const ID_ANDRIODUC:String = "ID_ANDRIODUC";
		PlatformIds[ID_ANDRIODUC] = "10";
		PlatformDesc[ID_ANDRIODUC] = "UCANDRIOD";
		PlatformServerGroupId[ID_ANDRIODUC] = 1;
		PlatformServerVerifyId[ID_ANDRIODUC] = PlatformVerifyID_Hack;
		
		public static const ID_ANDROID360:String = "ID_ANDROID360";
		PlatformIds[ID_ANDROID360] = "12";
		PlatformDesc[ID_ANDROID360] = "360ANDROID";
		PlatformServerGroupId[ID_ANDROID360] = 1;
		PlatformServerVerifyId[ID_ANDROID360] = PlatformVerifyID_Hack;
		
		public static const ID_ANDROIDXIAOMI:String = "ID_ANDROIDXIAOMI";
		PlatformIds[ID_ANDROIDXIAOMI] = "13";
		PlatformDesc[ID_ANDROIDXIAOMI] = "XIAOMIANDROID";
		PlatformServerGroupId[ID_ANDROIDXIAOMI] = 1;
		PlatformServerVerifyId[ID_ANDROIDXIAOMI] = PlatformVerifyID_Hack;
		
		public static const ID_ANDROIDDUOKU:String = "ID_ANDROIDDUOKU";
		PlatformIds[ID_ANDROIDDUOKU] = "14";
		PlatformDesc[ID_ANDROIDDUOKU] = "DUOKUANDROID";
		PlatformServerGroupId[ID_ANDROIDDUOKU] = 1;
		PlatformServerVerifyId[ID_ANDROIDDUOKU] = PlatformVerifyID_Hack;
		
		public static const ID_ANDROIDDOWNJOY:String = "ID_ANDROIDDOWNJOY";
		PlatformIds[ID_ANDROIDDOWNJOY] = "15";
		PlatformDesc[ID_ANDROIDDOWNJOY] = "DOWNJOYANDROID";
		PlatformServerGroupId[ID_ANDROIDDOWNJOY] = 1;
		PlatformServerVerifyId[ID_ANDROIDDOWNJOY] = PlatformVerifyID_Hack;
		
		public static const ID_IOSKUAIYONG:String = "ID_IOSKUAIYONG";
		PlatformIds[ID_IOSKUAIYONG] = "16";
		PlatformDesc[ID_IOSKUAIYONG] = "KUAIYONGIOS";
		PlatformServerGroupId[ID_IOSKUAIYONG] = 1;
		PlatformServerVerifyId[ID_IOSKUAIYONG] = PlatformVerifyID_Hack;
		
		public static const ID_ANDROIDYYH:String = "ID_ANDROIDYYH";
		PlatformIds[ID_ANDROIDYYH] = "17";
		PlatformDesc[ID_ANDROIDYYH] = "YYHANDROID";
		PlatformServerGroupId[ID_ANDROIDYYH] = 1;
		PlatformServerVerifyId[ID_ANDROIDYYH] = PlatformVerifyID_Hack;

		public static const ID_ANDROIDWANDOUJIA:String = "ID_ANDROIDWANDOUJIA";
		PlatformIds[ID_ANDROIDWANDOUJIA] = "18";
		PlatformDesc[ID_ANDROIDWANDOUJIA] = "WANDOUJIAANDROID";
		PlatformServerGroupId[ID_ANDROIDWANDOUJIA] = 1;
		PlatformServerVerifyId[ID_ANDROIDWANDOUJIA] = PlatformVerifyID_Hack;
		
		public static const ID_IOSPPZHUSHOU:String = "ID_IOSPPZHUSHOU";
		PlatformIds[ID_IOSPPZHUSHOU] = "19";
		PlatformDesc[ID_IOSPPZHUSHOU] = "PPZHUSHOUIOS";
		PlatformServerGroupId[ID_IOSPPZHUSHOU] = 1;
		PlatformServerVerifyId[ID_IOSPPZHUSHOU] = PlatformVerifyID_Hack;
		
		public static const ID_KAIXINDINGKAI:String = "ID_KAXINDINGKAI";
		PlatformIds[ID_KAIXINDINGKAI] = "20";
		PlatformDesc[ID_KAIXINDINGKAI] = "ID_KAXINDINGKAI";
		PlatformServerGroupId[ID_KAIXINDINGKAI] = 1;
		PlatformServerVerifyId[ID_KAIXINDINGKAI] = PlatformVerifyID_Hack;
		channelIdSignDict[ID_KAIXINDINGKAI] = "b";
		
		public static const ID_9SPLAY:String = "ID_9SPLAY";
		PlatformIds[ID_9SPLAY] = "21";
		PlatformDesc[ID_9SPLAY] = "ID_9SPLAY";
		PlatformServerGroupId[ID_9SPLAY] = 1;
		PlatformServerVerifyId[ID_9SPLAY] = PlatformVerifyID_Hack;
		
		public static const ID_ANZHI:String = "ID_ANZHI";
		PlatformIds[ID_ANZHI] = "22";
		PlatformDesc[ID_ANZHI] = "ID_ANZHI";
		PlatformServerGroupId[ID_ANZHI] = 1;
		PlatformServerVerifyId[ID_ANZHI] = PlatformVerifyID_Hack;
		channelIdSignDict[ID_ANZHI] = "d";
		
	}
}