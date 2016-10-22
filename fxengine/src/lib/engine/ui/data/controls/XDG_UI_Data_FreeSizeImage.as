package lib.engine.ui.data.controls
{
	public dynamic class XDG_UI_Data_FreeSizeImage extends XDG_UI_Data
	{
		public static const TYPE:String = "TYPE_XDG_UI_FreeSizeImage_Data";
		public function XDG_UI_Data_FreeSizeImage()
		{
			super(TYPE);
		}
		
		private var _ImageCorner_left_top:String;

		/**
		 * 左上角图片 
		 */
		public function get ImageCorner_left_top():String
		{
			return _ImageCorner_left_top;
		}

		/**
		 * @private
		 */
		public function set ImageCorner_left_top(value:String):void
		{
			_ImageCorner_left_top = value;
		}

		private var _ImageCorner_left_down:String;

		/**
		 * 左下角图片 
		 */
		public function get ImageCorner_left_down():String
		{
			return _ImageCorner_left_down;
		}

		/**
		 * @private
		 */
		public function set ImageCorner_left_down(value:String):void
		{
			_ImageCorner_left_down = value;
		}

		
		private var _ImageCorner_right_top:String;

		/**
		 * 右上角图片 
		 */
		public function get ImageCorner_right_top():String
		{
			return _ImageCorner_right_top;
		}

		/**
		 * @private
		 */
		public function set ImageCorner_right_top(value:String):void
		{
			_ImageCorner_right_top = value;
		}

		
		private var _ImageCorner_right_down:String;

		/**
		 * 右下角图片 
		 */
		public function get ImageCorner_right_down():String
		{
			return _ImageCorner_right_down;
		}

		/**
		 * @private
		 */
		public function set ImageCorner_right_down(value:String):void
		{
			_ImageCorner_right_down = value;
		}

		
		private var _ImageBorder_top:String;

		/**
		 * 上边框图片
		 */
		public function get ImageBorder_top():String
		{
			return _ImageBorder_top;
		}

		/**
		 * @private
		 */
		public function set ImageBorder_top(value:String):void
		{
			_ImageBorder_top = value;
		}

		private var _ImageBorder_down:String;

		/**
		 * 下边框图片
		 */
		public function get ImageBorder_down():String
		{
			return _ImageBorder_down;
		}

		/**
		 * @private
		 */
		public function set ImageBorder_down(value:String):void
		{
			_ImageBorder_down = value;
		}

		
		private var _ImageBorder_left:String;

		/**
		 * 左边框图片
		 */
		public function get ImageBorder_left():String
		{
			return _ImageBorder_left;
		}

		/**
		 * @private
		 */
		public function set ImageBorder_left(value:String):void
		{
			_ImageBorder_left = value;
		}

		private var _ImageBorder_right:String;

		/**
		 * 右边框图片
		 */
		public function get ImageBorder_right():String
		{
			return _ImageBorder_right;
		}

		/**
		 * @private
		 */
		public function set ImageBorder_right(value:String):void
		{
			_ImageBorder_right = value;
		}

		private var _ImageBg:String;

		/**
		 * 背景图片 
		 */
		public function get ImageBg():String
		{
			return _ImageBg;
		}

		/**
		 * @private
		 */
		public function set ImageBg(value:String):void
		{
			_ImageBg = value;
		}

		
		private var _ImageBgScale:Boolean = true;

		/**
		 * 背景图片是否拉伸 
		 */
		public function get ImageBgScale():Boolean
		{
			return _ImageBgScale;
		}

		/**
		 * @private
		 */
		public function set ImageBgScale(value:Boolean):void
		{
			_ImageBgScale = value;
		}
		
		
		
		private var _ImageBorderScale:Boolean = true;

		/**
		 * 邊框图片是否拉伸 
		 */
		public function get ImageBorderScale():Boolean
		{
			return _ImageBorderScale;
		}

		/**
		 * @private
		 */
		public function set ImageBorderScale(value:Boolean):void
		{
			_ImageBorderScale = value;
		}

	}
}