package SJ.Game.Platform
{
	import com.nd.complatform.NdComPlatform;
	import com.nd.complatform.NdComPlatformEvents;
	
	import flash.events.StatusEvent;
	
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_receipt;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfPlatformReceipt;
	import SJ.Game.data.config.CJDataOfRechargeProperty;
	import SJ.Game.data.json.Json_recharge_setting;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJLayerManager;
	
	import engine_starling.utils.Logger;
	import engine_starling.utils.SPlatformUtils;
	
	import feathers.controls.Label;
	
	import starling.events.Event;

	
	public class SPlatform91IOS extends SPlatformDefault
	{
		private var _logger:Logger = Logger.getInstance(SPlatform91IOS);
		public function SPlatform91IOS()
		{
		}
		
		override public function startup(params:Object):void
		{
			NdComPlatform.getInstance().NdInitSDK(104556,"389b34c2aa81f1c2d66cea5f7ae24410d0e971ea48d1c571",1);
			NdComPlatform.getInstance().NdSetScreenOrientation(4);
			NdComPlatform.getInstance().NdSetAutoRotation(false);
			NdComPlatform.getInstance().addEventListener(StatusEvent.STATUS, _statusHandler);
			
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
		
		override public function enterpause():void
		{
			NdComPlatform.getInstance().NdPause();
		}
		
		override public function entertoolbar():void
		{
			NdComPlatform.getInstance().NdShowToolBar(1);
		}
		
		
		private function _statusHandler(event:StatusEvent):void
		{
			if(event.code == NdComPlatformEvents.kNdCPLoginNotification)
			{
				_logger.info("登录消息:" + NdComPlatformEvents.kNdCPLoginNotification);
				
				var xmlLogin:XML = XML(event.level);
				_logger.info("result:" + xmlLogin.toString());
				_logger.info("result:" + Boolean(xmlLogin.result));
				_logger.info("error:" + int(xmlLogin.error));		
				_logger.info("uid:" + NdComPlatform.getInstance().loginUin());
				_logger.info("sessionId:" + NdComPlatform.getInstance().sessionId());
				if(int(xmlLogin.result) == 1)
				{
					_dispatch_login(true,"");
				}
				else
				{
					_dispatch_login(false,"");
				}
				
			}
			else if(event.code == NdComPlatformEvents.kNdCPInitDidFinishNotification)
			{
				_logger.info("init:" + event.level);
				_dispatch_init(true);
			}
			else if(event.code == NdComPlatformEvents.kNdCPBuyResultNotification)
			{
				var xmlLogin2:XML = XML(event.level);
				
				dispatchEventWith(SPlatformEvents.EventBuy, false, _CpOrderId);
				
				if(int(xmlLogin2.result)==0)//支付宝，银行卡
				{
//					switch(int(xmlLogin2.error))
//					{
//						case -12://用户取消----NdErrorCode.ND_COM_PLATFORM_ERROR_USER_CANCEL
//							break;
//						case -2://网络连接错误----NdErrorCode.ND_COM_PLATFORM_ERROR_NETWORK_FAIL 
//							break;
//						case -10://服务器处理失败----NdErrorCode.ND_COM_PLATFORM_ERROR_SERVER_RETURN_ERROR  
//							break;
//						case -4004://订单已提交---ND_COM_PLATFORM_ERROR_ORDER_SERIAL_SUBMITTED
//							dispatchEventWith(SPlatformEvents.EventBuy, false, _CpOrderId);
//							break;
//						
//						default:
//							_logger.info("NdComlatform: 购买过程发生错误");
//							break;
//					}
				}
				
				if(int(xmlLogin2.result)==1)//91豆
				{
					
				}
			}
			
			_logger.info("_statusHandler——————event.code ："+event.code+"____"+event.level);
		}
		override public function login(callback:Function):void
		{
			NdComPlatform.getInstance().NdLogin(0);
		}
		
		override public function logout(callback:Function):void
		{
			NdComPlatform.getInstance().NdLogout(1);
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
			
			_CpOrderId = cfgData.rechargeid;//"91ios_1";//
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
					 * cooOrderSerial 	sdk所需订单号
					 * productId	产品id
					 * productOrginalPrice	产品原价
					 * productName	产品名称
					 * productPrice	产品价格
					 * productCount		产品数量(1<=count<=10000)
					 * payDescription 产品描述
					 */
//					_PayConins = 1;//debug
					NdComPlatform.getInstance().NdUniPayAsyn(msg.retparams["orderId"],
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
		
		override public function enterplatform():void
		{
			NdComPlatform.getInstance().NdEnterPlatform(0);
		}
		
		override public function getproducts():void
		{
			// 获取配置数据
			var arrayProductData:Array = _getConfigPlatformProductData();
			dispatchEventWith(SPlatformEvents.EventGetProducts, false, arrayProductData); 
		}
		
		override public function enterbbs():void
		{
			NdComPlatform.getInstance().NdEnterAppBBS(0);
		}
		
		override public function enterfeedback():void
		{
			NdComPlatform.getInstance().NdUserFeedBack();	
		}
		
		override public function uid():String
		{
			return "91key_"+NdComPlatform.getInstance().loginUin();
		}
		
		override public function SessionId():String
		{
			return uid();
		}
		
		
		
	}
}