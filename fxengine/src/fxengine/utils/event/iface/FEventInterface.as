package fxengine.utils.event.iface
{
	import fxengine.utils.event.FEvent;

	public interface FEventInterface
	{
		function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void;
		function dispatchEvent(event:FEvent):Boolean;
		function hasEventListener(type:String):Boolean;
		function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void;
		function willTrigger(type:String):Boolean;
	}
}