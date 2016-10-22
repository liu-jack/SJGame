package SJ.Game.Platform
{
	/**
	 * 回调地址更改方式: 开发者后台配置
	 */
	import flash.desktop.NativeApplication;
	import flash.display.StageOrientation;
	import flash.events.InvokeEvent;
	import flash.utils.getTimer;
	
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
	
	import engine_starling.SApplication;
	import engine_starling.utils.Logger;
	import engine_starling.utils.SPlatformUtils;
	
	import ppEvents.PPClosePageViewEvent;
	import ppEvents.PPCloseWebViewEvent;
	import ppEvents.PPLogOffEvent;
	import ppEvents.PPLoginEvent;
	import ppEvents.PPPayEvent;
	import ppEvents.PPVerifyingUpdatePassEvent;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.TouchEvent;

	public class SPlatformPPZHUSHOUIOS extends SPlatformDefault
	{
		private var _logger:Logger = Logger.getInstance(SPlatformPPZHUSHOUIOS);
		private var _uid:String = "";
		private var _sessionId:String = "";
		private var _CpOrderId:String = "";
		private var _PayConins:int = 0;
		private var _ane:PPAne = PPAne.getInstance();
		private var _time: int;
		
		public function SPlatformPPZHUSHOUIOS()
		{
			super();
		}	
		
		override public function startup(params:Object):void
		{
			var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
			dataReceipt.addEventListener(CJDataOfPlatformReceipt.RECEIPT_FAILED, _onReceiptFailed);
			
			_ane.initSDKPlatform(1971,"7236b7403243e22ebd2fdbe82b197db2",10,true,true,true,true,"关闭充值提示语",true,true,false,false);
			_ane.addEventListener(PPClosePageViewEvent.PP_CLOSEPAGEVIEW_EVENT,ppClosePageViewEvent);
			_ane.addEventListener(PPCloseWebViewEvent.PP_CLOSEWEBVIEW_EVENT,ppCloseWebViewEvent);
			_ane.addEventListener(PPLoginEvent.PP_LOGIN_EVENT,ppLoginEvent);
			_ane.addEventListener(PPLogOffEvent.PP_LOGOFF_EVENT,ppLogOffEvent);
			_ane.addEventListener(PPPayEvent.PP_PAY_EVENT,ppPayEvent);
			_ane.addEventListener(PPVerifyingUpdatePassEvent.PP_VERIFYINGUPDATEPASS_EVENT,ppVerifyingUpdatePassEvent);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE,
				function invokeHandler(event:InvokeEvent):void{
					if(event.arguments.length > 0){
						_ane.alixPayResult(event.arguments[0]);
					}
				});

			_dispatch_init(true);
		}
		
		private function _onOrientation(event: TouchEvent):void
		{
			if (getTimer() < _time + 1000)
				return;
			if(Starling.current.nativeStage.orientation != StageOrientation.ROTATED_RIGHT)
			{
				Starling.current.nativeStage.setOrientation(StageOrientation.ROTATED_RIGHT);
			}
			SApplication.UIRootNode.stage.removeEventListener(starling.events.TouchEvent.TOUCH, _onOrientation);
		}
		
		override public function login(callback:Function):void
		{
			_ane.showLoginView();
		}
		
		override public function logout(callback:Function):void
		{
			_ane.showCenterView();
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
					Logger.log("PP助手 exchangeGoods CpOrderId: ", _CpOrderId);
					
					SApplication.UIRootNode.stage.addEventListener(starling.events.TouchEvent.TOUCH, _onOrientation);
					_time = getTimer();
					_ane.exchangeGoods(_PayConins, msg.retparams["orderId"], "金币", "0", 0);
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
		
		/**
		 * 关闭客户端页面回调事件， 
		 * @param e
		 * 当前关闭页面名称
		 */		
		private function ppClosePageViewEvent(e:PPClosePageViewEvent):void 
		{
			var paramClosePageCode:int = parseInt(e.typeEvent);
			if (paramClosePageCode == PPAppConfig.PPLoginViewPageCode) 
			{
				Starling.juggler.delayCall(_ane.showLoginView, 2);
			}
			else if(paramClosePageCode == PPAppConfig.PPRegisterViewPageCode)
			{
				Starling.juggler.delayCall(_ane.showLoginView, 2);
			}
			else if(paramClosePageCode == PPAppConfig.PPUpdatePwdViewPageCode)
			{
				Starling.juggler.delayCall(_ane.showLoginView, 2);
			}
			else if(paramClosePageCode == PPAppConfig.PPAlertSecurityViewPageCode)
			{
				PPAppConfig.PPCenterViewPageCode
			}
		}
		
		
		/**
		 * 兑换道具成功的回调，只有余额大于所购买道具时才响应该回调事件  
		 * @param e
		 * 
		 */		
		private function ppPayEvent(e:PPPayEvent):void
		{
			// TODO Auto-generated method stub
			var paramPPPayResultCode:int = parseInt(e.typeEvent);
			if(paramPPPayResultCode == PPAppConfig.PPPayResultCodeSucceed){
				dispatchEventWith(SPlatformEvents.EventBuy, false, _CpOrderId);
			}
		}
		
		/**
		 * 注销事件的回调 
		 * @param e
		 * 
		 */		
		private function ppLogOffEvent(e:PPLogOffEvent):void
		{
			// TODO Auto-generated method stub
			SApplicationUtils.exit();
		}
		
		/**
		 *登录成功回调 
		 * @param e ，
		 * String token
		 */		
		private function ppLoginEvent(e:PPLoginEvent):void
		{
			// TODO Auto-generated method stub
			_sessionId = e.typeEvent;
			
			_uid = _ane.currentUserId();
			//_ane.currentUserName();
			
			//登录验证成功
			_ane.getUserInfoSecurity();
			_dispatch_login(true, "");
			
		}
		
		/**
		 * 关闭Web页面的回调。 
		 * @param e
		 * String 当前的页面名称
		 */		
		private function ppCloseWebViewEvent(e:PPCloseWebViewEvent):void
		{
			// TODO Auto-generated method stub
			var paramCloseWebPageCode:int = parseInt(e.typeEvent);
			if (paramCloseWebPageCode == PPAppConfig.PPWebViewCodeRechargeAndExchange) 
			{
				dispatchEventWith(SPlatformEvents.EventBuy, false, _CpOrderId);	
			}
		}
		
		/**
		 * 检查游戏版本更新完成回调 
		 * @param e
		 * 完毕后弹出登录页面
		 */		
		private function ppVerifyingUpdatePassEvent(e:PPVerifyingUpdatePassEvent):void
		{
			_ane.showLoginView();
		}
	}
}