package SJ.Game.treasure
{
	import flash.geom.Rectangle;
	
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfTreasureList;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.util.CJTaskLabel;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.VAlign;
	
	/**
	 +------------------------------------------------------------------------------
	 * 灵丸界面UI
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-31 下午3:22:51  
	 +------------------------------------------------------------------------------
	 */
	public class CJTreasureLayer extends SLayer
	{
		//关闭按钮
		private var _btnClose:Button;
		private var _treasuerNumText:TextField;
		private var _scoreNumText:TextField;
		private var _silverNumText:TextField;
		private var _middlerPanel:CJTreasurePanelBase;
		private var _tempPanel:CJTreasureTempBagPanel;
		private var _indicatePanel:CJTreasureDirectPanel;
		
		public function CJTreasureLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._drawContent();
			this._addEventListeners();
		}
		
		private function _drawContent():void
		{
			var bg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waibiankuang02") , new Rectangle(16 , 16 , 1, 1)));
			bg.width = SApplicationConfig.o.stageWidth;
			bg.height = SApplicationConfig.o.stageHeight;
			bg.alpha = 0.8;
			this.addChild(bg);
			
			var line:SImage = new SImage(SApplication.assets.getTexture("common_fengetiao"));
			line.width = SApplicationConfig.o.stageWidth;
			line.height = 2;
			line.alpha = 0.8;
			line.y = 15;
			this.addChild(line);
			
			var infoBg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waibiankuang02") , new Rectangle(15 , 15 , 1, 1)));
			infoBg.width = 260;
			infoBg.height = 25;
			infoBg.x = 8;
			infoBg.y = 18;
			infoBg.alpha = 0.9;
			this.addChild(infoBg);
			
			_btnClose = new Button();
			_btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			_btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			_btnClose.x = 452;
			this.addChild(_btnClose);
			
			var titleImage:SImage = new SImage(SApplication.assets.getTexture("common_biaotikuang"));
			titleImage.x = 150;
			titleImage.width = 168;
			titleImage.height = 28;
			this.addChild(titleImage);
			
			var titleName:CJTaskLabel = new CJTaskLabel();
			titleName.fontFamily = ConstTextFormat.FONT_FAMILY_HEITI;
			titleName.fontSize = 14;
			titleName.colorText(CJLang('TREASURE_TITLE'),"#FFA800" , true);
			titleName.x = 210;
			titleName.y = 0;
			this.addChild(titleName);
			
			var leijilingqiName:CJTaskLabel = new CJTaskLabel();
			leijilingqiName.fontSize = 14;
			leijilingqiName.fontFamily = ConstTextFormat.FONT_FAMILY_LISHU;
			leijilingqiName.colorText(CJLang('TREASURE_BUTTON_leijilingqi'),"#EBFFB4");
			leijilingqiName.x = 19;
			leijilingqiName.y = 19;
			leijilingqiName.height = 15;
			this.addChild(leijilingqiName);
			
			var jifenName:CJTaskLabel = new CJTaskLabel();
			jifenName.fontSize = 14;
			jifenName.fontFamily = ConstTextFormat.FONT_FAMILY_LISHU;
			jifenName.colorText(CJLang('TREASURE_BUTTON_jifen'),"#EBFFB4");
			jifenName.x = 110;
			jifenName.y = 19;
			jifenName.height = 15;
			this.addChild(jifenName);
			
			var yinliangImage:SImage = new SImage(SApplication.assets.getTexture("common_yinliang"));
			yinliangImage.x = 190;
			yinliangImage.y = 24;
			this.addChild(yinliangImage);
			
			_treasuerNumText = new TextField(30 , 20 , "" , ConstTextFormat.FONT_FAMILY_Arial);
			_treasuerNumText.x = 77;
			_treasuerNumText.y = 19;
			_treasuerNumText.color = 0xEBFFB4;
			
			_scoreNumText = new TextField(30 , 20 , "", ConstTextFormat.FONT_FAMILY_Arial);
			_scoreNumText.x = 150;
			_scoreNumText.y = 19;
			_scoreNumText.color = 0xEBFFB4;
			
			_silverNumText = new TextField(42 , 26 , "", ConstTextFormat.FONT_FAMILY_Arial);
			_silverNumText.autoScale = true;
			_silverNumText.vAlign = VAlign.TOP;
			_silverNumText.x = 208;
			_silverNumText.y = 23;
			_silverNumText.color = 0xEBFFB4;
			
			this.addChild(_treasuerNumText);
			this.addChild(_scoreNumText);
			this.addChild(_silverNumText);
			_checkToShowContent();
		}
		
		/**
		 * 根据是否有灵丸确定显示哪个界面
		 */		
		private function _checkToShowContent():void
		{
			var treasureList:CJDataOfTreasureList = CJDataManager.o.DataOfTreasureList;
			_tempPanel = new CJTreasureTempBagPanel();
			_tempPanel.x = 7;
			_tempPanel.y = 40;
			_indicatePanel = new CJTreasureDirectPanel();
			_indicatePanel.x = 7;
			_indicatePanel.y = 40;
			this.addChild(_tempPanel);
			this.addChild(_indicatePanel);
			_tempPanel.visible =false;
			_indicatePanel.visible = true;
		}
		
		override protected function draw():void
		{
			super.draw();
			_treasuerNumText.text = "" + CJDataManager.o.DataOfTreasureUserInfo.treasurenum;
			_scoreNumText.text = "" + CJDataManager.o.DataOfTreasureUserInfo.scorenum;
			_silverNumText.text = ":" + CJDataManager.o.DataOfRole.silver;
//			确定显示哪个界面
			var treasureList:CJDataOfTreasureList = CJDataManager.o.DataOfTreasureList;
			if(treasureList.treasureTempBagList.length > 0 )
			{
				_indicatePanel.visible = false;	
				_tempPanel.visible = true;
			}
			else
			{
				_indicatePanel.visible = true;	
				_tempPanel.visible = false;
			}
		}
		
		private function _addEventListeners():void
		{
			this._btnClose.addEventListener(Event.TRIGGERED , this._closePanel);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_TREASURE_DATA_CHANGE , this.invalidate);
		}
		
		private function _closePanel(e:Event):void
		{
			SApplication.moduleManager.exitModule("CJTreasureModule");
		}
	}
}