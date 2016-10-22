package SJ.Game.event
{
	import starling.events.Event;
	import starling.events.EventDispatcher;

	/**
	 * 全局性 事件派发，监听
	 * @author yongjun
	 * 
	 */
	public class CJEventDispatcher extends EventDispatcher
	{
		private static var  _instance:CJEventDispatcher;
		public function CJEventDispatcher()
		{
		}
		public  static  function get o():CJEventDispatcher
		{
			if(_instance == null)
			{
				_instance = new CJEventDispatcher;
			}
			return _instance;
		}
		
		override public function addEventListener(type:String, listener:Function):void
		{
			super.addEventListener(type, listener);
		}
		
		
		public function addListener(type:String,func:Function):void
		{
			if(this.hasEventListener(type))return;
			this.addEventListener(type,func);
		}
		public function removeListener(type:String,func:Function):void
		{
			this.removeEventListener(type,func);
		}
		
		override public function dispatchEvent(event:Event):void
		{
			super.dispatchEvent(event);
		}
	}
}