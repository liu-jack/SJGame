package fxengine.resource
{
	import flash.utils.ByteArray;
	
	import fxengine.resource.constants.FConstants_event;
	import fxengine.resource.iface.FResourceInterface;
	import fxengine.utils.event.FEvent;
	import fxengine.utils.event.FEventBus;

	/**
	 * 资源管理器 
	 * @author caihua
	 * 
	 */
	public class FResourceManager implements FResourceInterface
	{

		public function FResourceManager()
		{
		}
		
		private static var _o:FResourceManager = null;

		public static function get o():FResourceManager
		{
			if(_o == null)
			{
				_o = new FResourceManager();
			}
			return _o;
		}
		
		
		public function addResource(URL:String, buffer:ByteArray):void
		{
			FEventBus.o.dispatchEvent(new FEvent(FConstants_event.F_R_LoadComplete));
			
		}
		
		public function getResource(URL:String):FResource
		{
			// TODO Auto Generated method stub
			return null;
		}
		
	}
}