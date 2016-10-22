package SJ.Game.Platform
{
	/**
	 * 回调地址更改方式: ane pay的时候传入
	 */
	import com.kaixin.ane.yyh.AneDispatcher;
	
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

	public class SPlatformYYHAndroid extends SPlatformDefault
	{
		private var _logger:Logger = Logger.getInstance(SPlatformYYHAndroid);
		private var _uid:String = "";
		private var _sessionId:String = "";
		private var _CpOrderId:String = "";
		private var _PayConins:int = 0;
		private var _ane:AneDispatcher = AneDispatcher.getInstance();
		
		public function SPlatformYYHAndroid()
		{
			super();
		}	
		
		override public function startup(params:Object):void
		{
			var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
			dataReceipt.addEventListener(CJDataOfPlatformReceipt.RECEIPT_FAILED, _onReceiptFailed);
			
			_ane.addEventListener(StatusEvent.STATUS, _statusHandler);
			_ane.YYHInit(AneDispatcher.YYH_SDK_TYPE_LANDSCAPE, "10081");
		}
		
		override public function login(callback:Function):void
		{
			_ane.YYHLogin(AneDispatcher.YYH_SDK_TYPE_LANDSCAPE);
		}
		
		override public function logout(callback:Function):void
		{
			_ane.YYHAccountManager(AneDispatcher.YYH_SDK_TYPE_LANDSCAPE, false);
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
			//_PayConins的单位是分
			_PayConins = cfgData.rmbnum;
			
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
					Logger.log("YYH exchangeGoods CpOrderId: ", _CpOrderId);
					
					_ane.YYHPay("RkJGMUY2MjBCMDRDNTc3MkI5Q0Y5QjUyNTMxQUU2QjhGRjhENzVGRU1UYzBNelkyTWpFMU1UWTBOVGsyTmpnek1qRXJNVE0wTkRJME5qVTNNamd6TXpRME9UZzRPRGMzTmpRMU16TTVNamt6T0RBNU56QXhPRGt6",
						"http://ht.shenjiang.kaixin001.com.cn/payCallback/yyh_notify.php",
						"10030000000002100300",
						1,
						1,
						msg.retparams["orderId"],
						_PayConins,
						"");
				}
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			}
		}
		
		private function _statusHandler(event:StatusEvent):void
		{
			var code:String = String(event.level);
			var myArray:Array = code.split(":");
			if(event.code == AneDispatcher.YYH_STATUS_CODE_INIT)
			{	
				switch(int(myArray[0]))
				{
					case 0:	
					{
						_dispatch_init(true);
						break;
					}
					default:
					{
						_logger.info("YYH_STATUS_CODE_INIT, code: " + code);
						break;
					}
				}			
			}
			else if(event.code == AneDispatcher.YYH_STATUS_CODE_LOGIN)
			{
				switch(int(myArray[0]))
				{
					case 0:	
					{
						var arr:Array = myArray[1].split("_");
						_uid = arr[0];
						_sessionId = arr[1];
						_dispatch_login(true, "");
						break;
					}
					case 1:
					{
						login(null);
						break;
					}
					default:
					{
						_logger.info("YYH_STATUS_CODE_LOGIN, code: " + code);
						break;
					}
				}	
			}
			else if(event.code == AneDispatcher.YYH_STATUS_CODE_PAY)
			{
				switch(int(myArray[0]))
				{
					case 0:	
					{
						dispatchEventWith(SPlatformEvents.EventBuy, false, _CpOrderId);
						break;
					}
					case 1:
					{
						if(myArray[1] == "100")
						{
							login(null);
						}
					}
					default:
					{
						var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
						dataReceipt.completeReceipt();
						_logger.info("YYH_STATUS_CODE_PAY, code: " + code);
						break;
					}
				}	
			}
			else if(event.code == AneDispatcher.YYH_STATUS_CODE_ACCOUNTCENTER)
			{
				
			}
			else if(event.code == "logout")
			{
				_dispatch_logout();
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
		
	
	}
}