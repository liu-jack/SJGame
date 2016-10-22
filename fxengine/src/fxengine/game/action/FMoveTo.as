package fxengine.game.action
{
	import flash.geom.Point;
	
	import fxengine.game.node.FNode;

	public class FMoveTo extends FActionInterval
	{
		
		public function FMoveTo()
		{
		}
		
		
		protected var _endPostion:Point = new Point();
		
		protected var _startPostion:Point = new Point();
		
		protected var _delta:Point = new Point();
		
		public static function actionWithDuration(duration:Number,position:Point):FMoveTo
		{
			return new FMoveTo().initWithDuration(duration,position);
		}
		
		public function initWithDuration(duration:Number,position:Point):FMoveTo
		{
			super.initWithDuring(duration);
			_endPostion = position;
			
			return this;
		}
		
		override public function startWithTarget(target:FNode):void
		{
			super.startWithTarget(target);
			_startPostion = new Point(target.x,target.y);
			
			_delta = _endPostion.subtract(_startPostion);
			
		}
		
		override public function update(t:Number):void
		{
			
			
			_target.x = _startPostion.x + _delta.x * t;
			_target.y = _startPostion.y + _delta.y * t;
			
//			trace("_target.x"+_target.x+"_startPostion.x"+_startPostion.x +"_delta.x" +_delta.x + "t:" + t); 
		}
		
		
	}
}