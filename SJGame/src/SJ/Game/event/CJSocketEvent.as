package SJ.Game.event
{
	import engine_starling.socket.SSocketEvent;

	/**
	 * 网络操作事件 
	 * @author caihua
	 * 
	 */
	public final class CJSocketEvent
	{
		public function CJSocketEvent()
		{
		}
		
		/**
		 * 网络数据到达 
		 */
		public static const SocketEventData:String = SSocketEvent.SocketEventData;
		
		/**
		 * 网络连接成功 
		 */
		public static const SocketEventConnect:String = SSocketEvent.SocketEventConnect;
		
		
		/**
		 * 网络断开连接 
		 */
		public static const SocketEventDisConnect:String = SSocketEvent.SocketEventDisConnect;
		
		
		/**
		 * 网络错误 
		 */
		public static const SocketEventError:String = SSocketEvent.SocketEventError;
		
		
		/**
		 * 网络连接错误 
		 */
		public static const SocketConnectError:String = SSocketEvent.SocketConnectError;
		
		
		/**
		 * 服务器状态错误 
		 */
		public static const SocketServerError:String = SSocketEvent.SocketServerError;
		
	}
}