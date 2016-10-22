package SJ.Game.task
{
	import SJ.Game.layer.CJLayerManager;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.STween;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 +------------------------------------------------------------------------------
	 * @comment 特效漂浮字 ,资源放到特效字目录
	 * 使用方法 new CJTaskFlowFont("xxx").addToLayer();
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-21 上午10:16:58  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskFlowImage extends SLayer
	{
		private var _resource_texiaozi:String = "resource_texiaozi.xml";
		private var _font:String;
		/*漂浮的字*/
		private var _image:SImage;
		private var _loadCompleteFunction:Function;
		private var _resourceType:String;
		/*显示时间*/
		private var _animateTime:Number = 1;

		private var _tween:STween;
		/*漂移距离*/
		private var _tweenDistance:Number;
		private var _offsetX:Number;
		private var _offsetY:Number;
		
		/**
		 * @param font : 字的名字
		 * @param animateTime : 动画显示时间
		 * @param tweenDistance : 漂移距离
		 */		
		public function CJTaskFlowImage(font:String , animateTime:Number = 1 , tweenDistance:Number = 10 , offsetX:Number = 0 , offsetY:Number = 0)
		{
			super();
			this._font = font;
			this._animateTime = animateTime;
			this._tweenDistance = tweenDistance;
			this._offsetX = offsetX;
			this._offsetY = offsetY;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._loadResource();
		}
		
		private function _loadResource():void
		{
//			CJTaskAsyncLoad.o.asyncLoad(_resource_texiaozi , "texiaozi");
//			CJEventDispatcher.o.addEventListener("texiaozi" , this._loadCompleteHandler)
			
			_loadCompleteHandler(null);
		}
		
		private function _loadCompleteHandler(e:Event):void
		{
			var texture:Texture = SApplication.assets.getTexture(_font);
			_image = new SImage(texture);
			
			this.width = texture.width;
			this.height = texture.height;
//			_image.x -= this.width >> 1;
			this.addChild(_image);
			
			_image.x += _offsetX;
			_image.y += _offsetY;
			
			_tween = new STween(_image , this._animateTime);
			_tween.moveTo(_image.x , _image.y - _tweenDistance);
			_tween.onComplete = _tweenCompleteHandler
			Starling.juggler.add(_tween);
		}
		
		private function _tweenCompleteHandler():void
		{
			Starling.juggler.remove(_tween);
			if(this.parent)
			{
				this.removeFromParent(true);
			}
		}
		
		public function addToLayer():void
		{
			CJLayerManager.o.addToModal(this);
		}
	}
}