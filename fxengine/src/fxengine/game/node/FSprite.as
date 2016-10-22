package fxengine.game.node
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import fxengine.FPoint;
	import fxengine.game.FRect;
	import fxengine.game.texture.FTexture;
	import fxengine.resource.FResource;
	import fxengine.resource.FResourceMemCache;

	public class FSprite extends FNode
	{

		private var _texture:FTexture = null;
		private var _rectRotated:Boolean = false;
		private var _rect:FRect;
		
		private var _unfilppedOffsetPositionFormTopLeft:FPoint = new FPoint();
		public function FSprite()
		{
			super();
			
			
		}
		
		/**
		 * 设置显示的 Frame 
		 * @param newFrame
		 * 
		 */
		public function setDisplayFrame(newFrame:FSpriteFrame):void
		{
			_unfilppedOffsetPositionFormTopLeft = newFrame.offset;
			var newtexture:FTexture = newFrame.texture;
			if(newtexture != _texture)
			{
				this.setTexture(newtexture);
			}
			_rectRotated = newFrame.rotated;
			
			this.setTextureRect(newFrame.rect,_rectRotated,newFrame.originalSize);
		}
		
		/**
		 * 是否是当前帧 
		 * @param frame
		 * @return 
		 * 
		 */
		public function isFrameDisplayed(frame:FSpriteFrame):Boolean
		{
			if(frame.texture == _texture && frame.rect.equals(_rect))
			{
				return true
			}
			return false;
		}
		
		public function displayFrame():FSpriteFrame
		{
		
			return new FSpriteFrame().initWithTexture(_texture,_rect,_rectRotated,new FPoint(),_texture.rect.originSize);
		}
		
		
//		public function flushFrame():void
//		{
//			var m:Matrix = new Matrix();
//			m.translate(-_rect.x,-_rect.y);
//			this.graphics.clear();
//			this.graphics.beginBitmapFill(_texture.image,m);
//			this.graphics.drawRect(0,0,_rect.width,_rect.height);
//			this.graphics.endFill();
//		}
		
		public function setTextureRect(rect:FRect,rotated:Boolean,untrimmedSize:FPoint):void
		{
			//设置原件大小
			this.contentSize = untrimmedSize;
			_rect = rect;


//			var newTexture:BitmapData = new BitmapData(rect.width,rect.height);
//			newTexture.copyPixels(_texture,rect,new Point());

//			this.flushFrame();
			
			var m:Matrix = new Matrix();
			if(rotated)
			{
				//旋转
				m.rotate(-Math.PI/2);
				//偏移
				var trapos:Point = m.transformPoint(new Point(rect.x,rect.y))
				m.translate(-trapos.x,-trapos.y + rect.height);
			}
			else
			{
				m.translate(-rect.x,-rect.y);
			}
			m.translate(_unfilppedOffsetPositionFormTopLeft.x,_unfilppedOffsetPositionFormTopLeft.y);
			
			this.graphics.clear();
			this.graphics.beginBitmapFill(_texture.image,m);
			this.graphics.drawRect(_unfilppedOffsetPositionFormTopLeft.x,_unfilppedOffsetPositionFormTopLeft.y,_rect.width,rect.height);
			this.graphics.endFill();
//			
			
//			trace("width:" +this.width);
			
		}
		
		/**
		 * 设置贴图 
		 * @param texture
		 * 
		 */
		public function setTexture(texture:FTexture):void
		{
			_texture = texture;
		}
		
		/**
		 * 通过文件名初始化 
		 * @param filename 文件名
		 * @param initFinish 初始化完成回调 (s:FSprite)
		 * @return 
		 * 
		 */
		public function initWithFileName(filename:String,initFinish:Function = null):FSprite
		{
			
			var _this:FSprite = this;
			FResourceMemCache.o.getResource(filename,function o(key:String,texture:FResource):void
			{
				initWithTexture(texture.resource);
				if(initFinish != null)
					initFinish(_this);
			});
			
			return this;
		}
		
		public function initWithTexture(texture:FTexture,rect:FRect = null,rotated:Boolean = false):FSprite
		{
			if(rect == null)
				rect = texture.rect
//				rect = new Rectangle(texture.width / 2,0,texture.width / 2,texture.height);
			_rectRotated = rotated;
			
			setTexture(texture);
			setTextureRect(rect,_rectRotated,rect.originSize);
			return this;
		}
	}
}