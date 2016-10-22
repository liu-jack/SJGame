package SJ.Game.controls
{
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstTextFormat;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;
	import feathers.controls.Label;

	/**
	 *  创建一个常用的普通按钮
	 * @author yongjun 
	 * 
	 */
	public class CJButtonUtil
	{
		public function CJButtonUtil()
		{
			
		}
		
		public static function createCommonButton(text:String):Button
		{
			var button:Button = new Button();
			button.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniu01new"));
			button.downSkin = new SImage( SApplication.assets.getTexture("common_anniu02new"));// zhengzheng++
			var fontFormat:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 14, 0xDEE035);
			button.label = text;
			button.width = 75;
			button.height = 28;
//			button.labelOffsetY = 2;
			button.horizontalAlign = Button.HORIZONTAL_ALIGN_CENTER;
			button.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
			button.defaultLabelProperties.textFormat = fontFormat;
			return button;
		}
		
		public static function createYellowSmallButton(text:String):Button
		{
			var ybutton:Button = new Button();
			ybutton.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniu01new"));
			ybutton.downSkin = new SImage( SApplication.assets.getTexture("common_anniu02new"));// zhengzheng++
			var fontFormat:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xffffff);
			ybutton.label = text;
			ybutton.width = 55;
			ybutton.height = 17;
			ybutton.horizontalAlign = Button.HORIZONTAL_ALIGN_CENTER;
			ybutton.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
			ybutton.defaultLabelProperties.textFormat = fontFormat;
			return ybutton;
		}
		
		public static function createYellowNormalButton(text:String):Button
		{
			var ynbutton:Button = new Button();
			ynbutton.defaultSkin = new SImage( SApplication.assets.getTexture("jingjichang_zuoceanniu01"));
			ynbutton.downSkin = new SImage( SApplication.assets.getTexture("jingjichang_zuoceanniu02"));// zhengzheng++
			var fontFormat:TextFormat = new TextFormat( "Arial", 14, 0x000000);
			ynbutton.label = text;
			ynbutton.horizontalAlign = Button.HORIZONTAL_ALIGN_CENTER;
			ynbutton.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
			ynbutton.defaultLabelProperties.textFormat = fontFormat;
			return ynbutton;
		}
		
		public static function createJingjiBangButton():Button
		{
			var jbutton:Button = new Button();
			jbutton.defaultSkin = new SImage( SApplication.assets.getTexture("jingjichang_anniujingjibang01"));
			jbutton.downSkin = new SImage( SApplication.assets.getTexture("jingjichang_anniujingjibang02"));
			return jbutton;
		}
		
		public static function createLianShenBangButton():Button
		{
			var jbutton:Button = new Button();
			jbutton.defaultSkin = new SImage( SApplication.assets.getTexture("jingjichang_anniulianshengbang01"));
			jbutton.downSkin = new SImage( SApplication.assets.getTexture("jingjichang_anniulianshengbang02"));
			return jbutton;
		}
		public static function createLoginBtn(btn:Button,labeltxt:String):Button
		{
			var fontFormat:TextFormat = new TextFormat( "Arial", 14, 0xFFFFFF,true);
			btn.label = labeltxt;
			btn.defaultLabelProperties.textFormat = fontFormat;
			return btn;
		}
	}
}