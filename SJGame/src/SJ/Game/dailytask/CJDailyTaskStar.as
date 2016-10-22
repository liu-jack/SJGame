package SJ.Game.dailytask
{
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;

	/**
	 +------------------------------------------------------------------------------
	 * 每日任务星星
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-10-16 下午3:32:54  
	 +------------------------------------------------------------------------------
	 */
	public class CJDailyTaskStar extends SLayer
	{
		private var _starNum:int = 0;
		private var _starList:Array;
		
		public function CJDailyTaskStar()
		{
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_starList = new Array();
			for(var i:int = 0 ; i < 5 ;i++)
			{
				var star:ImageLoader = new ImageLoader();
				star.scaleX = star.scaleY = 0.7;
				star.source = SApplication.assets.getTexture('zuoqi_xing02');
				this.addChild(star);
				star.x += 17*i;
				_starList[i] = star;
			}
		}
		
		override protected function draw():void
		{
			super.draw();
			for(var i:int = 0 ;i < 5 ; i++)
			{
				_starList[i].source = SApplication.assets.getTexture('zuoqi_xing02');
			}
			for(var j:int = 0  ; j < this._starNum ; j++)
			{
				_starList[j].source = SApplication.assets.getTexture('zuoqi_xing01');
			}
		}

		public function get starNum():int
		{
			return this._starNum;
		}

		public function set starNum(value:int):void
		{
			if(value == this._starNum || value == 0)
			{
				return;
			}
			this._starNum = value;
			this.invalidate();
		}
	}
}