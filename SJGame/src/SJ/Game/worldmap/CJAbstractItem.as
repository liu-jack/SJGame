package SJ.Game.worldmap
{
	import SJ.Game.formation.CJItemTurnPageBase;
	
	import engine_starling.SApplication;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;
	
	public class CJAbstractItem extends CJItemTurnPageBase implements IListItemRenderer
	{
		private var openbg:Scale3Image
		public function CJAbstractItem(name:String ,multiSelection:Boolean)
		{
			super(name,multiSelection);
		}
		override protected function initialize():void
		{
			super.initialize();
			_init();
		}
		
		private function _init():void
		{
			openbg= new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("huodong_dikuang01"),4,5))
			openbg.width = 375;
			var btn:Button = new Button;
			btn.defaultSkin = openbg
			this.addChild(btn);
			this.setSize(openbg.width,47);
		}
		
	}
}