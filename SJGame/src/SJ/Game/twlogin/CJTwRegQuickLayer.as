package SJ.Game.twlogin
{
	import flash.geom.Rectangle;
	
	import SJ.MainApplication;
	import SJ.Common.Constants.ConstRegistAccount;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.Platform.ISPlatfrom;
	import SJ.Game.Platform.SPlatform9splay;
	import SJ.Game.controls.CJButtonUtil;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.event.CJEvent;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.TextInput;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class CJTwRegQuickLayer extends CJTwBgLayer
	{
		private var accountTextInput:TextInput
		private var passwordTextInput:TextInput
		private var content:SLayer;
		private var oldpwd:String;
		public function CJTwRegQuickLayer()
		{
			super();
		}
		override protected function initialize():void
		{
			super.initialize();
			this.setSize(background.width,background.height);
			content = new SLayer;
			initContent();
		}
		private function initContent():void
		{
			var bg : Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew") , new Rectangle(2 , 2 , 1, 1)));
			bg.width = 340;
			bg.height = 190;
			content.addChild(bg);
			content.x = (this.width - bg.width)>>1;
			content.y = (this.height - bg.height)>>1;
			this.addChild(content);
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(333 , 183);
			bgBall.x = 5;
			bgBall.y = 5;
			content.addChild(bgBall);
			
			//底框
			var bgWrap:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangnew") , new Rectangle(10 , 10 , 3, 3)));
			bgWrap.width = bg.width;
			bgWrap.height = bg.height;
			content.addChild(bgWrap);	
			
			var titleImg:SImage = new SImage(SApplication.assets.getTexture("common_tounew"));
			titleImg.width = 340;
			titleImg.y = -15;
			content.addChild(titleImg);
			
			var tigleSign:SImage = new SImage(SApplication.assets.getTexture("shizitou"));
			tigleSign.x = 131;
			tigleSign.y = -26;
			content.addChild(tigleSign);
			
			var btnClose:Button = new Button;
			var btntxture:Texture = SApplication.assets.getTexture("common_guanbianniu01new");
			btnClose.defaultSkin = new SImage(btntxture);
			btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			btnClose.addEventListener(Event.TRIGGERED,function(e:*):void{
				dispatchEventWith(CJEvent.EVENT_NINESPLAY_CLOSE_REGQUICK);
			});
			btnClose.x = 319;
			btnClose.y = -19;
			content.addChild(btnClose);
			
			var titleText:Label = new Label;
			titleText.text = CJLang("TW_REGISETER_QUICK_TXT");
			titleText.x = 112;
			titleText.y = 23;
			titleText.textRendererProperties.textFormat = ConstTextFormat.twtitletextformat;
			content.addChild(titleText);
			
			var accountText:Label = new Label;
			accountText.text = CJLang("TW_ACCOUNT");
			accountText.x = 16;
			accountText.y = 60;
			accountText.textRendererProperties.textFormat = ConstTextFormat.twnormaltextformat;
			content.addChild(accountText);
			
			var passwordText:Label = new Label;
			passwordText.text = CJLang("TW_PASSWORD");
			passwordText.x = 16;
			passwordText.y = 107;
			passwordText.textRendererProperties.textFormat = ConstTextFormat.twnormaltextformat;
			content.addChild(passwordText);
			
			var accountBgTexture:Scale9Textures = new Scale9Textures(SApplication.assets.getTexture("kuang"),new Rectangle(12,14,16,16));
			var accountInputBg:Scale9Image = new Scale9Image(accountBgTexture);
			accountInputBg.width = 158;
			accountInputBg.height = 31;
			accountInputBg.x = 75;
			accountInputBg.y = 52;
			content.addChild(accountInputBg);
			
			var pwdBgTexture:Scale9Textures = new Scale9Textures(SApplication.assets.getTexture("kuang"),new Rectangle(12,14,16,16));
			var pwdInputBg:Scale9Image = new Scale9Image(pwdBgTexture);
			pwdInputBg.width = 158;
			pwdInputBg.height = 31;
			pwdInputBg.x = 75;
			pwdInputBg.y = 96;
			content.addChild(pwdInputBg);
			
			accountTextInput = new TextInput;
			var fontFormat:Object = accountTextInput.textEditorProperties; 
			fontFormat.fontFamily = "宋体";
			fontFormat.color = 0xFFFFFFFF;
			fontFormat.displayAsPassword = false;
			fontFormat.fontSize = 20;
			fontFormat.maxChars = 10;
			fontFormat.restrict = ConstRegistAccount.ConstUsernameRestrict;
			accountTextInput.textEditorProperties = fontFormat;
			accountTextInput.width = accountInputBg.width;
			accountTextInput.height = accountInputBg.height;
			accountTextInput.x = accountInputBg.x + 2;
			accountTextInput.y = accountInputBg.y + 4;
			accountTextInput.isEditable = false;
			content.addChild(accountTextInput);
			
			passwordTextInput = new TextInput;
			fontFormat = passwordTextInput.textEditorProperties
			fontFormat.fontFamily = "宋体";
			fontFormat.color = 0xFFFFFFFF;
//			fontFormat.displayAsPassword = true;
			fontFormat.fontSize = 20;
			fontFormat.maxChars = 18;
			fontFormat.restrict = ConstRegistAccount.ConstPasswordRestrict;
			passwordTextInput.textEditorProperties = fontFormat;
			passwordTextInput.width = pwdInputBg.width;
			passwordTextInput.height = pwdInputBg.height;
			passwordTextInput.x = pwdInputBg.x + 2;
			passwordTextInput.y = pwdInputBg.y + 4;
			content.addChild(passwordTextInput)
			
			var loginBtn:Button = CJButtonUtil.createCommonButton(CJLang("TW_LOGIN"));
			loginBtn.x = 111;
			loginBtn.y = 141;
			loginBtn.addEventListener(Event.TRIGGERED,function(e:Event):void
			{
				var iPlatform:ISPlatfrom = (SApplication.appInstance as MainApplication).platform;
				(iPlatform as SPlatform9splay).register(accountTextInput.text,passwordTextInput.text);
			});
			content.addChild(loginBtn);
			
			var modifyBtn:Button = CJButtonUtil.createCommonButton(CJLang("TW_MODIFYPASSWORD"));
			modifyBtn.addEventListener(Event.TRIGGERED,function(e:Event):void
			{
				var iPlatform:ISPlatfrom = (SApplication.appInstance as MainApplication).platform;
				(iPlatform as SPlatform9splay).modifyPwd(accountTextInput.text,oldpwd,passwordTextInput.text);
			});
			modifyBtn.x = 237;
			modifyBtn.y = 103;
			content.addChild(modifyBtn);
		}
		public function set username(name:String):void
		{
			accountTextInput.text = name;
		}
		public function set password(pwd:String):void
		{
			passwordTextInput.text = pwd;
			oldpwd = pwd;
		}
	}
}