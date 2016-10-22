package fxengine.game.manager
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import fxengine.game.iface.FUpdateInterface;
	
	import lib.engine.utils.CTimerUtils;

	/**
	 * Scheduler实例 
	 * @author caihua
	 * 
	 */
	public class FScheduler implements FUpdateInterface
	{
		private static var _o:FScheduler = null;
		//tickSprite
		private var _tickSprite:Sprite = null;
		private var _updateList:Vector.<FUpdateInterface> = null;
		
		//定时器列表
		private var _scheduleList:Vector.<Object> = null;
		//上次执行时间
		private var _lasttimetick:Number = 0;
		
		
		/**
		 * 永远执行 
		 */
		public static const FRepeatForever:int =  -1;

		public function get tickSprite():Sprite
		{
			if(_tickSprite == null)
			{
				_tickSprite = new Sprite();
				_tickSprite.addEventListener(Event.ENTER_FRAME,_tickEnterframe);
			}
			return _tickSprite;
		}

		public function FScheduler()
		{
			_initialze();
		}
		/**
		 * 初始化 
		 * 
		 */
		private function _initialze():void
		{
			_updateList = new Vector.<FUpdateInterface>();
			_scheduleList = new Vector.<Object>();
		}
		
		public static function get o():FScheduler
		{
			if(_o == null)
			{
				_o = new FScheduler();
			}
			return _o;
		}
		
		
		public function update(currenttime:Number, escapetime:Number):void
		{
			
			//更新schedule
			
			for each (var schedule:Object in _scheduleList)
			{
				//没有执行完
				if(schedule["currentRepeatCount"] < schedule["repeatcount"] 
					|| schedule["repeatcount"] == FRepeatForever)
				{
					//可以执行了
					if(currenttime >= schedule["lastTick"] + schedule["delaynum"])
					{
						schedule["callback"](schedule["params"]);
						//更新时间
						schedule["lastTick"] = schedule["lastTick"] + schedule["delaynum"];
						//更新次数
						schedule["currentRepeatCount"] += 1;
					}
				}
			}
			
			
			for each (var iupdate:FUpdateInterface in _updateList)
			{
				iupdate.update(currenttime,escapetime);
			}
			
		}
		
		private function _tickEnterframe(e:Event):void
		{
			var currentTime:Number = CTimerUtils.getCurrentTime();
			var escapetime:Number = currentTime - _lasttimetick;
			_lasttimetick = currentTime;
			
			update(currentTime,escapetime);
		}
		public function scheduleForUpdate(target:FUpdateInterface):void
		{
			_updateList.push(target);
		}
		public function schedule(callback:Function,target:Object,delaynum:int,repeatcount:int,params:Object = null):void
		{
			unschedule(callback,target);
			var schedule:Object = new Object;
			schedule["target"] =target;
			schedule["callback"] =callback;
			schedule["delaynum"] =delaynum;
			schedule["repeatcount"] =repeatcount;
			schedule["params"] =params;
			schedule["lastTick"] = CTimerUtils.getCurrentTime();
			schedule["currentRepeatCount"] = 0;	//当前执行次数
			_scheduleList.push(schedule);
		}
		public function unschedule(callback:Function,target:Object):void
		{
			var newscheduleList:Vector.<Object> = _scheduleList.filter(
				function callbackfunc(item:Object, index:int, array:Vector.<Object>):Boolean{
				if(item["callback"] == callback)
				{
					return false;
				}
				return true;
			});
			_scheduleList = newscheduleList;
		}
		public function unscheduleForTarget(target:Object):void
		{
			var newscheduleList:Vector.<Object> = _scheduleList.filter(function callbackfunc(item:Object, index:int, array:Vector.<Object>):Boolean{
				if(item["target"] == target)
				{
					return false;
				}
				return true;
			});
			_scheduleList = newscheduleList;
		}
		public function unscheduleUpdateForTarget(target:FUpdateInterface):void
		{
			var index:int = _updateList.indexOf(target);
			if(index != -1)
			{
				_updateList.splice(index,1);
			}
		}
	}
}