package SJ.Game.heroStar
{
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	import engine_starling.utils.STween;
	
	import feathers.controls.ImageLoader;
	
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;

//	import starling.extensions.pixelmask.PixelMaskDisplayObject;
	
	/**
	 * 计分板中的数字
	 * 独立出现翻记分牌效果
	 * @author longtao
	 */
	public class CJScoreBoardNumber extends SLayer
	{
		/**
		 * 资源名前缀
		 * 后直接跟数字即可
		 * 如"texiaozi_zhandouli0"
		 */
//		private static const ResourceNamePre:String = "texiaozi_zhandouli";
		/** 数字的最大数量 **/
		private static const MaxCount:int = 10;
		/** 补间动画整体时间 **/
		private static const CONST_MOVE_TIME:Number = 0.3;
//		/** 控件默认宽度 **/
//		public static const CONST_WIDTH:int = 20;
//		/** 控件默认高度 **/
//		public static const CONST_HEIGHT:int = 23;
		
		// 宽度
		private var _layerWidth:int;
		// 高度
		private var _layerHeight:int;
		
		
		private var _numArr:Object;
		private var _num:int;
		private var _isPlaying:Boolean = false;
		
		/// 底层
//		private var _layer:PixelMaskDisplayObject;
		/// 放置数字层
		private var _numLayer:SLayer;
		/// 遮罩
//		private var _mask:Quad;
		/// 补间动画
		private var _tween:STween;
		/// 是否应该显示
		private var _isShow:Boolean;
		
		private var _resource:String;
		
		
		private static const DEFAULT_POS_VALUE:Number = -1000;
		/** 下一个位置x **/
		private var _nextX:Number = DEFAULT_POS_VALUE;
		/** 下一个位置y **/
		private var _nextY:Number = DEFAULT_POS_VALUE;
		
		public function CJScoreBoardNumber(resource:String, vWidth:int, vHeight:int)
		{
			super();
			
			width = vWidth;
			height = vHeight;
			_resource = resource;
			_init();
		}
		
		// 初始化layer
		private function _init():void
		{
//			width = CONST_WIDTH;
//			height = CONST_HEIGHT;
			
//			// 底层
//			_layer = new PixelMaskDisplayObject;
			
//			// 遮罩
//			_mask = new Quad(width, height);
//			_layer.mask = _mask;
			// 数字层
			_numLayer = new SLayer;
//			_layer.addChild(_numLayer);
			addChild(_numLayer);
			
			clipRect = new Rectangle(0,0, width,height);
			
			_numArr = new Object;
			for (var i:int=0; i<MaxCount; ++i)
			{
				var img:ImageLoader = new ImageLoader;
				img.source = SApplication.assets.getTexture(_resource+i);
				img.x = 0;
				img.y = i*height;
				_numLayer.addChild(img);
				// 保存记录该loader
				_numArr[i] = img;
			}
//			addChild(_layer);
			// 默认为不显示
			visible = false;
		}
		
		// 播放动画
		private function _playAnimation():void
		{
			if (!visible) // 不显示的控件不必进行动画
				return;
			
			var img:ImageLoader = _numArr[_num];
			if (null == img)
				return;
			
			if (_tween) // 如果正在播放中
			{
				// 直接设置到制定位置，再进行移动
				_onComplete();
				_numLayer.x = _nextX;
				_numLayer.y = _nextY;
			}
			
			_tween = new STween(_numLayer, CONST_MOVE_TIME);
			_tween.moveTo(img.x, -img.y);
			_nextX = img.x;
			_nextY = -img.y;
			_tween.onComplete = _onComplete;
			Starling.juggler.add(_tween);
			
			function _onComplete ():void
			{
				Starling.juggler.remove(_tween);
				_tween = null;
			}
		}
		
		/**
		 * 设置数字
		 * @param value
		 */
		public function set num(value:uint):void
		{
			if (value >= MaxCount)
				return;
			
			_num = value;
			
			_playAnimation();
		}
		
		public function set isShow(value:Boolean):void
		{
			visible = value;
		}
		
		
	}
}