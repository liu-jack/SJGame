package SJ.Game.player
{
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.config.CJDataOfSkillPropertyList;
	import SJ.Game.data.json.Json_skill_setting;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.Events.MouseEvent;
	import engine_starling.display.SLayer;
	import engine_starling.display.SScale3Plane;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.core.PopUpManager;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class CJPlayerBattleTip extends SLayer
	{
		private var _bgLayer:SScale3Plane;
		public function CJPlayerBattleTip()
		{
			super();
		}

		public function get bgLayer():SScale3Plane
		{
			return _bgLayer;
		}

		public function set bgLayer(value:SScale3Plane):void
		{
			_bgLayer = value;
		}

		public function get playerData():CJPlayerData
		{
			return _playerData;
		}

		public function set playerData(value:CJPlayerData):void
		{
			_playerData = value;
			
			this.invalidate();
		}

		
		private var _playerData:CJPlayerData;
		
		private function _drawHeroStars():void
		{
			if(_playerData != null)
			{
				
				for(var i:int = 0;i<5;i++)
				{
					if(_playerData.isMonster)
					{
						(getChildByName("herostar_"+i+"_a") as ImageLoader).visible = false;
						(getChildByName("herostar_"+i+"_b") as ImageLoader).visible = false;
					}
					else
					{
						(getChildByName("herostar_"+i+"_a") as ImageLoader).visible = i<_playerData.herostar?true:false;
					}
				}
			}
		}
		
		override protected function draw():void
		{
			// TODO Auto Generated method stub
			if(_playerData != null)
			{
				(getChildByName("heroName") as Label).text = _playerData.displayName;
				(getChildByName("herobattleeffect") as Label).text = CJLang("BATTLE_BATTLE_POWER") + int(_playerData.battleeffect);
				(getChildByName("herolevel") as Label).text = "Lv" + _playerData.level;
				(getChildByName("herovalue") as Label).text = _playerData.hp + "/" + _playerData.hp_max;
				(getChildByName("herohpbar") as ProgressBar).value = Number(_playerData.hp)/Number(_playerData.hp_max);
				
				if(_playerData.heroConfig.identity != null)
				{
					(getChildByName("herospdesc") as Label).text = CJLang("HERO_IDEN_" + _playerData.templateId);
				}
				else
				{
					(getChildByName("herospdesc") as Label).text = CJLang("BATTLE_NO_NEED");
				}
				if(SStringUtils.isEmpty(_playerData.displayName))
				{
					(getChildByName("heroName") as Label).text = CJLang(_playerData.heroConfig.name);
				}
				
				_drawHeroStars();
				
				//设置技能
				if(_playerData.skillcurrentid != 0)
				{
					var skillConfig:Json_skill_setting = CJDataOfSkillPropertyList.o.getProperty(_playerData.skillcurrentid)  as Json_skill_setting;
					(getChildByName("heroskillname") as Label).text = CJLang(skillConfig.skillname);
//					(getChildByName("heroskilldesc") as Label).text = CJLang(skillConfig.skilldes);
					(getChildByName("heroskilldesc") as Label).text = skillConfig.skilldes;
					for(var i:int = 0;i<5;i++)
					{
						(getChildByName("heroround_"+(i)+"_a") as ImageLoader).visible = (i==_playerData.skillstartround|| (i-_playerData.skillstartround) % _playerData.skilleachround == 0)?true:false;
					}
				}
				
				if(_playerData.isMonster)
				{
					(getChildByName("heroName") as Label).y = 18;
					(getChildByName("herobattleeffect") as Label).visible = false;
					(getChildByName("herolevel") as Label).visible = false;
					if(parseInt(_playerData.heroConfig.pattack) > parseInt(_playerData.heroConfig.mattack))
					{
						(getChildByName("heroName") as Label).text += CJLang("BATTLE_WUGONG");
					}
					else
					{
						(getChildByName("heroName") as Label).text += CJLang("BATTLE_FAGONG");
					}
				}
			}
			super.draw();
		}
		
		override protected function initialize():void
		{
			// TODO Auto Generated method stub
			super.initialize();
			var pthis:CJPlayerBattleTip = this;
			
			var backquad:DisplayObject = PopUpManager.getTopDisObjectBg();
			backquad.addEventListener(TouchEvent.TOUCH,function _e(e:TouchEvent):void
			{
			
				if(e.getTouch(backquad,TouchPhase.BEGAN))
				{
					e.target.removeEventListener(e.type,_e);
					CJLayerManager.o.disposeFromModal(pthis,true);
					
				}
			});
		
		}
		
		override public function dispose():void
		{
			_playerData = null;
			super.dispose();
		}
		
		
		
		
		
		

	}
}