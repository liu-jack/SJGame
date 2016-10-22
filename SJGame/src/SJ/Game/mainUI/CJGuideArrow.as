package SJ.Game.mainUI
{
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Label;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.textures.Texture;
	
	/**
	 +------------------------------------------------------------------------------
	 * 新手引导箭头 - 动画
	 +------------------------------------------------------------------------------
	 * @author 	sangxu
	 * @date 	2013-08-19
	 +------------------------------------------------------------------------------
	 */
	public class CJGuideArrow extends SLayer implements IAnimatable
	{
		private var _scale:Number = 1;
		private var _factor:Number = 0.005;
		private var _dis:Number = 0;

		private var image:SImage;
		private var label:Label;
		private var _text:String;
		
		/** 是否是动画 */
		private var _isAnimate:Boolean = false;
		
		public function CJGuideArrow(labText:String)
		{
			super();
			_text = labText;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			var texture:Texture = SApplication.assets.getTexture("zhiyin_jiantou003");
			image = new SImage(texture);
			image.width = texture.frame.width;	
			image.height = texture.frame.height;
			image.pivotX = texture.frame.width >> 1;
			image.pivotY = texture.frame.height >> 1;
			
			this.addChild(image);
			
			label = new Label();
			label.text = _text;
			label.textRendererFactory = function():ITextRenderer
			{
				var textRender:TextFieldTextRenderer = new TextFieldTextRenderer();
				textRender.wordWrap = true;
				textRender.isHTML = true;
				textRender.textFormat = new TextFormat();
				textRender.textFormat.align = TextFormatAlign.CENTER;
				return textRender;
			}
				
			var linecont:int = 1;
			var labettext:String = label.text.toLowerCase();
			var lastfindindex:int = 0;
			while((lastfindindex = labettext.indexOf("<br/>",lastfindindex + 1)) != -1)
			{
				linecont ++;
			}
			label.width = image.width;
			label.pivotX = label.width /2;
			label.pivotY = (14 * linecont)/2;
			this.addChild(label);
			
//			this.pivotX = this.width / 2;
//			this.pivotY = this.height / 2;
		}
		
		/**
		 * 是否是动画
		 * @return 是动画返回true, 不是返回false
		 * 
		 */		
		public function get isAnimate():Boolean
		{
			return _isAnimate;
		}
		
		/**
		 * 设置框中文字
		 * @param labText	框中文字内容
		 * 
		 */		
		public function set text(labText:String):void
		{
			label.text = labText;
		}
		
		public function advanceTime(time:Number):void
		{
			_scale += _factor;
			if(_scale >= 1.05 || _scale <= 0.95)
			{
				_factor =- _factor;
			}
			if (null == image)
			{
				if (true == _isAnimate)
				{
					Starling.juggler.remove(this);
				}
				this.removeFromParent(true);
			}
			else
			{
				this.image.scaleX = this.image.scaleY = this._scale;
			}
		}
	}
}