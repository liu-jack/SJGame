package lib.engine.game.Impact
{
	import lib.engine.math.Vector2D;

	public class GameImpactMove extends GameObjectImpact
	{
		private var speeds:Vector2D = new Vector2D(0,0);
		private var speedsdegree:Number = 0;
		/**
		 *  
		 * @param speed 速度
		 * @param direct 方向
		 * 
		 */
		public function GameImpactMove(speed:Number = 1.0,direct:Number = Math.PI)
		{
			super();
			speeds.length = speed;
			speeds.angle = direct;
		}
		
		override protected function _onInit():void
		{
			super._onInit();
			
		}
		
		override public function update(currenttime:Number, escapetime:Number):void
		{
			// TODO Auto Generated method stub
			super.update(currenttime, escapetime);
			_mGameObject.degree = speeds.angle + Math.PI;
			_mGameObject.x += speeds.x;
			_mGameObject.y += speeds.y;
			
			
			if(!_mGameObject.canvas.viewport.contains(_mGameObject.x,_mGameObject.y))//_mGameObject.width,_mGameObject.height)))
			{
				_mGameObject.unregister();	
			}
		}
		
		
	}
}