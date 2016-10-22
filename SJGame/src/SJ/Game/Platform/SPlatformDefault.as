package SJ.Game.Platform
{
	import com.kaixin001.fxane.HelloAne;
	import com.kaixin001.fxane.InAppPurchase.AppPurchaseEvent;
	import com.kaixin001.fxane.InAppPurchase.Product;
	
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstPlatformId;
	import SJ.Common.Constants.ConstRecharge;
	import SJ.Game.ServerList.CJServerList;
	import SJ.Game.SocketServer.SocketCommand_quicklogin;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.core.TalkingDataService;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfAccounts;
	import SJ.Game.data.CJDataOfPlatformProduct;
	import SJ.Game.data.CJDataOfPlatformReceipt;
	import SJ.Game.data.config.CJDataOfRechargeProperty;
	import SJ.Game.data.json.Json_recharge_setting;
	import SJ.Game.utils.SNetWorkUtils;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.Logger;
	import engine_starling.utils.SStringUtils;

	public class SPlatformDefault extends ISPlatfrom
	{
		protected var _account:SDataBase;
		protected var _authorizationcode:String;
		private var _rechargeid:String;
		private var _rmbnum:String;
		private var _goldnum:String;
		private var _orderId:String;
		
		public function SPlatformDefault()
		{
			_account = new SDataBase("SPlatformDefault");
			_account.loadFromCache();
			if(!_account.hasKey("username") || _account.getData('username') == null)
			{
				//fix 如果MAC为空  则用唯一ID 不会出现在IPhone上面 因为 IPhone的 取MAC实际上是去OpenUUID上，只会出现在部分没有打开wifi的android设备上
				if( SStringUtils.isEmpty(SNetWorkUtils.hardAddress))
				{
					_account.setData("username",ConstGlobal.DeviceInfo.DeviceId);
				}
				else
				{
					_account.setData("username",SNetWorkUtils.hardAddress);
				}
				_account.setData("password",SStringUtils.md5String(SNetWorkUtils.hardAddress + "oo0oo0"));
				_account.setData("iscreate",false);
				_account.setData("isLogin",false);
				_account.saveToCache();
			}
		}
		
		override public function startup(params:Object):void
		{
			HelloAne.o.addEventListener(AppPurchaseEvent.UPDATED_TRANSACTIONS, function _e(e:AppPurchaseEvent):void
			{
				//fix 苹果支付没有保存票据向服务器验证 peng.zhi ++
				var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
				
				var orderid:String = JSON.stringify({"receipt": String(e.datas), "rechargeid":_rechargeid});
				
				dataReceipt.saveDataToCache(ConstGlobal.CHANNELID, orderid, false);
				
				dispatchEventWith(SPlatformEvents.EventBuy, false, orderid);	
//				TalkingDataService.o.chargeSuccess(_orderId);
			});
			HelloAne.o.addEventListener(AppPurchaseEvent.PRODUCTS_RECEIVED,function _e(e:AppPurchaseEvent):void
			{
				var arrayDataAne:Array = e.datas;
				if (null == arrayDataAne)
				{
					return;
				}
				var arrayDataProducts:Array = new Array();
				var arrayProducts:CJDataOfPlatformProduct;
				for (var i:int = 0; i < arrayDataAne.length; i++)
				{
					var pdt:Product = arrayDataAne[i];
					arrayProducts = new CJDataOfPlatformProduct();
					arrayProducts.goldName = String(pdt.title);
					arrayProducts.rmbName = String(pdt.price);
					arrayProducts.productId = String(pdt.identifier);
					arrayDataProducts.push(arrayProducts);
				}
				dispatchEventWith(SPlatformEvents.EventGetProducts, false, arrayDataProducts);
			});
			HelloAne.o.addEventListener(AppPurchaseEvent.RESTORE_FAILED,function _e(e:AppPurchaseEvent):void
			{
				// 充值点击取消按钮、不输入用户名均派发此事件
				dispatchEventWith(ConstRecharge.EVENTTYPE_RECHARGE_APPSTORE_RESTORE_FAILED, false);
			});
			_dispatch_init(true);
		}
		
		/**
		 * 获取平台充值配置文件
		 * @return Array(Json_recharge_setting)
		 * 
		 */		
		protected function _getPlatformProductConfig():Array
		{
			return CJDataOfRechargeProperty.o.getPropertysByChannel(ConstGlobal.CHANNEL);
		}
		
		/**
		 * 获取平台充值配置文件
		 * @return Array(CJDataOfPlatformProduct)
		 * 
		 */		
		protected function _getConfigPlatformProductData():Array
		{
			var arrayCfg:Array = _getPlatformProductConfig();
			var cfgData:Json_recharge_setting;
			var dataProducts:CJDataOfPlatformProduct;
			var arrayDataProducts:Array = new Array();
			for (var i:int = 0; i < arrayCfg.length; i++)
			{
				cfgData = arrayCfg[i];
				dataProducts = new CJDataOfPlatformProduct();
				dataProducts.goldName = String(cfgData.goldnum);
				dataProducts.rmbName = String(int(cfgData.rmbnum) / 100);
				dataProducts.productId = String(cfgData.id);
				arrayDataProducts.push(dataProducts);
			}
			arrayDataProducts.sort(_productCfgDataSort);
			return arrayDataProducts;
		}
		
		/**
		 * 充值配置数据排序
		 * @param dataA CJDataOfPlatformProduct
		 * @param dataB CJDataOfPlatformProduct
		 * @return 
		 * 
		 */		
		private function _productCfgDataSort(dataA:CJDataOfPlatformProduct, dataB:CJDataOfPlatformProduct):int  
		{
			if (int(dataA.rmbName) > int(dataB.rmbName))
			{
				return 1;
			}
			return -1;
		}
			
		protected function _dispatch_init(succ:Boolean):void
		{
			dispatchEventWith(SPlatformEvents.EventInited,false,{ret:succ});
		}
		
		override public function clearcache():void
		{
			_account = new SDataBase("SPlatformDefault");
			_account.loadFromCache();
			_account.clearAll();
			_account.saveToCache();
		}
		
		override public function login(callback:Function):void
		{	
//			if(_account.getData("iscreate") == true)
//			{
//				_login();
//			}
//			else
//			{
			// 无论如何 创建帐号先.
				SocketCommand_quicklogin.thirdpartycreate(_account.getData("username"),_account.getData("password"),function (e:SocketMessage):void
				{
					var retcode:int = e.retcode;	
					_account.setData("iscreate",true);
					_account.saveToCache();
					_login();
				});
//			}
		}
		private function _login():void
		{
			SocketCommand_quicklogin.thirdpartylogin(_account.getData("username"),_account.getData("password"),function (e:SocketMessage):void
			{
				var retcode:int = e.retcode;
				var succ:Boolean = e.retparams[0] as Boolean;
				_authorizationcode = e.retparams[1];
				
				dispatchEventWith(SPlatformEvents.EventLogined,false,{ret:succ,reason:'succ'});
			});
		}
		protected function _dispatch_login(succ:Boolean,reason:String):void
		{
			dispatchEventWith(SPlatformEvents.EventLogined,false,{ret:succ,reason:reason});
		}
		
		override public function logout(callback:Function):void
		{
			_dispatch_logout();
		}
		protected function _dispatch_logout():void
		{
			dispatchEventWith(SPlatformEvents.EventLogout,false);
		}
		
		/**
		 * 购买是否成功 
		 * @param succ 成功
		 * @param receiptBase64 base64后的票据
		 * @param retcode 错误码
		 * 
		 */
		protected function _dispatch_buy(succ:Boolean,receiptBase64:String= "" ,retcode:int = 0):void
		{
			//购买是否成功
			// 此处貌似没有地方调用到
			dispatchEventWith(SPlatformEvents.EventBuy,false,{"ret":succ,"receipt":receiptBase64,"retcode":retcode});
				
		}
		
		override public function getproducts():void
		{
			super.getproducts();
			
			HelloAne.o.getIosProduct(_getProductString());
			
			// 获取配置数据
//			var arrayProductData:Array = _getConfigPlatformProductData();
//			dispatchEventWith(SPlatformEvents.EventGetProducts, false, arrayProductData); 
			
		}
		
		/**
 		 * 获取套餐id内容字符串
 		 * 
 		 */		
		private function _getProductString():String
		{
			var rtn:String = "";
			var arrayProductIds:Array = _getProductIds();
			for each(var product:String in arrayProductIds)
			{
				rtn += product + ",";
			}
			rtn = rtn.substr(0, rtn.length - 1);
			return rtn;
		}
		
		/**
		 * 充值产品数组
		 * @return 字符串数组
		 * 
		 */		
		protected function _getProductIds():Array
		{
			if (ConstGlobal.CHANNELID == ConstPlatformId.ID_DEBUG)
			{
				return ["Gods_tie_1", "Gods_tie_2",	"Gods_tie_3", "Gods_tie_4",	"Gods_tie_5", "Gods_tie_6"];
			}
			else
			{
				return ["local_tyrant_1",
					"local_tyrant_2",
					"local_tyrant_3",
					"local_tyrant_4",
					"local_tyrant_5",
					"local_tyrant_6"];
			}
		}
		
		override public function pay(orderSerial:String, PayConins:Number, paydesc:String, callback:Function):int
		{
			/**
			 * 支付 
			 * @param orderSerial 订单序列号
			 * @param PayConins 代币数量
			 * @param paydesc 支付描述
			 * @param callback 结果回调
			 * @return 
			 * 
			 */
			PayConins = 1;
			super.pay(orderSerial, PayConins, paydesc, callback);
			HelloAne.o.buyIosProduct(orderSerial, PayConins);
		
//			var cfgData:Json_recharge_setting = CJDataOfRechargeProperty.o.getProperty(orderSerial);
//			_rechargeid = cfgData.rechargeid;
//			_rmbnum = cfgData.rmbnum;
//			_goldnum = cfgData.goldnum;
//			_orderId = createOrderId();
//				
//			TalkingDataService.o.createOrder(_orderId, _rechargeid, parseInt(_rmbnum), parseInt(_goldnum));
			return 0;
		}
		
		override public function enterbbs():void
		{
			// TODO Auto Generated method stub
		}
		
		override public function enterfeedback():void
		{
			
		}
		
		override public function uid():String
		{
			return _authorizationcode;
		}
		
		override public function SessionId():String
		{
			return uid();
		}
		
		//票据生成器
		public static function createOrderId():String
		{
			var current:Date = new Date();  
			var orderId:String = "" + ConstGlobal.CHANNEL + "_"
				+ CJServerList.getServerID() + "_" 
				+ (CJDataManager.o.getData("CJDataOfAccounts") as CJDataOfAccounts).userID + "_"
				+ current.time + "_" 
				+ int(Math.random() * 10000);
			Logger.log("createOrderId", orderId);
			return orderId;		
		}
		
		
		
		
	}
}