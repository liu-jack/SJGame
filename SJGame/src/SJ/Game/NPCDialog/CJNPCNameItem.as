package SJ.Game.NPCDialog
{
	import SJ.Common.Constants.ConstTextFormat;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Label;
	
	public class CJNPCNameItem extends SLayer
	{
		
		private var _nameLabel:Label
		public function CJNPCNameItem()
		{
			super();
			_init();
		}
		
		private function _init():void
		{
			var bg:SImage = new SImage(SApplication.assets.getTexture("npcduihua_mingchengdi"));
			this.addChild(bg);
			var icon:SImage = new SImage(SApplication.assets.getTexture("npcduihua_biao"));
			icon.x = 21;
			icon.y = 2;
			this.addChild(icon);
			_nameLabel = new Label;
			_nameLabel.textRendererProperties.textFormat = ConstTextFormat.npcdialognameformat;
			_nameLabel.x = 40;
			_nameLabel.y = 3;
			this.addChild(_nameLabel)
		}
		
		public function set npcname(str:String):void
		{
			_nameLabel.text = str;
		}
	}
}