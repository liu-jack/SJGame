package SJ.Game.twlogin
{
	import engine_starling.display.SLayer;
	import engine_starling.SApplicationConfig;
	import starling.display.Quad;
	
	public class CJTwBgLayer extends SLayer
	{
		protected var background:Quad
		public function CJTwBgLayer()
		{
			super();
			initBg();
		}
		private function initBg():void
		{
			background = new Quad(SApplicationConfig.o.stageWidth,SApplicationConfig.o.stageHeight,0x000000);
			this.addChild(background);
		}
	}
}