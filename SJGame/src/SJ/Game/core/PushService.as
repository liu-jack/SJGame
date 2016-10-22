package SJ.Game.core
{
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.lang.CJLang;
	
	import com.freshplanet.nativeExtensions.PushNotification;
	import com.freshplanet.nativeExtensions.PushNotificationEvent;
	
	import engine_starling.utils.Logger;
	import engine_starling.utils.SManufacturerUtils;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.StatusEvent;
	
	import lib.engine.utils.CTimerUtils;

	/**
	 * Push服务 
	 * @author caihua
	 * 
	 */
	public class PushService
	{
		public static const RECURRENCE_NONE:int = 0;
		public static const RECURRENCE_DAY:int = 1;
		public static const RECURRENCE_WEEK:int = 2;
		public static const RECURRENCE_MONTH:int = 3;
		public static const RECURRENCE_YEAR:int = 4;

		private var _log:Logger = Logger.getInstance(PushService);
		private var _pushinstance:PushNotification = null;
		private var _devicetoken:String = null;
		public function PushService(_s:s)
		{
			_pushinstance = PushNotification.getInstance();
			if(SManufacturerUtils.getManufacturerType() == SManufacturerUtils.TYPE_ANDROID)
			{
				_pushinstance.registerForPushNotification();
			}
			else
			{
				_pushinstance.registerForPushNotification();
			}
				
			
			if ( _pushinstance.isPushNotificationSupported )
			{
				_pushinstance.addListenerForStarterNotifications(onStartUpByPush);
				
				_pushinstance.addEventListener(PushNotificationEvent.PERMISSION_GIVEN_WITH_TOKEN_EVENT,sendDeviceTokenToServer);
				_pushinstance.addEventListener(PushNotificationEvent.PERMISSION_REFUSED_EVENT,sendDeviceTokenToServerFailed);
				
				//取消本地的Nofity
				_pushinstance.cancelAllLocalNotification();
				
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE,_onActive);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,_onDeActive);
				
				_log.info("Support push NotifyNotification");
				
			}			
		}
		
		private function _onActive(e:Event):void
		{
			_log.info("Support push NotifyNotification _onActive");
			_pushinstance.setIsAppInForeground(false);
			_pushinstance.cancelAllLocalNotification();
		}
		private function _onDeActive(e:Event):void
		{
			_log.info("Support push NotifyNotification _onDeActive");
			
			
			_pushinstance.setIsAppInForeground(false);
			_sendCallbackNotification();
		}
		
		//发送召回push
		private function _sendCallbackNotification():void
		{
			var currentlocaltimeInday:Number = (CTimerUtils.getCurrentMiSecondLocal() / 1000) % CTimerUtils.TotalSecDay;
			var difftime:Number = (10 * CTimerUtils.TotalSecHour - currentlocaltimeInday);
			var currentsecond:Number = difftime + CTimerUtils.TotalSecDay;
			//每天10点发送
			currentsecond =currentsecond + CTimerUtils.getCurrentTime() / 1000;
			sendLocalNotification(CJLang("LOCALNOTIFICATION_NOTICE_NEXT_DAY"),currentsecond,CJLang("PUSH_TITLE"), 1);
			for(var i:int=1;i<30;i++)
			{
				currentsecond += i * CTimerUtils.TotalSecDay;
				sendLocalNotification(CJLang("LOCALNOTIFICATION_NOTICE_NEXT_DAY"),currentsecond,CJLang("PUSH_TITLE"));
			}
			
		}
		private static var _o:PushService = null;
		public static function get o():PushService
		{
			if(_o == null)
			{
				_o = new PushService(new s());
			}
			return _o;
		}
		/**
		 * 是否开启 
		 * @return 
		 * 
		 */
		public static function get enable():Boolean
		{
			return PushNotification.getInstance().isPushNotificationSupported;
		}
		public function getDeviceToken():String
		{
			return _devicetoken;
		}
		
		protected function onStartUpByPush(event:PushNotificationEvent):void
		{
			
			
			_log.debug("onStartUpByPush " + event.type + " with tokenString:" + JSON.stringify(event.parameters)+ "\n");
		}
		protected function sendDeviceTokenToServer(event:PushNotificationEvent):void
		{
			if(SManufacturerUtils.getManufacturerType() == SManufacturerUtils.TYPE_ANDROID)
			{
				_devicetoken = event.token;
				_log.debug("Received " + event.type + " with tokenString:" + _devicetoken + "\n");
			}
			else
			{
				_devicetoken = event.token.replace("<","").replace(">","");
				_log.debug("Received " + event.type + " with tokenString:" + _devicetoken + "\n");
			}
		}
		protected function sendDeviceTokenToServerFailed(event:PushNotificationEvent):void
		{
			
			_log.debug("Received " + event.type + " with tokenString:" + event.token + "\n");
		}

		public function get pushinstance():PushNotification
		{
			return _pushinstance;
		}
		
		/**
		 * 发送本地PUSH
		 * @param message			PUSH信息
		 * @param timestamp			PUSH时间 LocalTime   秒
		 * @param title				标题
		 * @param recurrenceType	循环类型
		 * 
		 */
		public function sendLocalNotification(message:String, timestamp:Number, title:String, recurrenceType:int=RECURRENCE_NONE):void
		{
	
			// 获取传入时间戳Date
			var d:Date = new Date(timestamp * 1000);
			// Push开始时间
			var pushOpenTimeMin:int = int(CJDataOfGlobalConfigProperty.o.getData("PUSHOPENTIMEMIN"));
			// Push结束时间
			var pushOpenTimeMax:int = int(CJDataOfGlobalConfigProperty.o.getData("PUSHOPENTIMEMAX"));
			
			/// 仅有符合推送时间可进行Push推送
			if ( d.hours < pushOpenTimeMin || d.hours > pushOpenTimeMax )
				return;
			
			// 进行推送
			_pushinstance.sendLocalNotification(message, timestamp, title, recurrenceType);
		}
	}
}

class s{}