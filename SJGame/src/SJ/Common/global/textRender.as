package SJ.Common.global
{
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	
	import feathers.core.ITextRenderer;
	
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;

	/**
	 +------------------------------------------------------------------------------
	 * 渲染html颜色的工厂 有描边和发光
	 +------------------------------------------------------------------------------
	 */
	public class textRender{
		
		/**
		 * Html标签 
		 */		
		public static function htmlTextRender():ITextRenderer
		{
			var _htmltextRender:TextFieldTextRendererEx;
			_htmltextRender = new TextFieldTextRendererEx()
			_htmltextRender.isHTML = true;
			return _htmltextRender;
		}
		
		/**
		 *  仅卷积效果
		 */		
		public static function convolutionTextRender():ITextRenderer
		{
			var _htmltextRender:TextFieldTextRendererEx;
			_htmltextRender = new TextFieldTextRendererEx()
			_htmltextRender.isHTML = true;
			
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			
			_htmltextRender.nativeFilters = [new ConvolutionFilter(3,3,matrix,3)];
			return _htmltextRender;
		}
		
		/**
		 * 仅发光效果
		 */		
		public static function glowTextRender():ITextRenderer
		{
			var _htmltextRender:TextFieldTextRendererEx;
			_htmltextRender = new TextFieldTextRendererEx()
			_htmltextRender.isHTML = true;
			_htmltextRender.nativeFilters = [new GlowFilter(0x000000,1.0,2.0,2.0,5,2)];
			return _htmltextRender;
		}
		
		/**
		 * 卷积，发光
		 */		
		public static function standardTextRender():ITextRenderer
		{
			var _htmltextRender:TextFieldTextRendererEx;
			_htmltextRender = new TextFieldTextRendererEx()
			_htmltextRender.isHTML = true;
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			
			_htmltextRender.nativeFilters = [new ConvolutionFilter(3,3,matrix,3) , new GlowFilter(0x000000,1.0,2.0,2.0,5,2)];
			return _htmltextRender;
		}
	}
}
