package fxengine.game.action
{
	public class FFiniteTimeAction extends FAction
	{
		protected var _duration:Number = 0;

		/**
		 * during second！ 
		 */
		public function get duration():Number
		{
			return _duration;
		}

		/**
		 * @private
		 */
		public function set duration(value:Number):void
		{
			_duration = value;
		}

		public function FFiniteTimeAction()
		{
			super();
		}
		
		/**
		 * 反转动画 
		 * @return 
		 * 
		 */		
		public function reverse():FFiniteTimeAction
		{
			return this;
		}
	}
}