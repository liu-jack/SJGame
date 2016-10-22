package SJ.Game.Platform
{
	/**
	 * 回调地址更改方式: ane init的时候传入
	*/
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
	
	import cn.kaixin.sdk.SDK360;
	
	import engine_starling.utils.Logger;
	import engine_starling.utils.SPlatformUtils;
	
	import starling.events.Event;
	

	public class SPlatform360Android extends SPlatformDefault
	{
		private var _logger:Logger = Logger.getInstance(SPlatform360Android);
		private var _uid:String = "";
		private var _sessionId:String = "";
		private var _CpOrderId:String = "";
		private var _amount:int = 0; //单位为分
		private var _accessToken:String = "";
		
		public function SPlatform360Android()
		{
			super();
		}
		
		override public function startup(params:Object):void
		{
			var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
			dataReceipt.addEventListener(CJDataOfPlatformReceipt.RECEIPT_FAILED, _onReceiptFailed);
				
			SDK360.instance.addEventListener(StatusEvent.STATUS, _statusHandler);
			var arr:Array = new Array();
			arr.push("http://ht.shenjiang.kaixin001.com.cn/payCallback/360_notify.php");
			SDK360.instance.requestAne("init", arr);
			
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
			_logger.info("login");
			var arr:Array = new Array();
			arr.push(true);
			arr.push(true);
			SDK360.instance.requestAne("login", arr);
		}
		
		public function check():void
		{
			_logger.info("check");
			var arr:Array = new Array();
			arr.push(_uid);
			arr.push(_accessToken);
			SDK360.instance.requestAne("check", arr);
		}
		
		public function register():void
		{
			_logger.info("register");
			var arr:Array = new Array();
			arr.push(_accessToken);
			SDK360.instance.requestAne("register", arr);
		}
		
		override public function logout(callback:Function):void
		{
			SDK360.instance.requestAne("exit", null);
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
			//_amount的单位是分
			_amount = cfgData.rmbnum;
			
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
					Logger.log("SDK360 CpOrderId: ", _CpOrderId);
					
					var arr:Array = new Array();
					arr.push(_accessToken);
					arr.push("appExt1");
					arr.push("appExt2");
					arr.push(SPlatformUtils.getApplicationName());					
					arr.push(msg.retparams["orderId"]);
					arr.push((CJDataManager.o.getData("CJDataOfAccounts") as CJDataOfAccounts).userID);
					arr.push(CJDataManager.o.DataOfRole.name);
					arr.push("1");
					arr.push("" + _amount);
					arr.push("1");
					arr.push("金币");
					arr.push(_uid);
					arr.push("yes");
								
					SDK360.instance.requestAne("pay", arr);
				}
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			}
		}
		
		override public function setUid(value: String):void
		{
			_uid = value;
		}
		
		override public function uid():String
		{
			return _uid;
		}
		
		override public function SessionId():String
		{
			return _sessionId;
		}
		
		override public function set accessToken(value: String):void
		{
		 	_accessToken = value;
		}
		
		private function _statusHandler(event:StatusEvent):void
		{
			_logger.info("360: " + event.level);
			var Str:String =new String();  
			var Arr:Array =new Array();  
			if(event.code == "init")
			{		 
				_logger.info("360 init: " + event.level);
				Str = event.level;
				Arr = Str.split(":",Str.length); 	
				_dispatch_init(Arr[0] == "1");
			}
			else if(event.code == "login")
			{
				_logger.info("360 login: " + event.level);
				Str = event.level;
				Arr = Str.split(":",Str.length); 	
				if(Arr[0] == "0")
				{
					_sessionId = Arr[1];
					_dispatch_login(true, "");
				}
				else 
				{
					login(null);
				}
			}
			else if(event.code == "pay")
			{
				_logger.info("360 pay: " + event.level);
				Str = event.level;
				Arr = Str.split(":",Str.length); 
				if(Arr[0] == "0")
				{
					_logger.info("购买成功");
					dispatchEventWith(SPlatformEvents.EventBuy, false, _CpOrderId);
				}
				else 
				{
					_logger.info("购买失败");
					var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
					dataReceipt.completeReceipt();
				}
				
			}
			else if(event.code == "exit")
			{
				_dispatch_logout();
			}
			else if(event.code == "check")
			{
				Str = event.level;
				Arr = Str.split(":",Str.length); 
				if(Arr[0] == "0")
				{
					//通过验证
					
				}
				else if(Arr[0] == "1")
				{
					//错误
					
				}
				else if(Arr[0] == "2")
				{
					//未注册, 调用注册
					register();
				}
				else if(Arr[0] == "3")
				{
					//未通过验证
					
				}
				
			}
			else if(event.code == "register")
			{
				//注册完毕  再次验证
				check();
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