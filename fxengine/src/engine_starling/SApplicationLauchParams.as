package engine_starling
{
	import flash.display.Bitmap;

	public class SApplicationLauchParams
	{
		public function SApplicationLauchParams()
		{
		}
		
		private var _startupLogo:Bitmap = null;
		private var _startupLogoHD:Bitmap = null;
		private var _startupBitmap:Bitmap = null;
		private var _startupHDBitmap:Bitmap = null;
		
		private var _backgroundfillBitmap:Bitmap = null;
		private var _backgroundfillBitmapHD:Bitmap = null

		/**
		 * logo 闪屏 
		 */
		public function get startupLogo():Bitmap
		{
			return _startupLogo;
		}

		/**
		 * @private
		 */
		public function set startupLogo(value:Bitmap):void
		{
			_startupLogo = value;
		}

		/**
		 * logo 闪屏 HD 
		 */
		public function get startupLogoHD():Bitmap
		{
			return _startupLogoHD;
		}

		/**
		 * @private
		 */
		public function set startupLogoHD(value:Bitmap):void
		{
			_startupLogoHD = value;
		}

		/**
		 * 启动界面闪屏 
		 */
		public function get startupBitmap():Bitmap
		{
			return _startupBitmap;
		}

		/**
		 * @private
		 */
		public function set startupBitmap(value:Bitmap):void
		{
			_startupBitmap = value;
		}

		/**
		 * 启动界面闪屏HD 
		 */
		public function get startupHDBitmap():Bitmap
		{
			return _startupHDBitmap;
		}

		/**
		 * @private
		 */
		public function set startupHDBitmap(value:Bitmap):void
		{
			_startupHDBitmap = value;
		}

		/**
		 * 背景填充图片 
		 */
		public function get backgroundfillBitmap():Bitmap
		{
			return _backgroundfillBitmap;
		}

		/**
		 * @private
		 */
		public function set backgroundfillBitmap(value:Bitmap):void
		{
			_backgroundfillBitmap = value;
		}

		/**
		 * 背景填充图片HD 
		 */
		public function get backgroundfillBitmapHD():Bitmap
		{
			return _backgroundfillBitmapHD;
		}

		/**
		 * @private
		 */
		public function set backgroundfillBitmapHD(value:Bitmap):void
		{
			_backgroundfillBitmapHD = value;
		}


	}
}