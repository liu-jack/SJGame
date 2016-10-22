package GameConsole
{
	import GameConsole.core.ConsoleLog;
	import GameConsole.core.IConsole;
	
	import engine_starling.display.SNode;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.KeyboardEvent;

	/**
	 * 控制台程序 
	 * @author caihua
	 * 
	 */
	public class ConsoleApplication
	{
		private var _rootNode:SNode;
		private var _stage:Stage;
		private static var _ins:ConsoleApplication;
		private var _consoledict:Dictionary = new Dictionary();
		
		
		
		public function ConsoleApplication(rootNode:SNode)
		{
			_rootNode = rootNode;
			_stage = _rootNode.stage;
			var iconsole:ConsoleLog = new ConsoleLog();
//			_rootNode.addChild(iconsole);

			var activeButton:Sprite = new Sprite();
			activeButton.graphics.lineStyle(1);
			activeButton.graphics.beginFill(0xFF0000);
			activeButton.graphics.drawRect(0,0,40,40);
			activeButton.graphics.lineTo(40,40);
			activeButton.graphics.moveTo(40,0);
			activeButton.graphics.lineTo(0,40);
			activeButton.graphics.endFill();
			activeButton.x = 0;
			activeButton.y = 240;
			activeButton.addEventListener(MouseEvent.CLICK,function _e(e:MouseEvent):void{
		
				var ne:Event = new KeyboardEvent(KeyboardEvent.KEY_UP,0,113,0,false,true);
				Starling.current.stage.dispatchEvent(ne);
			});
			
			
			
			Starling.current.nativeStage.addChild(activeButton);
			
			Starling.current.nativeStage.addChild(iconsole);
		
			_registerConsole(iconsole);
		}

		private function _registerhotkey():void
		{
			_stage.addEventListener(KeyboardEvent.KEY_UP,_onKeyDown);
		}
		private function _unregisterhotkey():void
		{
			_stage.removeEventListener(KeyboardEvent.KEY_UP,_onKeyDown);
		}
		
		private function _onKeyDown(e:KeyboardEvent):void
		{
			if(e.altKey)
			{
				if(_consoledict.hasOwnProperty(e.keyCode))
				{
					var iconsole:IConsole = _consoledict[e.keyCode];
					iconsole.isOpened = !iconsole.isOpened;
				}
			}
		}

		
		private function _registerConsole(console:IConsole):void
		{
			_consoledict[console.hotkeyId()] = console;
			
		}
		/**
		 * 注册控制台
		 * @param rootNode
		 * 
		 */
		public static function registerConsole(rootNode:SNode):void
		{
			if(ConsoleApplication._ins == null)
				ConsoleApplication._ins = new ConsoleApplication(rootNode);
			ConsoleApplication._ins._registerhotkey();
		}
		
		public static function unregisterConsole():void
		{
			if(ConsoleApplication._ins == null)
				return;
			ConsoleApplication._ins._unregisterhotkey();
		}
	}
}