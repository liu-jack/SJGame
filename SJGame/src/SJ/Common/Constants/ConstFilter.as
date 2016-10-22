package SJ.Common.Constants
{
	import starling.filters.ColorMatrixFilter;
	
	public class ConstFilter
	{
		public function ConstFilter()
		{
		}
		/**
		 * 黑白滤镜 
		 * @return 
		 * 
		 */		
		public static function genBlackFilter():ColorMatrixFilter
		{
			var filter:ColorMatrixFilter = new ColorMatrixFilter();
			filter.adjustSaturation(-1);
			return filter;
		}
		/**
		 *改变亮度 
		 * @return 
		 * 
		 */		
		public static function brighnessFilter():ColorMatrixFilter
		{
			var filter:ColorMatrixFilter = new ColorMatrixFilter();
			filter.adjustBrightness(-0.8);
			return filter;
		}
	}
}