package SJ.Game.layer
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.controls.CJButtonUtil;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import starling.events.Event;
	import starling.textures.Texture;

	/**
	 * 消息弹出框
	 * @author sangxu
	 * @date   2013-09-03
	 */	
	public class CJPanelMessageBoxLayer extends CJPanelBaseLayer
	{
		private var _defaultWidth:int = 232;
		private var _defaultHeight:int = 110;
		
		/** 是否显示按钮 */
		private var _showButton:Boolean = true;
		/** 按钮回调函数 */
		private var _callBackSure:Function;
		/** 按钮回调函数第二 */
		private var _callBackSureSec:Function;
		/** 文字内容 */
		private var _labelText:String;
		/** 按钮文字内容 */
		private var _btnText:String;
		/** 按钮宽度 */
		private var _btnWidth:int = 0;
		/** 按钮x坐标 */
		private var _btnX:int = 0;
		
		/** 控件 - 文字 */
		protected var _label:Label;
		/** 控件 - 按钮 */
		protected var _btnSure:Button;
		
		public function CJPanelMessageBoxLayer()
		{
		}
		
		override protected function _init():void
		{
			super._init();
			_initControls();
		}
		
		private function _initControls():void
		{
			this.layerWidth = this._defaultWidth;
			this.layerHeight = this._defaultHeight;
			_initBg();
			_initLable();
//			_initContent();
			_initButton();
		}
		
		/**
		 * 初始化背景图片
		 * 
		 */		
		protected function _initBg():void
		{
			var texture:Texture = SApplication.assets.getTexture("common_tishikuang");
			var texture9:Scale9Textures = new Scale9Textures(texture,new Rectangle(16,16,1,1));
			var imageBg:Scale9Image = new Scale9Image(texture9);
			imageBg.width = this._defaultWidth;
			imageBg.height = this._defaultHeight;
			this.setLayerSize(imageBg.width, imageBg.height);
			this.addLayerChild(imageBg);
		}
		
		/**
		 * 初始化文字控件
		 * 
		 */		
		protected function _initLable():void
		{
			_label= new Label();
			_label.textRendererFactory = textRender.htmlTextRender;
			var fontFormat:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFFFFFF);
			_label.textRendererProperties.textFormat = fontFormat;
			_label.textRendererProperties.wordWrap = true;
			_label.x = 10;
			_label.y = 20;
			_label.width = this.layerWidth - 20;
			this.addLayerChild(_label);
		}
		
		protected function _initButton():void
		{
			
			if (_btnText == null || _btnText == "")
			{
				_btnText = CJLang("COMMON_TRUE");
			}
			_btnSure = CJButtonUtil.createCommonButton(_btnText);
			
			_btnX = (_btnX == 0) ? 80 : _btnX;
			_btnWidth = (_btnWidth == 0) ? _btnSure.width : _btnWidth;
			
			_btnSure.addEventListener(Event.TRIGGERED, _touchHandler);
			_btnSure.x = _btnX;
			_btnSure.y = 70;
			_btnSure.labelOffsetY = -1;
			_btnSure.width = _btnWidth;
			_btnSure.visible = _showButton;
			this.addLayerChild(_btnSure);
			
			
			
		}
		
		protected function _touchHandler(e:Event):void
		{
			if (this._callBackSure != null)
			{
				this._callBackSure();
			}
			if (this._callBackSureSec != null)
			{
				this._callBackSureSec();
			}
			this.removeFromParent(true);
		}
		
		/**
		 * 设置点击按钮回调方法
		 * @param func
		 * 
		 */
		public function set callbackSure(func:Function):void
		{
			_callBackSure = func;
		}
		
		/**
		 * 设置点击按钮第二回调方法
		 * @param func
		 * 
		 */
		public function set callBackSureSec(func:Function):void
		{
			_callBackSureSec = func;
		}
		
		override protected function draw():void
		{
			super.draw();
			_label.text = _labelText;
			_btnSure.label = _btnText;
			_btnSure.width = _btnWidth;
			_btnSure.x = _btnX;
			_btnSure.visible = _showButton;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_callBackSure = null;
			_callBackSureSec = null;
			_labelText = null;
			_btnText = null;
			
			_label = null;
			_btnSure = null;
		}
		
		/** 提示文字 */
		public function get labelText():String
		{
			return _labelText;
		}
		public function set labelText(value:String):void
		{
			_labelText = value;
			this.invalidate();
		}
		
		/** 按钮文字 */
		public function get buttonText():String
		{
			return _btnText;
		}
		public function set buttonText(value:String):void
		{
			_btnText = value;
			this.invalidate();
		}
		
		/** 按钮宽度 */
		public function get buttonWidth():int
		{
			return _btnWidth;
		}
		public function set buttonWidth(value:int):void
		{
			_btnWidth = value;
			this.invalidate();
		}
		
		/** 按钮x坐标 */
		public function get buttonX():int
		{
			return _btnX;
		}
		public function set buttonX(value:int):void
		{
			_btnX = value;
			this.invalidate();
		}
		
		/** 是否显示按钮 */
		public function get showButton():Boolean
		{
			return _showButton;
		}
		public function set showButton(showButton:Boolean):void
		{
			this._showButton = showButton;
		}
	}
}