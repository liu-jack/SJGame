package SJ.Game.funcopen
{
	import engine_starling.display.SLayer;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Shape;
	
	/**
	 +------------------------------------------------------------------------------
	 * 构造含镂空区域的遮罩
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-25 下午2:53:45  
	 +------------------------------------------------------------------------------
	 */
	public class CJMaskUtil
	{
		public function CJMaskUtil()
		{
			super();
		}
		
		/**
		 * 相对舞台构造一个遮罩，里面有个镂空区域 
		 * @param x : 镂空区域的x坐标
		 * @param y : 镂空区域的y坐标
		 * @param width : 镂空区域的宽度
		 * @param height : 镂空区域的高度
		 */		
		public static function createMaskWithHoleOnStage(x:Number , y :Number , width:Number , height:Number):SLayer
		{
			return createMaskWithHoleOnTarget(x, y,width,height, Starling.current.stage);
		}
		
		/**
		 * 相对某个显示对象构造一个遮罩，里面有个镂空区域 
		 * @param x : 镂空区域的x坐标
		 * @param y : 镂空区域的y坐标
		 * @param width : 镂空区域的宽度
		 * @param height : 镂空区域的高度
		 */		
		public static function createMaskWithHoleOnTarget(x:Number , y :Number , width:Number , height:Number , target:DisplayObject):SLayer
		{
			var mask:SLayer = new SLayer();
			mask.width = target.width;
			mask.height = target.height;
			
			var shapeLeft:Shape = _drawLeft(x , y , width , height , target);
			var shapeRight:Shape = _drawRight(x , y , width , height , target);
			var shapeUp:Shape = _drawUp(x , y , width , height , target);
			var shapeBottom:Shape = _drawBottom(x , y , width , height , target);
			
			mask.addChild(shapeLeft);
			mask.addChild(shapeRight);
			mask.addChild(shapeUp);
			mask.addChild(shapeBottom);
			return mask;
		}
		
		private static function _drawUp(x:Number , y :Number , width:Number , height:Number , target:DisplayObject):Shape
		{
			return _drawRect(0 , 0 , target.width , y);
		}
		
		private static function _drawBottom(x:Number , y :Number , width:Number , height:Number , target:DisplayObject):Shape
		{
			return _drawRect(0 , y+height , target.width , target.height - y - height);
		}
		
		private static function _drawLeft(x:Number , y :Number , width:Number , height:Number , target:DisplayObject):Shape
		{
			return _drawRect(0 , y , x , height);
		}
		
		private static function _drawRight(x:Number , y :Number , width:Number , height:Number , target:DisplayObject):Shape
		{
			return _drawRect(x+width , y ,  target.width -x - width , height);
		}
		
		private static function _drawRect(x:Number , y :Number , width:Number , height:Number):Shape
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0x000000 , 0.7);
			shape.graphics.drawRect(x , y , width , height);
			shape.graphics.endFill();
			return shape;
		}
	}
}