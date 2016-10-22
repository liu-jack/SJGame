package lib.engine.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import lib.engine.game.bitmap.GBitmapData;

	public class GBitmapUtils
	{
		public function GBitmapUtils()
		{
		}
		/**
		 * 填充位图 
		 * @param srcBitmap 原Bitmap数据
		 * @param srcRect 原数据区域
		 * @param destRect 目标数据区域
		 * @param destBitmapdata 绘制到的区域
		 * @param Stretch true 拉伸 false 平铺
		 * 
		 */
		public static function fillBitmap(srcBitmap:GBitmapData,srcRect:Rectangle,destRect:Rectangle,destBitmapdata:BitmapData,Stretch:Boolean = false):void
		{
			if(Stretch)
			{
				StretchBitmap(srcBitmap,srcRect,destRect,destBitmapdata);
			}
			else
			{
				TileBitmap(srcBitmap,srcRect,destRect,destBitmapdata);
			}
		}
		/**
		 * 填充区域 平铺方式填充
		 * @param srcBitmap 原Bitmap数据
		 * @param srcRect 原数据区域
		 * @param destRect 目标数据区域
		 * @param destBitmapdata 绘制到的区域
		 * 
		 */
		public static function TileBitmap(srcBitmap:GBitmapData,srcRect:Rectangle,destRect:Rectangle,destBitmapdata:BitmapData):void
		{
			var x:int,y:int,xcount:int,ycount:int;
			x = 0;
			y = 0;
			xcount = destRect.width / srcRect.width + 1;
			ycount = destRect.height / srcRect.height + 1;
			
			var offsetwitdh:int;
			var offsetheight:int;
			
			for(y = 0;y<ycount;y++)
			{
				for(x = 0;x<xcount;x++)
				{
					offsetwitdh = srcRect.width;
					offsetheight = srcRect.height;
					
					if(x * srcRect.width + offsetwitdh>destRect.width)
					{
						offsetwitdh = destRect.width - x * srcRect.width;
					}
					if(y * srcRect.height + offsetheight>destRect.height)
					{
						offsetheight = destRect.height - y * srcRect.height;
					}
					destBitmapdata.copyPixels(srcBitmap.dataMix,new Rectangle(srcRect.x,srcRect.y,offsetwitdh,offsetheight),
						new Point(destRect.x + x * srcRect.width,destRect.y + y * srcRect.height),null,
						null,true);
				}
			}
		}
		
		/**
		 * 拉伸方式绘制 
		 * @param srcBitmap
		 * @param srcRect
		 * @param destRect
		 * @param destBitmapdata
		 * 
		 */
		public static function StretchBitmap(srcBitmap:GBitmapData,srcRect:Rectangle,destRect:Rectangle,destBitmapdata:BitmapData):void
		{
			var scaleX:Number,scaleY:Number;
			
			scaleX = destRect.width / srcRect.width;
			scaleY = destRect.height / srcRect.height;
			
			var mBitmapData:BitmapData = new BitmapData(srcRect.width,srcRect.height);
			mBitmapData.fillRect(mBitmapData.rect,0x00FFFFFF);
			mBitmapData.copyPixels(srcBitmap.dataMix,new Rectangle(srcRect.x,srcRect.y,srcRect.width,srcRect.height),
				new Point(0,0),null,
				null,true);
			
			var m:Matrix = new Matrix();
			
			
			
			m.scale(scaleX,scaleY);
			m.translate(destRect.x,destRect.y);
			destBitmapdata.draw(new Bitmap(mBitmapData),m,null,null,destRect,true);
			mBitmapData.dispose();
		}
	}
}