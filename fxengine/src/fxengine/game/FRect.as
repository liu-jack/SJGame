package fxengine.game
{
	import flash.geom.Rectangle;
	
	import fxengine.FPoint;

	public class FRect extends Rectangle 
	{
		public function FRect(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0) {
			super(x, y, width, height);
		}
		
		public function get origin() : FPoint {
			return new FPoint(x, y);
		}
		
		public function set origin(pt:FPoint) : void {
			x = pt.x;
			y = pt.y;
		}
		
		public function get originSize():FPoint
		{
			return new FPoint(width,height);
		}
	}
}