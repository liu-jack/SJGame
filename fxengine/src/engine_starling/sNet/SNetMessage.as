package engine_starling.sNet
{
	import com.google.protobuf.Message;
	
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;

	public class SNetMessage extends Message
	{
		public function SNetMessage()
		{
		}
		
		public function readHead(dataInput:IDataInput):Boolean
		{
			return false;
		}
		
		public function writeHead(dataInput:IDataOutput):void
		{
			
		}
		
		
	}
}