package fxengine.utils
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * 图形助手函数 
	 * @author caihua
	 * 
	 */
	public class TextureUtils
	{
		public function TextureUtils()
		{
		}
		
		/**
		 * MC to BitmapData 
		 * @param mc
		 * @param xscale
		 * @param yscale
		 * @return 
		 * 
		 */
		public static function MovieClipToBitmapData(mc:MovieClip, xscale:Number = 1,
													 yscale:Number = 1):Vector.<BitmapData>
		{
			var bitmapDataVector:Vector.<BitmapData> = new Vector.<BitmapData>();
//			var spriteContainer:Sprite = new Sprite();
//			spriteContainer.addChild(mc);
			for (var i:uint = 1; i <= mc.totalFrames; i++)
			{
				
				mc.gotoAndStop(i);
//				mc.scaleX = xscale;
//				mc.scaleY = yscale;
				var bd:BitmapData = new BitmapData(mc.width,
					mc.height, true, 0xFFFFFFFF);
				bd.draw(mc);
				bitmapDataVector.push(bd);
			}
//			spriteContainer.removeChild(mc);
			return bitmapDataVector;
		}
	}
}