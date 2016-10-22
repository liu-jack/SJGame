package SJ.Game.Platform
{
	import com.kyupdate.NativeAdd;
	import com.you.ran.Ky_PaySDK;
	import com.you.ran.PayDelegate;
	
	import flash.desktop.NativeApplication;
	import flash.events.InvokeEvent;
	import flash.events.StatusEvent;
	import flash.utils.Dictionary;
	
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
	
	
	public class SPlatformKYIOS extends SPlatformDefault implements PayDelegate
	{
		private var _logger:Logger = Logger.getInstance(SPlatformKYIOS);
		
		private var sdk:Ky_PaySDK = Ky_PaySDK.instance();
		private var checkane:NativeAdd;
		
		public function SPlatformKYIOS()
		{
			super();
		}
		
		//---------------------------------------------------------
		//------------------ 版本校验 ---------------------
		//---------------------------------------------------------
		
		/**
		 * 从快用平台上检测client版本
		 * @param ver 传入当前版本
		 * @param bundleid 产品的bundle identifier (打包快用版本的证书id)，现在是"com.kaixin001.company8"
		 * 监听返回结果事件
		 */		
		public function checkVerByPlatform(ver:String, bundleid:String="com.kaixin001.company8"):void
		{
			if(checkane == null)checkane = new NativeAdd();
			
			checkane.addEventListener(StatusEvent.STATUS, returnResult);
			var result:* = checkane.checkVer(bundleid, ver);//1.0.38
			trace(result);
		}
		
		//checkok
		//checkno
		//checkerror
		private function returnResult(e:StatusEvent):void
		{
			trace("returnResult--"+e.code+"--"+e.level);
			
			if(e.code=="checkok"){
				//版本一致
			}
			else if(e.code=="checkno"){
				//不一致
				
			}else if(e.code=="checkerror"){
				//校验出错
			}
		}
		
		/**
		 * 调用快用的安装接口
		 */		
		public function installClient():void
		{
			//安装
			if(checkane == null)checkane = new NativeAdd();
			var result:* = checkane.installNewClient();
			trace(result);
		}
		
		//---------------------------------------------------------
		//------------------ 支付  ---------------------
		//---------------------------------------------------------
		
		//接口方法
		public function userBehavior(param:int):void
		{
			trace("userBehavior"+param);
			dispatchEventWith(SPlatformEvents.EventBuy, false, _CpOrderId);
		}
		
		override public function startup(params:Object):void
		{
			sdk.init();
			sdk.setAppScheme("KyPayTuHaoKX");
			sdk.setDelegate(this);
			sdk.setNavigationController();
			
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE,
				function invokeHandler(event:InvokeEvent):void{
					if(event.arguments.length>0){
						var arr:Array = event.arguments;
						
						var result:int = sdk.checkAlipayResult(arr[0]);
						trace(result+"快用验证结果返回"+_CpOrderId);
						
						if(result == -1)//等待服务器验证
						{
							
						}
						else if(result == 0)//结果正确
						{
							dispatchEventWith(SPlatformEvents.EventBuy, false, _CpOrderId);
						}
						else if(result == 1)//结果错误
						{
							
						}
						else if(result == 2)//验证失败
						{
							
						}
					}
				});
			
			var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
			dataReceipt.addEventListener(CJDataOfPlatformReceipt.RECEIPT_FAILED, _onReceiptFailed);
			
			_dispatch_init(true);
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
			super.login(callback);
		}
		
		override public function logout(callback:Function):void
		{
			
		}
		
		private var _CpOrderId:String;
		private var _CpOrderName:String;
		private var _PayConins:Number;
		
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
					sdk.setFrameValue(30);
					
					var rechargeid:String = _CpOrderId;
//					_CpOrderId = msg.retparams["orderId"] + " " + rechargeid;
					_CpOrderId = JSON.stringify({"receipt": msg.retparams["orderId"], "rechargeid":rechargeid});
					var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
					dataReceipt.saveDataToCache(ConstGlobal.CHANNELID, _CpOrderId);
//					_PayConins = 0.2;//debug
					
					var map:Dictionary = new Dictionary;
					map["d"]="iPhone";//设备类型
					map["dealseq"]=msg.retparams["orderId"];//游戏方的交易号，游戏内唯一
					map["fee"]=_PayConins+"";//账单金额，单位元
					map["game"]="2890";//游戏在快用支付管理平台中分配的游戏ID或者CODE
					map["gamesvr"]="";//游戏的区服id，平台唯一值，通过支付管理平台查询到，可选
					map["subject"]= _CpOrderName;//购买的产品名
					map["uid"]= CJDataManager.o.DataOfAccounts.userID;//用户在游戏中的登录帐号
					map["v"]="1.3";//接口版本号，请填1.3
					map["paytype"]="alipaywap";//支付类型，现在只有支付宝的手机wap支付  alipaywap
					
					var md5:String = getSign(map);
					map["sign"]=md5;
					sdk.setValueMap(map);
					
				}
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			}
		}
		
		override public function getproducts():void
		{
			// 获取配置数据
			var arrayProductData:Array = _getConfigPlatformProductData();
			dispatchEventWith(SPlatformEvents.EventGetProducts, false, arrayProductData); 
		}
		
		//----------------------------------------------------
		
		private function getSign(map:Dictionary):String{
			var str:String="d="+map["d"]+
				"&dealseq="+map["dealseq"]+
				"&fee="+map["fee"]+
				"&game="+map["game"]+
				"&gamesvr="+map["gamesvr"]+
				"&paytype="+map["paytype"]+
				"&subject="+map["subject"]+
				"&uid="+map["uid"]+
				"&v="+map["v"];
			
			var md5:String = MD5.hash(str+"1r4ADYaSfkJQypJaHFi3w7KB86pF9NBb");
			
			return md5;
		}
		
		//安全支付,返回结果验签状况
		public function checkResult(flag:int):void
		{
			// TODO Auto Generated method stub
			trace("checkResult:"+flag);
		}
		
		public function payStateClick(state:Dictionary):void
		{
			// TODO Auto Generated method stub
			trace("payStateClick:"+state);
			trace("selectStr="+state["selectStr"]+" "+"seq="+state["seq"]);
//			dispatchEventWith(SPlatformEvents.EventBuy, false, _CpOrderId);
		}
		
		//银联支付结果返回
		public function unionpayResult(ruselt:Dictionary):void
		{
			// TODO Auto Generated method stub
			trace("unionpayResult:"+ruselt);
			trace("code="+ruselt["code"]+" str="+ruselt["str"]+" seq="+ruselt["seq"]);
		}
		
		//用户选择了银联支付,需要进行屏幕旋转
		public function userSelectUnionpay():void
		{
			// TODO Auto Generated method stub
			trace("userSelectUnionpay");
		}
		
		//用户点击了关闭按钮
		public function userCloseView():void
		{
			trace("userCloseView");
		}
		
		//用户卡类支付提交成功提示
		public function userCardPaySuccess():void
		{
			trace("用户卡类支付成功");
		}
		
	}
}


class IntUtil {
	
	/**
	 * Rotates x left n bits
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	public static function rol ( x:int, n:int ):int {
		return ( x << n ) | ( x >>> ( 32 - n ) );
	}
	
	/**
	 * Rotates x right n bits
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	public static function ror ( x:int, n:int ):uint {
		var nn:int = 32 - n;
		return ( x << nn ) | ( x >>> ( 32 - nn ) );
	}
	
	/** String for quick lookup of a hex character based on index */
	private static var hexChars:String = "0123456789abcdef";
	
	/**
	 * Outputs the hex value of a int, allowing the developer to specify
	 * the endinaness in the process.  Hex output is lowercase.
	 *
	 * @param n The int value to output as hex
	 * @param bigEndian Flag to output the int as big or little endian
	 * @return A string of length 8 corresponding to the 
	 *              hex representation of n ( minus the leading "0x" )
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	public static function toHex( n:int, bigEndian:Boolean = false ):String {
		var s:String = "";
		
		if ( bigEndian ) {
			for ( var i:int = 0; i < 4; i++ ) {
				s += hexChars.charAt( ( n >> ( ( 3 - i ) * 8 + 4 ) ) & 0xF ) 
					+ hexChars.charAt( ( n >> ( ( 3 - i ) * 8 ) ) & 0xF );
			}
		} else {
			for ( var x:int = 0; x < 4; x++ ) {
				s += hexChars.charAt( ( n >> ( x * 8 + 4 ) ) & 0xF )
					+ hexChars.charAt( ( n >> ( x * 8 ) ) & 0xF );
			}
		}
		
		return s;
	}
}
	
import flash.utils.ByteArray;   
/**
 * The MD5 Message-Digest Algorithm
 *
 * Implementation based on algorithm description at 
 * http://www.faqs.org/rfcs/rfc1321.html
 */
class MD5 {
	
	public static var digest:ByteArray;
	/**
	 * Performs the MD5 hash algorithm on a string.
	 *
	 * @param s The string to hash
	 * @return A string containing the hash value of s
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 8.5
	 * @tiptext
	 */
	
	public static function hash(s:String) :String{
		//Convert to byteArray and send through hashBinary function
		// so as to only have complex code in one location
		var ba:ByteArray = new ByteArray();
		ba.writeUTFBytes(s);    
		return hashBinary(ba);
	}
	
	public static function hashBytes(s:ByteArray) :String{  
		return hashBinary(s);
	}
	
	/**
	 * Performs the MD5 hash algorithm on a ByteArray.
	 *
	 * @param s The string to hash
	 * @return A string containing the hash value of s
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 8.5
	 * @tiptext
	 */      
	public static function hashBinary( s:ByteArray ):String {
		// initialize the md buffers
		var a:int = 1732584193;
		var b:int = -271733879;
		var c:int = -1732584194;
		var d:int = 271733878;
		
		// variables to store previous values
		var aa:int;
		var bb:int;
		var cc:int;
		var dd:int;
		
		// create the blocks from the string and
		// save the length as a local var to reduce
		// lookup in the loop below
		var x:Array = createBlocks( s );
		var len:int = x.length;
		
		// loop over all of the blocks
		for ( var i:int = 0; i < len; i += 16) {
			// save previous values
			aa = a;
			bb = b;
			cc = c;
			dd = d;                         
			
			// Round 1
			a = ff( a, b, c, d, x[int(i+ 0)],  7, -680876936 );     // 1
			d = ff( d, a, b, c, x[int(i+ 1)], 12, -389564586 );     // 2
			c = ff( c, d, a, b, x[int(i+ 2)], 17, 606105819 );      // 3
			b = ff( b, c, d, a, x[int(i+ 3)], 22, -1044525330 );    // 4
			a = ff( a, b, c, d, x[int(i+ 4)],  7, -176418897 );     // 5
			d = ff( d, a, b, c, x[int(i+ 5)], 12, 1200080426 );     // 6
			c = ff( c, d, a, b, x[int(i+ 6)], 17, -1473231341 );    // 7
			b = ff( b, c, d, a, x[int(i+ 7)], 22, -45705983 );      // 8
			a = ff( a, b, c, d, x[int(i+ 8)],  7, 1770035416 );     // 9
			d = ff( d, a, b, c, x[int(i+ 9)], 12, -1958414417 );    // 10
			c = ff( c, d, a, b, x[int(i+10)], 17, -42063 );                 // 11
			b = ff( b, c, d, a, x[int(i+11)], 22, -1990404162 );    // 12
			a = ff( a, b, c, d, x[int(i+12)],  7, 1804603682 );     // 13
			d = ff( d, a, b, c, x[int(i+13)], 12, -40341101 );      // 14
			c = ff( c, d, a, b, x[int(i+14)], 17, -1502002290 );    // 15
			b = ff( b, c, d, a, x[int(i+15)], 22, 1236535329 );     // 16
			
			// Round 2
			a = gg( a, b, c, d, x[int(i+ 1)],  5, -165796510 );     // 17
			d = gg( d, a, b, c, x[int(i+ 6)],  9, -1069501632 );    // 18
			c = gg( c, d, a, b, x[int(i+11)], 14, 643717713 );      // 19
			b = gg( b, c, d, a, x[int(i+ 0)], 20, -373897302 );     // 20
			a = gg( a, b, c, d, x[int(i+ 5)],  5, -701558691 );     // 21
			d = gg( d, a, b, c, x[int(i+10)],  9, 38016083 );       // 22
			c = gg( c, d, a, b, x[int(i+15)], 14, -660478335 );     // 23
			b = gg( b, c, d, a, x[int(i+ 4)], 20, -405537848 );     // 24
			a = gg( a, b, c, d, x[int(i+ 9)],  5, 568446438 );      // 25
			d = gg( d, a, b, c, x[int(i+14)],  9, -1019803690 );    // 26
			c = gg( c, d, a, b, x[int(i+ 3)], 14, -187363961 );     // 27
			b = gg( b, c, d, a, x[int(i+ 8)], 20, 1163531501 );     // 28
			a = gg( a, b, c, d, x[int(i+13)],  5, -1444681467 );    // 29
			d = gg( d, a, b, c, x[int(i+ 2)],  9, -51403784 );      // 30
			c = gg( c, d, a, b, x[int(i+ 7)], 14, 1735328473 );     // 31
			b = gg( b, c, d, a, x[int(i+12)], 20, -1926607734 );    // 32
			
			// Round 3
			a = hh( a, b, c, d, x[int(i+ 5)],  4, -378558 );        // 33
			d = hh( d, a, b, c, x[int(i+ 8)], 11, -2022574463 );    // 34
			c = hh( c, d, a, b, x[int(i+11)], 16, 1839030562 );     // 35
			b = hh( b, c, d, a, x[int(i+14)], 23, -35309556 );      // 36
			a = hh( a, b, c, d, x[int(i+ 1)],  4, -1530992060 );    // 37
			d = hh( d, a, b, c, x[int(i+ 4)], 11, 1272893353 );     // 38
			c = hh( c, d, a, b, x[int(i+ 7)], 16, -155497632 );     // 39
			b = hh( b, c, d, a, x[int(i+10)], 23, -1094730640 );    // 40
			a = hh( a, b, c, d, x[int(i+13)],  4, 681279174 );      // 41
			d = hh( d, a, b, c, x[int(i+ 0)], 11, -358537222 );     // 42
			c = hh( c, d, a, b, x[int(i+ 3)], 16, -722521979 );     // 43
			b = hh( b, c, d, a, x[int(i+ 6)], 23, 76029189 );       // 44
			a = hh( a, b, c, d, x[int(i+ 9)],  4, -640364487 );     // 45
			d = hh( d, a, b, c, x[int(i+12)], 11, -421815835 );     // 46
			c = hh( c, d, a, b, x[int(i+15)], 16, 530742520 );      // 47
			b = hh( b, c, d, a, x[int(i+ 2)], 23, -995338651 );     // 48
			
			// Round 4
			a = ii( a, b, c, d, x[int(i+ 0)],  6, -198630844 );     // 49
			d = ii( d, a, b, c, x[int(i+ 7)], 10, 1126891415 );     // 50
			c = ii( c, d, a, b, x[int(i+14)], 15, -1416354905 );    // 51
			b = ii( b, c, d, a, x[int(i+ 5)], 21, -57434055 );      // 52
			a = ii( a, b, c, d, x[int(i+12)],  6, 1700485571 );     // 53
			d = ii( d, a, b, c, x[int(i+ 3)], 10, -1894986606 );    // 54
			c = ii( c, d, a, b, x[int(i+10)], 15, -1051523 );       // 55
			b = ii( b, c, d, a, x[int(i+ 1)], 21, -2054922799 );    // 56
			a = ii( a, b, c, d, x[int(i+ 8)],  6, 1873313359 );     // 57
			d = ii( d, a, b, c, x[int(i+15)], 10, -30611744 );      // 58
			c = ii( c, d, a, b, x[int(i+ 6)], 15, -1560198380 );    // 59
			b = ii( b, c, d, a, x[int(i+13)], 21, 1309151649 );     // 60
			a = ii( a, b, c, d, x[int(i+ 4)],  6, -145523070 );     // 61
			d = ii( d, a, b, c, x[int(i+11)], 10, -1120210379 );    // 62
			c = ii( c, d, a, b, x[int(i+ 2)], 15, 718787259 );      // 63
			b = ii( b, c, d, a, x[int(i+ 9)], 21, -343485551 );     // 64
			
			a += aa;
			b += bb;
			c += cc;
			d += dd;
		}
		digest = new ByteArray()
		digest.writeInt(a);
		digest.writeInt(b);
		digest.writeInt(c);
		digest.writeInt(d);
		digest.position = 0;
		// Finish up by concatening the buffers with their hex output
		return IntUtil.toHex( a ) + IntUtil.toHex( b ) + IntUtil.toHex( c ) + IntUtil.toHex( d );
	}
	
	/**
	 * Auxiliary function f as defined in RFC
	 */
	private static function f( x:int, y:int, z:int ):int {
		return ( x & y ) | ( (~x) & z );
	}
	
	/**
	 * Auxiliary function g as defined in RFC
	 */
	private static function g( x:int, y:int, z:int ):int {
		return ( x & z ) | ( y & (~z) );
	}
	
	/**
	 * Auxiliary function h as defined in RFC
	 */
	private static function h( x:int, y:int, z:int ):int {
		return x ^ y ^ z;
	}
	
	/**
	 * Auxiliary function i as defined in RFC
	 */
	private static function i( x:int, y:int, z:int ):int {
		return y ^ ( x | (~z) );
	}
	
	/**
	 * A generic transformation function.  The logic of ff, gg, hh, and
	 * ii are all the same, minus the function used, so pull that logic
	 * out and simplify the method bodies for the transoformation functions.
	 */
	private static function transform( func:Function, a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
		var tmp:int = a + int( func( b, c, d ) ) + x + t;
		return IntUtil.rol( tmp, s ) +  b;
	}
	
	/**
	 * ff transformation function
	 */
	private static function ff ( a:int, b:int, c:int, d:int, x:int, s:int, t:int ):int {
		return transform( f, a, b, c, d, x, s, t );
	}
	
	/**
	 * gg transformation function
	 */
	private static function gg ( a:int, b:int, c:int, d:int, x:int, s:int, t:int ):int {
		return transform( g, a, b, c, d, x, s, t );
	}
	
	/**
	 * hh transformation function
	 */
	private static function hh ( a:int, b:int, c:int, d:int, x:int, s:int, t:int ):int {
		return transform( h, a, b, c, d, x, s, t );
	}
	
	/**
	 * ii transformation function
	 */
	private static function ii ( a:int, b:int, c:int, d:int, x:int, s:int, t:int ):int {
		return transform( i, a, b, c, d, x, s, t );
	}
	
	/**
	 * Converts a string to a sequence of 16-word blocks
	 * that we'll do the processing on.  Appends padding
	 * and length in the process.
	 *
	 * @param s The string to split into blocks
	 * @return An array containing the blocks that s was
	 *                      split into.
	 */
	private static function createBlocks( s:ByteArray ):Array {
		var blocks:Array = new Array();
		var len:int = s.length * 8;
		var mask:int = 0xFF; // ignore hi byte of characters > 0xFF
		for( var i:int = 0; i < len; i += 8 ) {
			blocks[ int(i >> 5) ] |= ( s[ i / 8 ] & mask ) << ( i % 32 );
		}
		
		// append padding and length
		blocks[ int(len >> 5) ] |= 0x80 << ( len % 32 );
		blocks[ int(( ( ( len + 64 ) >>> 9 ) << 4 ) + 14) ] = len;
		return blocks;
	}
	
}