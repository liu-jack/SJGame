package SJ.Game.Platform
{
	/**
	 * 回调地址更改方式: 开发者后台配置
	 */
	import com.dklib.AneDispatcher;
	
	import flash.events.StatusEvent;
	
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_receipt;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfPlatformReceipt;
	import SJ.Game.data.config.CJDataOfRechargeProperty;
	import SJ.Game.data.json.Json_recharge_setting;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	
	import engine_starling.utils.Logger;
	import engine_starling.utils.SPlatformUtils;
	
	import starling.events.Event;

	public class SPlatformDUOKUAndroid extends SPlatformDefault
	{
		private var _logger:Logger = Logger.getInstance(SPlatformDUOKUAndroid);
		private var _uid:String = "";
		private var _sessionId:String = "";
		private var _CpOrderId:String = "";
		private var _PayConins:int = 0;
		private var _ane:AneDispatcher = AneDispatcher.getInstance();
		
		public function SPlatformDUOKUAndroid()
		{
			super();
		}	
		
		override public function startup(params:Object):void
		{
			var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
			dataReceipt.addEventListener(CJDataOfPlatformReceipt.RECEIPT_FAILED, _onReceiptFailed);
			_ane.addEventListener(StatusEvent.STATUS, _statusHandler);
			_ane.DKSdkInit("1657", "d744b3eb66ef6a629a09774382b6a695", "8f8adeafd41f9733cf22f84b3b3f93ae");
			_ane.DKSetScreen(1);
			_dispatch_init(true);
		}
		
		override public function login(callback:Function):void
		{
			_ane.DKLogin();
		}
		
		override public function logout(callback:Function):void
		{
			_ane.DKAccountManager();
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
			//_PayConins的单位是元
			_PayConins = cfgData.rmbnum / 100;
			
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
					Logger.log("DKUnitPay CpOrderId: ", _CpOrderId);
					_ane.DKUnitPay(1, "金币", msg.retparams["orderId"], int(_PayConins), "none");
				}
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			}
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
		 	if(event.code == "DKLogoutCode")
			{	
				_logger.info("DKLogoutCode: " + event.level);
				_dispatch_logout();
			}
			else if(event.code == "LoginCode")
			{
				_logger.info("LoginCode: " + event.level);
				switch (event.level) {
					case "1011":
						login(null);
						break;
					case "1106":
						login(null);
						break;
					case "1021":
						_uid = AneDispatcher.getInstance().DKUid();
						_sessionId = AneDispatcher.getInstance().DKSession();
						_dispatch_login(true, "");
						
						break;
					default :
						_dispatch_login(false, "fuck");
						break;
				}
				
			}
			else if(event.code == "DKCharge")
			{
				_logger.info("DKCharge: " + event.level);
				
			}
			else if(event.code == "DKCode")
			{
				_logger.info("DKCode: " + event.level);
				switch (event.level) {
					case "1010":
						dispatchEventWith(SPlatformEvents.EventBuy, false, _CpOrderId);
						break;
					case "1012":
						var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
						dataReceipt.completeReceipt();
						break;
					default :
						break;
				}
			}
		}
	}
}