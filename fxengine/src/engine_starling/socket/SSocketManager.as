package engine_starling.socket
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import engine_starling.utils.Logger;
	import engine_starling.utils.SErrorUtil;
	import engine_starling.utils.SLRUCache;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;

	public class SSocketManager extends DisplayObjectContainer implements IAnimatable
	{
		
		
		
		private var _socketServer:Socket;
		private var _ip:String = null;
		private var _port:int;
		/**
		 * 网络检测间隔.秒 
		 */
		private const SOCKET_DELAY_CHECKTIME:Number = 2;
		/**
		 * 断开状态 
		 */
		public static const STATUS_DISCONNECT:int = 0;
		/**
		 * 连接中。。。 
		 */
		public static const STATUS_CONNECTING:int =1;
		/**
		 * 连上 
		 */
		public static const STATUS_CONNECTED:int = 2;
		/**
		 * 端口状态 
		 */
		private var _socketStatus:int = STATUS_DISCONNECT;
		/**
		 * 网络消息 延时缓存 
		 */
		private var _SocketSendCache:SLRUCache = new SLRUCache();
		/**
		 * 网络断开连接后发送的消息 
		 */		
		private var _preSendMsg:Vector.<SSocketMessage> = new Vector.<SSocketMessage>();
		/**
		 * 消息处理单元 
		 */
		protected var _currentMsg:SSocketMessage;
		
		private var _net_sendbytes:Number = 0;
		private var _enablelog:Boolean = false;
		
		/**
		 * 是否打开日志 
		 */
		public function get enablelog():Boolean
		{
			return _enablelog;
		}

		/**
		 * @private
		 */
		public function set enablelog(value:Boolean):void
		{
			_enablelog = value;
		}

		/**
		 * 网络字节数量 
		 */
		public function get net_sendbytes():Number
		{
			return _net_sendbytes;
		}

		/**
		 * @private
		 */
		public function set net_sendbytes(value:Number):void
		{
			_net_sendbytes = value;
		}

		/**
		 * 自动重发失败消息 
		 */
		public function get autoReSendFailedMsg():Boolean
		{
			return _autoReSendFailedMsg;
		}
		
		/**
		 * @private
		 */
		public function set autoReSendFailedMsg(value:Boolean):void
		{
			_autoReSendFailedMsg = value;
		}
		
		private var _auto_reconnectCallback:Function = null;
		/**
		 * 网络检测时间 
		 */
		private var _checktime:Number = 0.0;
		/**
		 * 是否正在自动重连 
		 */
		private var _is_reconnecting:Boolean = false;
		private var _logger:Logger;
		
		private var _autoReSendFailedMsg:Boolean = true;
		
		public function SSocketManager()
		{
			_init();
		}
		
		
		override public function dispose():void
		{
			Starling.juggler.remove(this);
			super.dispose();
		}
		
		
		/**
		 * 连接到指定的IP和端口号 
		 * @param ip
		 * @param port
		 * 
		 */
		public function connect(ip:String,port:int):void
		{
			if(connected)
			{
				_log("连接已经存在!");
				return
			}
			_ip = ip;
			_port = port;
			
			try
			{
				_socketStatus = STATUS_CONNECTING;
				_socketServer.connect(_ip,_port);
			}
			catch(error:IOError)
			{
				dispatchEventWith(SSocketEvent.SocketConnectError);
				_log("连接网络失败!{0}:{1} connect 函数",_ip,_port);
			}
			
		}
		
		/**
		 * 重新连接 
		 * 
		 */
		public function reconnect():void
		{
			Assert(_ip != null,"重连前,请先连接一次!");
			if(_is_reconnecting)
			{
				//正在重连中就不再重连了
				return;
			}
			_is_reconnecting = true;
			connect(_ip,_port);
		}
		/**
		 * 断开连接 
		 * 
		 */
		public function disconnect():void
		{
			if(connected)
			{
				_socketServer.close();
				_is_reconnecting = false;
			}
		}
		/**
		 * 是否连接 
		 * @return 
		 * 
		 */
		public function get connected():Boolean
		{
			return _socketServer.connected;
		}
		
		/**
		 * 调用远程函数 返回值通过  CJSocketEvent.SocketEventData 判断
		 * @param cmd 远程函数名称
		 * @param params 参数
		 * 
		 */
		public function call(cmd:String,...params):void
		{
			send(SSocketMessage.createMessage(cmd,params));
		}
		public function callunlock(cmd:String,...params):void
		{
			send(SSocketMessage.createMessage(cmd,params),false);
		}
		/**
		 * 调用远程 有直接的返回值 只执行一次
		 * @param rtnfunction functon(msg:SocketMessage)
		 * @param cmd 命令字
		 * @param params 参数
		 * 
		 */
		
		public function callwithRtn(cmd:String,rtnfunction:Function = null,useCache:Boolean = false,...params):void
		{
			_callwithRtn(cmd,true,useCache,rtnfunction,params);
		}
		
		public function callUnlockWithRtn(cmd:String,rtnfunction:Function = null,useCache:Boolean = false,...params):void
		{
			_callwithRtn(cmd,false,useCache,rtnfunction,params);
		}
		
		/**
		 * 有返回调用的消息发送 
		 * @param cmd 消息命令
		 * @param sync 是否为同步方法
		 * @param useCache 是否使用缓存
		 * @param rtnfunction 返回函数 functon(msg:SocketMessage)
		 * @param params 调用消息的参数
		 * 
		 */
		private function _callwithRtn(cmd:String,sync:Boolean,useCache:Boolean,rtnfunction:Function = null,params:Array= null):void
		{
			function _onrecv(e:*):void
			{
				var message:SSocketMessage = e.data as SSocketMessage;
				if(message.getCommand() != cmd)
					return;
				if(sendmsg.getCommandVer != message.getCommandVer)
					return;
				e.target.removeEventListener(e.type,_onrecv);
				rtnfunction(message);
			}
			var sendmsg:SSocketMessage = SSocketMessage.createMessage(cmd,params);
			_send(sendmsg,sync,useCache);
			if(rtnfunction != null)
			{
				addEventListener(SSocketEvent.SocketEventData,_onrecv);
			}
		}
		
		/**
		 * 发送消息 
		 * @param msg 消息内容	
		 * @param sync 同步消息
		 * 
		 */
		public function send(msg:SSocketMessage,sync:Boolean = true):void
		{
			_send(msg,sync,false);
		}
		/**
		 * 调用一次连接,然后断开 
		 * @param ip 服务器地址
		 * @param port 端口号
		 * @param cmd 命令字 例如 "account.getserverstatus"
		 * @param rtnfunction 调用返回 e(retParams{code:0成功,1失败 msg:获得的msg rtnfunctionParams:传入的回调参数})
		 * @param rtnfunctionParams 函数返回字段 可以为null
		 * @param params rp参数
		 * 
		 */
		public static function callonce(ip:String,port:int,cmd:String,rtnfunction:Function,rtnfunctionParams:Object,params:Array):void
		{
			var _sockmgr:SSocketManager = new SSocketManager();
			_sockmgr.autoReSendFailedMsg = false;
			
			var sendmsg:SSocketMessage = SSocketMessage.createMessage(cmd,params);
			var retParams:Object = new Object();
			retParams.rtnfunctionParams = rtnfunctionParams;
			retParams.msg = sendmsg;
			retParams.code = 0;
			
			function _onrecv(e:*):void
			{
				var message:SSocketMessage = e.data as SSocketMessage;
				if(message.getCommand() != cmd)
					return;
				if(sendmsg.getCommandVer != message.getCommandVer)
					return;
				e.target.removeEventListener(e.type,_onrecv);
				retParams.msg = message;
				if(rtnfunction!= null)
				{
					rtnfunction(retParams);
				}
				
				//断开连接
				_sockmgr.disconnect();
				_sockmgr.dispose();
				_sockmgr = null;
			}
			
			_sockmgr.addEventListener(SSocketEvent.SocketEventData,_onrecv);
			_sockmgr.addEventListener(SSocketEvent.SocketEventConnect,function (e:*):void
			{
				_sockmgr.send(sendmsg,false);
			});
			_sockmgr.addEventListener(SSocketEvent.SocketEventError,function(e:*):void
			{
				retParams.code = 1;
				if(rtnfunction!= null)
				{
					rtnfunction(retParams);
				}
				//断开连接
				_sockmgr.disconnect();
				_sockmgr.dispose();
				_sockmgr = null;
			});
			
			_sockmgr.connect(ip,port);
		}
		
		
		
		
		public function advanceTime(time:Number):void
		{
			_checktime += time;
			if(_checktime < SOCKET_DELAY_CHECKTIME)
				return;
			_checktime -= SOCKET_DELAY_CHECKTIME;
			
			var bTimeOut:Boolean = false;
			var timesocketmessages:Dictionary = _SocketSendCache.getAllExprieObject();
			
			//没有超时对象
			if(timesocketmessages == null)
				return;
			
			//主动断开一次连接
//			disconnect();
			
			//超时
			for (var key:String in timesocketmessages)
			{
				var msg:SSocketMessage = timesocketmessages[key]['msg'] as SSocketMessage;
				var sync:Boolean = timesocketmessages[key]['sync']
				_log("socket message time out:" + msg.toString());
				bTimeOut  = true;
				_unlock(msg);
				if(_autoReSendFailedMsg)
				{
					_send(msg,sync);
				}
			}
		}
		
		/**
		 * 自动重连后的执行函数 
		 */
		public function get auto_reconnectCallback():Function
		{
			return _auto_reconnectCallback;
		}
		
		/**
		 * @private
		 */
		public function set auto_reconnectCallback(value:Function):void
		{
			_auto_reconnectCallback = value;
		}
		
		private function _init():void
		{
			_logger = Logger.getInstance(SSocketManager);
			_socketServer = new Socket();
			_socketServer.endian = Endian.LITTLE_ENDIAN;
			_socketServer.addEventListener(Event.CONNECT,_onEventConnect);
			_socketServer.addEventListener(Event.CLOSE,_onEventDisconnect);
			_socketServer.addEventListener(IOErrorEvent.IO_ERROR,_onEventIOError);
			_socketServer.addEventListener(ProgressEvent.SOCKET_DATA,_onEventData);
			_socketServer.addEventListener(SecurityErrorEvent.SECURITY_ERROR,_onEventIOError);
			
			_currentMsg = new SSocketMessage();
			Starling.juggler.add(this);
		}
		/**
		 * 消息锁名称 
		 * @param msg
		 * @return 
		 * 
		 */
		protected function _lockname(msg:SSocketMessage):String
		{
			return "socketmanagerlock_" + msg.getCommand() + "_" + msg.getCommandVer;
		}
		protected function _lock(msg:SSocketMessage,sync:Boolean = false):void
		{
			var _lname:String = _lockname(msg);
			
			_SocketSendCache.addObject(_lname,{'msg':msg,'sync':sync},15 * 1000);
		}
		protected function _unlock(msg:SSocketMessage):void
		{
			var _lname:String = _lockname(msg);
			_SocketSendCache.delObject(_lname);
		}
		protected function _unlockall():void
		{
		}
		
		/**
		 * 发送消息 
		 * @param msg
		 * @param sync 是否同步操作
		 * @param useCache 是否使用缓存 废弃
		 * 
		 */
		private function _send(msg:SSocketMessage,sync:Boolean,useCache:Boolean = false):void
		{
			if(!connected)
			{
				_log("发送时网络已经关闭")
				_preSendMsg.push(msg);
				//自动重连
				reconnect();
				return;
			}
			
			if(msg.messageType ==  SSocketMessage.MessageTypeData
			||msg.messageType == SSocketMessage.MessageTypeDataGzip)
			{
				_lock(msg,sync);
				_log("socket send>>>{0}",msg.toString());
			}
			var msgbuffer:ByteArray = msg.buffer();
			net_sendbytes += msgbuffer.length;
			_socketServer.writeBytes(msgbuffer);
			_socketServer.flush();
		}
		private function _log(msg:String,...args):void
		{
			if(_enablelog)
			{
				_logger.info(msg,args);
			}
		}
		
		private function _onEventConnect(e:Event):void
		{
			_socketStatus = STATUS_CONNECTED;
			if(_is_reconnecting)//是自动重连进来的
			{
				_is_reconnecting = false;
				if(_auto_reconnectCallback != null)
				{
					_auto_reconnectCallback();
				}
			}
			//发送在连接之前已经在消息缓存中的消息后面的消息
			//
			var socketmsg:SSocketMessage = null;
			while(null != (socketmsg = _preSendMsg.pop()))
			{
				_send(socketmsg,false);
			}
			_log("连接网络成功!{0}:{1}",_socketServer.remoteAddress,_socketServer.remotePort.toString());
			this.dispatchEventWith(SSocketEvent.SocketEventConnect);
		}
		
		private function _onEventData(e:Event):void
		{
			//处理此消息
			_processMsg();	
		}
		private var _totalbuffercount:Number = 0;
		private function _processMsg():void
		{
			var e:Object = {err:false};
			
			while(connected && _currentMsg.readMsg(_socketServer,e))
			{
				if(_currentMsg.messageType == SSocketMessage.MessageTypeData
					||_currentMsg.messageType == SSocketMessage.MessageTypeDataGzip)
				{
					net_sendbytes += (_currentMsg.bodylen + 8);
					if(enablelog)
					{
						_log("socket recv<<<{0}/{1}k:{2}",_currentMsg.bodylen + 8,_totalbuffercount/1024,_currentMsg.toString());
					}
					_unlock(_currentMsg);
					try
					{
						if(_currentMsg.retcode > -1000)
						{
							dispatchEventWith(SSocketEvent.SocketEventData,false,_currentMsg);
						}
						else//服务器调用RPC错误
						{
							dispatchEventWith(SSocketEvent.SocketEventDataError,false,_currentMsg);
						}
					}
					catch(ex:Error)
					{
						SErrorUtil.reportError(ex,"[no crash]");
					}
				}
				else if(_currentMsg.messageType == SSocketMessage.MessageTypeLinkTest)
				{
					this.send(SSocketMessage.createLinkTestMessage(),false);
				}
				else if(_currentMsg.messageType == SSocketMessage.MessageTypeServerStatus)
				{
					//					_rpcHelperObject	Object (@1851f3e9)	
					//					err	"SERVER_ERROR"	
					//					msg	"服务器内部错误"	
					//					url	"http://example.com/error/server_error"	
					
					//					_rpcHelperObject	Object (@186b0c11)	
					//					err	"MAINTENANCE"	
					//					msg	"服务器处于维护状态"	
					//					url	"http://example.com/error/maintenance"	
					
					dispatchEventWith(SSocketEvent.SocketServerError,false,_currentMsg);
				}
				_currentMsg.clear();
			}
			
			if(e.err == true)
			{
				_currentMsg.clear();
				disconnect();
			}
		}
		
		private function _reset():void
		{
			_currentMsg.clear();
			//移除所哟网络锁
			_unlockall();
		}
		
		private function _onEventDisconnect(e:Event):void
		{
			_socketStatus = STATUS_DISCONNECT;
			//这里可能是因为3G为了省电,而断开连接, reconnect allow
			_log("网络断开");
			_reset();
			dispatchEventWith(SSocketEvent.SocketEventDisConnect);
		}
		
		private function _onEventIOError(e:Event):void
		{
			var connectederror:Boolean = false;
			if(_socketStatus == STATUS_CONNECTING)
			{
				connectederror = true;
				_log("网络错误!连接不到指定的网络");
			}
			else
			{
				_log("网络错误!请确保可以连接网络");
			}
			_socketStatus = STATUS_DISCONNECT;
			
			_reset();
			if(connectederror)
			{
				dispatchEventWith(SSocketEvent.SocketConnectError);
			}
			else
			{
				dispatchEventWith(SSocketEvent.SocketEventError);
			}
			
		}
		
		public function get socketStatus():int
		{
			return _socketStatus;
		}
	}
}