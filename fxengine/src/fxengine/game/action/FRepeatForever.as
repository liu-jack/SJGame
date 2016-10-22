package fxengine.game.action
{
	import fxengine.game.node.FNode;

	public class FRepeatForever extends FAction
	{
		
		protected var _innerAction:FActionInterval = null;
		
		public function FRepeatForever()
		{
			super();
		}
		
		
		public static function actionWithAction(action:FActionInterval):FRepeatForever
		{
			return new FRepeatForever().initWithAction(action);	
		}
		
		public function initWithAction(action:FActionInterval):FRepeatForever
		{
			_innerAction = action;
			return this;
		}
		
		override public function get isDone():Boolean
		{
			return false;
		}
		
		override public function startWithTarget(atarget:FNode):void
		{
			super.startWithTarget(atarget);
			_innerAction.startWithTarget(atarget);
		}
		
		override public function step(dt:Number):void
		{
			_innerAction.step(dt);
			if(_innerAction.isDone)
			{
				var diff:Number = _innerAction.elapsed - _innerAction.duration;
				_innerAction.startWithTarget(_target);
				
				_innerAction.step(0);
				_innerAction.step(diff);
			}
		}
		
		public function reverse():*
		{
			return FRepeatForever.actionWithAction(_innerAction.reverse() as FActionInterval);
		}
		
	}
}