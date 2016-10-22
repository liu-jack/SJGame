package lib.engine.game.object
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import lib.engine.game.bitmap.GBitmap;
	import lib.engine.verbose.Verbose;
	
	/**
	 * FPS控件 
	 * @author caihua
	 * 
	 */
	public class GameObjectFPS extends GameObject
	{
		private var _txt:TextField = new TextField();
		
		private var _fps:int = 0;
		private var _lasttime:int = 0;
		private var _gCache:BitmapData;
		public function GameObjectFPS()
		{
			super();
			
			this.gameojectType = GameObjectType.Type_SceneObject;
			this.depth = 0;
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_gCache = new BitmapData(120,40);
		
		}
		
		override public function render(g:GBitmap,offset:Rectangle):void
		{
			g.copyPixels(_gCache,_gCache.rect,new Point(0,0));
		}
		
		override public function update(currenttime:Number, escapetime:Number):void
		{
			_lasttime += escapetime;
			_fps++;
			if(_lasttime > 1000)
			{
				_txt.htmlText = "Objects:" + _canvas.ObjectCount + "FPS:" + _fps + "\nEngineVer:" + Verbose.VER;
				_lasttime = 0;
				_fps = 0;
				
				_gCache.fillRect(_gCache.rect,0xFFFFFFFF);
				_gCache.draw(_txt);
			}
			

		}
		
	}
}