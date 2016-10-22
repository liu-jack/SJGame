package engine_starling.Events
{
	import flash.utils.Dictionary;
	
	import starling.events.EventDispatcher;
	
	public class SafeEventDispatcher extends EventDispatcher
	{
		public function SafeEventDispatcher()
		{
			super();
		}
		
		private var _listenerproxy:Dictionary = new Dictionary();
		
		override public function addEventListener(type:String, listener:Function):void
		{
			// TODO Auto Generated method stub
			super.addEventListener(type, listener);
		}
		
		override public function removeEventListener(type:String, listener:Function):void
		{
			// TODO Auto Generated method stub
			super.removeEventListener(type, listener);
		}
		
		
	}
}