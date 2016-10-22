package fxengine.utils.event
{
	import fxengine.utils.event.iface.FEventInterface;

	/**
	 * 公用消息总线 
	 * @author caihua
	 * 
	 */
	public class FEventBus implements FEventInterface
	{
		private var _eventbus:FEventSystem = null;
		private static var _o:FEventBus = null;
		public function FEventBus()
		{
			_eventbus = new FEventSystem();
		}
		
		public static function get o():FEventBus
		{
			if(_o == null)
			{
				_o = new FEventBus();
			}
			return _o;
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_eventbus.addEventListener(type,listener,useCapture,priority,useWeakReference);			
		}
		
		public function dispatchEvent(event:FEvent):Boolean
		{
			return _eventbus.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _eventbus.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_eventbus.removeEventListener(type,listener,useCapture);			
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _eventbus.willTrigger(type);
		}
		
	}
}