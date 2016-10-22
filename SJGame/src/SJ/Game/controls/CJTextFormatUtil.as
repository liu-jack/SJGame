package SJ.Game.controls
{
	
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstTextFormat;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * 字体工具类
	 * @author sangxu
	 * 
	 */	
	public class CJTextFormatUtil
	{
		public function CJTextFormatUtil()
		{
		}
		
		/**
		 * 是否可将道具装入背包，单个道具与数量
		 * @param quality	道具品质，参照ConstItem.SCONST_ITEM_QUALITY_TYPE_***
		 * @param align		对其方式，TextFormatAlign，目前只支持左对齐与居中对齐
		 * @return ConstTextFormat.TEXT_FORMAT_QUALILTY_***,品质或对齐方式非法返回null
		 * 
		 */		
		public static function getTextFormatByItemQuality(quality:int, align:String):TextFormat
		{
			switch(quality)
			{
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_NORMAL:
					if (align == TextFormatAlign.CENTER)
					{
						return ConstTextFormat.TEXT_FORMAT_QUALILTY_WIGHT_CENTER;
					}
					else if(align == TextFormatAlign.LEFT)
					{
						return ConstTextFormat.TEXT_FORMAT_QUALILTY_WIGHT_LEFT;
					}
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_GREEN:
					if (align == TextFormatAlign.CENTER)
					{
						return ConstTextFormat.TEXT_FORMAT_QUALILTY_GREEN_CENTER;
					}
					else if(align == TextFormatAlign.LEFT)
					{
						return ConstTextFormat.TEXT_FORMAT_QUALILTY_GREEN_LEFT;
					}
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_BLUE:
					if (align == TextFormatAlign.CENTER)
					{
						return ConstTextFormat.TEXT_FORMAT_QUALILTY_BLUE_CENTER;
					}
					else if(align == TextFormatAlign.LEFT)
					{
						return ConstTextFormat.TEXT_FORMAT_QUALILTY_BLUE_LEFT;
					}
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_PURPLE:
					if (align == TextFormatAlign.CENTER)
					{
						return ConstTextFormat.TEXT_FORMAT_QUALILTY_PURPLE_CENTER;
					}
					else if(align == TextFormatAlign.LEFT)
					{
						return ConstTextFormat.TEXT_FORMAT_QUALILTY_PURPLE_LEFT;
					}
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_ORANGE:
					if (align == TextFormatAlign.CENTER)
					{
						return ConstTextFormat.TEXT_FORMAT_QUALILTY_ORANGE_CENTER;
					}
					else if(align == TextFormatAlign.LEFT)
					{
						return ConstTextFormat.TEXT_FORMAT_QUALILTY_ORANGE_LEFT;
					}
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_RED:
					if (align == TextFormatAlign.CENTER)
					{
						return ConstTextFormat.TEXT_FORMAT_QUALILTY_RED_CENTER;
					}
					else if(align == TextFormatAlign.LEFT)
					{
						return ConstTextFormat.TEXT_FORMAT_QUALILTY_RED_LEFT;
					}
			}
			return null;
		}
		
		/**
		 * 获取TextFormat
		 * @param quality	道具品质，参照ConstItem.SCONST_ITEM_QUALITY_TYPE_***
		 * @param size		字号，默认10
		 * @param font		字体，默认"Arial"
		 * @param align		对齐方式，默认左对齐
		 * @return 
		 * 
		 */		
		public static function getTextFormat(quality:int, 
											 size:int = 10, 
											 font:String = "Arial", 
											 align:String = TextFormatAlign.LEFT
											):TextFormat
		{
			var color:Object = _getTextColor(quality);
			return new TextFormat("Arial", size, color, null,null,null,null,null, align)
		}
		
		/**
		 * 根据道具品质，获取字体颜色
		 * @param quality	道具品质，参照ConstItem.SCONST_ITEM_QUALITY_TYPE_***
		 * @return 
		 * 
		 */		
		public static function _getTextColor(quality:int):Object
		{
			switch(quality)
			{
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_NORMAL:
					return ConstTextFormat.TEXT_COLOR_WIGHT;
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_GREEN:
					return ConstTextFormat.TEXT_COLOR_GREEN;
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_BLUE:
					return ConstTextFormat.TEXT_COLOR_BLUE;
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_PURPLE:
					return ConstTextFormat.TEXT_COLOR_PURPLE;
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_ORANGE:
					return ConstTextFormat.TEXT_COLOR_ORANGE;
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_RED:
					return ConstTextFormat.TEXT_COLOR_RED;
			}
			return null;
		}
		
		public static function getQualityColorString(quality:int):String
		{
			switch(quality)
			{
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_NORMAL:
					return ConstTextFormat.TEXT_COLOR_WIGHT_STR;
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_GREEN:
					return ConstTextFormat.TEXT_COLOR_GREEN_STR;
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_BLUE:
					return ConstTextFormat.TEXT_COLOR_BLUE_STR;
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_PURPLE:
					return ConstTextFormat.TEXT_COLOR_PURPLE_STR;
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_ORANGE:
					return ConstTextFormat.TEXT_COLOR_ORANGE_STR;
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_RED:
					return ConstTextFormat.TEXT_COLOR_RED_STR;
			}
			return "";
		}
		
	}
}