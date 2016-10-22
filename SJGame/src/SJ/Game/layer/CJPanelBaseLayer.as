package SJ.Game.layer
{
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SLayer;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 弹出面板层基类, 周围区域点击关闭
	 * @author sangxu
	 * @date   2013-09-03
	 */	
	public class CJPanelBaseLayer extends SLayer
	{
		private var _quad:Quad;
		/** 层 - 内容 */
		protected var _layerContant:SLayer;
		
		/** 关闭回调 */
		private var _funcCloseCallback:Function;
		
		public function CJPanelBaseLayer()
		{
			this._layerContant = new SLayer();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_init();
			
			_initControlsPanel();
		}
		
		protected function _init():void
		{
			// 子类重载
		}
		
		private function _initControlsPanel():void
		{
			this.width = SApplicationConfig.o.stageWidth;
			this.height = SApplicationConfig.o.stageHeight;
			
			// 背景, 点击关闭
			_quad = new Quad(SApplicationConfig.o.stageWidth, SApplicationConfig.o.stageHeight);
			_quad.alpha = 0;
			_quad.addEventListener(starling.events.TouchEvent.TOUCH, _onClickQuad);
			this.addChildAt(_quad, 0);
			
			// 内容层
			this._layerContant.x = (SApplicationConfig.o.stageWidth - this._layerContant.width) / 2;
			this._layerContant.y = (SApplicationConfig.o.stageHeight - this._layerContant.height) / 2;
			this.addChild(this._layerContant);
		}
		/**
		 * 对显示内容添加子节点, 
		 * @param child
		 * @return 
		 * 
		 */		
		public function addLayerChild(child:DisplayObject):DisplayObject
		{
			return this._layerContant.addChild(child);
		}
		
		/**
		 * 对显示内容添加子节点
		 * @param child
		 * @param index
		 * @return 
		 * 
		 */		
		public function addLayerChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return this._layerContant.addChildAt(child, index);
		}
		
		public function get layerWidth():int
		{
			return this._layerContant.width;
		}
		
		public function set layerWidth(width:int):void
		{
			this._layerContant.width = width;
		}
		
		public function get layerHeight():int
		{
			return this._layerContant.height;
		}
		
		public function set layerHeight(height:int):void
		{
			this._layerContant.height = height;
		}
		
		public function setLayerSize(width:Number, height:Number):void
		{
			this.setSize(width, height);
		}
		
		override public function dispose():void
		{
			super.dispose();
			_quad = null;
			_layerContant = null;
			_funcCloseCallback = null;
		}
		
		/**
		 * 点击事件响应 - 背景
		 * @param event
		 * 
		 */		
		private function _onClickQuad(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this._quad, TouchPhase.BEGAN);
			if (!touch)
			{
				return;
			}
			this._closeLayer();
		}
		
		/**
		 * 关闭
		 * 
		 */		
		private function _closeLayer(dispose:Boolean = true):void
		{
			if (_funcCloseCallback != null)
			{
				_funcCloseCallback();
			}
			this.removeFromParent(dispose);
		}
		
		/**
		 * 设置关闭回调方法
		 * @param func	回调方法
		 * 
		 */
		public function set callbackClose(func:Function):void
		{
			_funcCloseCallback = func;
		}
		
		public function get layerContant(): SLayer
		{
			return _layerContant;
		}
	}
}