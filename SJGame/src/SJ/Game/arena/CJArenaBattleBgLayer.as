package SJ.Game.arena
{
	import SJ.Game.battle.CJBattleReplayManager;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class CJArenaBattleBgLayer extends SLayer
	{
		//当前战斗句柄 
		public function CJArenaBattleBgLayer()
		{
			super();
			_init()
		}
		
		private function _init():void
		{
			var image:SImage = new SImage(SApplication.assets.getTexture("jingjichangbg"))
			this.addChild(image)
			image.scaleX = image.scaleY = 1.4;
		}

	}
}