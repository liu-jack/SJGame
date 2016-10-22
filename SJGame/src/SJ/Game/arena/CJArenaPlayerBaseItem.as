package SJ.Game.arena
{
	import SJ.Common.Constants.ConstTextFormat;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Label;
	
	public class CJArenaPlayerBaseItem extends SLayer
	{
		private var _numLabel:Label
		private var _player:CJArenaPlayerItem
		public function CJArenaPlayerBaseItem()
		{
			super();
			_init();
		}
		private function _init():void
		{
			var bgImage:SImage = new SImage(SApplication.assets.getTexture("common_dizuo"));
			bgImage.width = 65;
			bgImage.height = 10;
			this.addChild(bgImage);
			var numBg:SImage = new SImage(SApplication.assets.getTexture("jingjichang_paimingdi"));
			numBg.x = 12;
			numBg.y = 0;
			this.addChild(numBg);
			
			_numLabel = new Label
			_numLabel.x = 23
			_numLabel.y = 8;
			_numLabel.width = 27;
			_numLabel.height = 10;
			_numLabel.textRendererProperties.textFormat = ConstTextFormat.arenaSPlayerInfo
			this.addChild(_numLabel)
			this.touchable = false;
		}
		
		public function addPlayer(player:CJArenaPlayerItem):void
		{
			_player = player
			_player.x = 30;
			_player.y = -122;
			this.touchable = true;
			this.addChildAt(_player,1);
		}
		
		public function updateRankNum(num:int):void
		{
			_numLabel.text = String(num);
		}
		
		public function get player():CJArenaPlayerItem
		{
			return this._player
		}
		public function get rankNum():int
		{
			return int(_numLabel.text)
		}
	}
}