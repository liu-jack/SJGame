package fxengine.resource
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import fxengine.FPoint;
	import fxengine.game.FRect;
	import fxengine.game.node.FSpriteFrame;

	/**
	 * 场景Frame 
	 * @author caihua
	 * 
	 */
	public class FResourceSpriteFrameCache
	{
		private static var _o:FResourceSpriteFrameCache = null;
		
		public static function get o():FResourceSpriteFrameCache
		{
			if(_o == null)
			{
				_o = new FResourceSpriteFrameCache();
			}
			return _o;
		}
		
		
		public function FResourceSpriteFrameCache()
		{
		}
		
		private var spriteFrames_:Dictionary = new Dictionary;
		
		
		/**
		 * 通过PJson和File添加Frames 
		 * @param pjson
		 * @param textureFilename
		 * 
		 */
		public function addSpriteFramesWithFile(pjson:String,textureFilename:String = ""):void
		{
			FResourceMemCache.o.getResource(pjson,function loadComplete(key:String,resource:FResource):void
			{
				//下载完成pjson
				var pjsonRes:FResourcePJson = resource as FResourcePJson;
//				meta	Object (@3417ce9)	
//				app	"http://www.texturepacker.com"	
//				format	"RGBA8888"	
//				image	"resouce1.png"	
//				scale	"1"	
//				size	Object (@3417e81)	
//				smartupdate	"$TexturePacker:SmartUpdate:760c83927b32370a6505c8f551cb892a$"	
//				version	"1.0"	
				var meta:Object = resource.resource["meta"];
				var frames:Object = resource.resource["frames"];
				if(textureFilename == "")
				{
					textureFilename = meta["image"];
				}
				
				//添加涉及到的资源
				FResourceMemCache.o.getResource(textureFilename,function (key:String,resource:FResource):void
				{
					for each(var spriteObject:Object in frames)
					{
						var filename:String = spriteObject["filename"];
						var frame:FRect = new FRect(spriteObject.frame.x,spriteObject.frame.y,spriteObject.frame.w,spriteObject.frame.h);
						var rotated:Boolean = spriteObject.rotated;
						var trimmed:Boolean = spriteObject.trimmed;
						var offset:FPoint = new FPoint(spriteObject.spriteSourceSize.x,spriteObject.spriteSourceSize.y);
						var originalSize:FPoint = new FPoint(spriteObject.sourceSize.w,spriteObject.sourceSize.h);
						var spriteframe:FSpriteFrame = FSpriteFrame.frameWithTexture(resource.resource,frame,rotated,offset,originalSize);
				
						spriteFrames_[filename] = spriteframe;
					}
				});
				
			});
		}
		
		public function addSpriteFramesWithFileAndResource(pjson:String,texture:FResource):void
		{
			
		}
		
		public function addSpriteFrame(frame:FSpriteFrame,frameName:String):void
		{
			
		}
		
		public function removeSpriteFrames():void
		{
			
		}
		
		public function removeUnusedSpriteFrames():void
		{
			
		}
		
		public function removeSpriteFrameByName(name:String):void
		{
			
		}
		public function removeSpriteFrameFromFile(pjson:String):void
		{
			
		}
		public function spriteFrameByName(name:String):FSpriteFrame
		{
			return spriteFrames_[name];
//			return null;
		}
	}
}