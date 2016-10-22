package fxengine.game.action
{
	import fxengine.game.node.FNode;

	public class FRepeat extends FActionInterval
	{
		
		private var _times:uint;
		private var _total:uint;
		private var _nextDt:Number;
		private var _isActionInstant:Boolean;
		private var _innerAction:FFiniteTimeAction;
		
		public function FRepeat()
		{
			super();
		}
		
		
		
		
		
		
		public function get innerAction():FFiniteTimeAction
		{
			return _innerAction;
		}

		public function set innerAction(value:FFiniteTimeAction):void
		{
			_innerAction = value;
		}
		
		
		public static function actionWithAction(action:FFiniteTimeAction,times:uint):FRepeat
		{
			return new FRepeat().initWithAction(action,times);
		}
		
		override public function startWithTarget(target:FNode):void
		{
			_total = 0;
			_nextDt = _innerAction.duration / _duration;
			super.startWithTarget(target);
			_innerAction.startWithTarget(target);
		}
		
		override public function stop():void
		{
			_innerAction.stop();
			super.stop();
		}
		
		override public function update(t:Number):void
		{

			if(t >= _nextDt)
			{
				
				while(t >= _nextDt && _total < _times)
				{
					_innerAction.update(1.0);
					_total ++;
					
					_innerAction.stop();
					_innerAction.startWithTarget(_target);
					_nextDt += _innerAction.duration / duration;
				}
				
				if(t >= 1.0 && _total < _times)
				{
					_total ++;
				}
				
				if(!_isActionInstant)
				{
					if(_total == _times)
					{
						_innerAction.update(1.0);
						_innerAction.stop();
					}
					else
					{
						_innerAction.update(t - (_nextDt - _innerAction.duration / _duration));
					}
				}
			}
			else
			{
				_innerAction.update((t *_times) % 1.0);
				
//				trace("update:" + ((t *_times) % 1.0) + "(t *_times)" + (t *_times) +"t:" + t);
			}
		}
		
		public function initWithAction(action:FFiniteTimeAction,times:uint):FRepeat
		{
			var d:Number = action.duration * times;
			
			super.initWithDuring(d);
			_times = times;
			innerAction = action;
			
			_isActionInstant = action is FActionInstant?true:false;
			
			if(_isActionInstant)
				_times -= 1.0;
			
			_total = 0;
			
			return this;
		}
		
		override public function get isDone():Boolean
		{
			return _total == _times;
		}
		
		

	}
}