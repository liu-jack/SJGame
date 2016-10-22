package SJ.Game.activity
{
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	
	/**
	 +------------------------------------------------------------------------------
	 * 活跃度值
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-9 下午4:56:40  
	 +------------------------------------------------------------------------------
	 */
	public class CJActivityScore extends SLayer
	{
		private var _score:int = 0;
		
		public function CJActivityScore()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
		}
		
		override protected function draw():void
		{
			super.draw();
			this.removeChildren();
			var strList:Array = String(_score).split("");
			var length:int = strList.length;
			var offsetX:int = 0;
			if(length == 1)
			{
				offsetX = 5;
			}
			else if(length == 2)
			{
				offsetX = 0;
			}
			else
			{
				offsetX = -16;
			}
			for(var i:String in strList)
			{
				var img:ImageLoader = new ImageLoader();
				img.source = SApplication.assets.getTexture("huoyuedu_shuzi0"+strList[i])
				img.x = int(i)* 20 + offsetX;
				this.addChild(img);
			}
		}

		public function get score():int
		{
			return _score;
		}

		public function set score(value:int):void
		{
			if(_score == value)
			{
				return;
			}
			_score = value;
			this.invalidate();
		}
	}
}