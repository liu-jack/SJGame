package engine_starling.utils.FeatherControlUtils
{
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	
	import feathers.controls.Label;
	import feathers.core.ITextRenderer;
	
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * Label属性编辑器 
	 * @author caihua
	 * 
	 */
	public class FeatherControlPropertyBuilderLabel extends FeatherControlPropertyBuilderDefault
	{
		public function FeatherControlPropertyBuilderLabel()
		{
			super();
		}
		
		override public function get fullClassName():String
		{
			
			return "feathers.controls.Label";
		}

		/**
		 * 设置对其方式 0 左对齐 1居中 2右对齐 
		 * @param value
		 * 
		 */
		public function set align(value:*):void
		{
			var alignString:String = TextFormatAlign.LEFT;
			switch(int(value))
			{
				case 1:
					alignString = TextFormatAlign.CENTER;
					break;
				case 2:
					alignString = TextFormatAlign.RIGHT;
					break;
			}
			var tf:TextFormat = curTextformat;
			tf.align = alignString;
			curTextformat = tf;
		}
		public function set textSize(value:*):void
		{

			var tf:TextFormat = curTextformat;
			tf.size = int(value);
			curTextformat = tf;
		}
		
		public function set textColor(value:*):void
		{
			var tf:TextFormat = curTextformat;
			tf.color = int(value);
			curTextformat = tf;
		}
		
		/**
		 * 设置字体 
		 * @param value
		 * 
		 */
		public function set fontName(value:*):void
		{
			var tf:TextFormat = curTextformat;
			tf.font = value;
			curTextformat = tf;
		}
		/**
		 * 字体外发光颜色 
		 * @param value
		 * 
		 */
		public function set glowColor(value:*):void
		{
			(_editControl as Label).textRendererFactory = 
			function():ITextRenderer
			{
				var _htmltextRender:TextFieldTextRendererEx;
				_htmltextRender = new TextFieldTextRendererEx()
				_htmltextRender.isHTML = true;
				_htmltextRender.nativeFilters = [new GlowFilter(int(value),1.0,2.0,2.0,5,2)];
				_htmltextRender.wordWrap = true;
				return _htmltextRender;
			}
		}

		protected function get curTextformat():TextFormat
		{
			var tf:TextFormat = (_editControl as Label).textRendererProperties.textFormat;
			if (tf == null)
			{
				tf = new TextFormat();
			}
			return tf;
		}

		protected function set curTextformat(value:TextFormat):void
		{
			(_editControl as Label).textRendererProperties.textFormat = value;
		}
		
		
		
	}
}