package SJ.Game.Platform
{
	/**
	 * 回调地址更改方式: 找小米讨论组更改
	 */
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.StatusEvent;
	
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_receipt;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfAccounts;
	import SJ.Game.data.CJDataOfPlatformReceipt;
	import SJ.Game.data.config.CJDataOfRechargeProperty;
	import SJ.Game.data.json.Json_recharge_setting;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.SApplicationLauch;
	import engine_starling.utils.Logger;
	import engine_starling.utils.SPlatformUtils;
	
	import net.mi.extension.MiCommplatform;
	
	import starling.core.Starling;
	import starling.events.Event;

	public class SPlatformXIAOMIAndroid extends SPlatformDefault
	{
		private var _logger:Logger = Logger.getInstance(SPlatformXIAOMIAndroid);
		private var _uid:String = "";
		private var _sessionId:String = "";
		
		private var _CpOrderId:String = "";
		private var _CpUserInfo:String = "";
		private var _MiBi:int = 0;
		private var _ortherflag:String = "";
		private var _otherkey:String = "";
		
		
		[Embed(source="../../../startupres/startup_logoHD.png")]
		private static var _self_LogoHD:Class;
		
		public function SPlatformXIAOMIAndroid()
		{
			super();
		}
		private function _addFixBackGround():void
		{
			if(SJGame.as3Root.getChildByName("fixxiaomibackground")!= null)
			{
				return;
			}
			var icon2:Bitmap = new _self_LogoHD();
			
			icon2.name = "fixxiaomibackground";
			icon2.x = SApplication.StarlingInstance.viewPort.x;
			icon2.y = SApplication.StarlingInstance.viewPort.y;
			icon2.width  = SApplication.StarlingInstance.viewPort.width;
			icon2.height = SApplication.StarlingInstance.viewPort.height;
			SJGame.as3Root.addChild(icon2);
		}
		override public function startup(params:Object):void
		{
			var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
			dataReceipt.addEventListener(CJDataOfPlatformReceipt.RECEIPT_FAILED, _onReceiptFailed);
			MiCommplatform.getInstance().addEventListener(StatusEvent.STATUS, _statusHandler);
			MiCommplatform.getInstance().initMiSDK(20764, "4bbc56cf-6590-74c6-9e4a-5260ea4b61f1", "online", "custom", "horizontal");
			_dispatch_init(true);	
			
//			SApplicationLauch.suspendRendering = false;
			
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE,function(e:*):void
			{
				_addFixBackGround();
			});
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE,function(e:*):void
			{
				var icon2:DisplayObject = SJGame.as3Root.getChildByName("fixxiaomibackground");
				if(icon2 != null)
					SJGame.as3Root.removeChild(icon2);
			});
			
		}
		
		private function _onReceiptFailed(e: Event):void
		{
			CJConfirmMessageBox(CJLang("receipt_tip")
				,function ():void{
					var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
					dataReceipt.clearVerifyreceiptTimes();
					dataReceipt.checkAndSend();
				},function():void
				{
					var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
					dataReceipt.completeReceipt();
				},
				CJLang("RECHARGE_TRYAGAIN"),
				CJLang("RECHARGE_CANCEL"));
		}
		
		override public function login(callback:Function):void
		{
			_addFixBackGround();
			MiCommplatform.getInstance().miLogin();
		}
		
		override public function getproducts():void
		{
			// 获取配置数据
			var arrayProductData:Array = _getConfigPlatformProductData();
			dispatchEventWith(SPlatformEvents.EventGetProducts, false, arrayProductData); 
		}
		
		override public function pay(orderSerial:String, PayConins:Number, paydesc:String, callback:Function):int
		{	
			var cfgData:Json_recharge_setting = CJDataOfRechargeProperty.o.getProperty(orderSerial);
			
			_CpOrderId = cfgData.rechargeid;
			_CpUserInfo = (CJDataManager.o.getData("CJDataOfAccounts") as CJDataOfAccounts).userID;
			//_MiBi的单位是元
			_MiBi = cfgData.rmbnum / 100;
				
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			SocketCommand_receipt.createOrderId("" + ConstGlobal.CHANNEL, SPlatformUtils.getApplicationVersion(), _CpOrderId);
			return 0;
		}
		
		private function _onRpcReturn(e:Event):void{
			var msg:SocketMessage = e.data as SocketMessage;
			if(msg.getCommand() == ConstNetCommand.CS_RECEIPT_CREATEORDER)
			{
				if (msg.retcode == 0)
				{
					var rechargeid:String = _CpOrderId;
					_CpOrderId = JSON.stringify({"receipt": msg.retparams["orderId"], "rechargeid":rechargeid});
					var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
					dataReceipt.saveDataToCache(ConstGlobal.CHANNELID, _CpOrderId);
					Logger.log("MiCommplatform CpOrderId: ", _CpOrderId);
					MiCommplatform.getInstance().miUniPayOnline(msg.retparams["orderId"], _CpUserInfo, _MiBi);
				}
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			}
		}
		
		override public function logout(callback:Function):void
		{
			MiCommplatform.getInstance().miLogout();
		}
		
		private function _statusHandler(event:StatusEvent):void
		{
			if(event.code == "MiLoginFunction")
			{
				_logger.info("MiLoginFunction: " + event.level);
				var code:String = String(event.level);
				var myArray:Array = code.split(":");
				/**
				 *   myArray[0] = code
				 *   myArray[1] = uid
				 *   myArray[2] = sessionId
				 * 
				 * */
				switch(int(myArray[0]))
				{
					case 0:
						_logger.info("登录成功" + myArray[1] + "..." + myArray[2]);
						_uid = myArray[1];
						_sessionId = myArray[2];
						_dispatch_login(true, "");
						break;
					case -12:
						_logger.info("取消成功" + myArray[1] + "..." + myArray[2]);
						login(null);
						return;
					default:
						_logger.info("登录错误：" + int(myArray[0]));
						_dispatch_login(false, myArray[0]);
						break;
				}
			}
			else if(event.code == "MiLoginOutFunction")
			{
				_logger.info("MiLoginOutFunction: " + event.level);
				var loginout_code:int = int(event.level);
				
				switch(loginout_code)
				{
					case -104:
						_logger.info("注销成功:" + loginout_code);
						_dispatch_logout();
						break;
					
					default:
						_logger.info("注销失败:" + loginout_code);
						break;
				}
				
			}
			else if(event.code == "MiUniPayOnlineFunction")
			{
				_logger.info("MiUniPayOnlineFunction: " + event.level);
				var online_code:int = int(event.level); 
				switch(online_code){
					case 0:
						_logger.info("购买成功");
						dispatchEventWith(SPlatformEvents.EventBuy, false, _CpOrderId);
						break; 
					default: 
						_logger.info("购买失败：" + String(online_code));
						var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
						dataReceipt.completeReceipt();
						break;
				}
			}
		}
		
		override public function SessionId():String
		{
			return _sessionId;
		}
		
		override public function uid():String
		{
			return _uid;
		}
		
	}
}