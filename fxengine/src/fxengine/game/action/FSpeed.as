package fxengine.game.action
{
	import fxengine.game.node.FNode;

	public class FSpeed extends FAction
	{
		public function FSpeed()
		{
			super();
		}
		
		protected var _innerAction:FActionInterval;

//		public function get innerAction():FActionInterval
//		{
//			return _innerAction;
//		}
//
//		public function set innerAction(value:FActionInterval):void
//		{
//			_innerAction = value;
//		}

		
		protected var _speed:Number;

//		public function get speed():Number
//		{
//			return _speed;
//		}
//
//		public function set speed(value:Number):void
//		{
//			_speed = value;
//		}
		
		public static function actionWithAction(action:FActionInterval,speed:Number):FSpeed
		{
			return new FSpeed().initWithAction(action,speed);
		}
		
		public function initWithAction(action:FActionInterval,speed:Number):FSpeed
		{
			_innerAction = action;
			_speed = speed;
			return this;
		}
		
		override public function get isDone():Boolean
		{
			return _innerAction.isDone;
		}
		
		override public function startWithTarget(target:FNode):void
		{
			
			super.startWithTarget(target);
			_innerAction.startWithTarget(target);
		}
		
		override public function step(dt:Number):void
		{
			_innerAction.step(dt * _speed);
		}
		
		override public function stop():void
		{
			_innerAction.stop();
			super.stop();
		}
		
		public function reverse():FSpeed
		{
			return FSpeed.actionWithAction(_innerAction.reverse() as FActionInterval,_speed);
		}
		
		
	}
}