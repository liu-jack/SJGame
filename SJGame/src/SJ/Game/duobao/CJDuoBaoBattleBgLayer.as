package SJ.Game.duobao
{
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;

	public class CJDuoBaoBattleBgLayer extends SLayer
	{
		//当前战斗句柄 
		public function CJDuoBaoBattleBgLayer()
		{
			super();
			_init()
		}
		
		private function _init():void
		{
			var image:SImage = new SImage(SApplication.assets.getTexture("jingjichangbg"))
			this.addChild(image);
			image.scaleX = image.scaleY = 1.4;
		}
		
	}
}