package lib.engine.ui.Manager.Mouse
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	import lib.engine.ui.data.controls.XDG_UI_Data_MC;
	import lib.engine.ui.uicontrols.XDG_UI_MC;
	
	public class MouseManager
	{
		public function MouseManager()
		{
		}
		
		private static var _ins:MouseManager;
		private var _cursor:XDG_UI_MC;
		private var _useSystemcursor:Boolean = true;
		public static function get o():MouseManager
		{
			if(_ins == null)
				_ins = new MouseManager();
			return _ins;
		}
		/**
		 * 设置鼠标动画 
		 * MouseManager.o.setCursor("common_button_common2::close_3"); 
		 * @param resPath
		 * 
		 */
		public function setCursor(resPath:String):void
		{
			useSystemcursor = false;	
			_cursor.SetProperty("image",resPath);
					
		}
		
		public function get useSystemcursor():Boolean
		{
			return _useSystemcursor;
		}
		
		public function set useSystemcursor(value:Boolean):void
		{
			_useSystemcursor = value;
			if(_cursor != null)
				_cursor.visible = !value;
			
			if(value)
			{
				Mouse.show();
			}
			else
			{
				Mouse.hide();
			}
		}
		
		private function _onMouseMove(e:MouseEvent):void
		{
//			if(!useSystemcursor)
			{
				var pos:Point = e.target.localToGlobal(new Point(e.localX,e.localY));
				_cursor.x = pos.x;
				_cursor.y = pos.y;
			}
		}
		
		public function Register(sp:Sprite):void
		{
			_cursor = new XDG_UI_MC();
			_cursor.mouseEnabled = false;
			_cursor.LoadProperty(new XDG_UI_Data_MC());
			sp.addChild(_cursor);
			sp.stage.addEventListener(MouseEvent.MOUSE_MOVE,_onMouseMove);
		}

//		public function get cursor():XDG_UI_MC
//		{
//			return _cursor;
//		}

		
	}
}