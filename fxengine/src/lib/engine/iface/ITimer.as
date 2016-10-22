package lib.engine.iface
{
	import flash.events.TimerEvent;

	public interface ITimer
	{
		function onTimer(e:TimerEvent,params:Object = null):void;
		function onTimerEnd():void;
	}
}