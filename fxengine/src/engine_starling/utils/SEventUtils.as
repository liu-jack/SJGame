package engine_starling.utils
{
	import starling.events.Event;
	import starling.events.EventDispatcher;

	final public class SEventUtils
	{
		public function SEventUtils()
		{
		}
		
		/**
		 * 添加一个只执行一次的事件 
		 * @param target        事件目标
		 * @param type  事件类型
		 * @param handler       事件函数
		 * @param useParam      是否传入参数
		 * @param param 参数列表
		 * 
		 */
		static public function addEventListenerOnce(target:EventDispatcher,type:String,listener:Function):void
		{
			var numArgs:int = listener.length;
			var agentListener:Function = function (e:Event):void
			{
				e.target.removeEventListener(type,agentListener);
				if (numArgs == 0) listener();
				else if (numArgs == 1) listener(e);
				else listener(e, e.data);
			};
			target.addEventListener(type,agentListener);
		}
	}
}