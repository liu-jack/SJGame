package SJ.Game.fuben
{
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import starling.textures.Texture;
	
	public class CJFubenTaskGuidIcon extends SLayer
	{
		public function CJFubenTaskGuidIcon()
		{
			super();
			this.touchable = false;
			_init();
		}
		private function _init():void
		{
			var jtIconTexture:Texture = SApplication.assets.getTexture("fuben_new")
			var jtIcon:SImage = new SImage(jtIconTexture);
			this.addChild(jtIcon)
			this.setSize(jtIconTexture.width,jtIconTexture.height)
		}
	}
}