package fxengine.game.node
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;


	public class FLayer extends FNode
	{
		
		private var _bgcolor:int = 0xFFFFFFFF;

		public function get bgcolor():int
		{
			return _bgcolor;
		}

		public function set bgcolor(value:int):void
		{
			_bgcolor = value;
			
			_bgshape.graphics.beginFill(value);
			_bgshape.graphics.drawRect(0,0,FCanvas.o.winSize.x,FCanvas.o.winSize.y);
			_bgshape.graphics.endFill();
		}

		private var _bgshape:Shape = new Shape();
		public function FLayer()
		{
			this.addChild(_bgshape);
		}
		
		

	}
}