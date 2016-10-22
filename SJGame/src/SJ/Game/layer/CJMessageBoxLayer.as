package SJ.Game.layer
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.controls.CJButtonUtil;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	import engine_starling.utils.SManufacturerUtils;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class CJMessageBoxLayer extends SLayer
	{
		private static var _ins:CJMessageBoxLayer = null;
		protected var _label:Label;
		protected var _image:Scale9Image
		private var _callBack:Function;
		private var _content:SLayer;
		private var _labeltext:String;
		
		public function CJMessageBoxLayer()
		{
			super();
			
		}
		
		override protected function draw():void
		{
			super.draw();
			_label.text = _labeltext;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_init();
		}
		
		
		public static function get o():CJMessageBoxLayer
		{
			if(_ins == null)
				_ins = new CJMessageBoxLayer();
			return _ins;
		}
		private function _init():void
		{
			_initBg();
			_initLable();
			_initContent();
			_initButton();
		}
		
		/**
		 * 设置文字 
		 * @param str
		 * 
		 */
		public function set text(str:String):void
		{
			labeltext = "   "+str;
		}
		/**
		 * 设置回调函数
		 * @param func
		 * 
		 */
		public function set callBack(func:Function):void
		{
			_callBack = func;
		}
		protected function _initBg():void
		{
			var texture:Texture = SApplication.assets.getTexture("common_tishikuang");
			var texture9:Scale9Textures = new Scale9Textures(texture,new Rectangle(16,16,1,1));
			_image = new Scale9Image(texture9);
			_image.width = 232;
			_image.height = 110;
			this.setSize(_image.width,_image.height);
			this.addChild(_image);
		}
		
		protected function _initContent():void
		{
			_content = new SLayer
			this.addChild(_content)
		}
		
		public function addContent(content:DisplayObject):void
		{
			this._content.removeChildren(0,-1,true);
			this._content.addChild(content)
		}
		
		protected function _initLable():void
		{
			_label= new Label;
			var fontFormat:TextFormat = new TextFormat();
			fontFormat.font = ConstTextFormat.FONT_FAMILY_HEITI;
			fontFormat.color = 0xffffff;
			fontFormat.size = 10;
			if(SManufacturerUtils.getManufacturerType() == SManufacturerUtils.TYPE_IOS)
			{
				_label.textRendererProperties.textFormat = fontFormat;
				_label.textRendererProperties.wordWrap = true; 
				_label.textRendererFactory = textRender.htmlTextRender;
			}
			else
			{
				_label.textRendererFactory = function():ITextRenderer
				{
					var tr:TextFieldTextRenderer = new TextFieldTextRenderer();
					tr.width = 212;
					tr.wordWrap = true;
					tr.maxWidth = 212;
					tr.isHTML = true;
					var tf:TextFormat = new TextFormat(); 
					tf.align = TextFormatAlign.LEFT;
					tf.color = 0xffffff;
					tf.size = 10;
					tr.textFormat = tf;
					return tr;
				};
			}
			_label.x = 10;
			_label.y = 20;
			_label.width = this.width-20;
			this.addChild(_label);
		}
		
		protected function _initButton():void
		{
			var quedingButton:Button = CJButtonUtil.createCommonButton(CJLang("COMMON_TRUE"));
			quedingButton.addEventListener(Event.TRIGGERED,_touchHandler);
			quedingButton.x = 80;
			quedingButton.y = 70;
			quedingButton.labelOffsetY = -1;
			this.addChild(quedingButton);
		}
		
		protected function _touchHandler(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			this._label.text = "";
			this._content.removeChildren(0,-1,true);
			if(this._callBack!=null)
			{
				this._callBack();
			}
			this._callBack = null;
			this.removeFromParent(false);
		}

		public function get labeltext():String
		{
			return _labeltext;
		}

		public function set labeltext(value:String):void
		{
			_labeltext = value;
			this.invalidate();
		}

		
	}
}