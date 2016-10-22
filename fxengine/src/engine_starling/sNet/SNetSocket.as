package engine_starling.sNet
{
	import flash.net.Socket;

	/**
	 * 网络套接字 
	 * @author caihua
	 * 
	 */
	public class SNetSocket extends Socket
	{
		private var _sock:Socket;
		public function SNetSocket()
		{
			super();
			
		
		}
		
		public function SendData(message:SNetMessage):void
		{
			
			message.writeToDataOutput(this);
			flush();
			
		}
		
		
	}
}