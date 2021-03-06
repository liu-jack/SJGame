package SJ.Game.fuben
{
	import SJ.Common.global.textRender;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfGuankaBattleProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.json.Json_guanka_battle_config;
	import SJ.Game.lang.CJLang;
	import SJ.Game.map.CJBattleMapManager;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.Label;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;

	public class CJFubenBattleTitleLayer extends SLayer
	{

		private var _targetObject:Object;
		private var _currentZid:int;
		private var _leftBattleeffect:int;
		private var _rightBattleeffect:int;
		
		public function CJFubenBattleTitleLayer()
		{
			super();
		}
		override protected function initialize():void
		{
			super.initialize();
			_init();
		}
		
		public function setCurrentZid(zid:int):void
		{
			_currentZid = zid;
		}
		
		public function countBattleeffect(json:String):void
		{
			_rightBattleeffect = 0;
			_leftBattleeffect = 0;
			var battleJsonObject:Object = JSON.parse(json);
			if(battleJsonObject["battle"]["0"]["info"]["player0"].hasOwnProperty("battleheros"))
			{
				var dic0:Object = battleJsonObject["battle"]["0"]["info"]["player0"]["battleheros"];
				for each(var hero0:Object in dic0)
				{
					if(hero0.hasOwnProperty("battleeffect"))
					{
						_leftBattleeffect += parseInt(hero0["battleeffect"]);
					}
				}
			}
			if(battleJsonObject["battle"]["0"]["info"]["player1"].hasOwnProperty("battleheros"))
			{
				var dic1:Object = battleJsonObject["battle"]["0"]["info"]["player1"]["battleheros"];
				for each(var hero1:Object in dic1)
				{
					if(hero1.hasOwnProperty("battleeffect"))
					{
						_rightBattleeffect += parseInt(hero1["battleeffect"]);
					}
				}
			}
		}
		
		private function _init():void
		{
			//战斗UI
			var guankaBattale:Json_guanka_battle_config = CJDataOfGuankaBattleProperty.o.getPropertyById(_currentZid);
			var mainHeroInfo:CJDataOfHero;
			
			var roleData:CJDataOfRole = CJDataManager.o.DataOfRole;
			mainHeroInfo = CJDataManager.o.DataOfHeroList.getMainHero();
			
			//左边头像底图
			var leftBg:SImage = new SImage(SApplication.assets.getTexture("zhandouui_touxiangkuang"));
			leftBg.x = 0;
			leftBg.y = 0;
			CJBattleMapManager.o.topLayer.addChild(leftBg);
			//战斗力图
			var leftBattleeffect:SImage = new SImage(SApplication.assets.getTexture("wujiang_zhandouli"));
			leftBattleeffect.x = 46;
			leftBattleeffect.y = 14;
			leftBattleeffect.scaleX = 0.5;
			leftBattleeffect.scaleY = 0.5;
			CJBattleMapManager.o.topLayer.addChild(leftBattleeffect);	
			//左边头像
			var leftHead:SImage = new SImage(SApplication.assets.getTexture(mainHeroInfo.heroProperty.headicon));
			leftHead.x = -18;
			leftHead.y = -26;
			CJBattleMapManager.o.topLayer.addChild(leftHead);
			//右边头像底图
			var rightBg:SImage = new SImage(SApplication.assets.getTexture("zhandouui_touxiangkuang"));
			rightBg.x = SApplicationConfig.o.stageWidth;
			rightBg.y = 0;
			rightBg.scaleX = -1;
			CJBattleMapManager.o.topLayer.addChild(rightBg);
			//战斗力图
			var rightBattleeffect:SImage = new SImage(SApplication.assets.getTexture("wujiang_zhandouli"));
			rightBattleeffect.x = 340;
			rightBattleeffect.y = 14;
			rightBattleeffect.scaleX = 0.5;
			rightBattleeffect.scaleY = 0.5;
			CJBattleMapManager.o.topLayer.addChild(rightBattleeffect);
			//右边头像	 
			if(!SStringUtils.isEmpty(guankaBattale.headicon)) {
				var rightHead:SImage = new SImage(SApplication.assets.getTexture(guankaBattale.headicon));
				rightHead.x = SApplicationConfig.o.stageWidth - rightHead.width + 18;
				rightHead.y = -26;
				CJBattleMapManager.o.topLayer.addChild(rightHead);
			}
			//中间回合背景
			var roundBg:SImage = new SImage(SApplication.assets.getTexture("zhandouui_huihekuang"));
			roundBg.x = (SApplicationConfig.o.stageWidth - roundBg.width) / 2;
			roundBg.y = 0;
			CJBattleMapManager.o.topLayer.addChild(roundBg);
			//左战斗力
			var leftBattleeffectLabel:Label = new Label();
			leftBattleeffectLabel.x = leftBattleeffect.x + 52;
			leftBattleeffectLabel.y = leftBattleeffect.y + 1;
			leftBattleeffectLabel.textRendererFactory = textRender.glowTextRender;
			leftBattleeffectLabel.width = 81;
			var fontFormat:TextFormat = new TextFormat( "Arial", 8, 0xFEEB47,null,null,null,null,null, TextFormatAlign.LEFT);
			leftBattleeffectLabel.textRendererProperties.textFormat = fontFormat;
			leftBattleeffectLabel.text = "" + _leftBattleeffect;
			CJBattleMapManager.o.topLayer.addChild(leftBattleeffectLabel);
			//右战斗力
			var rightBattleeffectLabel:Label = new Label();
			rightBattleeffectLabel.x = rightBattleeffect.x + 52;
			rightBattleeffectLabel.y = rightBattleeffect.y + 1;
			rightBattleeffectLabel.textRendererFactory = textRender.glowTextRender;
			rightBattleeffectLabel.width = 81;
			rightBattleeffectLabel.textRendererProperties.textFormat = fontFormat;
			rightBattleeffectLabel.text = "" + _rightBattleeffect;
			CJBattleMapManager.o.topLayer.addChild(rightBattleeffectLabel);
			//左名字
			var leftNameLabel:Label = new Label();
			leftNameLabel.x = 52;
			leftNameLabel.y = 3;
			leftNameLabel.textRendererFactory = textRender.glowTextRender;
			leftNameLabel.width = 96;
			fontFormat = new TextFormat( "Arial", 8, 0xFFFFFF,null,null,null,null,null, TextFormatAlign.LEFT);
			leftNameLabel.textRendererProperties.textFormat = fontFormat;
			leftNameLabel.text = roleData.name;
			CJBattleMapManager.o.topLayer.addChild(leftNameLabel);
			//右名字
			var npcInfo:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(guankaBattale.name);
			var rightNameLabel:Label = new Label();
			rightNameLabel.x = SApplicationConfig.o.stageWidth - 52 - 96;
			rightNameLabel.y = 3;
			rightNameLabel.textRendererFactory = textRender.glowTextRender;
			rightNameLabel.width = 96;
			fontFormat = new TextFormat( "Arial", 8, 0xFFFFFF,null,null,null,null,null, TextFormatAlign.RIGHT);
			rightNameLabel.textRendererProperties.textFormat = fontFormat;
			rightNameLabel.text = CJLang(npcInfo.name);
			CJBattleMapManager.o.topLayer.addChild(rightNameLabel);
			//左等级
			var leftLevelLabel:Label = new Label();
			leftLevelLabel.x = 103;
			leftLevelLabel.y = 3;
			leftLevelLabel.textRendererFactory = textRender.glowTextRender;
			leftLevelLabel.width = 48;
			fontFormat = new TextFormat( "Arial", 8, 0xFEEB47,null,null,null,null,null, TextFormatAlign.RIGHT);
			leftLevelLabel.textRendererProperties.textFormat = fontFormat;
			leftLevelLabel.text = "LV " + mainHeroInfo.level;
			CJBattleMapManager.o.topLayer.addChild(leftLevelLabel);
			//右等级
			//			var rightLevelLabel:Label = new Label();
			//			rightLevelLabel.x = SApplicationConfig.o.stageWidth - 103 - 48;
			//			rightLevelLabel.y = 3;
			//			rightLevelLabel.textRendererFactory = textRender.glowTextRender;
			//			rightLevelLabel.width = 48;
			//			fontFormat = new TextFormat( "Arial", 8, 0xFEEB47,null,null,null,null,null, TextFormatAlign.LEFT);
			//			rightLevelLabel.textRendererProperties.textFormat = fontFormat;
			//			rightLevelLabel.text = "LV " + mainHeroInfo.level;
			//			CJBattleMapManager.o.topLayer.addChild(rightLevelLabel);
			
		}
	}
}