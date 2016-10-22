package SJ.Game.Platform
{
	import com.nd.ane.NdCommplatform;
	
	import flash.events.KeyboardEvent;
	import flash.events.StatusEvent;
	import flash.ui.Keyboard;
	
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
	import SJ.Game.utils.SApplicationUtils;
	
	import engine_starling.utils.Logger;
	import engine_starling.utils.SPlatformUtils;
	
	import starling.core.Starling;
	import starling.events.Event;

	/**
	 * 91android
	 * @author caihua
	 * 
	 */
	public class SPlatform91Android extends SPlatformDefault
	{
		
		public function SPlatform91Android()
		{
			super();
		}
		
		private var _logger:Logger = Logger.getInstance(SPlatform91Android);

		override public function startup(params:Object):void
		{
//			NdCommplatform.getInstance().ndSetDebugMode();
			NdCommplatform.getInstance().init91SDK(107145,"9821b9541d506e9f070a869d1d202277d68bfcd802b322a3",1);
			
			NdCommplatform.getInstance().ndSetScreenOrientation(1);
			NdCommplatform.getInstance().addEventListener(StatusEvent.STATUS, _statusHandler);
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN,_handle_KeyDown);
			
			var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
			dataReceipt.addEventListener(CJDataOfPlatformReceipt.RECEIPT_FAILED, _onReceiptFailed);
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
		
		private function _handle_KeyDown(e:KeyboardEvent):void
		{

			switch(e.keyCode)
			{
				case Keyboard.BACK: // user hit the back button on Android device
				case Keyboard.MENU:
				case 0x1000016:
				case 0x1000012:
				{  
					NdCommplatform.getInstance().ndExit();
					e.preventDefault();
					e.stopImmediatePropagation();
					break;
				}
			}
		}
		
		override public function login(callback:Function):void
		{
			var res:String = NdCommplatform.getInstance().ndLogin();
			_logger.info("ndlogin:{0}",res);
		}
		
		override public function logout(callback:Function):void
		{
			
			NdCommplatform.getInstance().ndLogout(1);
			_dispatch_logout();
		}
		
		private var _CpOrderId:String;
		private var _CpOrderName:String;
		private var _PayConins:int;
		
		/**
		 * 支付 
		 * @param orderSerial 订单序列号 -- 此处为配置id(CJDataOfPlatformProduct.productId)
		 * @param PayConins 代币数量  -- 此处为人民币充值金额
		 * @param paydesc 支付描述
		 * @param callback 结果回调
		 * @return 
		 */
		override public function pay(orderSerial:String, PayConins:Number, paydesc:String, callback:Function):int
		{
			//根据订单号获得charge信息
			var cfgData:Json_recharge_setting = CJDataOfRechargeProperty.o.getProperty(orderSerial);
			
			_CpOrderId = cfgData.rechargeid;//"91andriod_1";//
			_CpOrderName = cfgData.goldnum+"元宝";//cfgData.dbname;//"cjgame";//
			_PayConins = cfgData.rmbnum/100;//1;//
			
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
					
					/**
					 * serial 	sdk所需订单号
					 * productId	产品id
					 * productName	产品名称
					 * productOrginalPrice	产品原价
					 * productPrice	产品价格
					 * count		产品数量(1<=count<=10000)
					 * desription 产品描述
					 */
//					_PayConins = 1;
					NdCommplatform.getInstance().ndUniPayAsyn(msg.retparams["orderId"],
																				rechargeid,
																				_CpOrderName,
																				_PayConins,
																				_PayConins,
																				1,
																				"");
				}
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			}
		}
		
		private function _statusHandler(event:StatusEvent):void
		{
			if(event.code == NdCommplatform.ND_LOGIN_FUNCTION)
			{
				_logger.info("登录消息:" + NdCommplatform.ND_LOGIN_FUNCTION);
				var code:int = int(event.level);
				if(code == 0)
				{
					_logger.info("uid:" + NdCommplatform.getInstance().ndGetLoginUin());
					_logger.info("sessionId:" + NdCommplatform.getInstance().ndGetSessionId());
					_dispatch_login(Boolean(true),"");
				}
				else if (code == -12)
				{
					//xx
					login(null);
				}
				else 
				{
					_dispatch_login(false,"" +code);
				}
				
			}
			else if(event.code == NdCommplatform.ND_INIT_FUNCTION)
			{
				_logger.info("init:" + event.level);
				switch(int(event.level))
				{
					case 0:
						_dispatch_init(true);
						break;
					default:
						SApplicationUtils.exit();
						break;
				}
			}
			else if(event.code == NdCommplatform.ND_EXIT_FUNCTION) 
			{
				SApplicationUtils.exit();
				
			}
			else if(event.code == "NdUniPayAsynFunction")
			{
				/**
				 * 收到购买消息时判断如下三种状态时进行刷新
				 * 0 购买成功
				 * -6004 订单已提交，充值短信已发送(充值到账存在延时，服务端可能不能及时得到该物品的状态信息)
				 * -4004 订单已提交(充值到账存在延时，服务端可能不能及时得到该物品的状态信息)
				 */
				dispatchEventWith(SPlatformEvents.EventBuy, false, _CpOrderId);
//				switch(int(event.level))
//				{
//					case 0://购买成功----NdErrorCode.ND_COM_PLATFORM_SUCCESS
//						
//						dispatchEventWith(SPlatformEvents.EventBuy, false, _CpOrderId);
//						
//						break;
//					case -18003://购买失败----NdErrorCode.ND_COM_PLATFORM_ERROR_PAY_FAILURE 
//						var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
//						dataReceipt.completeReceipt();
//						break;
//					case -18004://购买取消----NdErrorCode.ND_COM_PLATFORM_ERROR_PAY_CANCEL 
//						var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
//						dataReceipt.completeReceipt();
//						break;
//					case -6004://订单已提交，充值短信已发送----NdErrorCode.ND_COM_PLATFORM_ERROR_PAY_ASYN_SMS_SENT 
//						dispatchEventWith(SPlatformEvents.EventBuy, false, _CpOrderId);
//						break;
//					case -4004://订单已提交----NdErrorCode.ND_COM_PLATFORM_ERROR_PAY_REQUEST_SUBMITTED 
//						dispatchEventWith(SPlatformEvents.EventBuy, false, _CpOrderId);
//						break;
//					
//					default:
//						_logger.info("NdCommplatform: 购买失败");
//						break;
//				}
			}
			_logger.info("_statusHandler——————event.code ："+event.code+"____"+event.level);
		}
		
		override public function enterpause():void
		{
			NdCommplatform.getInstance().ndPause();
		}
		
		override public function entertoolbar():void
		{
			NdCommplatform.getInstance().ndToolBarShow(1);
		}
		
		
		override public function enterplatform():void
		{
			NdCommplatform.getInstance().ndEnterPlatform();
		}
		
		
		override public function enterbbs():void
		{
			NdCommplatform.getInstance().ndEnterAppBBS();
		}
		
		override public function enterfeedback():void
		{
			NdCommplatform.getInstance().ndUserFeedBack();
		}
		
		override public function uid():String
		{
			return "91key_"+NdCommplatform.getInstance().ndGetLoginUin();
		}
		
		override public function SessionId():String
		{
			return uid();
		}
		
		
	}
}