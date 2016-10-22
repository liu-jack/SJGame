package SJ.Game.map
{
	import engine_starling.utils.STween;
	
	import starling.core.Starling;

	public class CJBattleRootLayer extends MapLayer
	{
		public function CJBattleRootLayer()
		{
			_shakeTween = new STween(this,0);
		}
		private var _shakeTween:STween;
		/**
		 * 震动 
		 * @param shakemode 震动模式
		 * @param shakex x振幅
		 * @param shakey y振幅
		 * @param during 间隔时间
		 * 
		 */
		public function shake(shakemode:int,shakex:Number,shakey:Number,during:Number):void
		{
			Starling.juggler.remove(_shakeTween);
			
			var oldScaleX:Number = 0;
			var oldScaleY:Number = 0;
			
			_shakeTween.reset(this,during);
			_shakeTween.onUpdate = function():void{
				x = Math.random() * shakex;
				y = Math.random() * shakey;
				
			};
			_shakeTween.onComplete = function():void
			{
				x = oldScaleX;
				y = oldScaleY;
			}
			Starling.juggler.add(_shakeTween);
		}
	}
}