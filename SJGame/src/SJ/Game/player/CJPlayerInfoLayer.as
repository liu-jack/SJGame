package SJ.Game.player
{
	import SJ.Common.Constants.ConstPlayer;
	import SJ.Game.battle.CJBattleMananger;
	import SJ.Game.map.CJBattleMapManager;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.SApplication;
	import engine_starling.data.SDataBase;
	import engine_starling.display.SLayer;
	import engine_starling.display.SNode;
	
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;
	
	import starling.display.Image;
	import starling.events.Event;
	
	public class CJPlayerInfoLayer extends SLayer
	{
		private var _ownerPlayer:CJPlayerNpc;
		private var _hp:int;

		public function get hp():int
		{
			return _hp;
		}

		public function set hp(value:int):void
		{
			_hp = value;
			if(_progressbar)
			{
				if(_hp == 0)
				{
					_progressbar.visible = false;
				}
				_progressbar.value = _hp;
				
				hptext.text = _hp + "/" + _hpmax;
				
			}
		}

		/**
		 * 最大血量 
		 */
		private var _hpmax:int;
		private var _progressbar:ProgressBar;
		public function CJPlayerInfoLayer(owner:CJPlayerNpc)
		{
			super();
			_ownerPlayer = owner;
		}
		
		override protected function draw():void
		{
			// TODO Auto Generated method stub
			super.draw();
		}
		private var hptext:Label;
		

		
		override public function set scaleX(value:Number):void
		{
			// TODO Auto Generated method stub
			super.scaleX = value;
			
			
		}
		
		
		override protected function initialize():void
		{
			_hpmax = _ownerPlayer.playerData.hp_max;
			_hp = _ownerPlayer.playerData.hp;
			
			
			
			if(_ownerPlayer.playerData.playerType == ConstPlayer.SConstPlayerTypeBoss)
			{
				_initialize_wujiangLayout();
//				_initialize_bossLayout();
			}
			else if(_ownerPlayer.playerData.playerType == ConstPlayer.SConstPlayerTypeHero || 
				_ownerPlayer.playerData.playerType == ConstPlayer.SConstPlayerTypePlayer)
			{
				_initialize_wujiangLayout();
			}
			
			addEventListener(Event.REMOVED_FROM_STAGE,_on_RemoveFromStage);
			_ownerPlayer.playerData.addEventListener(DataEvent.DataChange,_onDataChange);
			
			
			hptext = new Label();
			hptext.scaleX = _ownerPlayer.scaleX;
			hptext.text = _hp + "/" + _hpmax;
			
//			addChild(hptext);
			
			super.initialize();
		}
		
		private function _initialize_wujiangLayout():void
		{
			var xuecaos:SNode = new SNode();
			
			var xuecaoTexture:String = "wujiang_xuecao";
			//布局血槽

			var xuecao:Image = new Image(SApplication.assets.getTexture(xuecaoTexture));
			xuecaos.addChild(xuecao);
			xuecaos.pivotX = 43/2;
			
			_progressbar = new ProgressBar();
			_progressbar.backgroundSkin = new Image(SApplication.assets.getTexture("wujiang_xuedi"));
			_progressbar.backgroundSkin.alpha = 0.001;
			var texture:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture("wujiang_xue"),2,1);
			_progressbar.fillSkin = new Scale3Image(texture);
			
			_progressbar.minimum = 0;
			_progressbar.maximum = _hpmax;
			_progressbar.x = 4;
			_progressbar.y = 2;
			_progressbar.width = 43;
			
			xuecaos.addChild(_progressbar);
			_progressbar.validate();
			_progressbar.value = _hp;
			addChild(xuecaos);

		}
		
		private function _initialize_bossLayout():void
		{
			var xuecaos:SNode = new SNode();
			var xuecaoTexture:String = "boss_xuecao";
			var xuecao:Image = new Image(SApplication.assets.getTexture(xuecaoTexture));
			xuecaos.addChild(xuecao);
//			xuecaos.pivotX = xuecao.width/2;
			
			_progressbar = new ProgressBar();
			_progressbar.backgroundSkin = new Image(SApplication.assets.getTexture("wujiang_xuedi"));
			_progressbar.backgroundSkin.alpha = 0.001;
			var texture:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture("boss_xue"),4,1);
			_progressbar.fillSkin = new Scale3Image(texture);
			
			_progressbar.minimum = 0;
			_progressbar.maximum = _hpmax;
			_progressbar.x = 12;
			_progressbar.y = 24;
			_progressbar.width = 430/2;
			_progressbar.height = 18/2;
			_progressbar.pivotX = _progressbar.width/2;
			_progressbar.x += _progressbar.pivotX;
			_progressbar.scaleX = -1;
			
			xuecaos.addChild(_progressbar);
			_progressbar.validate();
			_progressbar.value = _hp;
			xuecaos.x = 386/2;
			xuecao.scaleX = this.scaleX;
			CJBattleMapManager.o.playerInfoLayer.addChild(xuecaos);
			
			
		}
		
		private function _onDataChange(e:Event):void
		{
			if(e.data['key'] == 'hp')
			{
				hp = e.data['value'];
			}
		}
		
		
		private function _on_RemoveFromStage(e:Event):void
		{
			_ownerPlayer.playerData.removeEventListener(DataEvent.DataChange,_onDataChange);
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			_ownerPlayer = null;
			super.dispose();
		}
		
		
//		override public function set scaleX(value:Number):void
//		{
//			// TODO Auto Generated method stub
////			super.scaleX = 1/value;;
//		}
		
		
		
		
	}
}