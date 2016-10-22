package SJ.Game.heroStar
{
	import engine_starling.display.SLayer;
	import engine_starling.utils.STween;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	
	/**
	 * 向上飘图片
	 * @author longtao
	 */
	public class CJHeroStarFlyImage extends SLayer
	{
		/** 显示对象 **/
		private var _displayObj:Sprite;
		/** 动画显示时间 **/
		private var _time:Number;
		/** 漂浮距离 **/
		private var _distance:Number;
		
		/** 补间 **/
		private var _tween:STween;
		
		/**
		* @param displayObj : 要漂浮的显示对象
		* @param animateTime : 动画显示时间
		* @param tweenDistance : 漂移距离(单位像素)
		*/		
		public function CJHeroStarFlyImage(displayObj:Sprite , time:Number = 1 , distance:Number = 10)
		{
			super();
			
			if(null == displayObj)
				return;
			
			_displayObj = displayObj;
			_time = time;
			_distance = distance;
		}
		
		/**
		 * 开始播放
		 */
		public function gotoAndPlay():void
		{
			if (null == _displayObj)
				return;
			
			// 添加到显示列表
			addChild(_displayObj);
			
			_tween = new STween(_displayObj, _time);
			_tween.moveTo(_displayObj.x , _displayObj.y - _distance);
			_tween.onComplete = _complete;
			Starling.juggler.add(_tween);
		}
		
		/// 完成
		private function _complete():void
		{
			Starling.juggler.remove(_tween);
			_tween.onComplete = null;
			_tween = null;
			
			this.removeFromParent(true);
		}
		
		
		
	}
}