package lib.engine.event
{
	import flash.events.Event;
	
	public class CEvent extends Event
	{
		private var _ext:Object;

		/**
		 * 事件附带数据 
		 */
		public function get ext():Object
		{
			return _ext;
		}

		/**
		 * @private
		 */
		public function set ext(value:Object):void
		{
			_ext = value;
		}

		public function CEvent(type:String,ext:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_ext = ext;
		}
		
		
		
		
	}
}