package engine_starling.feathersextends
{
	import feathers.controls.text.TextFieldTextRenderer;
	
	/**
	 * 扩展字体渲染器 
	 * @author caihua
	 * 
	 */
	public class TextFieldTextRendererEx extends TextFieldTextRenderer
	{
		public function TextFieldTextRendererEx()
		{
			super();
		}
		
		private var mNativeFilters:Array;
		
		override protected function initialize():void
		{
			super.initialize();
			textField.filters =  mNativeFilters;
		}
		/** The native Flash BitmapFilters to apply to this TextField. 
		 *  Only available when using standard (TrueType) fonts! */
		override public function get nativeFilters():Array { return mNativeFilters; }
		override public function set nativeFilters(value:Array) : void
		{			
			mNativeFilters = value.concat();
			
			if (textField != null)
				textField.filters =  mNativeFilters;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
	}
}