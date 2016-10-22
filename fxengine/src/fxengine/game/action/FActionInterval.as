package fxengine.game.action
{
	import fxengine.game.node.FNode;

	public class FActionInterval extends FFiniteTimeAction
	{
		public function FActionInterval()
		{
			super();
		}
		
		
		protected var _elapsed:Number;

		public function get elapsed():Number
		{
			return _elapsed;
		}

		protected var _fristTick:Boolean;
		
		
		
		public static function actionWithDuration(d:Number):FActionInterval
		{
			return new FActionInterval().initWithDuring(d);
		}
		
		public function initWithDuring(d:Number):FActionInterval
		{
			_duration = d;
			
			_elapsed = 0;
			_fristTick = true;
			
			
			return this;	
		}
		
		
		
		override public function get isDone():Boolean
		{
			
			return (_elapsed >= _duration);
		}
		
		override public function reverse():FFiniteTimeAction
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		override public function step(dt:Number):void
		{
			if(_fristTick)
			{
				_fristTick = false;
				_elapsed = 0.0;
			}
			else
			{
				_elapsed += dt;
			}
			var mupdate:Number = _elapsed / _duration;
			mupdate = mupdate > 0?(mupdate > 1?1:mupdate):0;
			update(mupdate);
			
		}
		
		override public function startWithTarget(target:FNode):void
		{
			super.startWithTarget(target);
			
			_elapsed = 0.0;
			_fristTick = true;
			
		}
		
		
	}
}