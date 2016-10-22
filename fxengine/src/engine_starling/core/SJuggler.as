package engine_starling.core
{
	import starling.animation.Juggler;
	
	public class SJuggler extends Juggler
	{
		public function SJuggler()
		{
			super();
		}
		private var _speedup:Number = 1.0;

		/**
		 * 加速的倍数 
		 */
		public function get speedup():Number
		{
			return _speedup;
		}

		/**
		 * @private
		 */
		public function set speedup(value:Number):void
		{
			_speedup = value;
		}

		override public function advanceTime(time:Number):void
		{
			// TODO Auto Generated method stub
			time = time * _speedup;
			super.advanceTime(time);
		}
		
		
	}
}