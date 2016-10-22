package lib.engine.event
{
	import flash.events.EventDispatcher;
	
	import lib.engine.iface.IEventSubject;

	/**
	 * 事件目标是 Flash ® Player 和 Adobe ® AIR® 事件模型的重要组成部分。事件目标是事件如何通过显示列表层次结构这一问题的焦点。当发生鼠标单击或按键等事件时，Flash Player 或 AIR 应用程序会将事件对象调度到从显示列表根开始的事件流中。然后该事件对象在显示列表中前进，直到到达事件目标，然后从这一点开始其在显示列表中的回程。在概念上，到事件目标的此往返行程被划分为三个阶段：捕获阶段包括从根到事件目标节点之前的最后一个节点的行程，目标阶段仅包括事件目标节点，冒泡阶段包括回程上遇到的任何后续节点到显示列表的根。
	 * @author caihua
	 * 
	 */
	public class CEventSubject implements IEventSubject
	{
		private var _eventbus:EventDispatcher;
		public function CEventSubject()
		{
			_eventbus = new EventDispatcher();
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_eventbus.addEventListener(type,listener,useCapture,priority,useWeakReference);			
		}
		
		public function dispatchEvent(event:CEvent):Boolean
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