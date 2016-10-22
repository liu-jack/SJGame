package lib.engine.net
{
	import flash.events.*;
	import flash.net.*;
	
	import lib.engine.utils.functions.Assert;

	
	/**
	 * amf 调用类
	 * 请继承使用，先调用静态方法 <code>setConst</code> ，设置常量
	 */
	public class CAmfCall extends NetConnection
	{
		private static var _params:Object;				//  系统参数，verify 等
		private static var _gateway:String;				//	 amf网关
		protected static var _loading:Boolean = false;	//  是否正在加载中
		protected var _connection:NetConnection;
		protected var _responder:Responder;
		protected var _service:String;
		protected var _evtMC:*;
		protected var _onResult:Function;
		protected var _onFault:Function;
		protected var _keepAlive:Boolean=false;
		
		/**
		 * 远程AMF通信类
		 * @param onResult 结果返回调用函数
		 * @param onFault 出错回调函数
		 * @param keepAlive 是否保持连接，保持连接将实例化时候进行连接，然后可以随时调用call方法进行远程调用，一般用于比较密集调用的地方
		 *
		 */
		public function CAmfCall(onResult:Function=null, onFault:Function=null, keepAlive:Boolean=false)
		{
			super();
			Assert(CAmfCall._gateway != null && CAmfCall._gateway != "","CAmfCall._gateway 调用AMF前请设置 调用 setConst");
			if(null == _gateway || _gateway == "")
			{
				return;
			}
			this._onResult 	= onResult;
			this._onFault 		= onFault;
			this._keepAlive	= keepAlive;
			
			this.addEventListener(NetStatusEvent.NET_STATUS, this.netStatusHandler, false , 0 , true);
			this.addEventListener(IOErrorEvent.IO_ERROR, this.iOErrorHandler, false, 0, true);
			this.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler, false, 0, true);
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler, false, 0, true);
			if(this._keepAlive) this.connect(CAmfCall._gateway);
		}
		
		/**
		 * 设置CAmfCall常量
		 */
		public static function setConst(gateway:String, params:Object=null):void
		{
			_gateway	= gateway;
			_params 	= params;
		}

		/**
		 *	amf 请求
		 * @param	service	请求service的一个类
		 * @param	param	传递给这个service的参数
		 */
		public function amfCall(service:String, ... arguments):void
		{
			this._service = service;
			var funcParam:Array = arguments as Array;
			
			var serviceArr:Array = service.split(".");
			service = serviceArr[0] + '.callfunc';				//  调用 amfApp 的 run 函数
			CAmfCall._params['calFunc'] = serviceArr[1]; //  把 calFunc 添加到系统参数中去
			
			this._responder = new Responder(this.onResult, this.onFault);
			if(!this._keepAlive)
				this.connect(CAmfCall._gateway);
			
			
			if( true == CAmfCall._loading)
			{
			}
			else
			{
				CAmfCall._loading = true;
			}
		
//			super.call.apply(
			//this.call(serviceArr[0] + '.callfunc', this._responder, CAmfCall._params["verify"] , service , serviceArr[1], funcParam);
			super.call.apply(this,[serviceArr[0] + '.callfunc', this._responder, CAmfCall._params["verify"], CAmfCall._params["loginid"], service, serviceArr[1]].concat(funcParam));
		}
		
		/**
		 * 内部的成功回调函数
		 * @param	result	得到的成功数据
		 */
		protected function onResult(result:Object):void
		{
			if (false != result)
			{
				if(null != this._onResult)
				{
					this._onResult(result);
				}
			}
			if(!this._keepAlive)
				this.close();
			CAmfCall._loading = false;
		}
		
		/**
		 *	内部的失败回调函数
		 * @param	fault	得到的失败数据
		 */
		private function onFault(fault:Object):void
		{
			if(null != this._onFault)
			{
				this._onFault(fault);
			}
			if(!this._keepAlive)
				this.close();
			CAmfCall._loading = false;
		}
		
		/**
		 * 处理网络状态的Handler
		 * @param	event	事件实例
		 */
		private function netStatusHandler(event:NetStatusEvent):void
		{
			switch (event.info.code)
			{
				case "NetConnection.Connect.Success":
					break;
				
				case "NetStream.Play.StreamNotFound":
					break;
				
				case "NetConnection.Connect.Closed":
					if(this._keepAlive)
					{
						//如果保持连接，则在意外关闭的情况下，重新连接
						this.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false , 0 , true);
						this.connect(CAmfCall._gateway);
					}
					break;
				default:
					break;
			}
			CAmfCall._loading = false;
		}
		
		// 处理 网络IO异常
		private function iOErrorHandler(event:IOErrorEvent):void
		{
			CAmfCall._loading = false;
		}
		
		// 处理 异步代码异常
		private function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			CAmfCall._loading = false;
		}
		
		// 处理 权限异常
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			CAmfCall._loading = false;
		}
	}
}
