package engine_starling.utils.FeatherControlUtils
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import feathers.controls.Label;

	public class FeatherControlCocosXPropertyBuilderLabel extends FeatherControlCocosXPropertyBuilderDefault
	{
		public function FeatherControlCocosXPropertyBuilderLabel()
		{
			super();
		}
		private var _textformat:TextFormat;
		override public function get fullClassName():String
		{
			
			return "feathers.controls.Label";
		}
		
		override protected function _onEndEdit():void
		{
			// TODO Auto Generated method stub
			super._onEndEdit();
			_textformat.color = _color;
			(_editControl as Label).textRendererProperties.textFormat = _textformat;
		}
		
		override protected function _onbeginEdit():void
		{
			// TODO Auto Generated method stub
			super._onbeginEdit();
			_textformat = new TextFormat();
			
		}
		
//		"areaHeight": 100,
//		"areaWidth": 200,
//		"fontName": "宋体",
//		"fontSize": 20,
//		"fontType": 0,
//		"hAlignment": 0,
//		"text": "Text Area",
//		"vAlignment": 1
		
		public function set text(value:String):void
		{
			(_editControl as Label).text = value;
		}
//		public function set textColorR(value:int):void
//		{
//			_textformat.color = ((int(_textformat.color) & 0xFFFF)|(value & 0xFF) <<16);
//		}
//		public function set textColorG(value:int):void
//		{
//			_textformat.color = ((int(_textformat.color) & 0xFF00FF)|(value & 0xFF) <<8);
//		}
//		public function set textColorB(value:int):void
//		{
//			_textformat.color = ((int(_textformat.color) & 0xFFFF00)|(value & 0xFF));
//		}
		public function set fontName(value:String):void
		{
			_textformat.font = value;
		}
		public function set fontSize(value:int):void
		{
			_textformat.size = value/2;
		}
		
		public function set hAlignment(value:int):void
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
			_textformat.align = alignString;
		}
	}
}