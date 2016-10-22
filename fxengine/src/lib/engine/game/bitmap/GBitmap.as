package lib.engine.game.bitmap
{
	import flash.display.BitmapData;
	
	/**
	 * 图形绘制扩展 
	 * @author caihua
	 * 
	 */
	public class GBitmap extends BitmapData
	{
		/**
		 * 图形缓存堆栈 
		 */
//		private var _BitmapStack:Vector.<BitmapData> = new Vector.<BitmapData>();
//		private var _BitmapIns:BitmapData;
		
		public function GBitmap(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
//			_BitmapIns = new BitmapData(width, height, transparent, fillColor);
		}
		
		
//		public function LockBitmap():void
//		{
//			var _BitmapCache:BitmapData = this.clone();
//			_BitmapCache.fillRect(this.rect,0x00000000);
//			_BitmapStack.push(_BitmapCache);
//		}
//		public function ReleaseBitmap():void
//		{
//			
//		}
//		
//		protected function get g():BitmapData
//		{
//			if(_BitmapStack.length == 0)
//			{
//				return _BitmapIns;
//			}
//			else
//			{
//				return _BitmapStack[_BitmapStack.length - 1];
//			}
//		}
		
		
		
		
		
	}
}