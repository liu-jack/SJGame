package fxengine.game.action
{
	import fxengine.game.node.FNode;
	
	import mx.collections.ArrayCollection;

	public class FSequence extends FActionInterval
	{
		public function FSequence()
		{
			super();
			_actions = new ArrayCollection;
		}
		
		protected var _actions:ArrayCollection;
		
		/**
		 * 时间分割线 
		 */
		protected var _split:Number;
		
		protected var _last:int;
		
		
		public static function actions(... actions):FSequence
		{
//			return new FSequence().actionWithArray(actions);	
			
			return actionWithArray(actions);
		}
		
		public static function actionWithArray(arrayofAction:Array):FSequence
		{
			var prev:FFiniteTimeAction = arrayofAction[0];
			for(var i:int = 1;i<arrayofAction.length;i++)
			{
				prev = actiontow(prev,arrayofAction[i]);
			}
			return prev as FSequence;	
		}
		
		public static function actiontow(one:FFiniteTimeAction,tow:FFiniteTimeAction):FSequence
		{
			return new FSequence().inittow(one,tow);	
		}
		
		public function inittow(one:FFiniteTimeAction,tow:FFiniteTimeAction):FSequence
		{
			
			var d:Number = one.duration + tow.duration;
			super.initWithDuring(d);
			
			_actions.addItem(one);
			_actions.addItem(tow);
			
			return this;
		}
		
		override public function reverse():FFiniteTimeAction
		{
			return actiontow((_actions[1] as FActionInterval).reverse(),(_actions[0] as FActionInterval).reverse());
		}
		
		override public function startWithTarget(target:FNode):void
		{
			
			super.startWithTarget(target);
			
			_split = (_actions[0] as FActionInterval).duration / _duration;
			_last = -1;
			
			
		}
		
		override public function stop():void
		{
		
			if(_last != -1)
			{
				(_actions[_last] as FActionInterval).stop();
			}
			super.stop();
		}
		
		override public function update(t:Number):void
		{

			var found:int = 0;
			var new_t:Number = 0.0;
			
			if(t < _split){
				
				found = 0;
				if(_split != 0)
				{
					new_t = t/_split;
				}
				else
				{
					new_t = 1;
				}
			}
			else
			{
				found = 1;
				if(_split == 1)
					new_t = 1;
				else
				{
					new_t = (t-_split)/(1-_split);
				}
			}
			
			if(found == 1)
			{
				if(_last == -1)
				{
					//skip 0
					var action_0:FActionInterval = _actions[0];
					action_0.startWithTarget(target);
					action_0.update(1);
					action_0.stop();
				}
				else if (_last == 0)
				{
					//switch to action1 stop action 0
					action_0 = _actions[0];
					action_0.update(1);
					action_0.stop();
					
				}
			}
			
			if(found != _last)
			{
				(_actions[found] as FActionInterval).startWithTarget(_target);
			}
			(_actions[found] as FActionInterval).update(new_t);
			_last = found;
			
		}
		
	}
}