package SJ.Game.controls
{
	import engine_starling.display.SLayer;
	
	import feathers.controls.Label;
	
	import flash.text.TextFormat;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	
	public class CJTimerUtil extends SLayer implements IAnimatable
	{
		private var _label:Label;
		private var _defaultTextFormat:TextFormat = new TextFormat("Arial", 10, 0xffffff);
		private var _completeCallBack:Function;
		
		private var _second:int = 0;
		private var _passTime:Number = 0;
		/** 时间间隔：单位秒 */
		private var _gap:int = 1;
		
		public function CJTimerUtil()
		{
			super();
			this._initControls();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
//			this._label.width = this.width;
//			this._label.height = this.height;
			
		}
		
		private function _initControls():void
		{
			this._label = new Label();
			this._label.textRendererProperties.textFormat = _defaultTextFormat;
			this.addChild(this._label);
		}
		
		public function set labelTextForamt(tf:TextFormat):void
		{
			this._label.textRendererProperties.textFormat = tf;	
		}
		
		public function setTimeAndRun(second:int, callback:Function = null):void
		{
			if (second <= 0)
			{
				reset();
				return;
			}
			this._completeCallBack = callback;
			_second = second;
			Starling.juggler.add(this);
		}
		
		public function reset():void
		{
			_second = 0;
			_redraw();
		}
		
		public function start():void
		{
			Starling.juggler.add(this);	
		}
		
		public function stop():void
		{
			reset();
			Starling.juggler.remove(this);
		}
		/**
		 * 每隔一段时间添加一次
		 * @param time
		 * 
		 */
		public function advanceTime(time:Number):void
		{
			if(_second <=0)
			{
				this._complete();
			}
			_passTime += time;
			if (_passTime < _gap)
			{
				return;
			}
			else
			{
				_passTime = _passTime - _gap;
				_second -=_gap
				_redraw();
			}

		}
		
		private function _complete():void
		{
			if(this._completeCallBack!=null)
			{
				this._completeCallBack();
			}
			this.stop();
		}
		/**
		 * 重绘
		 * 
		 */		
		private function _redraw():void
		{
			this._label.text = this._getTimeString();
		}
		
		/**
		 * 获取事件字符串
		 * 
		 */		
		private function _getTimeString():String
		{
			var hour:int = Math.floor(_second/3600)
			
			var minute:int = (_second - (hour*3600))/60;
			var seconds:int = _second - (hour*3600) - (minute*60);
			return _getStringValue(hour)+":"+_getStringValue(minute) + ":" + _getStringValue(seconds);
		}
		/**
		 * 获取单个时间值字符串
		 * @param value
		 * @return 
		 * 
		 */		
		private function _getStringValue(value:int):String
		{
			if (value >= 10)
			{
				return String(value);
			}
			if(value <0) value=0;
			return "0" + value;
		}
		
		public function clear():void
		{
			this._completeCallBack = null;
		}
		
		public function getLeftTime():int
		{
			return _second
		}
		
		override public function dispose():void
		{
			this._label.textRendererProperties.textFormat = null;
			Starling.juggler.remove(this);
			super.dispose();
		}
		
		
		
	}
}