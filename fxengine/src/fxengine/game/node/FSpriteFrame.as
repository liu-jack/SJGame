package fxengine.game.node
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import fxengine.FPoint;
	import fxengine.game.FRect;
	import fxengine.game.texture.FTexture;
	import fxengine.resource.FResource;
	import fxengine.resource.FResourceMemCache;

	public class FSpriteFrame
	{
		public function FSpriteFrame()
		{
		}
		
		private var _rect:FRect = new FRect();
		private var _rectinPixels:FRect = new FRect();
		private var _rotated:Boolean;
		private var _offset:FPoint = new FPoint();
		private var _offsetInPixels:FPoint = new FPoint();
		private var _originalSize:FPoint = new FPoint();
		private var _originalSizeInPixels:FPoint = new FPoint();
		
		private var _texture:FTexture;
		private var _textureName:String;

		public function get texture():FTexture
		{
			return _texture;
		}

		public function set texture(value:FTexture):void
		{
			_texture = value;
		}

		public function get textureName():String
		{
			return _textureName;
		}

		public function set textureName(value:String):void
		{
			_textureName = value;
		}

		public function get originalSizeInPixels():FPoint
		{
			return _originalSizeInPixels;
		}

		public function set originalSizeInPixels(value:FPoint):void
		{
			_originalSizeInPixels = value;
		}

		public function get originalSize():FPoint
		{
			return _originalSize;
		}

		public function set originalSize(value:FPoint):void
		{
			_originalSize = value;
		}

		public function get offsetInPixels():FPoint
		{
			return _offsetInPixels;
		}

		public function set offsetInPixels(value:FPoint):void
		{
			_offsetInPixels = value;
		}

		public function get offset():FPoint
		{
			return _offset;
		}

		public function set offset(value:FPoint):void
		{
			_offset = value;
		}

		public function get rotated():Boolean
		{
			return _rotated;
		}

		public function set rotated(value:Boolean):void
		{
			_rotated = value;
		}

		public function get rectinPixels():FRect
		{
			return _rectinPixels;
		}

		public function set rectinPixels(value:FRect):void
		{
			_rectinPixels = value;
		}

		public function get rect():FRect
		{
			return _rect;
		}

		public function set rect(value:FRect):void
		{
			_rect = value;
		}
			
		public static function frameWithTexture(texture:FTexture,rect:FRect,rotated:Boolean,offset:FPoint,originalSize:FPoint):FSpriteFrame
		{
			return new FSpriteFrame().initWithTexture(texture,rect,rotated,offset,originalSize);
		}
		
		public static function frameWithTextureFilename(filename:String,rect:FRect,rotated:Boolean,offset:FPoint,originalSize:FPoint):FSpriteFrame
		{
			
			return new FSpriteFrame().initWithTextureFilename(filename,rect,rotated,offset,originalSize);
		}
		
		
		public function initWithTexture(texture:FTexture,rect:FRect,rotated:Boolean,offset:FPoint,originalSize:FPoint):FSpriteFrame
		{
			_texture = texture;
			_rect = rect;
			_rotated = rotated;
			_offset = offset;
			_originalSize = originalSize;
			return this;
		}
		
		public function initWithTextureFilename(filename:String,rect:FRect,rotated:Boolean,offset:FPoint ,originalSize:FPoint):FSpriteFrame
		{
			_rect = rect;
			_rotated = rotated;
			_offset = offset;
			_originalSize = originalSize;
			FResourceMemCache.o.getResource(filename,function (key:String,resource:FResource):void{
				_texture = resource.resource;
			});
			return this;
		}

	}
}