package SJ.Game.Platform
{
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

	public class SPlatformWANDOUJIAAndroid extends SPlatformDefault
	{
		private var _logger:Logger = Logger.getInstance(SPlatformWANDOUJIAAndroid);
		private var _uid:String = "";
		private var _sessionId:String = "";
		private var _CpOrderId:String = "";
		private var _PayConins:int = 0;
		//private var _ane:AneDispatcher = AneDispatcher.getInstance();
		
		public function SPlatformWANDOUJIAAndroid()
		{
			super();
		}	
		
		override public function startup(params:Object):void
		{
			var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
			dataReceipt.addEventListener(CJDataOfPlatformReceipt.RECEIPT_FAILED, _onReceiptFailed);
			//_ane.addEventListener(StatusEvent.STATUS, _statusHandler);
			_dispatch_init(true);
		}
		
		override public function login(callback:Function):void
		{

		}
		
		override public function logout(callback:Function):void
		{

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
					_CpOrderId = msg.retparams["orderId"] + " " + rechargeid;
					Logger.log("DKUnitPay CpOrderId: ", _CpOrderId);
					//_ane.DKUnitPay(1, "金币", msg.retparams["orderId"], int(_PayConins), "none");
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
			return _sessionId + " " + _uid;
		}
		
		private function _statusHandler(event:StatusEvent):void
		{
			
		}
	}
}