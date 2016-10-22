package SJ.Game.moneytree
{
	import SJ.Common.Constants.ConstTextFormat;
	
	import engine_starling.display.SLayer;
	
	import feathers.controls.Label;
	
	import flash.text.TextFormat;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;

	/**
	 * 摇钱树时间layer
	 * @author sangxu
	 * 
	 */	
	public class CJMoneyTreeTimeLayer extends SLayer implements IAnimatable
	{
		
		private var _passTime:Number = 0;
		/** 时间间隔：单位秒 */
		private var _gap:int = 1;
		/** 时间上限：单位秒 */
		private var _max:int = 180;
		
		private var _minute:int = 3;
		private var _second:int = 0;
		
		private var _label:Label;
		
		private var _run:Boolean;
		
		private var _completeCallBack:Function;
		
		private var _defaultTextFormat:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 7, 0x89C542);
		
		public function CJMoneyTreeTimeLayer()
		{
			super();
			this._initControls();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			this._label.width = this.width;
			this._label.height = this.height;
			
		}
		
		private function _initControls():void
		{
			this._label = new Label();
			this._label.x = 0;
			this._label.y = 0;
			this._label.textRendererProperties.textFormat = _defaultTextFormat;
			this.addChild(this._label);
			
			this.visible = false;
		}
		
		/**
		 * 字体
		 * @param textFormat
		 * @return 
		 * 
		 */		
		public function set textFormat(textFormat:TextFormat):void
		{
			this._label.textRendererProperties.textFormat = textFormat;
		}
		
		public function setTimeAndRun(second:int, callback:Function = null):void
		{
			if (second <= 0)
			{
				return;
			}
			this._completeCallBack = callback;
			this.visible = true;
			
			this._max = second;
			this._minute = second / 60;
			this._second = second % 60;
			this._run = true;
			Starling.juggler.add(this);
		}
		
		/**
		 * 每隔一段时间添加一次
		 * @param time
		 * 
		 */
		public function advanceTime(time:Number):void
		{
			if (!_run)
			{
				return;
			}
			_passTime += time;
			if (_passTime < _gap)
			{
				return;
			}
			else
			{
				_passTime = _passTime - _gap;
			}
			if (_second >= 0)
			{
				if (_second == 0)
				{
					if (_minute > 0)
					{
						_second = 59;
						_minute -= 1;
						this._redraw();
						return;
					}
					else
					{
						this._onComplete();
					}
				}
				else
				{
					_second -= 1;
					this._redraw();
					return;
				}
			}
		}
		
		/**
		 * 计时已到
		 * 
		 */		
		private function _onComplete():void
		{
			if (_completeCallBack != null)
			{
				this._run = false;
				this._completeCallBack();
			}
			this.visible = false;
			Starling.juggler.remove(this);
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
			return _getStringValue(_minute) + ":" + _getStringValue(_second);
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
			return "0" + value;
		}
	}
}