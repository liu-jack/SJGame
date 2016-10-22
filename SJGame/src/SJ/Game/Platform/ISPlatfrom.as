package SJ.Game.Platform
{
	import starling.events.EventDispatcher;

	/**
	 * 平台接入 
	 * @author caihua
	 * 
	 */
	public class ISPlatfrom extends EventDispatcher
	{
		
		
		/**
		 * 系统启动 
		 * @param params
		 * 
		 */
		public function startup(params:Object):void{};
		/**
		 * 登录 
		 * @param callback(e:object)
		 * 
		 */
		public function login(callback:Function):void{};

		/**
		 * 注销 
		 * @param callback
		 * 
		 */
		public function logout(callback:Function):void{};
		
		
		/**
		 * 帐号ID 
		 * @return 
		 * 
		 */
		public function uid():String{return null;};
		
		
		/**
		 * SessionID 
		 * @return 
		 * 
		 */
		public function SessionId():String{return null;};
		
		/**
		 * 进入工具栏 
		 * 
		 */
		public function entertoolbar():void{};	
		/**
		 * 进入暂停页面 
		 * 
		 */
		public function enterpause():void{};
		/**
		 * 进入平台 
		 * 
		 */
		public function enterplatform():void{};
		/**
		 * 进入bbs 
		 * 
		 */
		public function enterbbs():void{};
		
		/**
		 * 问题反馈 
		 * 
		 */
		public function enterfeedback():void{};
		
		/**
		 * 游戏退出 
		 * @param code 退出参数
		 * 
		 */
		public function gameexit(code:int):void {};
		
		
		/**
		 * 清空缓存数据 
		 * 
		 */
		public function clearcache():void
		{
			
		}
		
		public function set accessToken(value: String):void{}
		
		public function setUid(value: String):void{}
		
		/**
		 * 支付 
		 * @param orderSerial 订单序列号
		 * @param PayConins 代币数量
		 * @param paydesc 支付描述
		 * @param callback 结果回调
		 * @return 
		 * 
		 */
		public function pay(orderSerial:String,PayConins:Number,paydesc:String,callback:Function):int{return 0};
		
		/**
		 * 返回商品列表 
		 * 
		 */
		public function getproducts():void{};

		/**
		 * 构造器 
		 * @param platformid
		 * @return 
		 * 
		 */
		public static function builder(platformid:String):ISPlatfrom
		{
			var iPlatform:ISPlatfrom = new SPlatformDefault();
			CONFIG::CHANNELID_2 {
				iPlatform = new SPlatform91IOS();
			}
			CONFIG::CHANNELID_4 {
				iPlatform = new SPlatform91Android();
			}
			CONFIG::CHANNELID_9 {
				iPlatform = new SPlatformUCIOS();
			}
			CONFIG::CHANNELID_10 {
				iPlatform = new SPlatformUCANDROID();
			}
			CONFIG::CHANNELID_12 {
				iPlatform = new SPlatform360Android();
			}
			CONFIG::CHANNELID_13 {
				iPlatform = new SPlatformXIAOMIAndroid();
			}
			CONFIG::CHANNELID_14 {
				iPlatform = new SPlatformDUOKUAndroid();
			}
			CONFIG::CHANNELID_15 {
				iPlatform = new SPlatformDOWNJOYAndroid();
			}
			CONFIG::CHANNELID_16 {
				iPlatform = new SPlatformKYIOS();
			}
			CONFIG::CHANNELID_17 {
				iPlatform = new SPlatformYYHAndroid();
			}
			CONFIG::CHANNELID_18 {
				iPlatform = new SPlatformWANDOUJIAAndroid();
			}
			CONFIG::CHANNELID_19 {
				iPlatform = new SPlatformPPZHUSHOUIOS();
			}
			CONFIG::CHANNELID_21 {
				iPlatform = new SPlatform9splay();
			}
			return iPlatform;
		}
	}
}