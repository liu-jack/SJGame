package GameConsole.core
{
	import engine_starling.SApplicationConfig;
	import engine_starling.data.SDataBase;
	import engine_starling.utils.Logger;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.core.Starling;
	
	
	
	public class ConsoleLog extends Sprite implements IConsole
	{
		private var _isOpened:Boolean;
		private var _logTextfield:TextField = new TextField();
		private var _logbackBuffer:TextField = new TextField();
		private var _filtertextinput:TextField = new TextField();
		private var _config:SDataBase = new SDataBase("ConsoleLog");
		public function ConsoleLog()
		{
			super();
			initialize();
			
		
			_config.loadFromCache();
			_filtertextinput.text = _config.getData("filter","");
			
		}
		
		public function hotkeyId():uint
		{
			// TODO Auto Generated method stub
			return 113;
		}
		
		public function get isOpened():Boolean
		{
			// TODO Auto Generated method stub
			return _isOpened;
		}
		
		public function set isOpened(value:Boolean):void
		{
			_isOpened = value;
			
			visible = _isOpened;
			
			
			_logbackBuffer.text = Logger.logRecords;
//			_logTextfield.scrollV = _logTextfield.numLines;
			_highlightLog();
		}
		
		protected function initialize():void
		{
			// TODO Auto Generated method stub
		
			scaleX = Starling.current.viewPort.width / Starling.current.stage.stageWidth;
			scaleY = Starling.current.viewPort.height / Starling.current.stage.stageHeight;
			
			
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xFFFFFF,0.5);
			shape.graphics.drawRect(0,0,SApplicationConfig.o.stageWidth,SApplicationConfig.o.stageHeight);
			shape.graphics.endFill();
			addChild(shape);
			
			
			
			var textFormat:TextFormat = new TextFormat("Verdana",12 / scaleX, 0x000000);
			textFormat.align = TextFormatAlign.LEFT;
			_logTextfield.defaultTextFormat = textFormat;
			
			
			_logTextfield.width = Starling.current.stage.stageWidth;
			_logTextfield.height = Starling.current.stage.stageHeight - 40;
			_logTextfield.x = (Starling.current.stage.stageWidth - _logTextfield.width) / 2;
			_logTextfield.y = 20;
			_logTextfield.background = true;
			_logTextfield.backgroundColor = 0xffffff;
			_logTextfield.border = true;
			_logTextfield.type =TextFieldType.DYNAMIC;
			_logTextfield.multiline = true;
			addChild(_logTextfield);
			
			
			_logbackBuffer.width = Starling.current.stage.stageWidth;
			_logbackBuffer.height = Starling.current.stage.height;
			_logbackBuffer.type =TextFieldType.DYNAMIC;
			_logbackBuffer.multiline = true;

			
			
			
			_filtertextinput.type = TextFieldType.INPUT;
			_filtertextinput.defaultTextFormat = textFormat;
			_filtertextinput.x = 0;
			_filtertextinput.y = 0;
			_filtertextinput.height = 20;
			_filtertextinput.width = Starling.current.stage.stageWidth - 20;
			_filtertextinput.border = true;
			_filtertextinput.borderColor = 0xFF0000;
			_filtertextinput.background = true;
			_filtertextinput.backgroundColor = 0xffffff;
			addChild(_filtertextinput);
			
			_filtertextinput.addEventListener(Event.CHANGE,function _e(e:Event):void
			{
				
				_config.setData("filter",_filtertextinput.text);
				_config.saveToCache();
				
				_highlightLog();
			});
			
			var closeButton:Sprite = new Sprite();
			closeButton.graphics.lineStyle(1);
			closeButton.graphics.beginFill(0xFF0000);
			closeButton.graphics.drawRect(0,0,20,20);
			closeButton.graphics.lineTo(20,20);
			closeButton.graphics.moveTo(20,0);
			closeButton.graphics.lineTo(0,20);
			closeButton.graphics.endFill();
			
			
//			closeButton.label = "×";
//			closeButton.width = 40;
//			closeButton.height = 40;
			
			closeButton.x = Starling.current.stage.stageWidth - closeButton.width;
			closeButton.y = 0;
			
			closeButton.addEventListener(MouseEvent.CLICK,function _e(e:MouseEvent):void{
				isOpened = false;
			});
			addChild(closeButton);
			visible = _isOpened;
		}
		
		
		private function _highlightLog():void
		{
			
			
			_logTextfield.text = "";
			
			if(_filtertextinput.length == 0)
			{
				_logTextfield.text = _logbackBuffer.text
				_logTextfield.scrollV = _logTextfield.numLines;
				return;
			}
			
			var appendString:String = "";
			var i:int = 0;
			for(i=0;i<_logbackBuffer.numLines;i++)
			{
				if(_logbackBuffer.getLineText(i).indexOf(_filtertextinput.text)!= -1)
				{
//					var start:int = _logTextfield.getLineOffset(i);
//					var end:int = start + _logTextfield.getLineLength(i);
//					var highligthtextFormat:TextFormat = new TextFormat("Verdana",12 / scaleX, 0xff0000);
//					_logTextfield.setTextFormat(highligthtextFormat,start,end);
					appendString += (_logbackBuffer.getLineText(i));
					
					
				}
			}
			_logTextfield.setTextFormat(_logTextfield.defaultTextFormat);
			_logTextfield.text = appendString;
//			_logTextfield.scrollV = 0;
			_logTextfield.scrollV = _logTextfield.numLines;
		}
	
		

		
		
	}
}