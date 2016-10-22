package SJ.Game.task.util
{
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	
	import SJ.Common.Constants.ConstTextFormat;
	
	import starling.text.TextField;

	/**
	 +------------------------------------------------------------------------------
	 * html标签的工具类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-10 下午2:03:34  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskHtmlUtil
	{
		/**
		 * 字体描边
		 */		
		public static function drawFlow(tf:TextField):void
		{
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			tf.nativeFilters = [new ConvolutionFilter(3,3,matrix,3),
				new GlowFilter(0x000000,1.0,2.0,2.0,5,2)];
		}
		
		/**
		 * label发光
		 * 返回发光的标签
		 */		
		public static function createGlowLabel(text:String="" , color:uint = 0xFDA600):CJTaskLabel
		{
			var titleLabel:CJTaskLabel = new CJTaskLabel();
			titleLabel.fontColor = color;
			titleLabel.fontFamily = ConstTextFormat.FONT_FAMILY_LISHU;
			titleLabel.fontSize = 14;
			titleLabel.text = text;
			return titleLabel;
		}
		
		/**
		 * 过滤html标签
		 */		
		public static function wipeHtmlTag(text:String):String
		{
			var reg:RegExp = new RegExp(/<[^>]+>/ig);
			var newText:String = text.replace(reg , "");
			return newText;
		}
		
		/**
		 * 造一个颜色标签出来
		 * @param text 原装的标签
		 * @param color 需要使用的颜色
		 */		
		public static function colorText(text:String , color:String):String
		{
			if(color)
			{
				text = wipeHtmlTag(text);
				text = "<font color='"+color+"'>"+text+"</font>";
			}
			return text;
		}
		
		/**
		 * 现在用的按钮上的怪黄色的字体
		 * @param text
		 * @param color
		 */		
		public static function buttonText(text:String):String
		{
			text = wipeHtmlTag(text);
			text = "<font color='#FFA800'>"+text+"</font>";
			return text;
		}
		
		public static function get tab():String
		{
			return "	";
		}
		
		public static function get space():String
		{
			return " ";
		}
		
		public static function get br():String
		{
			return "<br/>";
		}
	}
}