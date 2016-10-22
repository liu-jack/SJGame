package lib.engine.ui.impact
{
	import lib.engine.utils.functions.Assert;

	public class UI_Impact_fade_In extends UI_Impact
	{
		/**
		 * 淡出或者淡入的变化值 
		 */
		private var _step:Number = 0.1;
		
		
		private var _fadetime:Number = 1000;

		/**
		 * 淡出淡入的时间,毫秒值 
		 */
		public function get fadetime():Number
		{
			return _fadetime;
		}

		/**
		 * @private
		 */
		public function set fadetime(value:Number):void
		{
			Assert(value > 0,"value > 0");
			_fadetime = value;
		}

		/**
		 * 流逝时间 
		 */
		private var _escapetime:Number = 0;
		
		
		private var _fromAlpha:Number = 0;

		public function set fromAlpha(value:Number):void
		{
			Assert(value>= 0 && value <= 1,"value>= 0 && value <= 1");
			_fromAlpha = value;
		}


		public function get fromAlpha():Number
		{
			return _fromAlpha;
		}

		
		private var _toAlpha:Number = 1;

		/**
		 * 目标Alpha值 
		 */
		public function get toAlpha():Number
		{
			return _toAlpha;
		}

		/**
		 * @private
		 */
		public function set toAlpha(value:Number):void
		{
			Assert(value>= 0 && value <= 1,"value>= 0 && value <= 1");
			_toAlpha = value;
		}

		
		/**
		 * 淡入淡出修改器 
		 * @param fadetime 淡入淡出时间
		 * @param fromAlpha 原始Aplha值
		 * @param toAlpha 目的Alpha值
		 * 
		 */
		public function UI_Impact_fade_In(fadetime:Number,fromAlpha:Number = 0,toAlpha:Number = 1)
		{
			this.fadetime = fadetime;
			this.fromAlpha = fromAlpha;
			this.toAlpha = toAlpha;
			
			this.autodelete = true;
			this.lefttime = fadetime;
		}
		
		override public function update(currenttime:Number, escapetime:Number):void
		{
			_escapetime += escapetime;
			if(_escapetime < _fadetime)
			{
				_mainControl.alpha = _fromAlpha + (_escapetime / _fadetime) * (_toAlpha - _fromAlpha);
			}

		}
		
		override protected function onDelete():void
		{
			_mainControl.alpha = _toAlpha;
		}
		
		
		override protected function _onInit():void
		{
			_escapetime = 0;
			_mainControl.alpha = _fromAlpha;
		}
		
		
	}
}