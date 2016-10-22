package lib.engine.ui.uicontrols
{
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	/**
	 * 文本输入框控件 
	 * @author caihua
	 * 
	 */
	public class XDG_UI_TextInput extends XDG_UI_Label
	{
		public function XDG_UI_TextInput()
		{
			super();
			
		}
		
		override protected function _onInit_ui():void
		{
			super._onInit_ui();
			_textfield.type = TextFieldType.INPUT;
			_textfield.selectable = true;
			_textfield.multiline = false;
			_textfield.autoSize = TextFieldAutoSize.NONE;
			_textfield.mouseEnabled = true;
			_textfield.addEventListener(Event.CHANGE,_onTextChange);
		}
		
		protected function _onTextChange(e:Event):void
		{			
			this._property.text = _textfield.text;
		}
		
		
		
		
		
		

		
		
	}
}