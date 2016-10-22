package SJ.Game.task.util
{
	import flash.text.TextFormat;
	
	import SJ.Common.global.textRender;
	
	import feathers.controls.Label;
	
	/**
	 +------------------------------------------------------------------------------
	 * 颜色标签
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-3 下午5:22:27  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskLabel extends Label
	{
		private static const INVALIDATION_FLAG_FORMAT_CHANGE:String = "INVALIDATION_FLAG_FORMAT_CHANGE";
		
		private var _wrap:Boolean = false;
		private var _fontFamily:String = "arial";
		private var _fontSize:uint = 13;
		private var _fontColor:uint = 0xffffff;
		private var _htmlText:Boolean = true;
		private var _isBold:Boolean = false;
		
		public function CJTaskLabel()
		{
			super();
			this._init();
		}
		
		private function _init():void
		{
			this.textRendererFactory =  textRender.htmlTextRender;
		}
		
		override protected function draw():void
		{
			if(isInvalid(INVALIDATION_FLAG_FORMAT_CHANGE))
			{
				this.textRendererProperties.textFormat = new TextFormat( _fontFamily,_fontSize, _fontColor,_isBold);
				this.textRendererProperties.wordWrap = _wrap;
			}
			super.draw();

		}
		
		/**
		 * 设置label的字体，颜色等 
		 * @param fontSize:int 字体大小
		 * @param color:unit 字体颜色
		 * @param fontFamily:String 字体类型 arial 宋体等
		 */		
		public function setTextFormat(fontSize:int, color:uint = 0xffffff , fontFamily:String = "宋体"):void
		{
			this.textRendererProperties.textFormat = new TextFormat(fontFamily , fontSize , color);
		}
		
		/**
		 * 设置label的字体，颜色等 
		 */		
		public function setNormalTextFormat(format:TextFormat):void
		{
			this.textRendererProperties.textFormat = format;
		}
		
		/**
		 * 是否换行
		 * @param value
		 */		
		public function set wrap(value:Boolean):void
		{
			_wrap = value;
			this.textRendererProperties.wordWrap = _wrap;
		}
		
		/**
		 * 设置字体颜色
		 * @param text
		 * @param color
		 * @param bold
		 */		
		public function colorText(text:String , color:String = "#ffffff" , bold:Boolean = false):void
		{
			if(color)
			{
				text = CJTaskHtmlUtil.colorText(text , color);
			}
			if(bold)
			{
				text = "<b>"+text+"</b>";
			}
			this.text = text;
		}
		
		public function get wrap():Boolean
		{
			return _wrap;
		}

		public function get fontFamily():String
		{
			return _fontFamily;
		}

		public function set fontFamily(value:String):void
		{
			_fontFamily = value;
			this.invalidate(INVALIDATION_FLAG_FORMAT_CHANGE);
		}

		public function get fontSize():uint
		{
			return _fontSize;
		}

		public function set fontSize(value:uint):void
		{
			_fontSize = value;
			this.invalidate(INVALIDATION_FLAG_FORMAT_CHANGE);
		}

		public function get fontColor():uint
		{
			return _fontColor;
		}

		public function set fontColor(value:uint):void
		{
			_fontColor = value;
			this.invalidate(INVALIDATION_FLAG_FORMAT_CHANGE);
		}

		public function get htmlText():Boolean
		{
			return _htmlText;
		}

		public function set htmlText(value:Boolean):void
		{
			_htmlText = value;
			this.invalidate();
		}

		public function get isBold():Boolean
		{
			return _isBold;
		}
		
		public function set isBold(value:Boolean):void
		{
			_isBold = value;
			this.invalidate(INVALIDATION_FLAG_FORMAT_CHANGE);
		}
	}
}