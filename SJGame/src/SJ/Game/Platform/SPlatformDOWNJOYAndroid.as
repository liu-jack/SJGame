package SJ.Game.Platform
{
	import com.downjoy.ane.*;
	
	import engine_starling.utils.Logger;
	
	import flash.events.StatusEvent;

	public class SPlatformDOWNJOYAndroid extends SPlatformDefault
	{
		private var _logger:Logger = Logger.getInstance(SPlatformDOWNJOYAndroid);
		private var _uid:String = "";
		private var _sessionId:String = "";
		private var _CpOrderId:String = "";
		
		public function SPlatformDOWNJOYAndroid()
		{
			super();
		}
		
		override public function startup(params:Object):void
		{
			DLExtension.getInstance().addEventListener(StatusEvent.STATUS, _statusHandler);
			/**
			 * 
			 * @param merchantId   当乐分配的MERCHANT_ID
			 * @param appId 当乐分配的APP_ID
			 * @param serverSeqNum 当乐分配的SERVER_SEQ_NUM，不同服务器序列号可使用不同计费通知地址
			 * @param appKey 当乐分配的APP_KEY
			 * @return 
			 * 
			 */	
			DLExtension.getInstance().DLInit("merchantId", "879", "serverSeqNum", "a29wbDdevgNG");
		}		
		
		override public function login(callback:Function):void
		{
			DLExtension.getInstance().DLLogIn(0);
		}
		
		override public function logout(callback:Function):void
		{
			DLExtension.getInstance().ExitSDKHandle(0);
		}
		
		override public function pay(orderSerial:String, PayConins:Number, paydesc:String, callback:Function):int
		{
			//CpOrderId
			//rmb
			//productName
			_CpOrderId = orderSerial;		
			var data:Vector.<String> = new Vector.<String>();
			data.push(_CpOrderId);
			data.push("" + int(PayConins));
			data.push(paydesc);
			DLExtension.getInstance().DLPay(data);
			return 0;
		}
		
		override public function uid():String
		{
			return _uid;
		}
		
		override public function SessionId():String
		{
			return _sessionId;
		}
		
		private function _statusHandler(event:StatusEvent):void
		{
			var Str:String;
			var Arr:Array; 
			if(event.code == DLEvents.DOUWAN_INIT_STATUS)
			{
				_logger.info(event.level);
				_dispatch_init(true);
			}
			else if(event.code == DLEvents.DOUWAN_LOGIN_STATUS)
			{
				Str = event.level;
				Arr = Str.split("*",Str.length); 
				switch (Arr.length) {
					case 1 :
						_logger.info(event.level);
						_dispatch_login(false, event.level);
						break;
					case 6 :
						_logger.info("DOUWAN_LOGIN_STATUS: memberId: " + Arr[2]);
						_logger.info("DOUWAN_LOGIN_STATUS: username: " + Arr[3]);
						_logger.info("DOUWAN_LOGIN_STATUS: nickname: " + Arr[4]);
						_logger.info("DOUWAN_LOGIN_STATUS: token: " + Arr[5]);
						_uid = Arr[2];
						_sessionId = Arr[5];
						_dispatch_login(true, "");
						break;
					default :
						_dispatch_login(false, "fuck");
						break;
				}
				
			}
			else if(event.code == DLEvents.DOUWAN_LOGOUT_STATUS)
			{
				_logger.info("DOUWAN_LOGOUT_STATUS: " + event.level);
				_dispatch_logout();
			}
			else if(event.code == DLEvents.DOUWAN_PAY_STATUS)
			{
				_logger.info("DOUWAN_PAY_STATUS: " + event.level);
				Str = event.level;
				Arr = Str.split("success!",Str.length); 
				if(Arr.length == 2)
				{
					_dispatch_buy(true, _CpOrderId);
				}
				else 
				{
					Arr = Str.split("Error",Str.length); 
					if(Arr.length > 1)
					{
						_dispatch_buy(false, "");
					}
				}
				
				
			} 
			else if(event.code == DLEvents.DOUWAN_ENTER_USER_INFO_SAMPLE_STATUS)
			{
				_logger.info("DOUWAN_ENTER_USER_INFO_SAMPLE_STATUS: " + event.level);
			} 			
			
		}
		
		override public function clearcache():void
		{
			
		}
		
		override public function enterbbs():void
		{
			
		}
		
		override public function enterfeedback():void
		{
			
		}
		
		override public function getproducts():void
		{
			DLExtension.getInstance().DLenterUserInfo(0);
		}
		
		override public function enterpause():void
		{
			
		}
		
		override public function enterplatform():void
		{
			
		}
		
		override public function entertoolbar():void
		{
			
		}
	}
}