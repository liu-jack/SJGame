package fxengine.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class FTickUtils
	{

		/**
		 * 计时器列表 
		 */
		private var _timerlist:Vector.<Object> = new Vector.<Object>();
		
		public function FTickUtils()
		{
		}
		
		private static var _o:FTickUtils = null;
		
		public static function get o():FTickUtils
		{
			if(_o == null)
				_o = new FTickUtils();
			return _o;
		}
		
		/**
		 * 增加Tick 
		 * @param timeId TickID名称
		 * @param delaynum 执行间隔
		 * @param repeatcount 执行次数,不能等于0,也就是必须有执行次数,没有永久执行之说,如果
		 * 是永久执行的,应该选用Update
		 * @param callback function(e:TimerEvent,params:Object)执行回调函数
		 * @param params 回调函数参数
		 * @param complete 执行完毕后回调
		 * @return 
		 * 
		 */
		public function addTick(timeId:String,delaynum:int,repeatcount:int,callback:Function,params:Object = null,complete:Function = null):Boolean
		{
//			Assert(repeatcount > 0,"repeatcount 次数不对 应该大于0");
			if(repeatcount <= 0)
				return false;
			var _timer:Timer = new Timer(delaynum,repeatcount);
			
			_timer.addEventListener(TimerEvent.TIMER,_onTick);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTickEnd);
			_timer.start();
			
			_timerlist.push({'timeId':timeId,'timer':_timer,'callback':callback,'params':params,'complete':complete});
			return true;
		}
		
		/**
		 * 删除计时器 
		 * @param timeId
		 * 
		 */
		public function removeTick(timeId:String):void
		{
			for each(var obj:Object in _timerlist)
			{
				if(obj.timeId == timeId)
				{
					_removeTick(obj.timer);
					return;
				}
			}
		}
		
		/**
		 * 删除Tick 
		 * @param t
		 * 
		 */
		private function _removeTick(t:Timer):void
		{
			t.stop();
			t.reset();
			t.removeEventListener(TimerEvent.TIMER,_onTick);
			t.removeEventListener(TimerEvent.TIMER_COMPLETE,onTickEnd);
			
			for(var i:String in _timerlist)
			{
				if(_timerlist[i].timer == t)
				{
					_timerlist.splice(int(i),1);
					break;
				}
			}
			
		}
		
		/**
		 * 获取Tick 
		 * @param t
		 * @return 
		 * 
		 */
		private function _getTick(t:Timer):Object
		{
			for each(var obj:Object in _timerlist)
			{
				if(obj.timer == t)
				{
					return obj
				}
			}
			return null;
			
		}
		
		/**
		 * Tick执行 
		 * @param e
		 * 
		 */
		private function _onTick(e:TimerEvent):void
		{
			var obj:Object = _getTick(e.target as Timer);
			
			if(obj.callback != null)
			{
				obj.callback(e,obj.params);
			}
		}
		
		private function onTickEnd(e:TimerEvent):void
		{
			var obj:Object = _getTick(e.target as Timer);
			if(obj.complete != null)
			{
				obj.complete();
			}
			_removeTick(e.target as Timer);
		}
	}
}