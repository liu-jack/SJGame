package uiEditor
{
	import engine_starling.display.SNode;
	import uiEditor.core.AUIECanvas;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.core.Starling;
	import starling.display.Stage;
	import starling.events.KeyboardEvent;
	
	/**
	 * UI编辑器应用 
	 * @author caihua
	 * 
	 */
	public final class AUIEApplication
	{
		private var _stage:Stage;
		private var _rootNode:SNode;
		private var _uicanvas:AUIECanvas;
		private var _isOpened:Boolean = false;
		public function AUIEApplication(rootNode:SNode)
		{
			_rootNode = rootNode;
			_stage = _rootNode.stage;
			
			_uicanvas = new AUIECanvas();
			
		}
		
		private static var _ins:AUIEApplication;
		
		/**
		 * 是否打开 
		 */
		public function get isOpened():Boolean
		{
			return _isOpened;
		}

		/**
		 * @private
		 */
		public function set isOpened(value:Boolean):void
		{
			_isOpened = value;
			Starling.current.showStats = !_isOpened;
			if(_isOpened)
			{
				
				_rootNode.addChild(_uicanvas);
				_uicanvas.bringMetofrount();
			}
			else
			{
				_uicanvas.removeFromParent();
			}
		}

		public static function get o():AUIEApplication
		{
			Assert(_ins != null,"请先运行registerUIEditer 注册UI编辑器");
			return _ins;
		}
		
		private function _onKeyDown(e:KeyboardEvent):void
		{
			if(e.altKey)
			{
				switch(e.keyCode)
				{
					
					//ALT+F1 启动/关闭
					case 112:
					{
						isOpened = !isOpened;
						break;
					}
					default:
					{
						
					}
				}
			}
		}
		private function _registerhotkey():void
		{
			_stage.addEventListener(KeyboardEvent.KEY_UP,_onKeyDown);
		}
		private function _unregisterhotkey():void
		{
			_stage.removeEventListener(KeyboardEvent.KEY_UP,_onKeyDown);
		}
		
		/**
		 * 注册UI编辑器 
		 * @param rootNode
		 * 
		 */
		public static function registerUIEditer(rootNode:SNode):void
		{
			if(AUIEApplication._ins == null)
				AUIEApplication._ins = new AUIEApplication(rootNode);
			AUIEApplication._ins._registerhotkey();
		}
		
		public static function unregisterUIEditer():void
		{
			if(AUIEApplication._ins == null)
				return;
			AUIEApplication._ins._unregisterhotkey();
		}
	}
}