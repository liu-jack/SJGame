package fxengine.utils.event
{
	import flash.events.Event;
	
	public class FEvent extends Event
	{
		
		private var _object:Object;

		/**
		 * 附加包含对象 
		 */
		public function get object():Object
		{
			return _object;
		}

		/**
		 *  
		 * @param type 事件类型
		 * @param object 包含对象
		 * 
		 */
		public function FEvent(type:String,object:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_object = object;
		}
		
		
		
	}
}