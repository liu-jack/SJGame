package lib.engine.ui.data.controls
{
	

	/**
	 * Lable控件 
	 * @author caihua
	 * 
	 */
	public dynamic class  XDG_UI_Data_Label extends XDG_UI_Data
	{
		public static const TYPE:String = "XDG_UI_Data_Label";
		public function XDG_UI_Data_Label()
		{
			super(TYPE);
			
		}
		private var _text:String;

		/**
		 * Label 显示文字 
		 */
		public function get text():String
		{
			return _text;
		}

		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			_text = value;
		}

		
		private var _textStyle:String;

		/**
		 * 文字显示样式描述 
		 */
		public function get textStyle():String
		{
			return _textStyle;
		}

		/**
		 * @private
		 */
		public function set textStyle(value:String):void
		{
			_textStyle = value;
		}
		private var _image:String;

		/**
		 * 图片名称 
		 */
		public function get image():String
		{
			return _image;
		}

		/**
		 * @private
		 */
		public function set image(value:String):void
		{
			_image = value;
		}



		private var _autoSize:String = "left";
		
		
		/**
		 * 对其方式 
		 * left center right 
		 */
		public function get autoSize():String
		{
			return _autoSize;
		}
		
		/**
		 * @private
		 */
		public function set autoSize(value:String):void
		{
			_autoSize = value;
		}


	}
}