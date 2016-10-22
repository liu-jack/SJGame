package engine_starling.utils
{
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.events.Event;
	
	/**
	 * ...
	 * var tween:XTween = new XTween...
...
tween.loop = XTween.XSTLoopTypeReverse;
tween.delay = 1;
 
tween.onLoop = function():void
{
	if (tween.loopCounter & 1) // On every other loop, reinstate delay but don't reset loop counter
		tween.softReset(false);
	if (tween.loopCounter == 3)
		tween.loop = XTween.XSTLoopTypeRepeat; // Change to repeat loop
	else if (tween.loopCounter == 6)
		tween.loop = XTween.XSTLoopTypeNone; // Stop looping
};
 
juggler.add(tween);
	 * @author Cheeky Mammoth
	 */
	public class STween extends Tween
	{
		/**
		 * 停止循环 
		 */
		public static const XSTLoopTypeNone:int = 0;
		/**
		 * 自身循环 不包括 nexttween 
		 */
		public static const XSTLoopTypeRepeat:int = 1;
		/**
		 * 完全循环,包括nexttween 
		 */
		public static const XSTLoopTypeReverse:int = 2;
		
		private var mLoop:int;
		private var mLoopCounter:int;
		
		private var mOnLoop:Function;
		private var mOnLoopArgs:Array;
		
		public function STween(target:Object, time:Number, transition:String="linear")
		{
			super(target, time, transition);
		}
		
		/** For reusing the tween. */
		public function softReset(resetLoopCounter:Boolean = true):void
		{
			mCurrentTime = -mDelay;
			
			if (resetLoopCounter)
				mLoopCounter = 0;
		}
		
		override public function reset(target:Object, time:Number, transition:Object="linear"):Tween
		{
			mOnLoop = null;
			mOnLoopArgs = null;
			mLoop = XSTLoopTypeNone;
			mLoopCounter = 0;
			return super.reset(target, time, transition);
		}
		
		
//		public override function reset(target:Object, time:Number, transition:String="linear"):Tween
//		{
//			mOnLoop = null;
//			mOnLoopArgs = null;
//			mLoop = XSTLoopTypeNone;
//			mLoopCounter = 0;
//			return super.reset(target, time, transition);
//		}
		
		public override function advanceTime(time:Number):void
		{
			if (time == 0 || isComplete) return;
			
			if (mCurrentTime >= mTotalTime) mCurrentTime = 0; // We've looped
			
			var previousTime:Number = mCurrentTime;
			var restTime:Number = mTotalTime - mCurrentTime;
			var carryOverTime:Number = time > restTime ? time - restTime : 0;
			mCurrentTime = Math.min(mTotalTime, mCurrentTime + time);
			
			if (mCurrentTime <= 0) return;  // The delay is not over yet
			
			if (onStart != null && previousTime <= 0 && mCurrentTime >= 0)
				onStart.apply(null, onStartArgs);
			
			var ratio:Number = mCurrentTime / mTotalTime;
			var invertTransition:Boolean = (mLoop == XSTLoopTypeReverse && ((mLoopCounter & 1) != 0));
			var numAnimatedProperties:int = mStartValues.length;
			
			for (var i:int=0; i<numAnimatedProperties; ++i)
			{
				if (isNaN(mStartValues[i]))
					mStartValues[i] = mTarget[mProperties[i]] as Number;
				
				var startValue:Number = mStartValues[i];
				var endValue:Number = mEndValues[i];
				var delta:Number = endValue - startValue;
				
				var transitionFunc:Function = Transitions.getTransition(mTransitionName);
				var tansitionValue:Number = invertTransition ? 1.0 - transitionFunc(1.0 - ratio) : transitionFunc(ratio);
				var currentValue:Number = startValue + tansitionValue * delta;
				if (mRoundToInt) currentValue = Math.round(currentValue);
				mTarget[mProperties[i]] = currentValue;
			}
			
			if (onUpdate != null)
				onUpdate.apply(null, onUpdateArgs);
			
			if (previousTime < mTotalTime && mCurrentTime == mTotalTime)
			{
				if (mLoop != XSTLoopTypeNone)
				{
					++mLoopCounter;
					if (mOnLoop != null) mOnLoop.apply(null, mOnLoopArgs);
				}
				
				if (mLoop == XSTLoopTypeRepeat)
				{
					for (i=0; i<numAnimatedProperties; ++i)
						mTarget[mProperties[i]] = mStartValues[i];
				}
				else if (mLoop == XSTLoopTypeReverse)
				{
					var swap:Number;
					
					for (i=0; i<numAnimatedProperties; ++i)
					{
						swap = mEndValues[i];
						mEndValues[i] = mStartValues[i];
						mStartValues[i] = swap;
					}
				}
				else
				{
					dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
					if (onComplete != null) onComplete.apply(null, onCompleteArgs);
				}
			}
			
			advanceTime(carryOverTime);
		}
		
		/** Indicates if the tween is finished. */
		public override function get isComplete():Boolean { return mLoop == XSTLoopTypeNone && mCurrentTime >= mTotalTime; }
		
		/** Indicates whether or not the tween will loop rather than complete. */
		/** This could probably benefit from a TweenLoop verification class in starling.utils. */
		public function get loop():int { return mLoop; }
		public function set loop(value:int):void { mLoop = value; }
		
		/** The number of times we have looped. */
		public function get loopCounter():int { return mLoopCounter; }
		
		/** A function that will be called when the tween loops. */
		public function get onLoop():Function { return mOnLoop; }
		public function set onLoop(value:Function):void { mOnLoop = value; }
		
		/** The arguments that will be passed to the 'onLoop' function. */
		public function get onLoopArgs():Array { return onLoopArgs; }
		public function set onLoopArgs(value:Array):void { onLoopArgs = value; }
	}
}