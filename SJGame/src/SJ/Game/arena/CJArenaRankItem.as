package SJ.Game.arena
{
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.SApplication
	import SJ.Common.Constants.ConstTextFormat
		
	import feathers.controls.Label;
	
	public class CJArenaRankItem extends SLayer
	{
		private var _rankNum:Label
		private var _playerName:Label
		private var _level:Label
		private var _totalbattle:Label
		private var _data:Object
		public function CJArenaRankItem()
		{
			super();
			_init();
		}
		
		private function _init():void
		{
			_rankNum = new Label
			_rankNum.x = 35
			_rankNum.textRendererProperties.textFormat = ConstTextFormat.arenarankwhite
			this.addChild(_rankNum)
			
//			var icon:SImage = new SImage(SApplication.assets.getTexture("paihangbang_jiantou01"))
//				icon.x = 47
//			this.addChild(icon)
				
			_playerName = new Label
			_playerName.x = 97
			_playerName.textRendererProperties.textFormat = ConstTextFormat.arenarankyellow
			this.addChild(_playerName);
			
			_level = new Label
			_level.x = 202
			_level.textRendererProperties.textFormat = ConstTextFormat.arenarankwhite
			this.addChild(_level)
				
			_totalbattle = new Label
			_totalbattle.x = 281
			_totalbattle.textRendererProperties.textFormat = ConstTextFormat.arenarankqingse
			this.addChild(_totalbattle)
		}
		
		public function update(data:Object):void
		{
			_data = data
			_rankNum.text = data.rankid
			_playerName.text= data.rolename
			_level.text = data.level
			_totalbattle.text = data.battleeffectsum
		}
	}
}