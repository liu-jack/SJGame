package SJ.Game.arena
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.json.Json_arena_award_setting;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBoxLayer;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Label;
	
	public class CJArenaBattleConfirmContent extends CJConfirmMessageBoxLayer
	{
		private var titleLabel:Label
		private var configData:Json_arena_award_setting
		private var failData:Json_arena_award_setting
		public function CJArenaBattleConfirmContent()
		{
			super();
		}
		private var _succSilverLabel:Label
		private var _succCreditLabel:Label
		private var _succExpLabel:Label
		private var _failSilverLabel:Label
		private var _failCreditLabel:Label
		private var _failExpLabel:Label
		
		
		override protected function initialize():void
		{
			super.initialize();
			_init();
		}
		private function _init():void
		{
			
			titleLabel = new Label
			titleLabel.textRendererProperties.textFormat = ConstTextFormat.arenarankwhite
			titleLabel.text = CJLang("ARENA_CONFIRM_BATTLE")
			titleLabel.x = 41;
			titleLabel.y = 26;
			this.addChild(titleLabel);
			
			var awardSucc:Label = new Label
			awardSucc.textRendererProperties.textFormat = ConstTextFormat.arenaBattleFormat
			awardSucc.x = 7;
			awardSucc.y = 59;
			awardSucc.text = CJLang("ARENA_AWARD_SUCC")
			this.addChild(awardSucc)
				
			var awardFail:Label = new Label
			awardFail.textRendererProperties.textFormat = ConstTextFormat.arenaBattleFormat
			awardFail.x = 7;
			awardFail.y = 82;
			awardFail.text = CJLang("ARENA_AWARD_FAIL")
			this.addChild(awardFail)
				
			_succSilverLabel = new Label
			_succSilverLabel.textRendererProperties.textFormat = ConstTextFormat.arenaRetFormat
			_succSilverLabel.x = 90
			_succSilverLabel.y = 58
			this.addChild(_succSilverLabel);
			
			_succCreditLabel = new Label
			_succCreditLabel.textRendererProperties.textFormat = ConstTextFormat.arenaRetFormat
			_succCreditLabel.x = 140
			_succCreditLabel.y = 58
			this.addChild(_succCreditLabel);
			
			_succExpLabel = new Label
			_succExpLabel.textRendererProperties.textFormat = ConstTextFormat.arenaRetFormat
			_succExpLabel.x = 200
			_succExpLabel.y = 58
			this.addChild(_succExpLabel);
			
			_failSilverLabel = new Label
			_failSilverLabel.textRendererProperties.textFormat = ConstTextFormat.arenaRetFormat
			_failSilverLabel.x = 90
			_failSilverLabel.y = 86
			this.addChild(_failSilverLabel);
			
			_failCreditLabel = new Label
			_failCreditLabel.textRendererProperties.textFormat = ConstTextFormat.arenaRetFormat
			_failCreditLabel.x = 140
			_failCreditLabel.y = 86
			this.addChild(_failCreditLabel);
			
			_failExpLabel = new Label
			_failExpLabel.textRendererProperties.textFormat = ConstTextFormat.arenaRetFormat
			_failExpLabel.x = 200
			_failExpLabel.y = 86
			this.addChild(_failExpLabel);
			
			var silverImage:SImage = new SImage(SApplication.assets.getTexture("common_yinliang"))
			silverImage.x = 75;
			silverImage.y = 60;
			this.addChild(silverImage);
			
			var silverImage2:SImage = new SImage(SApplication.assets.getTexture("common_yinliang"))
			silverImage2.x = 75;
			silverImage2.y = 88;
			this.addChild(silverImage2);
			//声望图标
			var creditImage:SImage = new SImage(SApplication.assets.getTexture("jingjichang_tubiaoshengwang"));
			creditImage.x = 119
			creditImage.y = 55;
			creditImage.scaleX = creditImage.scaleY = 0.7;
			this.addChild(creditImage);
			
			var creditImage2:SImage = new SImage(SApplication.assets.getTexture("jingjichang_tubiaoshengwang"));
			creditImage2.x = 119
			creditImage2.y = 83;
			creditImage2.scaleX = creditImage2.scaleY = 0.7;
			this.addChild(creditImage2);
			
			//声望图标
			var expImage:SImage = new SImage(SApplication.assets.getTexture("exp"));
			expImage.x = 165
			expImage.y = 60;
			this.addChild(expImage);
			
			var expImage2:SImage = new SImage(SApplication.assets.getTexture("exp"));
			expImage2.x = 165
			expImage2.y = 88;
			this.addChild(expImage2);
			
			_succSilverLabel.text = configData.succsilver
			_succCreditLabel.text = configData.succcredit
			_failSilverLabel.text = failData.failsilver
			_failCreditLabel.text = failData.failcredit;
			_succExpLabel.text = configData.succexp;
			_failExpLabel.text = failData.failexp;
		}
		
		public function updateTitle(roleName:String):void
		{
			titleLabel.text = titleLabel.text.replace("{rolename}",roleName)
		}
		public function updateData(awardData:Json_arena_award_setting,failAwardData:Json_arena_award_setting):void
		{
			configData = awardData
			failData = failAwardData
		}
	}
}