package SJ.Game.arena
{
	import SJ.Common.Constants.ConstTextFormat;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Label;
	
	public class CJArenaPlayerNameItem extends SLayer
	{
		private var _nameLabel:Label;
		public function CJArenaPlayerNameItem()
		{
			super();
			_init();
		}
		
		private function _init():void
		{
			var bg:SImage = new SImage(SApplication.assets.getTexture("jingjichang_mingchengdi"));
			this.addChild(bg);
			_nameLabel = new Label;
			_nameLabel.width = 63;
			_nameLabel.height = 30;
			_nameLabel.textRendererProperties.textFormat = ConstTextFormat.arenaOPlayerName;
			this.addChild(_nameLabel)
		}
		
		public function set text(txt:String):void
		{
			_nameLabel.text = txt;
		}
		public function get text():String
		{
			return _nameLabel.text
		}
		public function set isSelf(b:Boolean):void
		{
			if(b)
			{
				_nameLabel.textRendererProperties.textFormat = ConstTextFormat.arenaSelfPlayerName;
			}
		}
	}
}