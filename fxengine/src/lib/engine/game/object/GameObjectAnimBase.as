package lib.engine.game.object
{
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import lib.engine.game.bitmap.GBitmap;
	import lib.engine.game.bitmap.GBitmapDataAnim;
	
	/**
	 * 动画基础类 
	 * @author caihua
	 * 
	 */
	public class GameObjectAnimBase extends GameObject
	{
		/**
		 * 帧动画 
		 */
		private var _frames:Vector.<GBitmapDataAnim> = new Vector.<GBitmapDataAnim>();;
		private var _framecounts:int = 0;
		private var _currentframe:int = 0;
		private var _fps:int = 10;
		//fps时间间隔
		private var _fpstime:Number = 1000/_fps;
		//当前帧持续时间
		private var _fpslasttime:Number = 0;
		private var _loop:Boolean = true;
		private var _autodelete:Boolean = false;
		
		private static const STATE_PLAY:String = "STATE_PLAY";
		private static const STATE_STOP:String = "STATE_STOP";
		private static const STATE_SPACE:String = "STATE_SPACE";
		
		private var _state:String = STATE_STOP;
		
		private var _pixelcollision:Boolean = false;
		private var _playspace:uint = 0;
		
		
		
		
		public function get loop():Boolean
		{
			return _loop;
		}
		
		public function set loop(value:Boolean):void
		{
			_loop = value;
		}
		
		
		public function get fps():int
		{
			return _fps;
		}
		
		public function set fps(value:int):void
		{
			_fps = value;
			_fpstime = 1000/fps;
		}
		
		
		public function GameObjectAnimBase()
		{
			super();
		}
		
		override protected function onInit():void
		{
			super.onInit();
		}
		
		
		/**
		 * 添加帧动画 
		 * @param image
		 * 
		 */
		public function addFrameImage(image:GBitmapDataAnim):void
		{
			_frames.push(image);
			_framecounts = _frames.length;
			
			
			if(image.bitmap.data.width > this.width)
			{
				this.width = image.bitmap.data.width;
			}
			if(image.bitmap.data.height > this.height)
			{
				this.height = image.bitmap.data.height;
			}
		}
		
		override public function hitTest(pos:Point):Boolean
		{
			if(_frames.length != 0)
			{
				if(_pixelcollision)
				{
			
					_canvas.collsionbuffer.fillRect(_canvas.collsionbuffer.rect,0x00000000);
					render(_canvas.collsionbuffer,new Rectangle(_canvas.viewport.x,_canvas.viewport.y,
						_canvas.collsionbuffer.rect.width,_canvas.collsionbuffer.rect.height));
					return _canvas.collsionbuffer.hitTest(new Point(_canvas.viewport.x,_canvas.viewport.y),255,pos);
				}
				else
				{
					var m_frame:GBitmapDataAnim = _frames[CurrentFrame()];
					var rect:Rectangle = new Rectangle(x + m_frame.mainbody.x,
						y + m_frame.mainbody.y,this.width,this.height);
					return rect.contains(pos.x,pos.y);
				}
			}
			return false;
		}
		
		
		override public function render(g:GBitmap, offset:Rectangle):void
		{
			if(_frames.length != 0)
			{
				var m_frame:GBitmapDataAnim = _frames[CurrentFrame()];
				var mPos:Point = new Point(x - offset.x + m_frame.mainbody.x 
					,y  - offset.y + m_frame.mainbody.y);
				
				if(degree == 0)
				{
					
					g.copyPixels(m_frame.bitmap.dataMix,m_frame.bitmap.dataMix.rect,
						mPos,null,null,true);
				}
				else
				{
					
					var m:Matrix = new Matrix();
					m.translate(m_frame.mainbody.x,m_frame.mainbody.y);
					m.rotate(degree);
					m.translate(x- offset.x,y - offset.y);
					var colorT:ColorTransform = new ColorTransform();
					colorT.alphaMultiplier = alpha;
					
					g.draw(m_frame.bitmap.dataMix,m,colorT,null,null,true);
				}
				
			}
			
		}
		
		override public function update(currenttime:Number, escapetime:Number):void
		{
			
			if(_state == STATE_STOP)
				return;
			
			_fpslasttime += escapetime;
			
			if(_state == STATE_SPACE)
			{
				if(_fpslasttime > _playspace)
				{
					reStart();
				}
				return;
			}
			
			if(_state == STATE_PLAY && _fpslasttime > _fpstime)
			{
				_currentframe += _fpslasttime / _fpstime;
				_fpslasttime = 0;
				if(_currentframe >= _framecounts)
				{
					_onPlayEnd();
				}
				
				
			}
			
		}
		
		/**
		 * 播放结束 
		 * 
		 */
		private function _onPlayEnd():void
		{
			if(!_loop)
			{
				Stop();
				_currentframe = _framecounts - 1;
				if(_autodelete)
					unregister();
			}
			else
			{
				_currentframe =  _framecounts - 1;
				_state = STATE_SPACE;
				
			}
		}
		
		public function NextFrame():int
		{
			_currentframe ++;
			_currentframe = _currentframe % _framecounts;
			return _currentframe;
		}
		public function PrevFrame():int
		{
			_currentframe = _currentframe + _framecounts - 1;
			_currentframe = _currentframe % _framecounts;
			return _currentframe;
		}
		public function CurrentFrame():int
		{
			return _currentframe;
		}
		/**
		 * 停止播放 
		 * 
		 */
		public function Stop():void
		{
			if(_state != STATE_STOP){
				
				_state = STATE_STOP;
				_fpslasttime = 0;
				
				onStop();
			}
			
		}
		/**
		 * 从上次停止的位置开始播放 
		 * 
		 */
		public function Start():void
		{
			if(_state != STATE_PLAY)
			{
				onStart();
				_state = STATE_PLAY;
			}
			
		}
		
		/**
		 * 从头开始播放 
		 * 
		 */
		public function reStart():void
		{
			if(_state != STATE_PLAY)
			{
				onStart();
				_state = STATE_PLAY;
				_currentframe = 0;
				_fpslasttime = 0;
			}
		}
		
		public function gotoAndStop(frame:uint):void
		{
			Stop();
			_currentframe = frame % _framecounts;
		}
		
		public function gotoAndPlay(frame:uint):void
		{
			_currentframe = frame % _framecounts;
			_fpslasttime = 0;
			_state = STATE_PLAY;
		}
		
		
		public function Reset():void
		{
			Stop();
			_framecounts = 0;
			_fps = 0;
			_fpslasttime = 0;
			this.width = 0;
			this.height = 0;
			while(null!=_frames.pop()){};
			_currentframe = 0;
		}
		
		protected function onStop():void{}
		
		protected function onStart():void{}
		
		/**
		 * 播放结束自动删除
		 * 必须是_loop 为false的时候 
		 */
		public function get autodelete():Boolean
		{
			return _autodelete;
		}
		
		/**
		 * @private
		 */
		public function set autodelete(value:Boolean):void
		{
			_autodelete = value;
		}
		
		/**
		 * 像素级检测 
		 */
		public function get pixelcollision():Boolean
		{
			return _pixelcollision;
		}
		
		/**
		 * @private
		 */
		public function set pixelcollision(value:Boolean):void
		{
			_pixelcollision = value;
		}
		
		/**
		 * 循环播放间隔 
		 */
		public function get playspace():uint
		{
			return _playspace;
		}
		
		/**
		 * @private
		 */
		public function set playspace(value:uint):void
		{
			_playspace = value;
		}
		
		
	}
}