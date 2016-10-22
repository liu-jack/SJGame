package lib.engine.game.Impact
{
	import lib.engine.math.Vector2D;

	/**
	 * 移动到指定点 
	 * @author caihua
	 * 
	 */
	public class GameImpactMoveDest extends GameObjectImpact
	{
		private var _destPos:Vector2D = new Vector2D(0,0);
		private var _duringTime:Number = 0;
		private var _speed:Vector2D = new Vector2D();
		public function GameImpactMoveDest()
		{
			this.autodelete = true;
			super();
		}

		public function get destPos():Vector2D
		{
			return _destPos;
		}

		public function set destPos(vec:Vector2D):void
		{
			_destPos.x = vec.x;
			_destPos.y = vec.y;
		}
		
		override protected function _onInit():void
		{
			super._onInit();
			
			_speed = _destPos.subtract(new Vector2D(_mGameObject.x,_mGameObject.y));
			_speed.length = _speed.length / _duringTime;
		}
		
		override public function update(currenttime:Number, escapetime:Number):void
		{
//			_mGameObject.degree = _speed.angle + Math.PI;
			_mGameObject.x += _speed.x * escapetime;
			_mGameObject.y += _speed.y * escapetime;
		}

		public function get duringTime():Number
		{
			return _duringTime;
		}

		public function set duringTime(value:Number):void
		{
			_duringTime = value;
			lefttime = value;
		}
		
		override protected function onDelete():void
		{
			_mGameObject.x = _destPos.x;
			_mGameObject.y = _destPos.y;
		}
		

	}
}