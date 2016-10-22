package SJ.Game.SocketServer
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;

	public class HttpServer implements IAnimatable
	{
		private static var _instance:HttpServer;
		/**
		 * 网络检测间隔.秒 
		 */
		private const SOCKET_DELAY_CHECKTIME:Number = 1;
		/**
		 * 网络检测时间 
		 */
		private var _checktime:Number = 0.0;
		
		private var _domain:String = "";
		
		private var requestPool:Vector.<HttpMessage> = new Vector.<HttpMessage>;
		
		public function HttpServer()
		{
		}
		
		public static function getInstance():HttpServer
		{
			if(_instance == null)
			{
				_instance = new HttpServer();
				Starling.juggler.add(_instance);
			}
			return _instance;
		}

		private function _genUrlLoader():URLLoader
		{
			var urlLoader:URLLoader = new URLLoader;
			_configureListeners(urlLoader);
			return urlLoader;
		}
	
		public function advanceTime(time:Number):void
		{
			_checktime += time;
			if(_checktime < SOCKET_DELAY_CHECKTIME)
				return;
			_checktime -= SOCKET_DELAY_CHECKTIME;
			
			_send()
		}
		
		private function _send():void
		{
			if(requestPool.length > 0)
			{
				var d:HttpMessage = requestPool.shift(); //先入先出
				var url:String = d.url;
				var data:Object = d.data;
				var urlRequest:URLRequest = new URLRequest;
				urlRequest.method = URLRequestMethod.POST;
				urlRequest.url = url;
				urlRequest.data = data;
				var urlLoader:URLLoader = _genUrlLoader();
				urlLoader.addEventListener(Event.COMPLETE, function(event:Event):void
				{
					var loader:URLLoader = URLLoader(event.target);
					var data:Object = JSON.parse(loader.data);
					if(d.func)
					{
						d.func(data);
					}
				});
				try {
					trace("request:"+urlRequest.url);
					urlLoader.load(urlRequest);
				} catch (error:Error) {
					trace("Unable to load requested data.");
				}
			}
		}
		
		public  function request(url:String,callBack:Function,data:Object = null):void
		{
			var nurl:String = _domain+url;
			var httpmessage:HttpMessage = new HttpMessage
				httpmessage.url = nurl;
				httpmessage.data = data;
				httpmessage.func = callBack;
			this.requestPool.push(httpmessage);
		}
		
		private function _configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function openHandler(event:Event):void {
			trace("openHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			trace("httpStatusHandler: " + event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}

		public function get domain():String
		{
			return _domain;
		}

		public function set domain(value:String):void
		{
			_domain = value;
		}

	}
}