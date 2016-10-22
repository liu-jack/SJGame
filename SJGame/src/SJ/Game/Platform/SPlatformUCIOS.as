package SJ.Game.Platform
{
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstPlatformId;
	import SJ.Game.ServerList.CJServerList;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfPlatformReceipt;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfRechargeProperty;
	import SJ.Game.data.json.Json_recharge_setting;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	
	import cn.uc.gamesdk.ane.ios.CallbackEvent;
	import cn.uc.gamesdk.ane.ios.Constants;
	import cn.uc.gamesdk.ane.ios.StatusCode;
	import cn.uc.gamesdk.ane.ios.UCGameSDK;
	
	import engine_starling.utils.Logger;
	import engine_starling.utils.SPlatformUtils;
	
	import starling.core.Starling;
	import starling.events.Event;

	public class SPlatformUCIOS extends SPlatformDefault
	{
		private var _ucsdk:UCGameSDK;
		private var _logger:Logger = Logger.getInstance(SPlatformUCIOS);
		public function SPlatformUCIOS()
		{
			super();
		}
		
		override public function startup(params:Object):void
		{
			var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
			dataReceipt.addEventListener(CJDataOfPlatformReceipt.RECEIPT_FAILED, _onReceiptFailed);
			var cpid:int = 26261;
			var gameid:int = 527451;
			var serverid:int = 2345;
			var servername:String = "土豪OL";
			
			_ucsdk = new UCGameSDK();
			_ucsdk.addEventListener(Constants.EVENT_TYPE_UCGameSDKCallback, _onCallback);
			_ucsdk.setLogLevel(Constants.LOGLEVEL_DEBUG);
			_ucsdk.setOrientation(Constants.ORIENTATION_LANDSACPE_RIGHT);
			_ucsdk.showFloatButton(0,0,true);
			_ucsdk.initSDK(false, Constants.LOGLEVEL_DEBUG, gameid, cpid, serverid, servername, true, true);
//			super.startup(params);
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
		
		override public function login(callback:Function):void
		{
			_ucsdk.login(false,"",null);
			_logger.info("login");
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
			var cfgData:Json_recharge_setting = CJDataOfRechargeProperty.o.getProperty(orderSerial);
			
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
			 */
			var dataRole:CJDataOfRole = CJDataManager.o.DataOfRole;
			var dataMainHero:CJDataOfHero = CJDataManager.o.DataOfHeroList.getMainHero();
			
			var allowContinuousPay:Boolean = false;	//false表示只能进行一笔充值即返回游戏
			var amount:Number = Number(cfgData.rmbnum / 100);	//充值金额。如果不设或设为0，充值时用户从充值界面中选择或输入金额；如果设为大于0的值，表示固定充值金额，不允许用户选择或输入其它金额。
			var serverId:int = 0;	//当前充值的游戏服务器（分区）标识，此标识即UC分配的游戏服务器ID
			var roleId:String = dataMainHero.heroid;	//当前充值用户在游戏中的角色标识
			var roleName:String = dataRole.name;		//当前充值用户在游戏中的角色名称
			var grade:String = dataMainHero.level;		//当前充值用户在游戏中的角色等级
			
			var customInfoObj:Object = new Object();
			customInfoObj.uid = dataMainHero.heroid;
			customInfoObj.platformid = ConstGlobal.CHANNEL;
			customInfoObj.serverid = CJServerList.getServerID();
			customInfoObj.clientversion = SPlatformUtils.getApplicationVersion();
			var customInfoStr:String = JSON.stringify(customInfoObj);
			
			_logger.info("===================customInfoStr:" + customInfoStr);
			_ucsdk.pay(allowContinuousPay, 
				amount,
				serverId, 
				roleId,
				roleName,
				grade,
				customInfoStr);
			return 0;
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
			_logger.info("received callback event: " + event.toString());
			var callbackType:String = event.callbackType;
			var code:int = event.code;
			var data:Object = event.data;
			
			_logger.info("received callback event: callbackType=" + callbackType + ", code=" + code + ", data=" + (data != null ? data.toString() : "") );
			
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
						
//						this.sid = ucsdk.getSid();
//						this.isLogined = true;
						_logger.info("登录成功：sid=" + _ucsdk.getSid());
						
						//创建悬浮按钮
//						ucsdk.createFloatButton();
					}
					else
					{
						//登录失败
						_logger.info("登录失败：" + data.toString());
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
						var orderId:String = data.orderId;
						var orderAmount:Number = data.orderAmount;
						var payWay:int = data.payWay;
						var payWayName:String = data.payWayName;
						
//						var txt:String = "orderId=" + orderId + ", orderAmount=" + orderAmount.toString() + ", payWay=" + payWay.toString() + ", payWayName=" + payWayName;
//						ucsdk.alertShow("充值下单成功：" + txt, "", "ok");
//						outputs("充值下单成功：" + txt);
						
						var verfyData:Object = new Object();
						verfyData.orderid = orderId;
						verfyData.orderamount = orderAmount;
						verfyData.platformid = ConstGlobal.CHANNEL;
						var dataString:String = JSON.stringify({"receipt": orderId, "rechargeid":ConstGlobal.CHANNEL});
						
						_logger.info("============= UC orderId:[" + orderId + "]");
						
						// 延迟秒数
						var delaySeconds:int = int(CJDataOfGlobalConfigProperty.o.getData("RECHARGE_UC_DELAY_SECONDS"));
						Starling.juggler.delayCall(fucTimeOut, 15);
						
						function fucTimeOut():void{
							_logger.info("============= setTimeout run!!!");
							dispatchEventWith(SPlatformEvents.EventBuy, false, dataString);
						}
						
					}
					else if (code == StatusCode.FAIL)
					{
						//充值下单失败
//						ucsdk.alertShow("充值下单失败", "", "ok");
//						outputs("充值下单失败！");
					}
					break;
				
				case Constants.CALLBACKTYE_PayExit:
					
					_ucsdk.alertShow("退出充值页面", "", "ok");
					break;
				
			}
		}
		
		
		
		
	}
}