package fxengine.game.action
{
	import flash.utils.Dictionary;
	
	import fxengine.game.animation.FAnimation;
	import fxengine.game.animation.FAnimationFrame;
	import fxengine.game.node.FNode;
	import fxengine.game.node.FSprite;
	import fxengine.game.node.FSpriteFrame;
	
	import mx.collections.ArrayCollection;

	/**
	 * 动画类 
	 * @author caihua
	 * 
	 */
	public class FAnimate extends FActionInterval
	{
		public function FAnimate()
		{
			super();
		}
		
		private var _splitTimes:ArrayCollection;
		
		private var _nextFrame:int;
		
		private var _animation:FAnimation;
		
		private var _origFrame:FSpriteFrame;

		public function get animation():FAnimation
		{
			return _animation;
		}

		public function set animation(value:FAnimation):void
		{
			_animation = value;
		}

	

		
		private var _exectedLoops:uint;
		
		
		public static function actionWithAnimation(animation:FAnimation):FAnimate
		{
			return new FAnimate().initWithAnimation(animation);
		}
		
		public function initWithAnimation(anim:FAnimation):FAnimate
		{
			var singleDuration:Number = anim.duration;
			
			
			super.initWithDuring(singleDuration * anim.loops);
			_nextFrame = 0;
			animation = anim;
			_origFrame = null;
			_exectedLoops = 0;
			
			
			_splitTimes = new ArrayCollection();
			
			var accumUnitsOfTime:Number = 0;
			var newUnitOfTimeValue:Number = singleDuration / anim.totalDelayUnits;
			
			for each(var frame:FAnimationFrame in anim.frames)
			{
				var value:Number = accumUnitsOfTime * newUnitOfTimeValue / singleDuration;
				accumUnitsOfTime += frame.delayUnits;
				
				_splitTimes.addItem(value);
			}
			
			return this;
		}
		
		override public function reverse():FFiniteTimeAction
		{
			var oldArray:ArrayCollection  =_animation.frames;
			var newArray:ArrayCollection = new ArrayCollection();
			
			for(var i:int=oldArray.length - 1;i--;i>=0)
			{
				newArray.addItem(oldArray[i]);
			}
			
			 var newAnim:FAnimation = FAnimation.animationWithAnimationFrames(newArray,_animation.delayPerUnit,_animation.loops);
			newAnim.restoreOriginalFrame = _animation.restoreOriginalFrame;
			
			return actionWithAnimation(newAnim);
			
		}
		
		override public function startWithTarget(target:FNode):void
		{
			super.startWithTarget(target);
			
			var sprite:FSprite = target as FSprite;
			
			if(animation.restoreOriginalFrame)
				_origFrame = sprite.displayFrame();
			
			_nextFrame = 0;
			_exectedLoops = 0;
			
		}
		
		override public function stop():void
		{
			if(_animation.restoreOriginalFrame)
			{
				var sprite:FSprite = _target as FSprite;
				sprite.setDisplayFrame(_origFrame);
				
			}
			super.stop();
		}
		
		override public function update(t:Number):void
		{
			
			if(t < 1.0)
			{
				t *= animation.loops;
				
				
				var loopNumber:uint = t;
				if(loopNumber > _exectedLoops)
				{
					_nextFrame = 0;
					_exectedLoops ++;
				}
				
				t = t %1.0;
			}
			
			var frames:ArrayCollection = _animation.frames;
			var numberOfFrames:int = frames.length;
			var frameToDisPlay:FSpriteFrame = null;
			
			
			for(var i:int = _nextFrame;i<numberOfFrames;i++)
			{
				var splittime:Number = _splitTimes[i];
				
				if(splittime <= t)
				{
					var frame:FAnimationFrame = frames[i];
					frameToDisPlay = frame.spriteFrame;
					
					var sprite:FSprite = _target as FSprite;
					sprite.setDisplayFrame(frameToDisPlay);
					
					var dict:Dictionary = frame.userinfo;
					if(dict)
					{
						//NOTIFACTION
					}
					
					_nextFrame = i+1;
					break;
					
				}
			}
			
		}
		
		
		
		
		
	}
}