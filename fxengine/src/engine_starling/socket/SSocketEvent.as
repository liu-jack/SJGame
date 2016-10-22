package engine_starling.socket
{
	public class SSocketEvent
	{
		public function SSocketEvent()
		{
		}
		/**
		 * 网络数据到达 
		 */
		public static const SocketEventData:String = "SocketEventData";
		
		/**
		 * 服务器错误数据 
		 */
		public static const SocketEventDataError:String = "SocketEventDataError";
		
		/**
		 * 网络连接成功 
		 */
		public static const SocketEventConnect:String = "SocketEventConnect";
		
		
		/**
		 * 网络断开连接 
		 */
		public static const SocketEventDisConnect:String = "SocketEventDisConnect";
		
		
		/**
		 * 网络错误 
		 */
		public static const SocketEventError:String = "SocketEventError";
		
		
		/**
		 * 网络连接错误 
		 */
		public static const SocketConnectError:String = "SocketConnectError";
		
		
		/**
		 * 服务器状态错误 
		 */
		public static const SocketServerError:String = "SocketServerError";
	}
}