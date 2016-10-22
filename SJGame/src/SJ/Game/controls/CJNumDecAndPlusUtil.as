package SJ.Game.controls
{
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	
	public class CJNumDecAndPlusUtil extends SLayer
	{
		private var _decreaseBtn:Button;
		private var _plusBtn:Button;
		private var _maxBtn:Button;
		public function CJNumDecAndPlusUtil()
		{
			super();
			_init();
		}
		
		private function _init():void
		{
			_decreaseBtn = new Button;
			_decreaseBtn.defaultSkin = new SImage (SApplication.assets.getTexture("common_jiananniu"));
			_plusBtn = new Button;
			_plusBtn.defaultSkin = new SImage ( SApplication.assets.getTexture("common_jiaanniu"));
			_maxBtn = new Button;
			_maxBtn.defaultSkin = new SImage ( SApplication.assets.getTexture("zuoqi_zuidahua"));
		}
		
	}
}