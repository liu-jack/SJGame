package lib.engine.ui.data.controls
{
	

	/**
	 * MC控件 
	 * @author caihua
	 * 
	 */
	public dynamic class XDG_UI_Data_MC extends XDG_UI_Data
	{
		public static const TYPE:String = "TYPE_XDG_UI_MC_Data";
		public function XDG_UI_Data_MC()
		{
			super(TYPE);
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
		
		
//		override public function getnecessaryImageSets():Dictionary
//		{
//			var arr:Dictionary = new Dictionary();
//			if(_image != null)
//			{
//				XDG_UI_DataUtils.GetImage_ImageSetName(_image)
//				arr[XDG_UI_DataUtils.GetImage_ImageSetName(_image)] = XDG_UI_DataUtils.GetImage_ImageSetName(_image);
//			}
//			return arr;
//		}
//		
		
		
		
	}
}