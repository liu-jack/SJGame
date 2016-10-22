package lib.engine.iface
{
	import lib.engine.event.CEvent;
	
	/**
	 * 消息主题接口 
	 * @author caihua
	 * 
	 */
	public interface IEventSubject
	{
		function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void;
		function dispatchEvent(event:CEvent):Boolean;
		function hasEventListener(type:String):Boolean;
		function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void;
		function willTrigger(type:String):Boolean;
	}
}