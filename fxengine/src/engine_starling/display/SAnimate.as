package engine_starling.display
{
	import flash.errors.IllegalOperationError;
	
	import engine_starling.SApplication;
	import engine_starling.utils.SLRUCache;
	
	import starling.animation.IAnimatable;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.formatString;
	
	/** Dispatched whenever the movie has displayed its last frame. */
	[Event(name="complete", type="starling.events.Event")]
	
	/** A MovieClip is a simple way to display an animation depicted by a list of textures.
	 *  
	 *  <p>Pass the frames of the movie in a vector of textures to the constructor. The movie clip 
	 *  will have the width and height of the first frame. If you group your frames with the help 
	 *  of a texture atlas (which is recommended), use the <code>getTextures</code>-method of the 
	 *  atlas to receive the textures in the correct (alphabetic) order.</p> 
	 *  
	 *  <p>You can specify the desired framerate via the constructor. You can, however, manually 
	 *  give each frame a custom duration. You can also play a sound whenever a certain frame 
	 *  appears.</p>
	 *  
	 *  <p>The methods <code>play</code> and <code>pause</code> control playback of the movie. You
	 *  will receive an event of type <code>Event.MovieCompleted</code> when the movie finished
	 *  playback. If the movie is looping, the event is dispatched once per loop.</p>
	 *  
	 *  <p>As any animated object, a movie clip has to be added to a juggler (or have its 
	 *  <code>advanceTime</code> method called regularly) to run. The movie will dispatch 
	 *  an event of type "Event.COMPLETE" whenever it has displayed its last frame.</p>
	 *  
	 *  @see starling.textures.TextureAtlas
	 */    
	public class SAnimate extends Image implements IAnimatable
	{
		private var mTextures:Vector.<Texture>;
		private var mFrameScripts:Vector.<SAnimateFrameScriptContains>;
		private var mDurations:Vector.<Number>;
		private var mStartTimes:Vector.<Number>;
		
		private var mDefaultFrameDuration:Number;
		private var mTotalTime:Number;
		private var mCurrentTime:Number;
		private var mCurrentFrame:int;
		private var mLoop:Boolean;
		private var mPlaying:Boolean;
		
		private var _data:Object;

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

		
		/** Creates a movie clip from the provided textures and with the specified default framerate.
		 *  The movie will have the size of the first frame. */  
		public function SAnimate(textures:Vector.<Texture>, fps:Number=12)
		{
			if (textures.length > 0)
			{
				super(textures[0]);
				init(textures, fps);
			}
			else
			{
				throw new ArgumentError("Empty texture array");
			}
		}
		
		private function init(textures:Vector.<Texture>, fps:Number):void
		{
			if (fps <= 0) throw new ArgumentError("Invalid fps: " + fps);
			var numFrames:int = textures.length;
			
			mDefaultFrameDuration = 1.0 / fps;
			mLoop = true;
			mPlaying = true;
			mCurrentTime = 0.0;
			mCurrentFrame = 0;
			mTotalTime = mDefaultFrameDuration * numFrames;
			mTextures = textures.concat();
			mFrameScripts = new Vector.<SAnimateFrameScriptContains>(numFrames);
			mDurations = new Vector.<Number>(numFrames);
			mStartTimes = new Vector.<Number>(numFrames);
			
			for (var i:int=0; i<numFrames; ++i)
			{
				mDurations[i] = mDefaultFrameDuration;
				mStartTimes[i] = i * mDefaultFrameDuration;
			}
		}
		
		// frame manipulation
		
		/** Adds an additional frame, optionally with a sound and a custom duration. If the 
		 *  duration is omitted, the default framerate is used (as specified in the constructor). */   
		public function addFrame(texture:Texture, scriptContains:SAnimateFrameScriptContains=null, duration:Number=-1):void
		{
			addFrameAt(numFrames, texture, scriptContains, duration);
		}
		
		/** Adds a frame at a certain index, optionally with a sound and a custom duration. */
		public function addFrameAt(frameID:int, texture:Texture, scriptContains:SAnimateFrameScriptContains=null, 
								   duration:Number=-1):void
		{
			if (frameID < 0 || frameID > numFrames) throw new ArgumentError("Invalid frame id");
			if (duration < 0) duration = mDefaultFrameDuration;
			
			mTextures.splice(frameID, 0, texture);
			mFrameScripts.splice(frameID, 0, scriptContains);
			mDurations.splice(frameID, 0, duration);
			mTotalTime += duration;
			
			if (frameID > 0 && frameID == numFrames) 
				mStartTimes[frameID] = mStartTimes[frameID-1] + mDurations[frameID-1];
			else
				updateStartTimes();
		}
		
		/** Removes the frame at a certain ID. The successors will move down. */
		public function removeFrameAt(frameID:int):void
		{
			if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
			if (numFrames == 1) throw new IllegalOperationError("Movie clip must not be empty");
			
			mTotalTime -= getFrameDuration(frameID);
			mTextures.splice(frameID, 1);
			mFrameScripts.splice(frameID, 1);
			mDurations.splice(frameID, 1);
			
			updateStartTimes();
		}
		
		/** Returns the texture of a certain frame. */
		public function getFrameTexture(frameID:int):Texture
		{
			if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
			return mTextures[frameID];
		}
		
		/** Sets the texture of a certain frame. */
		public function setFrameTexture(frameID:int, texture:Texture):void
		{
			if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
			mTextures[frameID] = texture;
		}
		
		/** Returns the sound of a certain frame. */
		public function getFrameScriptContains(frameID:int):SAnimateFrameScriptContains
		{
			if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
			return mFrameScripts[frameID];
		}
		
		/** Sets the sound of a certain frame. The sound will be played whenever the frame 
		 *  is displayed. */
		public function setFrameScriptContains(frameID:int, scriptContains:SAnimateFrameScriptContains):void
		{
			if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
			mFrameScripts[frameID] = scriptContains;
		}
		
		/** Returns the duration of a certain frame (in seconds). */
		public function getFrameDuration(frameID:int):Number
		{
			if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
			return mDurations[frameID];
		}
		
		/** Sets the duration of a certain frame (in seconds). */
		public function setFrameDuration(frameID:int, duration:Number):void
		{
			if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
			mTotalTime -= getFrameDuration(frameID);
			mTotalTime += duration;
			mDurations[frameID] = duration;
			updateStartTimes();
			
		}
		
		/**
		 * 从第0帧开始播放 
		 * 
		 */
		public function gotoAndPlay():void
		{
			play();
			currentFrame = 0;
		}
		
		
		// playback methods
		
		/** Starts playback. Beware that the clip has to be added to a juggler, too! */
		public function play():void
		{
			mPlaying = true;
		}
		
		/** Pauses playback. */
		public function pause():void
		{
			mPlaying = false;
		}
		
		/** Stops playback, resetting "currentFrame" to zero. */
		public function stop():void
		{
			mPlaying = false;
			currentFrame = 0;
		}
		
		// helpers
		
		private function updateStartTimes():void
		{
			var numFrames:int = this.numFrames;
			
			mStartTimes.length = 0;
			mStartTimes[0] = 0;
			
			for (var i:int=1; i<numFrames; ++i)
				mStartTimes[i] = mStartTimes[i-1] + mDurations[i-1];
		}
		
		/** @inheritDoc */
		public function advanceTime(passedTime:Number):void
		{
			if (mCurrentFrame != previousFrame)
				texture = mTextures[mCurrentFrame];
			if (restTime)
				advanceTime(restTime);
			
			
			if (!mPlaying || passedTime <= 0.0) return;
			
			var finalFrame:int;
			var previousFrame:int = mCurrentFrame;
			var restTime:Number = 0.0;
			var breakAfterFrame:Boolean = false;
			var hasCompleteListener:Boolean = hasEventListener(Event.COMPLETE); 
			var dispatchCompleteEvent:Boolean = false;
			var totalTime:Number = this.totalTime;
			
			if (mLoop && mCurrentTime >= totalTime)
			{ 
				mCurrentTime = 0.0; 
				mCurrentFrame = 0; 
			}
			
			if (mCurrentTime < totalTime)
			{
				mCurrentTime += passedTime;
				finalFrame = mTextures.length - 1;
				
				while (mCurrentTime > mStartTimes[mCurrentFrame] + mDurations[mCurrentFrame])
				{
					if (mCurrentFrame == finalFrame)
					{
						if (mLoop && !hasCompleteListener)
						{
							mCurrentTime -= totalTime;
							mCurrentFrame = 0;
						}
						else
						{
							breakAfterFrame = true;
							restTime = mCurrentTime - totalTime;
							dispatchCompleteEvent = hasCompleteListener;
							mCurrentFrame = finalFrame;
							mCurrentTime = totalTime;
						}
					}
					else
					{
						mCurrentFrame++;
					}
					
					var scriptContains:SAnimateFrameScriptContains = mFrameScripts[mCurrentFrame];
					if (scriptContains) scriptContains.execute(this);
					if (breakAfterFrame) break;
				}
				
				// special case when we reach *exactly* the total time.
				if (mCurrentFrame == finalFrame && mCurrentTime == totalTime)
					dispatchCompleteEvent = hasCompleteListener;
				
				//fix 时间累积误差的问题
				if (mLoop==false
					&& hasCompleteListener==true
					&& dispatchCompleteEvent==false
					&& mCurrentFrame == finalFrame
					&& mCurrentTime >= totalTime)
				{
					trace("fix mloop = false bug:" + this.name);
					trace("" + mCurrentTime + "/" + totalTime);
					
					dispatchCompleteEvent = hasCompleteListener;
				}
				
			}
			
			if (mCurrentFrame != previousFrame)
				texture = mTextures[mCurrentFrame];
			
			if (dispatchCompleteEvent)
				dispatchEventWith(Event.COMPLETE);
			
			if (mLoop && restTime > 0.0)
				advanceTime(restTime);
		}
		
		/** Indicates if a (non-looping) movie has come to its end. */
		public function get isComplete():Boolean 
		{
			return !mLoop && mCurrentTime >= mTotalTime;
		}
		
		// properties  
		
		/** The total duration of the clip in seconds. */
		public function get totalTime():Number { return mTotalTime; }
		
		/** The total number of frames. */
		public function get numFrames():int { return mTextures.length; }
		
		/** Indicates if the clip should loop. */
		public function get loop():Boolean { return mLoop; }
		public function set loop(value:Boolean):void { mLoop = value; }
		
		/** The index of the frame that is currently displayed. */
		public function get currentFrame():int { return mCurrentFrame; }
		public function set currentFrame(value:int):void
		{
			mCurrentFrame = value;
			mCurrentTime = 0.0;
			
			for (var i:int=0; i<value; ++i)
				mCurrentTime += getFrameDuration(i);
			
			texture = mTextures[mCurrentFrame];
			if (mFrameScripts[mCurrentFrame]) mFrameScripts[mCurrentFrame].execute(this);
		}
		
		/** The default number of frames per second. Individual frames can have different 
		 *  durations. If you change the fps, the durations of all frames will be scaled 
		 *  relatively to the previous value. */
		public function get fps():Number { return 1.0 / mDefaultFrameDuration; }
		public function set fps(value:Number):void
		{
			if (value <= 0) throw new ArgumentError("Invalid fps: " + value);
			
			var newFrameDuration:Number = 1.0 / value;
			var acceleration:Number = newFrameDuration / mDefaultFrameDuration;
			mCurrentTime *= acceleration;
			mDefaultFrameDuration = newFrameDuration;
			
			for (var i:int=0; i<numFrames; ++i) 
			{
				var duration:Number = mDurations[i] * acceleration;
				mTotalTime = mTotalTime - mDurations[i] + duration;
				mDurations[i] = duration;
			}
			
			updateStartTimes();
		}
		
		/** Indicates if the clip is still playing. Returns <code>false</code> when the end 
		 *  is reached. */
		public function get isPlaying():Boolean 
		{
			if (mPlaying)
				return mLoop || mCurrentTime < mTotalTime;
			else
				return false;
		}

		
		
		private static var _AnimateCache:SLRUCache = new SLRUCache();
		private static var _baseFrameCount:Array = null;
//		private static var _subframetoatlas:Dictionary = new Dictionary();
		
//		private static var _subframeTexture:Dictionary = new Dictionary(true);
		
		/**
		 * 获取贴图，有缓存 
		 * @param name
		 * @return 
		 * 
		 */
//		private static function _getAnimateTexture(name:String):Texture
//		{
//			var atlasname:String = _subframetoatlas[name];
//			if(atlasname == null)
//			{
//				atlasname = SApplication.assets.getAtlasNameBySubTextureName(name);
//				_subframetoatlas[name] = atlasname;
//			}
//			
//			if(atlasname == null)
//			{
//				return null;
//			}
//			var atlasTexture:TextureAtlas = SApplication.assets.getTextureAtlas(atlasname);
//			if(atlasTexture == null)
//				return null;
//			
//			var subtexture:Texture = _subframeTexture[name];
//			if(subtexture == null)
//			{
//				_subframeTexture[name] = atlasTexture.getTexture(name);
//			}
//			else
//			{
//				var vtexture:SubTexture = (_subframeTexture[name] as SubTexture);
//				if(vtexture.parent != atlasTexture.texture)
//				{
//					_subframeTexture[name] = atlasTexture.getTexture(name);
//				}
//			}
//			return _subframeTexture[name];
//		}
		/**
		 * 生成动画,通过动画对象 
		 * @param animObject
		 * @return 
		 * 
		 */
		public static function SAnimateFromAnimJsonObject(animObject:Object,scriptClass:Class = null):SAnimate
		{
			
			if(_baseFrameCount == null)
			{
				_baseFrameCount = new Array();
//				var numberformat:NumberFormat = new NumberFormat("0000");
				
				for(i=0;i<1000;i++)
				{
					if(i<10)
					{
						_baseFrameCount[i] = "000" + i;
					}
					else if(i<100)
					{
						_baseFrameCount[i] = "00" + i;
					}
					else
					{
						_baseFrameCount[i] = "0" + i;
					}
//					_baseFrameCount[i] = numberformat.format(i);
				}
			}
			
			var fps:int = animObject["fps"];
			var framesPropertys:Vector.<Object> = new Vector.<Object>();
			var framesArray:Array = null;
			var framesTextureVec:Vector.<Texture> = null;
			var frametype:int = animObject["frametype"];
			var framecount:int = animObject["framecount"];
			if(scriptClass == null)
			{
				scriptClass = SAnimateFrameScriptAction;
			}
			var length:int = 0;
			var i:int,j:int = 0;
			var registerx:Number = animObject["registerx"];
			var registery:Number = animObject["registery"];
			var registerposx:Number = animObject["registerposx"];
			var registerposy:Number = animObject["registerposy"];
			
			framesArray = _AnimateCache.getObject(animObject["name"]);
			
			if(framesArray == null)
			{
				//先用 framebasename构建 
				framesArray = new Array();
				var framebasename:String = animObject["framebasename"];
				
				for(i=0;i<framecount;i++)
				{
					framesArray[i] = {"index":i,"framename":formatString("{0}{1}",framebasename,_baseFrameCount[i])};
				}
				
				var customFrameArray:Array = animObject["frames"];
				var scriptContains:SAnimateFrameScriptContains;
				//包含自定义帧数据
				if(customFrameArray != null)
				{
					customFrameArray.sort(function(a:Object,b:Object):int
					{
						if(a["index"]>b["index"])
							return 1;
						return -1;
					});
					length = customFrameArray.length;
					var frameIndex:int = 0;
					var propertys:Object = null;
					for(i=0;i<length;i++)
					{
						frameIndex = customFrameArray[i]["index"];
						//使用自定义的帧名称
						if(customFrameArray[i].hasOwnProperty("framename"))
						{
							framesArray[frameIndex]["framename"] = customFrameArray[i]["framename"];
						}
						if(customFrameArray[i].hasOwnProperty("frameduring"))
						{
							framesArray[frameIndex]["frameduring"] = customFrameArray[i]["frameduring"];
						}
						//处理自定义属性
						propertys = customFrameArray[i]["property"];
						if(propertys != null)
						{
							scriptContains = new SAnimateFrameScriptContains();
							scriptContains.addScript(SAnimateFrameScriptAction.genWithPropertyObject(propertys,scriptClass));
							framesArray[frameIndex]["scriptContains"] = scriptContains;
						}
					}
				}
				
				_AnimateCache.addObject(animObject["name"],framesArray,1 * 60 * 60 * 1000);
			}

			
			
			
			
			
			framesTextureVec= new Vector.<Texture>();
			length = framesArray.length;
			for(i = 0;i<length;i++)
			{
				var frameObject:Object = framesArray[i];
				var frameTexture:Texture = SApplication.assets.getTexture(frameObject["framename"]);
//				var frameTexture:Texture = _getAnimateTexture(frameObject["framename"]);
				if(frameTexture == null)
				{
//					Assert(false,"frameTexture:{0} is null",frameObject["framename"]);
				}
				else
				{
					framesTextureVec.push(frameTexture);
				}
			}
			
			if(framesTextureVec.length == 0)
			{
				return null;
			}
			
			var ins:SAnimate = new SAnimate(framesTextureVec,fps);
			ins.name = animObject["name"];
			//修正注册点
			if(isNaN(registerx))
			{
				ins.pivotX = registerposx;
				ins.pivotY = registerposy;
			}
			else
			{
				ins.pivotX = registerx * framesTextureVec[0].frame.width;
				ins.pivotY = registery * framesTextureVec[0].frame.height;
			}
			length = framesArray.length;
			for(i=0;i<length;i++)
			{
				frameIndex = framesArray[i]["index"];
				if(framesArray[i].hasOwnProperty("scriptContains"))
				{
					
					scriptContains = framesArray[i]["scriptContains"];
					ins.setFrameScriptContains(frameIndex,scriptContains);
				}
				
				if(framesArray[i].hasOwnProperty("frameduring"))
				{
					ins.setFrameDuration(frameIndex,parseFloat(framesArray[i]["frameduring"]));
				}
			}
			framesTextureVec = null;
			
			return ins;
		}
		
		public function removeFromJuggler():void
		{
			dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
		}
	}
}