package SJ.Game.arena
{
	import SJ.Common.Constants.ConstBattle;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.controls.CJButtonUtil;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.task.util.CJTaskHtmlUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import starling.events.Event;
	
	public class CJArenaResult extends SLayer
	{
		private var _creditLabel:Label
		private var _silverLabel:Label
		private var _expLabel:Label
		private var succTitleImage:SImage
		private var failTitleImage:SImage 
		public function CJArenaResult()
		{
			super();
			this.setSize(200,160)
			_init()
			setTitle();
			awardImage();
		}
		private function _init():void
		{
			var texture:Scale9Textures = new Scale9Textures(SApplication.assets.getTexture("common_tishikuang"),new Rectangle(16,15,2,2))
			var bg:Scale9Image = new Scale9Image(texture)
			bg.width = this.width;
			bg.height = this.height;
			this.addChild(bg);
		}
		
		private function setTitle():void
		{
			succTitleImage = new SImage(SApplication.assets.getTexture("jingjichang_shengli"));
			succTitleImage.visible = false;
			succTitleImage.x = 42;
			succTitleImage.y = -15;
			this.addChild(succTitleImage)
				
			failTitleImage = new SImage(SApplication.assets.getTexture("jingjichang_shibai"));
			failTitleImage.visible = false;
			failTitleImage.x = 42;
			failTitleImage.y = -15;
			this.addChild(failTitleImage);
		}
		
		private function awardImage():void
		{
			//银两图标
			var silverImage:SImage = new SImage(SApplication.assets.getTexture("common_yinliang"))
			silverImage.x = 98;
			silverImage.y = 32;
			this.addChild(silverImage);
			//声望图标
			var creditImage:SImage = new SImage(SApplication.assets.getTexture("jingjichang_tubiaoshengwang"));
			creditImage.x = 98
			creditImage.y = 60;
			this.addChild(creditImage);
			
			var expImage:SImage = new SImage(SApplication.assets.getTexture("exp"));
			expImage.x = 98
			expImage.y = 94;
			this.addChild(expImage);
			
			var awardText:Label = new Label
			awardText.text = CJLang("NPCDIALOG_REWARD");
			awardText.textRendererProperties.textFormat = ConstTextFormat.arenaTextFormat
			awardText.x = 30
			awardText.y = 27
			this.addChild(awardText)
				
			var awardText2:Label = new Label
			awardText2.text = CJLang("NPCDIALOG_REWARD");
			awardText2.textRendererProperties.textFormat = ConstTextFormat.arenaTextFormat
			awardText2.x = 30
			awardText2.y = 59
			this.addChild(awardText2)
			
			var awardText3:Label = new Label
			awardText3.text = CJLang("NPCDIALOG_REWARD");
			awardText3.textRendererProperties.textFormat = ConstTextFormat.arenaTextFormat
			awardText3.x = 30
			awardText3.y = 85
			this.addChild(awardText3)
				
			var zhidaoBtn:Button = CJButtonUtil.createCommonButton(CJLang("ARENA_KNOW"));
			zhidaoBtn.labelOffsetY = -1;
			zhidaoBtn.addEventListener(Event.TRIGGERED,clickHandler)
			zhidaoBtn.x = 65
			zhidaoBtn.y = 117;
			this.addChild(zhidaoBtn);
			
			_creditLabel = new Label
			_creditLabel.textRendererFactory = textRender.htmlTextRender;
			_creditLabel.x = 135
			_creditLabel.y = 60
			this.addChild(_creditLabel)
				
			_silverLabel = new Label
			_silverLabel.textRendererFactory = textRender.htmlTextRender;
			_silverLabel.x = 135;
			_silverLabel.y = 32;
			this.addChild(_silverLabel);
			
			_expLabel = new Label
			_expLabel.textRendererFactory = textRender.htmlTextRender;
			_expLabel.x = 135;
			_expLabel.y = 90;
			this.addChild(_expLabel);
		}
		
		public function updateAward(data:Object):void
		{
			_creditLabel.text = CJTaskHtmlUtil.colorText(data['award']['credit'] , "#FFFFFF");
			_silverLabel.text = CJTaskHtmlUtil.colorText(data['award']['silver'] , "#FFFFFF");
			_expLabel.text = CJTaskHtmlUtil.colorText(data['award']['exp'] , "#FFFFFF");
			if(int(data['result']) == ConstBattle.BattleResultSuccess)
			{
				succTitleImage.visible = true;
				failTitleImage.visible = false;
			}
			else
			{
				succTitleImage.visible = false;
				failTitleImage.visible = true;
			}
		}
		
		private function clickHandler(e:Event):void
		{
			this.removeFromParent(true);
			SApplication.moduleManager.exitModule("CJArenaBattleModule");
			SApplication.moduleManager.enterModule("CJArenaModule");
		}
	}
}