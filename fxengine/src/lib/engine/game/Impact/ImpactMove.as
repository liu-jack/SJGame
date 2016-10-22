package lib.engine.game.Impact
{
	import flash.geom.Rectangle;
	
	import lib.engine.math.Vector2D;

	public class ImpactMove extends GameObjectImpact
	{
		private var speeds:Vector2D = new Vector2D(0,0);
		private var speedsdegree:Number = 0;
		public function ImpactMove()
		{
			super();
//			speeds.x = Math.random();
//			speeds.y = Math.random();
			
			
			speeds.length = 1;
			speeds.angle = Math.PI * 2 * Math.random();
			
			speedsdegree = speeds.angle;
			//d = d * 180 / Math.PI;
			
		}
		
		override public function update(currenttime:Number, escapetime:Number):void
		{
			// TODO Auto Generated method stub
			super.update(currenttime, escapetime);
			_mGameObject.degree = speedsdegree + Math.PI;
			_mGameObject.x += speeds.x;
			_mGameObject.y += speeds.y;
			
			
			var _rect:Rectangle = new Rectangle(-50,-50,900,700);
			if(!_rect.contains(_mGameObject.x,_mGameObject.y))
			{
				if(_mGameObject.y > _rect.bottom || _mGameObject.y < _rect.top)
				{
					speeds.y = -1 * speeds.y;
				}
				if(_mGameObject.x > _rect.right || _mGameObject.x < _rect.left)
				{
					speeds.x = -1 * speeds.x;
				}
				speedsdegree = speeds.angle;
			}
		}
		
		
	}
}