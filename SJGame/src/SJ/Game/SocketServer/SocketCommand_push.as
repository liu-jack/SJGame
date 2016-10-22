package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.core.PushService;
	
	import engine_starling.utils.SManufacturerUtils;
	
	public class SocketCommand_push
	{
		public function SocketCommand_push()
		{
		}
		
		/**
		 * 注册Token 
		 * 
		 */
		public static function registertoken():void
		{
			
			if(PushService.o.getDeviceToken()== null)
			{
				return;
			}
			var manufactory:String = SManufacturerUtils.getManufacturerType();		
			var pushType:int = 0;//0: android 1: iphone
			if(manufactory == SManufacturerUtils.TYPE_ANDROID)
			{
				pushType = 0;
			}
			else if(manufactory == SManufacturerUtils.TYPE_IOS)
			{
				pushType = 1;
			}
			else 
			{
				pushType = -1;
			}
			SocketManager.o.callunlock(ConstNetCommand.CS_REGISTER_PUSH,pushType
				,PushService.o.getDeviceToken());
		}
	}
}