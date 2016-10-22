package lib.engine.ui.data.controls
{
	/**
	 * 进度条数据 
	 * @author caihua
	 * 
	 */
	public dynamic class XDG_UI_Data_ProgressBar extends XDG_UI_Data
	{
		public static const TYPE:String = "XDG_UI_Data_ProgressBar";
		public function XDG_UI_Data_ProgressBar()
		{
			super(TYPE);
		}
		
		private var _minvalue:Number = 0;
		private var _maxvalue:Number = 100;
		private var _value:Number = 0;
		private var _bgImageScale:Boolean = true;
		private var _bgImageMid:String = "";
		private var _bgImageleft:String = "";	
		private var _bgImageright:String = "";	
		private var _valueImage:String = "";
		
		private var _valueImageScale:Boolean = false;
		private var _horizontal:Boolean = false;
		
		private var _reverseValue:Boolean = false;
		
		
		
		/**
		 * 最小值 ,默认为0
		 */
		public function get minvalue():Number
		{
			return _minvalue;
		}
		
		/**
		 * @private
		 */
		public function set minvalue(value:Number):void
		{
			_minvalue = value;
		}
		
		/**
		 * 最大值,默认为100 
		 */
		public function get maxvalue():Number
		{
			return _maxvalue;
		}
		
		/**
		 * @private
		 */
		public function set maxvalue(value:Number):void
		{
			_maxvalue = value;
		}
		
		/**
		 * 当前值,默认为0 
		 */
		public function get value():Number
		{
			return _value;
		}
		
		/**
		 * @private
		 */
		public function set value(value:Number):void
		{
			_value = value;
		}
		
		/**
		 * 背景图片拉伸方式
		 */
		public function get bgImageScale():Boolean
		{
			return _bgImageScale;
		}
		
		/**
		 * @private
		 */
		public function set bgImageScale(value:Boolean):void
		{
			_bgImageScale = value;
		}
		
		/**
		 * 背景中间图片 
		 */
		public function get bgImageMid():String
		{
			return _bgImageMid;
		}
		
		/**
		 * @private
		 */
		public function set bgImageMid(value:String):void
		{
			_bgImageMid = value;
		}
		
		/**
		 * 背景左面图片 
		 */
		public function get bgImageleft():String
		{
			return _bgImageleft;
		}
		
		/**
		 * @private
		 */
		public function set bgImageleft(value:String):void
		{
			_bgImageleft = value;
		}
		
		/**
		 * 背景右面图片 
		 */
		public function get bgImageright():String
		{
			return _bgImageright;
		}
		
		/**
		 * @private
		 */
		public function set bgImageright(value:String):void
		{
			_bgImageright = value;
		}
		
		/**
		 * 进度条图片拉伸方式 
		 */
		public function get valueImageScale():Boolean
		{
			return _valueImageScale;
		}
		
		/**
		 * @private
		 */
		public function set valueImageScale(value:Boolean):void
		{
			_valueImageScale = value;
		}
		
		/**
		 * 进度条图片 
		 */
		public function get valueImage():String
		{
			return _valueImage ;
		}
		
		/**
		 * @private
		 */
		public function set valueImage(value:String):void
		{
			_valueImage = value;
		}
		
		/**
		 * 横向 
		 */
		public function get horizontal():Boolean
		{
			return _horizontal;
		}
		
		/**
		 * @private
		 */
		public function set horizontal(value:Boolean):void
		{
			_horizontal = value;
		}
		
		/**
		 * 是否反转进度条显示,
		 * 如果false 横向 进度条为从左向右 纵向 进度条从下向上
		 * 如果 true 横向 进度条从右向左 纵向 进度条从上向下
		 * 默认为false
		 *  
		 */
		public function get reverseValue():Boolean
		{
			return _reverseValue;
		}
		
		/**
		 * @private
		 */
		public function set reverseValue(value:Boolean):void
		{
			_reverseValue = value;
		}
		
		
	}
}