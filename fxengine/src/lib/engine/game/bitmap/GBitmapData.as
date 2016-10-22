package lib.engine.game.bitmap
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;

	/**
	 * Bitmap单元图形数据
	 * @author caihua
	 * 
	 */
	public class GBitmapData
	{
		private var _bitmap:BitmapData;
		
		private var _bitmapalpha:BitmapData;
		/**
		 * 混合通道的图像 
		 */
		private var _mixbitmap:BitmapData;
		
		public function GBitmapData(image:DisplayObject,offsetx:Number = 0,offsety:Number = 0,width:int = -1,height:int= -1)
		{
			
//			_CreateBitmap(image,offsetx,offsety);
//			_CreateBitmapAlpha(image,offsetx,offsety);
			_CreateBitmapMix(image,offsetx,offsety,width,height);
		}
		
		public function get data():BitmapData
		{
			return 	_mixbitmap;
		}
		
		public function get dataAlpha():BitmapData
		{
			return _mixbitmap;
		}
		/**
		 * 带Alpha混合数据 
		 * @return 
		 * 
		 */
		public function get dataMix():BitmapData
		{
			return _mixbitmap;
		}
		
		protected function _CreateBitmap(image:DisplayObject,offsetx:Number = 0,offsety:Number = 0):void
		{
			_bitmap = new BitmapData(image.width,image.height,true,0xFFFFFFFF);
			//_bitmap.fillRect(_bitmap.rect,0x00FFFFFF);
			var m:Matrix = new Matrix();
			m.translate(offsetx,offsety);
			_bitmap.draw(image,m,null,null,null,true);
			_mixbitmap.dispose()
		}
		
		protected function _CreateBitmapAlpha(image:DisplayObject,offsetx:Number = 0,offsety:Number = 0):void
		{
			_bitmapalpha = new BitmapData(image.width,image.height,true,0xFFFFFFFF);
			var m:Matrix = new Matrix();
			m.translate(offsetx ,offsety);
			_bitmapalpha.draw(image,m,null,BlendMode.ALPHA,null,true);
		}
		
		protected function _CreateBitmapMix(image:DisplayObject,offsetx:Number = 0,offsety:Number = 0,width:int = -1,height:int= -1):void
		{
			var bitmapwidth:int = (width == -1?image.width:width);
			var bitmapheight:int = (height == -1?image.height:height);
			if(bitmapwidth == 0 || bitmapheight == 0)
			{
				_mixbitmap = new BitmapData(1,1,true,0xFFFFFFFF);
			}
			else
			{
				_mixbitmap = new BitmapData(bitmapwidth,bitmapheight,true,0xFFFFFFFF);
			}
			
			_mixbitmap.fillRect(_mixbitmap.rect,0x00FFFFFF);
			var m:Matrix = new Matrix();
			m.translate(-offsetx,-offsety);
			
			_mixbitmap.draw(image,m,null,null,null,true);
		}
		
		/**
		 *释放用来存储 BitmapData 对象的内存。 
对图像调用 dispose() 方法时，该图像的宽度和高度将设置为 0。对此 BitmapData 实例的方法或属性的所有后续调用都将失败，并引发异常。 

BitmapData.dispose() 立即释放由实际的位图数据占用的内存（一个位图最多可使用 64 MB 的内存）。使用 BitmapData.dispose() 后，BitmapData 对象不再可用，而且，如果对 BitmapData 对象调用函数，Flash 运行时将引发异常。但是，BitmapData.dispose() 不会将 BitmapData 对象（大约 128 个字节）作为垃圾回收；由实际的 BitmapData 对象占用的内存在垃圾回收器收集 BitmapData 对象时释放。

 
		 * 
		 */
		public function dispose():void
		{
			if(_bitmap != null)
				_bitmap.dispose();
			if(_bitmapalpha != null)
				_bitmapalpha.dispose();
			if(_mixbitmap != null)
				_mixbitmap.dispose();
		}
	}
}