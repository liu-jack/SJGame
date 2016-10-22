package engine_starling.utils
{
	import flash.geom.Point;
	
	import starling.display.DisplayObject;

	public class SDisplayUtils
	{
		public function SDisplayUtils()
		{
		}
		
		/**
		 * 设置对象中心点 
		 * @param x 0-1 0为左
		 * @param y 0-1 0为上
		 * @param srcDisplayObject 要设置的对象
		 * @param newPos 设置完成新的坐标,空为转换新的坐标
		 */
		public static function setAnchorPoint(srcDisplayObject:DisplayObject,x:Number = 0.5,y:Number = 0.5, newPos:Point = null):void
		{
			
			
			var oldPivotX:Number = srcDisplayObject.pivotX;
			var oldPivotY:Number = srcDisplayObject.pivotY;
			
			srcDisplayObject.pivotX = srcDisplayObject.width * x;
			srcDisplayObject.pivotY =srcDisplayObject.height * y;
			
//			if(newPos == null)
//			{
//				srcDisplayObject.x += (srcDisplayObject.pivotX - oldPivotX);
//				srcDisplayObject.y += (srcDisplayObject.pivotY - oldPivotY);
//					
//			}
//			else
//			{
//			
//				srcDisplayObject.x = newPos.x;
//				srcDisplayObject.y = newPos.y;
//			}
		}
	}
}