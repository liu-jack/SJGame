package SJ.Game.duobao
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstBattle;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.controls.CJButtonUtil;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	
	public class CJDuoBaoBattleResultLayer extends SLayer
	{
		private var _silverLabel:Label
		private var succTitleImage:SImage
		private var failTitleImage:SImage 
		public function CJDuoBaoBattleResultLayer()
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
			succTitleImage = new SImage(SApplication.assets.getTexture("duobao_shengli"));
			succTitleImage.visible = false;
			succTitleImage.x = 42;
			succTitleImage.y = -15;
			this.addChild(succTitleImage)
			
			failTitleImage = new SImage(SApplication.assets.getTexture("duobao_shibai"));
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
			silverImage.y = 70;
			this.addChild(silverImage);
			
			var awardText:Label = new Label
			awardText.text = CJLang("DUOBAO_BATTLE_REWARD");
			awardText.textRendererProperties.textFormat = ConstTextFormat.arenaTextFormat
			awardText.x = 30
			awardText.y = 63
			this.addChild(awardText)
			
			var zhidaoBtn:Button = CJButtonUtil.createCommonButton(CJLang("DUOBAO_BATTLE_SURE"));
			zhidaoBtn.labelOffsetY = -1;
			zhidaoBtn.addEventListener(Event.TRIGGERED,clickHandler)
			zhidaoBtn.x = 65
			zhidaoBtn.y = 117;
			this.addChild(zhidaoBtn);
			
			_silverLabel = new Label
			_silverLabel.textRendererFactory = textRender.htmlTextRender;	
			_silverLabel.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFFFFFF);
			_silverLabel.x = 135;
			_silverLabel.y = 68;
			this.addChild(_silverLabel);
		}
		
		public function updateAward(data:Object):void
		{
			_silverLabel.text = data["usereward"];
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
			SApplication.moduleManager.exitModule("CJDuoBaoBattleModule");
			SApplication.moduleManager.enterModule("CJDuoBaoModule");
		}
	}
}