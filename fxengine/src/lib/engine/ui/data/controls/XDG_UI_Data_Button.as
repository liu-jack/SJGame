package lib.engine.ui.data.controls
{
	
	
	public dynamic class XDG_UI_Data_Button extends XDG_UI_Data
	{
		public static const TYPE:String = "TYPE_XDG_UI_Button_Data";
		public function XDG_UI_Data_Button()
		{
			super(TYPE);
		}
		
		protected var _normal:String;
		
		/**
		 * 普通状态 
		 */
		public function get normal():String
		{
			return _normal;
		}
		
		/**
		 * @private
		 */
		public function set normal(value:String):void
		{
			_normal = value;
		}
		
		protected var _disabled:String;
		
		/**
		 * 无效，失效状态 
		 */
		public function get disabled():String
		{
			return _disabled;
		}
		
		/**
		 * @private
		 */
		public function set disabled(value:String):void
		{
			_disabled = value;
		}
		
		protected var _select:String;
		
		/**
		 * 选中，状态 
		 */
		public function get select():String
		{
			return _select;
		}
		
		/**
		 * @private
		 */
		public function set select(value:String):void
		{
			_select = value;
		}
		
		protected var _down:String;
		
		/**
		 * 按下状态 
		 */
		public function get down():String
		{
			return _down;
		}
		
		/**
		 * @private
		 */
		public function set down(value:String):void
		{
			_down = value;
		}
		
		private var _over:String;
		
		/**
		 * 鼠标经过图片 
		 */
		public function get over():String
		{
			return _over;
		}
		
		/**
		 * @private
		 */
		public function set over(value:String):void
		{
			_over = value;
		}
		
		
		
//		override public function getnecessaryImageSets():Dictionary
//		{
//			var arr:Dictionary = new Dictionary();
//			if(_normal != null)
//			{
//				XDG_UI_DataUtils.GetImage_ImageSetName(_normal)
//				arr[XDG_UI_DataUtils.GetImage_ImageSetName(_normal)] = XDG_UI_DataUtils.GetImage_ImageSetName(_normal);
//			}
//			if(_disabled != null)
//			{
//				XDG_UI_DataUtils.GetImage_ImageSetName(_disabled)
//				arr[XDG_UI_DataUtils.GetImage_ImageSetName(_disabled)] = XDG_UI_DataUtils.GetImage_ImageSetName(_disabled);
//			}
//			if(_select != null)
//			{
//				XDG_UI_DataUtils.GetImage_ImageSetName(_select)
//				arr[XDG_UI_DataUtils.GetImage_ImageSetName(_select)] = XDG_UI_DataUtils.GetImage_ImageSetName(_select);
//			}
//			if(_down != null)
//			{
//				XDG_UI_DataUtils.GetImage_ImageSetName(_down)
//				arr[XDG_UI_DataUtils.GetImage_ImageSetName(_down)] = XDG_UI_DataUtils.GetImage_ImageSetName(_down);
//			}
//			if(_over != null)
//			{
//				XDG_UI_DataUtils.GetImage_ImageSetName(_over)
//				arr[XDG_UI_DataUtils.GetImage_ImageSetName(_over)] = XDG_UI_DataUtils.GetImage_ImageSetName(_over);
//			}
//			
//			return arr;
//			
//		}
		
//		override public function Pack():Object
//		{
//			// TODO Auto Generated method stub
//			var obj:Object = super.Pack();
//			if(_normal != null)
//			{
//				obj.normal = _normal;
//			}
//			if(_disabled != null)
//			{
//				obj.disabled = _disabled;
//			}
//			if(_select != null)
//			{
//				obj._select = _select;
//			}
//			if(_down != null)
//			{
//				obj.down = _down;
//			}
//			if(_over != null)
//			{
//				obj.over = _over;
//			}
//			
//			return obj;
//		}
		
		
		
		
	}
}