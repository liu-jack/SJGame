package engine_starling.socket
{
	import com.probertson.utils.GZIPBytesEncoder;
	
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import engine_starling.utils.SPlatformUtils;
	
	import lib.engine.utils.CStringUtils;
	import lib.engine.utils.functions.Assert;

	public class SSocketMessage
	{
		
		/**
		 * 消息头长度 
		 */
		private static const  MessageHeaderLen:int = 1+1+2+4;
		
		
		/**
		 * 普通数据消息 
		 */
		public static const MessageTypeData:int = 0;
		/**
		 * 链路检测消息 
		 */
		public static const MessageTypeLinkTest:int = 1;
		/**
		 * 压缩数据消息 
		 */
		public static const MessageTypeDataGzip:int = 2;
		
		/**
		 * 服务器信息 
		 */
		public static const MessageTypeServerStatus:int = 3;
		
		/**
		 * 当前消息大版本号 
		 * 2 支持Gzip
		 */
		public static const curMessageverMajor:int = 2;
		/**
		 * 当前消息小版本号 
		 */
		public static const curMessageVerMinjor:int = 0;
		
		
		private static var _gzipencoder:GZIPBytesEncoder;
		
		public function SSocketMessage()
		{
			_verMajor = curMessageverMajor;
			_verMinjor = curMessageVerMinjor
			_msgBody = new ByteArray();
			_got_head = false;
		}
		
		private var _verMajor:int;
		
		/**
		 * Rpc解析辅助对象
		 */
		public function get rpcHelperObject():Object
		{
			return _rpcHelperObject;
		}
		
		/**
		 * 消息主版本号 
		 */
		public function get verMajor():int
		{
			return _verMajor;
		}
		
		/**
		 * @private
		 */
		public function set verMajor(value:int):void
		{
			_verMajor = value;
		}
		
		private var _verMinjor:int;
		
		/**
		 * 消息次版本号 
		 */
		public function get verMinjor():int
		{
			return _verMinjor;
		}
		
		/**
		 * @private
		 */
		public function set verMinjor(value:int):void
		{
			_verMinjor = value;
		}
		
		private var _messageType:int;
		
		/**
		 * 消息类型 
		 */
		public function get messageType():int
		{
			return _messageType;
		}
		
		/**
		 * @private
		 */
		public function set messageType(value:int):void
		{
			_messageType = value;
		}
		
		private var _bodylen:int;
		
		/**
		 * 消息长度 
		 */
		public function get bodylen():int
		{
			return _bodylen;
		}
		
		/**
		 * @private
		 */
		public function set bodylen(value:int):void
		{
			_bodylen = value;
		}
		
		
		/**
		 * 是否已经读取消息头 
		 */
		private var _got_head:Boolean;
		private var _got_body:Boolean;
		
		
		private var _msgBody:ByteArray;
		
		/**
		 * 消息体
		 */
		public function get msgBody():ByteArray
		{
			return _msgBody;
		}
		
		/**
		 * 设置消息体  
		 * @param value JSON字符串
		 * 
		 */
		protected function _setmsgBody(value:String):void
		{
			_msgBody.clear();
			_msgBody.writeMultiByte(value,"utf-8");
			_msgBody.position = 0;
			
			
			_bodylen = _msgBody.length;
			
		}
		
		
		/**
		 * 获取需要发送的数据 
		 * @return 
		 * 
		 */
		public function buffer():ByteArray
		{
			
			var tmpBuffer:ByteArray = new ByteArray();
			tmpBuffer.endian = Endian.LITTLE_ENDIAN
			tmpBuffer.writeByte(_verMajor);
			tmpBuffer.writeByte(_verMinjor);
			tmpBuffer.writeShort(_messageType);
			tmpBuffer.writeUnsignedInt(_bodylen);
			tmpBuffer.writeBytes(_msgBody);
			return tmpBuffer;
		}
		
		/**
		 * 读取消息 重置使用 clear
		 * @param socket
		 * @return T 读取成功 F读取失败 
		 * 
		 */
		public function readMsg(socket:Socket,e:Object = null):Boolean
		{
			
			if(!_got_head)//读取消息头
			{
				//没有完整消息头
				_got_head = _readMsgHead(socket);
				if(!_got_head)
					return false;
			}
			
			
			//读取消息体
			_got_body = _readMsgBody(socket,e);
			return _got_body;
			
		}
		
		
		
		/**
		 * 读取消息头 
		 * @param socket
		 * @return 
		 * 
		 */
		private function _readMsgHead(socket:Socket):Boolean
		{
			if(socket.bytesAvailable < MessageHeaderLen)
			{
				return false;	
			}
			_verMajor =  socket.readByte();
			_verMinjor = socket.readByte();
			_messageType = socket.readShort();
			_bodylen = socket.readUnsignedInt();
			return true;
		}
		/**
		 * 读取消息体 
		 * @param socket
		 * @return 
		 * 
		 */
		private function _readMsgBody(socket:Socket,e:Object):Boolean
		{
			Assert(_bodylen >= 0,"readMsgBody error _bodylen < 0");
			if(socket.bytesAvailable < _bodylen)
			{
				return false;
			}
			if(_bodylen == 0)
			{
				return true;
			}
			_msgBody.length = 0;
			socket.readBytes(_msgBody,0,_bodylen);
			_msgBody.position = 0;
			try
			{
				if(_messageType == MessageTypeDataGzip){
					if(_gzipencoder == null)
						_gzipencoder = new GZIPBytesEncoder();
					
					var uncompressbyteArray:ByteArray = _gzipencoder.uncompressToByteArray(_msgBody);
					_rpcHelperObject = JSON.parse(uncompressbyteArray.toString());
					
					uncompressbyteArray.clear();
				}
				else{
					_rpcHelperObject = JSON.parse(_msgBody.toString());
				}
			}
			catch(ex:Error)
			{
				if(e != null)
				{
					e.err = true;
				}
				return false;
			}
			return true;
		}
		
		public function clone():SSocketMessage
		{
			var cloned:SSocketMessage = new SSocketMessage();
			cloned._verMajor = _verMajor;
			cloned._verMinjor = _verMinjor;
			cloned._messageType = _messageType;
			cloned._bodylen = _bodylen;
			cloned._got_head = _got_head;
			cloned._msgBody.writeBytes(_msgBody);
			
			return cloned;
		}
		
		public function clear():void
		{
			_verMajor = 0;
			_verMinjor = 0;
			_messageType = 0;
			_bodylen = 0;
			_got_head = false;
			
			_msgBody.clear();
			_rpcHelperObject = null;
		}
		
		public function toString():String
		{
			
			if(SPlatformUtils.isDebug())
			{
				if(_messageType == SSocketMessage.MessageTypeData)
				{
				var r:String = CStringUtils.replaceStringByOrder("Message verMajor{0} varMinor{1} type:{2} bodyLen:{3} msg:{4}",
					_verMajor,_verMinjor,_messageType,_bodylen,_msgBody.toString());
				}
				else if(_messageType == SSocketMessage.MessageTypeDataGzip)
				{
					_msgBody.position = 0;
					r = CStringUtils.replaceStringByOrder("Message verMajor{0} varMinor{1} type:{2} bodyLen:{3} msg:{4}",
						_verMajor,_verMinjor,_messageType,_bodylen,_gzipencoder.uncompressToByteArray(_msgBody).toString());
				}
				return r;
			}
			else
			{
				return "";
			}
			
		}
		
		private var _rpcHelperObject:Object;
		/**
		 * 获取命令字符 
		 * @return 
		 * 
		 */
		public function getCommand():String
		{
			if (_rpcHelperObject == null)
				_rpcHelperObject = JSON.parse(_msgBody.toString());
			if(_rpcHelperObject.hasOwnProperty('cmd'))
				return _rpcHelperObject['cmd'];
			return null
			
		}
		public function get getCommandVer():int
		{
			if (_rpcHelperObject == null)
				_rpcHelperObject = JSON.parse(_msgBody.toString());
			if(_rpcHelperObject.hasOwnProperty('cmdver'))
				return _rpcHelperObject['cmdver'];
			return 0
		}
		
		/**
		 * 获取返回参数个数 
		 * @return 
		 * 
		 */
		public function get numOfParams():int
		{
			if (_rpcHelperObject == null)
				_rpcHelperObject = JSON.parse(_msgBody.toString());
			return _rpcHelperObject['params']['__ac'];
		}
		/**
		 * 获取返回参数 ,自己函数的参数从1开始,0是RetCode
		 * @param index
		 * 
		 */
		public function params(index:int = 0):*
		{
			if(index >= numOfParams)
			{
				Assert(false,"获取索引越界");
				return null;
			}
			return _rpcHelperObject['params']['__' + index];
			
		}
		
		/**
		 * 获取返回参数 
		 * @return * 返回参数 == params(1)
		 * 
		 */		
		public function get retparams():*
		{
			return params(1);
		}
		/**
		 * 返回code 
		 * @return 
		 * 
		 */
		public function get retcode():int
		{
			return params(0) as int;
		}
		/**
		 * 消息版本种子 
		 */
		private static var _cmdverseek:int = 0;
		/**
		 * 创建新消息的助手类 
		 * @param command
		 * @param params 参数
		 * @return 
		 * 
		 */
		public static function createMessage(command:String,params:Array,username:String = null ,md5password:String = null):SSocketMessage
		{
			var msg:SSocketMessage = new SSocketMessage();
			msg.verMajor = curMessageverMajor;
			msg.verMinjor = curMessageVerMinjor;
			
			var msgObject:Object = new Object;
			var length:int = params.length;
			
			msgObject.cmd = command;
			msgObject.cmdver = _cmdverseek ++ ;
			
			
			if(username != null)
			{
				msgObject.uname = username;
				msgObject.pwd = md5password;
			}
			var paramsdict:Object = new Object();
			for (var i:int=0;i<length;i++)
			{
				paramsdict["__" + i] = params[i]
			}
			paramsdict["__ac"] = length;
			
			msgObject.params = paramsdict;
			
			var msgString:String = JSON.stringify(msgObject);
			msg._setmsgBody(msgString);
			
			
			return msg;
		}
		
		/**
		 * 生成链路检测消息 
		 * 
		 */
		public static function createLinkTestMessage():SSocketMessage
		{
			var msg:SSocketMessage = new SSocketMessage();
			msg.verMajor = curMessageverMajor;
			msg.verMinjor = curMessageVerMinjor;
			
			msg.messageType = MessageTypeLinkTest;
			msg._setmsgBody("[]");
			return msg;
		}
	}
}