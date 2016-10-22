package fxengine.game.animation
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import fxengine.FPoint;
	import fxengine.game.FRect;
	import fxengine.game.node.FSpriteFrame;
	import fxengine.game.texture.FTexture;
	import fxengine.resource.FResourceMemCache;
	
	import mx.collections.ArrayCollection;

	public class FAnimation
	{
		public function FAnimation()
		{
		}
		
		private var _frames:ArrayCollection = new ArrayCollection();
		private var _totalDelayUnits:Number = 0.1;
		private var _delayPerUnit:Number = 0.1;
		private var _restoreOriginalFrame:Boolean = true;
		private var _loops:uint = 0;
		
		/**
		 * 循环的次数 
		 */
		public function get loops():uint
		{
			return _loops;
		}

		/**
		 * @private
		 */
		public function set loops(value:uint):void
		{
			_loops = value;
		}

		/**
		 * 当动画播放完成，是否回复到第一帧 
		 */
		public function get restoreOriginalFrame():Boolean
		{
			return _restoreOriginalFrame;
		}

		/**
		 * @private
		 */
		public function set restoreOriginalFrame(value:Boolean):void
		{
			_restoreOriginalFrame = value;
		}

		public function get frames():ArrayCollection
		{
			return _frames;
		}

		public function set frames(value:ArrayCollection):void
		{
			_frames = value;
		}

		/**
		 * 没帧的间隔 毫秒
		 */
		public function get delayPerUnit():Number
		{
			return _delayPerUnit;
		}

		/**
		 * @private
		 */
		public function set delayPerUnit(value:Number):void
		{
			_delayPerUnit = value;
		}

		/**
		 * 总延时 
		 */
		public function get totalDelayUnits():Number
		{
			return _totalDelayUnits;
		}
		
		
		public static function animation():FAnimation
		{
			return new FAnimation();
		}
		
		public static function animationWithFSpriteFrames(arrayOfSpriteFrameNames:ArrayCollection,delay:Number):FAnimation
		{
			return new FAnimation().initWithSpriteFrames(arrayOfSpriteFrameNames,delay);
		}
		
		public static function animationWithAnimationFrames(arrayOfAnimationFrames:ArrayCollection,delayPerUnit:Number,loop:uint):FAnimation
		{
			return new FAnimation().initWithAnimationFrames(arrayOfAnimationFrames,delayPerUnit,loop);
		}
		
		public function initWithSpriteFrames(arrayOfSpriteFrameNames:ArrayCollection,delay:Number):FAnimation
		{
			_loops = 1;
			_delayPerUnit = delay;
			
			for each(var frame:FSpriteFrame in arrayOfSpriteFrameNames)
			{
				var animFrame:FAnimationFrame = new FAnimationFrame().initWithSpriteFrame(frame,1,null);
				_frames.addItem(animFrame);
				
				_totalDelayUnits ++;
			}
			
			return this;
		}
		
		public function initWithAnimationFrames(arrayOfAnimationFrames:ArrayCollection,delayPerUnit:Number,loop:uint):FAnimation
		{
			
			_delayPerUnit = delayPerUnit;
			_loops = loop;
			
			_frames = arrayOfAnimationFrames;
			
			for each(var animFrame:FAnimationFrame in _frames)
			{
				_totalDelayUnits += animFrame.delayUnits;
			}
			return this;
		}
		
		
		public function addSpriteFrame(frame:FSpriteFrame):void
		{
			var animFrame:FAnimationFrame = new FAnimationFrame().initWithSpriteFrame(frame,1,null);
			_frames.addItem(animFrame);
			_totalDelayUnits ++;
		}
		
		public function addSpriteFrameWithFilename(filename:String):void
		{
//			FResourceMemCache.o.getResource(filename,function o(key:String,texture:BitmapData):void
//			{
//				addSpriteFrameWithTexture(texture);
//			});
		}
		
		public function addSpriteFrameWithTexture(texture:FTexture,rect:FRect = null):void
		{
			if(rect == null)
				rect = texture.rect;
			var frame:FSpriteFrame = FSpriteFrame.frameWithTexture(texture,rect,false,new FPoint(),new FPoint());
			addSpriteFrame(frame);
		}
		
		public  function get duration():Number
		{
			return _totalDelayUnits * _delayPerUnit;
		}

	}
}