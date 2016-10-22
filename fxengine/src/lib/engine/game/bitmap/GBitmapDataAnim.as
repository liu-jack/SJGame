package lib.engine.game.bitmap
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	

	/**
	 * 动画缓存 
	 * @author caihua
	 * 
	 */
	public class GBitmapDataAnim
	{
		public function GBitmapDataAnim(movie:MovieClip)
		{
			var rect:Rectangle = movie.getBounds(null);
			_bitmap = new GBitmapData(movie,rect.x,rect.y);
			
			var mainpos:DisplayObject = movie.getChildByName("mainbody");
			//var pos:Point = movie.globalToLocal(new Point(0,0));
			if(mainpos != null)
			{
				_mainbody.x = rect.x - mainpos.x;
				_mainbody.y = rect.y - mainpos.y;
			}
			else
			{
				_mainbody.x = rect.x;
				_mainbody.y = rect.y;
			}
		}
		
		private var _bitmap:GBitmapData;
		private var _mainbody:Point = new Point();

		public function get bitmap():GBitmapData
		{
			return _bitmap;
		}
		
		/**
		 * 中心点坐标 
		 * @return 
		 * 
		 */
		public function get mainbody():Point
		{
			return _mainbody;
		}

	}
}