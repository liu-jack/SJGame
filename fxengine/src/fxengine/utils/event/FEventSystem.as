package fxengine.utils.event
{
	import flash.events.EventDispatcher;
	
	import fxengine.utils.event.iface.FEventInterface;

	/**
	 * 消息总线 
	 * @author caihua
	 * 
	 */
	public class FEventSystem implements FEventInterface
	{
		private var _eventbus:EventDispatcher;
		public function FEventSystem()
		{
			_eventbus = new EventDispatcher();
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