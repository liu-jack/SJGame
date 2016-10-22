package SJ.Game.formation
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	import SJ.Game.data.json.Json_function_open_setting;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.data.SDataBase;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.display.Quad;
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 战前阵型布局UI
	 * @comment 阵型控件布局
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-3-30 下午1:39:29  
	 +------------------------------------------------------------------------------
	 */
	public class CJFormationLayer extends SLayer
	{
		/*关闭按钮*/
		private var _btnClose:Button;
		/*开始战斗按钮*/
		private var _btnStartBattle:Button;
		/*当前触碰的武将item对象*/
		private var _touchHero:CJItemHero = null;
		/*放置在阵型上的npc*/
		private var _heroNPCList:Array = null;

		private var squarePanel:CJFormationSquarePanel;

		private var heroPanel:CJFormationHeroPanel;

		private var skillPanel:CJFormationSkillPanel;
		/*指引寻路方块*/
		private var _directQuad1:Quad;
		private var _directQuad2:Quad;
		
		private var _btnBattleStartCallback:Function = null;
		
		public function CJFormationLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			this._drawContent();
			this._addLiteners();
			this.setSize(365, 275);
			
			//检测是否已经开启过引导  1 = 开启过
			var directed:int = CJDataManager.o.DataOfFormation.formationDirected;
			if(directed == 0)
			{
				var formationDirectData:SDataBase = new SDataBase("CJDataOfFormation");
				formationDirectData.loadFromCache();
				//是否已经开启过
				CJDataManager.o.DataOfFormation.formationDirected = int(formationDirectData.getData("formationdirected"));
				
				//如果需要显示开启引导
				if(CJDataManager.o.DataOfFormation.formationDirected == 0 && int(CJDataManager.o.DataOfHeroList.getMainHero().level) <= 10)
				{
					var json:Json_function_open_setting = CJDataOfFuncPropertyList.o.getPropertyByModulename("CJFormationModule");
					if(json)
					{
						SApplication.moduleManager.enterModule("CJFunctionOpenModule" , json.functionid);
						formationDirectData.setData("formationdirected" , 1);
						formationDirectData.saveToCache();
						CJDataManager.o.DataOfFormation.formationDirected = 1;
					}
				}
			}
			
		}
		
		private function _drawContent():void
		{
			//背景
			var bg:SImage = new SImage(SApplication.assets.getTexture("zhenxing_beijing"));
			bg.x = 35;
			bg.y = 16;
			bg.scaleX = bg.scaleY = 2;
			bg.alpha = 0.9;
			this.addChild(bg);
			
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(357 , 267);
			bgBall.x = 32;
			bgBall.y = 10;
			this.addChild(bgBall);
			
			//背景框
			var bgFrame:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangnew") , new Rectangle(15 , 15 , 1, 1)));
			bgFrame.width = 365;
			bgFrame.height = 275;
			bgFrame.x = 28;
			bgFrame.y = 6;
			this.addChild(bgFrame);
			
			//边角装饰
			var dec:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangzhuangshinew") , new Rectangle(66,30 , 1,1)));
			dec.width = 345;
			dec.height = 253;
			dec.x = 38;
			dec.y = 17;
			this.addChild(dec);
			
			//关闭按钮
			_btnClose = new Button();
			_btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			_btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			_btnClose.x = 369;
			_btnClose.y = -13;
			this.addChild(_btnClose);
			
			//标头
			var title:CJPanelTitle = new CJPanelTitle(CJLang("TITLE_ZHENXING"));
			this.addChild(title);
			title.x = ((SApplicationConfig.o.stageWidth - title.width) >> 1) -50;
			title.y = -7;
			
			//左侧武将面板
			heroPanel = new CJFormationHeroPanel();
			heroPanel.x = -37;
			heroPanel.y = 8;
			heroPanel.width = 66;
			heroPanel.height = 275;
			this.addChild(heroPanel);
			
			//中间阵型
			squarePanel = new CJFormationSquarePanel();
			squarePanel.x = 43;
			squarePanel.y = 13;
			squarePanel.width = 273;
			squarePanel.height = 240;
			this.addChild(squarePanel);
			
			//右侧技能面板
			skillPanel = new CJFormationSkillPanel();
			skillPanel.x = 317;
			skillPanel.y = 20;
			skillPanel.width = 64;
			skillPanel.height = 240;
			this.addChild(skillPanel);
			
			
			_directQuad1 = new Quad(80 , 90);
			_directQuad1.alpha = 0;
			_directQuad1.touchable = false;
			_directQuad1.x = 95;
			_directQuad1.y = 110;
			_directQuad1.name = "CJFormation_4";
			this.addChild(_directQuad1);
			
			_directQuad2 = new Quad(80 , 45);
			_directQuad2.alpha = 0;
			_directQuad2.touchable = false;
			_directQuad2.x = 175;
			_directQuad2.y = 155;
			_directQuad2.name = "CJFormation_1";
			this.addChild(_directQuad2);
			
			
			_btnStartBattle = new Button();
			_btnStartBattle.x = 230;
			_btnStartBattle.y = 234;
			_btnStartBattle.width = 82;
			_btnStartBattle.height = 37;
			_btnStartBattle.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_btnStartBattle.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_btnStartBattle.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xFFEFBD);
			_btnStartBattle.label = CJLang("DYNAMIC_START_FIGHT");
			this._btnStartBattle.addEventListener(Event.TRIGGERED , this._startBattle);
			this.addChild(_btnStartBattle);
			_btnStartBattle.visible = false;
		}
		
		override public function dispose():void
		{
			heroPanel = null;
			squarePanel = null;
			skillPanel = null;
			super.dispose();
		}
		
		/**
		 * 添加相关监听器
		 */
		private function _addLiteners():void
		{
			this._btnClose.addEventListener(Event.TRIGGERED , this._closeDialog);
		}
		/**
		 * 开始战斗
		 * @param e
		 * 
		 */		
		private function _startBattle(e:Event):void
		{
//			_btnStartBattle.isEnabled = false;
			SSoundEffectUtil.playTipSound();
			if(_btnBattleStartCallback!=null)
			{
				_btnBattleStartCallback();
			}
		}
		private function _closeDialog(e:Event):void
		{
			SApplication.moduleManager.exitModule(CJFormationModule.MOUDLE_NAME);
		}
		
		public function get btnClose():Button
		{
			return _btnClose;
		}

		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}
		
		public function set btnStartBattleVisible(value:Boolean):void
		{
			_btnStartBattle.visible = value
			this.invalidate();
		}
		
		public function set btnStartBattleCallback(cb:Function):void
		{
			this._btnBattleStartCallback = cb;
		}
	}
}