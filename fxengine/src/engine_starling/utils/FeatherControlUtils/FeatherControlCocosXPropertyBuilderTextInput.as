package engine_starling.utils.FeatherControlUtils
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import feathers.controls.Label;
	import feathers.controls.TextInput;

	public class FeatherControlCocosXPropertyBuilderTextInput extends FeatherControlCocosXPropertyBuilderDefault
	{
		public function FeatherControlCocosXPropertyBuilderTextInput()
		{
			super();
		}
		private var _textformat:TextFormat;
		override public function get fullClassName():String
		{
			return "feathers.controls.TextInput";
		}
		
		override protected function _onEndEdit():void
		{
			// TODO Auto Generated method stub
			super._onEndEdit();
			(_editControl as TextInput).textEditorProperties.color = _color;
			if(_maxLengthEnable == false)
			{
				(_editControl as TextInput).maxChars = 0;
			}
		}
		
		override protected function _onbeginEdit():void
		{
			// TODO Auto Generated method stub
			super._onbeginEdit();
			_maxLengthEnable = true;
//			_textformat = new TextFormat();
		}
//		"maxLength": 6,
//		"maxLengthEnable": false,
//		"passwordEnable": false,
//		"passwordStyleText": "*",
//		"placeHolder": "input words here",
//		"text": "Text Field"
		private var _maxLengthEnable:Boolean = true;
		public function set maxLength(value:int):void
		{
			(_editControl as TextInput).maxChars = value;
		}
		public function set maxLengthEnable(value:Boolean):void
		{
			_maxLengthEnable = value;
		}
		public function set passwordEnable(value:Boolean):void
		{
			(_editControl as TextInput).displayAsPassword = value;
		}
		public function set passwordStyleText(value:String):void
		{
//			(_editControl as TextInput).
		}
		public function set placeHolder(value:String):void
		{
			(_editControl as TextInput).prompt = value;
		}
		public function set text(value:String):void
		{
			(_editControl as TextInput).text = value;
		}
		public function set fontName(value:String):void
		{
			(_editControl as TextInput).textEditorProperties.fontFamily = value;
		}
		public function set fontSize(value:int):void
		{
			(_editControl as TextInput).textEditorProperties.fontSize = value/2;
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
			(_editControl as TextInput).textEditorProperties.textAlign = alignString;
		}
		
	}
}