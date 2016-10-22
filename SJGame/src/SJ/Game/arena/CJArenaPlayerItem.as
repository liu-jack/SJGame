package SJ.Game.arena
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfAccounts;
	import SJ.Game.lang.CJLang;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Label;
	
	import starling.core.Starling;
	
	public class CJArenaPlayerItem extends SLayer
	{
		private var _nameItem:CJArenaPlayerNameItem
		private var _levelText:Label;
		private var _battleText:Label;
		private var _levelLabel:Label;
		private var _battleLabel:Label;
		private var _userid:String;
		private var _titleLayer:SLayer;
		private var _userInfo:Object;
		
		
		public function CJArenaPlayerItem()
		{
			super();
			_init();
		}
		
		private function _init():void
		{
			_titleLayer = new SLayer;
			this.addChild(_titleLayer)
			_initName();
			_initInfo();
			_initPlayer();
		}
		private function _initName():void
		{
			_nameItem = new CJArenaPlayerNameItem;
			_titleLayer.pivotX = 63>>1;
			_titleLayer.pivotY = 15>>1;
			this._titleLayer.addChild(_nameItem);
		}
		private function _initInfo():void
		{
			_levelText = new Label;
			_levelText.text = CJLang("HERO_UI_LEVEL")+":";
			_levelText.x = 16;
			_levelText.y = 19;
			_levelText.textRendererProperties.textFormat = ConstTextFormat.arenaSPlayerName
			this._titleLayer.addChild(_levelText);
			
			_battleText = new Label;
			_battleText.text = CJLang("ARENA_PLAYERINFO_BATTLENUM")+":";
			_battleText.x = 16;
			_battleText.y = 30;
			_battleText.textRendererProperties.textFormat = ConstTextFormat.arenaSPlayerName
			this._titleLayer.addChild(_battleText);
			
			_levelLabel = new Label;
			_levelLabel.x = 51;
			_levelLabel.y = 19;
			_levelLabel.textRendererProperties.textFormat = ConstTextFormat.arenaSPlayerName
			this._titleLayer.addChild(_levelLabel);
			
			_battleLabel = new Label;
			_battleLabel.x = 51;
			_battleLabel.y = 30;
			_battleLabel.textRendererProperties.textFormat = ConstTextFormat.arenaSPlayerName
			this._titleLayer.addChild(_battleLabel)
			
		}
		
		private function _initPlayer():void
		{
			
		}
		
		public function set userid(id:int):void
		{
			
		}
		public function set userInfo(info:Object):void
		{
			_userInfo = info;
			_userid = info.userid;
			_nameItem.text = info.rolename;
			//是玩家自己
			if(_userid == (CJDataManager.o.getData("CJDataOfAccounts") as CJDataOfAccounts).userID)
			{
				_nameItem.isSelf = true;
				var bgImage:SImage = new SImage(SApplication.assets.getTexture("jingjichang_wanjiaguangxiao"));
				bgImage.pivotX = bgImage.texture.width>>1
				bgImage.pivotY = bgImage.texture.height
				bgImage.y = 135;
				this.addChildAt(bgImage,0);
				
				_levelText.textRendererProperties.textFormat = ConstTextFormat.arenaSPlayerInfo
				_levelLabel.textRendererProperties.textFormat = ConstTextFormat.arenaSPlayerInfo
				_battleText.textRendererProperties.textFormat = ConstTextFormat.arenaSPlayerInfo
				_battleLabel.textRendererProperties.textFormat = ConstTextFormat.arenaSPlayerInfo
			}
			templateId = info.templateId;
			_levelLabel.text = info.level;
			_battleLabel.text = info.battlelevel;
		}
		
		public function get userInfo():Object
		{
			return _userInfo;	
		}
		
		public function set templateId(id:int):void
		{
			var playerDatas:Vector.<CJPlayerData> = new Vector.<CJPlayerData>();
			var playerData:CJPlayerData = new CJPlayerData;
			playerData.isPlayer = true;
			playerData.templateId = id
			playerDatas.push(playerData);
			var role:CJPlayerNpc= new CJPlayerNpc(playerData,Starling.juggler);
			role.lodlevel = CJPlayerNpc.LEVEL_LOD_1;
			role.hidebattleInfo();
			role.onloadResourceCompleted = function loaded(npc:CJPlayerNpc):void{
				npc.idle();
			};
			role.y = 127;
			this.addChild(role);
		}
		
		public function get roleName():String
		{
			return _nameItem.text
		}
		
		public function get uid():String
		{
			return this._userid;
		}
	}
}