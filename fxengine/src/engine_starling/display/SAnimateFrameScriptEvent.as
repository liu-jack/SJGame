package engine_starling.display
{
	import engine_starling.Events.AnimateEvent;

	public class SAnimateFrameScriptEvent implements ISAnimateFrameScript
	{
		public function SAnimateFrameScriptEvent()
		{
		}
		
		private var _event_value:String;

		public function get event_value():String
		{
			return _event_value;
		}

		public function set event_value(value:String):void
		{
			_event_value = value;
		}
		
		
		public static function genWithPropertyObject(property:Object,template:SAnimate):SAnimateFrameScriptEvent
		{
			var ins:SAnimateFrameScriptEvent = new SAnimateFrameScriptEvent();
			ins.event_value = property["value"];
			return ins;
		}
		
		public function execute(owner:SAnimate):void
		{
			// TODO Auto Generated method stub
			owner.dispatchEventWith(AnimateEvent.Event_Custom,false,{"value":event_value});
			
		}
		
		

	}
}