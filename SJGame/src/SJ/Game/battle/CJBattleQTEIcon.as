package SJ.Game.battle
{
	import SJ.Game.event.CJEvent;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	import engine_starling.utils.SDisplayUtils;
	import engine_starling.utils.STween;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	
	public class CJBattleQTEIcon extends SLayer
	{
		private var _movieClip:MovieClip;
		private var _tweenFlash:STween;
		private var _iconIndex:int;

		/**
		 * 图标的索引 
		 */
		public function get iconIndex():int
		{
			return _iconIndex;
		}

		public function CJBattleQTEIcon(iconIndex:int)
		{
			_iconIndex = iconIndex;
			super();
			
		}
		
		override protected function draw():void
		{
			// TODO Auto Generated method stub
			super.draw();
		}
		
		override protected function initialize():void
		{
			_initLayer();
			super.initialize();
		}
		
		
		private function _initLayer():void
		{
			var _vectorTextures:Vector.<Texture> = new Vector.<Texture>();
			_vectorTextures.push(SApplication.assets.getTexture("qte_quanliang"));
			_vectorTextures.push(SApplication.assets.getTexture("qte_liang"));
			_vectorTextures.push(SApplication.assets.getTexture("qte_an"));
			
			_movieClip = new MovieClip(_vectorTextures);
			addChild(_movieClip);
			_movieClip.currentFrame = 0;
			
			_tweenFlash = new STween(_movieClip,0.3);
			_tweenFlash.fadeTo(0.01);
			_tweenFlash.nextTween = new Tween(_movieClip,0.3);
			_tweenFlash.nextTween.fadeTo(1);
			_tweenFlash.loop = STween.XSTLoopTypeReverse;
			this.width = _vectorTextures[0].frame.width;
			this.height = _vectorTextures[0].frame.height;
//			this.pivotX = _vectorTextures[0].frame.width/2;
//			this.pivotY = _vectorTextures[0].frame.height/2;
			SDisplayUtils.setAnchorPoint(this);
			touchable = false;
		}
		
		public function Dark():void
		{
			_movieClip.alpha = 0.50;
			_movieClip.currentFrame = 2;
		}
		
		public function Light():void
		{
			_movieClip.alpha = 1;
			_movieClip.currentFrame = 1;
		}
		
		/**
		 * 激活 
		 * 
		 */
		public function active():void
		{
			//默认不可触摸
			touchable = true;
			flash();
		}
		
		public function deactive():void
		{
			//支撑不可点击
			touchable = false;
			unflash();
		}
		
		/**
		 * 闪烁 
		 * 
		 */
		private function flash():void
		{
			_movieClip.alpha = 1;
			_movieClip.currentFrame = 1;
			_tweenFlash.loop = STween.XSTLoopTypeRepeat;
			Starling.juggler.add(_tweenFlash);
		}
		
		/**
		 * 停止闪烁 
		 * 
		 */
		private function unflash():void
		{
			_tweenFlash.loop = STween.XSTLoopTypeNone;
			Starling.juggler.remove(_tweenFlash);
		}
		
		private function _onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
//			if (touch && touch.phase != TouchPhase.HOVER)
			{
				deactive();
				dispatchEventWith(CJEvent.Event_QTE_Active);	
			}
		}
	}
}