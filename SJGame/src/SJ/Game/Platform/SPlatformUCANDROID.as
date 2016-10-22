package SJ.Game.Platform
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstPlatformId;
	import SJ.Game.ServerList.CJServerList;
	import SJ.Game.SocketServer.SocketCommand_receipt;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfPlatformReceipt;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfRechargeProperty;
	import SJ.Game.data.json.Json_recharge_setting;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.utils.SApplicationUtils;
	
	import cn.uc.gamesdk.ane.CallbackEvent;
	import cn.uc.gamesdk.ane.Constants;
	import cn.uc.gamesdk.ane.StatusCode;
	import cn.uc.gamesdk.ane.UCGameSDK;
	
	import engine_starling.SApplication;
	import engine_starling.utils.Logger;
	import engine_starling.utils.SPlatformUtils;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.KeyboardEvent;

	public class SPlatformUCANDROID extends SPlatformDefault
	{
		private var _ucsdk:UCGameSDK;
		private var _logger:Logger = Logger.getInstance(SPlatformUCANDROID);
		
		// 充值id，配置表中rechargeid
		private var _rechargeId:String = "";
		// 开心订单id
		private var _kxOrderId:String = "";
//		private var _CpOrderId:String = "";
		private var _orderSerial:String = "";
		[Embed(source="../../../startupres/startup_logoHD.png")]
		private static var _self_LogoHD:Class;
	
		public function SPlatformUCANDROID()
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
		override public function getproducts():void
		{
			// 获取配置数据
			var arrayProductData:Array = _getConfigPlatformProductData();
			dispatchEventWith(SPlatformEvents.EventGetProducts, false, arrayProductData); 
		}
		
		override public function startup(params:Object):void
		{
			
			var cpid:int = int(CJDataOfGlobalConfigProperty.o.getData("RECHARGE_UC_CPID"));	//26261
			var gameid:int = int(CJDataOfGlobalConfigProperty.o.getData("RECHARGE_UC_GAMEID"));	//527451
			var serverid:int = int(CJDataOfGlobalConfigProperty.o.getData("RECHARGE_UC_SERVERID"));	//2345
			var servername:String = String(CJDataOfGlobalConfigProperty.o.getData("RECHARGE_UC_SERVERNAME"));	//"大神传"
			
//			cpid = 26261;
//			gameid = 527451;
//			serverid = 2345;
//			servername = "大神传";
			
			_ucsdk = new UCGameSDK();
			_ucsdk.addEventListener(Constants.EVENT_TYPE_UCGameSDKCallback,_onCallback);
			_ucsdk.setLogLevel(Constants.LOGLEVEL_DEBUG);
			_ucsdk.setOrientation(Constants.ORIENTATION_LANDSCAPE);
			_ucsdk.setLoginUISwitch(Constants.UCLOGIN_FACETYPE_USE_WIDGET);
			
			var debugMode:Boolean = false;
//			var globalCfgUcDebug:int = int(CJDataOfGlobalConfigProperty.o.getData("RECHARGE_UC_IS_DEBUG"));
//			if (globalCfgUcDebug == 0)
//			{
//				debugMode = false;
//			}
//			else
//			{
//				debugMode = true;
//			}
			debugMode = false;
			
			_ucsdk.initSDK(debugMode, Constants.LOGLEVEL_DEBUG, gameid, cpid, serverid, servername, true, true);
			
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN,_handle_KeyDown);
			
			var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
			dataReceipt.addEventListener(CJDataOfPlatformReceipt.RECEIPT_FAILED, _onReceiptFailed);
			
			
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE,function(e:*):void
			{
				_addFixBackGround();
			});
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE,function(e:*):void
			{
				Starling.juggler.delayCall(closefixbackground,10);
			});
			Starling.current.stage3D.addEventListener(flash.events.Event.CONTEXT3D_CREATE, function(e:*):void
			{
				if(Starling.current.isStarted)
				{
					closefixbackground();
				}
			});
			
			function closefixbackground():void
			{
				var icon2:DisplayObject = SJGame.as3Root.getChildByName("fixxiaomibackground");
				if(icon2 != null)
					SJGame.as3Root.removeChild(icon2);
			}
//			super.startup(params);
		}
		
		private function _onReceiptFailed(e: *):void
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
		
		override public function gameexit(code:int):void
		{
			// TODO Auto Generated method stub
			super.gameexit(code);
			if (_ucsdk != null)
			{
				_ucsdk.exitSDK();
			}
			
		}
		
		
		private function _handle_KeyDown(e:*):void
		{
			
			switch(e.keyCode)
			{
				case Keyboard.BACK: // user hit the back button on Android device
				case Keyboard.MENU:
				case 0x1000016:
				case 0x1000012:
				{  
//					_ucsdk.logout();
					
					CJConfirmMessageBox("亲，是否退出游戏呢?"
						,function ():void{
	
						},function():void
						{
							
							SApplicationUtils.exit();
						},
						"再玩一会儿吧",
						"坚持退出");
					

					//是否不让切后台？
					e.preventDefault();
					e.stopImmediatePropagation();
					break;
				}
			}
		}
		
		override public function login(callback:Function):void
		{
			// TODO delete 2013-10-23
//			dispatchEventWith(SPlatformEvents.EventLogined,false,{ret:true,reason:0});
//			return;
			
			/**
			 * 调用SDK的用户登录 
			 * @param enableGameAccount 是否允许使用游戏老账号（游戏自身账号）登录
			 * @param gameAccountTitle 游戏老账号（游戏自身账号）的账号名称，如“三国号”、“风云号”等。
			 *         如果 enableGameAccount 为false，此参数的值设为空字符串即可。
			 * @param gameUserLoginOperation 游戏老账号登录操作对象，如果 enableGameAccount 为false，此参数设为空即可，如果 enableGameAccount 为true，此对象不可为空。
			 * @return 
			 */
			_ucsdk.login(false,"",null);
//			_logger.info("login");
		}
		
		override public function enterbbs():void
		{
			_ucsdk.enterUserCenter();
		}
		
		override public function enterfeedback():void
		{
			super.enterfeedback();
		}
		
		override public function logout(callback:Function):void
		{
			_ucsdk.logout();
		}
		
		override public function pay(orderSerial:String, PayConins:Number, paydesc:String, callback:Function):int
		{
			/**
			 * 支付 
			 * @param orderSerial 订单序列号 -- 此处为配置id(CJDataOfPlatformProduct.productId)
			 * @param PayConins 代币数量  -- 此处为人民币充值金额
			 * @param paydesc 支付描述
			 * @param callback 结果回调
			 * @return 
			 */
			_orderSerial = orderSerial;
			var cfgData:Json_recharge_setting = CJDataOfRechargeProperty.o.getProperty(orderSerial);
			
			// 配置表中的rechargeid
			_rechargeId = cfgData.rechargeid;
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			
			// 生成kx订单号
			SocketCommand_receipt.createOrderId("" + ConstGlobal.CHANNEL, SPlatformUtils.getApplicationVersion(), _rechargeId);
			return 0;
		}
		
		private function _onRpcReturn(e:*):void{
			var msg:SocketMessage = e.data as SocketMessage;
			if(msg.getCommand() == ConstNetCommand.CS_RECEIPT_CREATEORDER)
			{
				if (msg.retcode == 0)
				{
					var rechargeid:String = _rechargeId;
//					_CpOrderId = msg.retparams["orderId"] + " " + rechargeid;
					var kxId:String = msg.retparams["orderId"];
//					_CpOrderId = msg.retparams["orderId"] + " " + rechargeid;
					
					_kxOrderId = msg.retparams["orderId"];
					var dataString:String = JSON.stringify({"receipt": _kxOrderId, "rechargeid":_rechargeId});
					var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
					dataReceipt.saveDataToCache(ConstGlobal.CHANNELID, dataString);
					Logger.log("MiCommplatform kxOrderId: ", _kxOrderId);
					
					var cfgData:Json_recharge_setting = CJDataOfRechargeProperty.o.getProperty(_orderSerial);
					
					var dataRole:CJDataOfRole = CJDataManager.o.DataOfRole;
					var dataMainHero:CJDataOfHero = CJDataManager.o.DataOfHeroList.getMainHero();
					/**
					 * 执行充值下单操作，此操作会调出充值界面。 
					 * @param allowContinuousPay 设置是否允许连接充值，true表示在一次充值完成后在充值界面中可以继续下一笔充值，false表示只能进行一笔充值即返回游戏。
					 * @param amount 充值金额。默认为0，如果不设或设为0，充值时用户从充值界面中选择或输入金额；如果设为大于0的值，表示固定充值金额，不允许用户选择或输入其它金额。
					 * @param serverId 当前充值的游戏服务器（分区）标识，此标识即UC分配的游戏服务器ID
					 * @param roleId 当前充值用户在游戏中的角色标识
					 * @param roleName 当前充值用户在游戏中的角色名称
					 * @param grade 当前充值用户在游戏中的角色等级
					 * @param customInfo 充值自定义信息，此信息作为充值订单的附加信息，充值过程中不作任何处理，仅用于游戏设置自助信息，比如游戏自身产生的订单号、玩家角色、游戏模式等。
					 *    如果设置了自定义信息，UC在完成充值后，调用充值结果回调接口向游戏服务器发送充值结果时将会附带此信息，游戏服务器需自行解析自定义信息。
					 *    如果不需设置自定义信息，将此参数置为空字符串即可。
					 * @return 
					 * 
					 */
					var allowContinuousPay:Boolean = false;	//false表示只能进行一笔充值即返回游戏
					var amount:Number = Number(cfgData.rmbnum / 100);	//充值金额。如果不设或设为0，充值时用户从充值界面中选择或输入金额；如果设为大于0的值，表示固定充值金额，不允许用户选择或输入其它金额。
					var serverId:int = 2345;	//当前充值的游戏服务器（分区）标识，此标识即UC分配的游戏服务器ID
					var roleId:String = dataMainHero.heroid;	//当前充值用户在游戏中的角色标识
					var roleName:String = dataRole.name;		//当前充值用户在游戏中的角色名称
					var grade:String = dataMainHero.level;		//当前充值用户在游戏中的角色等级
					//			var customInfo:String = "{\'uid\':\'" + dataMainHero.heroid + "\',\'platformid\':" + ConstGlobal.CHANNEL + ", \'serverId\':\'" + CJServerList.getServerID() + "\', \'clientVersion\':\'" + SPlatformUtils.getApplicationVersion() + "\'}";
					var customInfoObj:Object = new Object();
//					customInfoObj.uid = dataMainHero.heroid;
//					customInfoObj.platformid = ConstGlobal.CHANNEL;
//					customInfoObj.serverid = CJServerList.getServerID();
//					customInfoObj.clientversion = SPlatformUtils.getApplicationVersion();
//					customInfoObj.callbackInfo = kxId;
//					var customInfoStr:String = JSON.stringify(customInfoObj);
					
//					_logger.info("===================customInfoStr:" + customInfoStr);
					
					_ucsdk.pay(allowContinuousPay, amount, serverId, roleId, roleName, grade, kxId);
				}
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			}
		}
		
		override public function uid():String
		{
			return _ucsdk.getSid();
		}
		
		
		override public function SessionId():String
		{
			return _ucsdk.getSid();
		}
		
		
		private function _onCallback(event:CallbackEvent): void
		{
//			_logger.info("****************received callback event: " + event.toString());
			var callbackType:String = event.callbackType;
			var code:int = event.code;
			var data:Object = event.data;
			
//			_logger.info("received callback event: callbackType=" + callbackType + ", code=" + code + ", data=" + (data != null ? data.toString() : "") );
			
			switch(callbackType) {
				case Constants.CALLBACKTYE_InitSDK:
					//data 为 String 类型，表示错误说明
					if (code == StatusCode.SUCCESS)
					{
						_logger.info("SDK初始化成功");
					}
					else 
					{
						//初始化失败，需重新初始化
						_logger.info("SDK初始化失败code:" + String(code));
						_logger.info("SDK初始化失败：" + String(data));
					}
					_dispatch_init(code == StatusCode.SUCCESS);
					break;
				
				case Constants.CALLBACKTYE_Login:
					//收到登录结果回调消息
					//data 为 String 类型，表示错误说明
					var logined:Boolean = false;
					if (code == StatusCode.SUCCESS)
					{
						logined = true;
						_ucsdk.createFloatButton();
						_ucsdk.showFloatButton(0,0,true);
						//						this.sid = ucsdk.getSid();
						//						this.isLogined = true;
						_logger.info("登录成功：sid=" + _ucsdk.getSid());
						
						//创建悬浮按钮
						//						ucsdk.createFloatButton();
					}
					else if (code == StatusCode.LOGIN_EXIT)
					{
						//退出登录界面，返回到游戏画面，游戏需根据是否已经登录成功执行相应界面逻辑
//						outputs("退出登录界面，返回到游戏画面。。。");
//						2
						_logger.info("退出登录界面 退出登录界面 登录成功：sid=" + _ucsdk.getSid());
						if(_ucsdk.getSid() == "")
						{
							logined = false;
							login(null);
							return;
						}
						logined = true;
						return;
	
					}
					else
					{
						//登录失败
						logined = false;
//						outputs("登录失败：" + data.toString());
					}
					_dispatch_login(logined,"");
					break;
				
				case Constants.CALLBACKTYE_Logout:
					//收到用户切换账号（注销登录）消息，游戏需将游戏逻辑置于未登录状态，游戏可重新调用登录方法以进行账号切换
					//data 为 String 类型，表示错误说明
					//					isLogined = false;
					_logger.info("用户退出当前账号了，需把游戏逻辑和画面置为未登录状态，游戏可重新调用登录方法以进行账号切换。。。");
					_dispatch_logout();
					login(null);
					break;
				
				
				case Constants.CALLBACKTYE_Pay:
					//收到充值下单结果的消息，游戏可能需要将下单结果传给游戏服务器。游戏服务器保存后，等待最终支付结果，再为用户发放游戏货币或奖励
					//data 中包含订单结果数据
					if (code == StatusCode.SUCCESS) 
					{
						var orderId:String = data.orderId;	//订单号
						var orderAmount:Number = data.orderAmount;	//订单金额
						var payWay:int = data.payWay;	//充值类型，具体可参考支付通道编码列表
						var payWayName:String = data.payWayName;	//充值类型的中文名称
						
//						var txt:String = "orderId=" + orderId + ", orderAmount=" + orderAmount.toString() + ", payWay=" + payWay.toString() + ", payWayName=" + payWayName;
						
						var verfyData:Object = new Object();
						verfyData.orderid = orderId;
						verfyData.orderamount = orderAmount;
						verfyData.platformid = ConstGlobal.CHANNEL;
						var dataString:String = JSON.stringify(verfyData);
						
						dataString = JSON.stringify({"receipt": _kxOrderId, "rechargeid":_rechargeId});
						
						dispatchEventWith(SPlatformEvents.EventBuy, false, dataString);
//						_logger.info("============= UC orderId:[" + orderId + "]");
						
						// 延迟秒数
//						var delaySeconds:Number = Number(CJDataOfGlobalConfigProperty.o.getData("RECHARGE_UC_DELAY_SECONDS"));
////						delaySeconds = 0.01;
//						Starling.juggler.delayCall(fucTimeOut, delaySeconds);
//						
//						function fucTimeOut():void{
////							_logger.info("============= setTimeout run!!!");
//							
//							dataString = JSON.stringify({"receipt": _kxOrderId, "rechargeid":_rechargeId});
//							
//							dispatchEventWith(SPlatformEvents.EventBuy, false, dataString);
//						}
//						
						// 派发充值购买事件, 将在GameStateLogin中处理
//						dispatchEventWith(SPlatformEvents.EventBuy, false, dataString);
					}
					else if (code == StatusCode.PAY_USER_EXIT)
					{
//						var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
//						dataReceipt.completeReceipt();
						//退出充值界面，返回游戏画面
//						outputs("退出充值界面，返回游戏画面。。。");
					}
					else if (code == StatusCode.FAIL)
					{
						var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
						dataReceipt.completeReceipt();
						//充值下单失败
//						outputs("充值下单失败！");
					}
					break;
//				case Constants.c:
//					
//					_ucsdk.alertShow("退出充值页面", "", "ok");
//					break;
				
			}
		}
	}
}