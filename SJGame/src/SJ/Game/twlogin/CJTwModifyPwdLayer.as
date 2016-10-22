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
	import SJ.Game.layer.CJMessageBox;
	
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
	
	public class CJTwModifyPwdLayer extends CJTwBgLayer
	{
		private var accountTextInput:TextInput;
		private var passwordTextInput:TextInput;
		private var oldPwd:String;
		private var content:SLayer;
		public function CJTwModifyPwdLayer()
		{
			super();
			this.setSize(background.width,background.height);
			content = new SLayer;
			initContent();
		}
		private function initContent():void
		{
			var bg : Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew") , new Rectangle(2 , 2 , 1, 1)));
			bg.width = 340;
			bg.height = 225;
			content.addChild(bg);
			content.x = (this.width - bg.width)>>1;
			content.y = (this.height - bg.height)>>1;
			this.addChild(content);
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(bg.width-7 , bg.height-7);
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
				dispatchEventWith(CJEvent.EVENT_NINESPLAY_CLOSE_MODIFYPWD)
			});
			btnClose.x = 319;
			btnClose.y = -19;
			content.addChild(btnClose);
			
			var titleText:Label = new Label;
			titleText.text = CJLang("TW_MODIFYPASSWORD");
			titleText.x = 129;
			titleText.y = 23;
			titleText.textRendererProperties.textFormat = ConstTextFormat.twtitletextformat;
			content.addChild(titleText);
			
			var accountText:Label = new Label;
			accountText.text = CJLang("TW_ACCOUNT");
			accountText.x = 58;
			accountText.y = 54;
			accountText.textRendererProperties.textFormat = ConstTextFormat.twnormaltextformat;
			content.addChild(accountText);
			
			var passwordText:Label = new Label;
			passwordText.text = CJLang("TW_NEWPWD");
			passwordText.x = 58;
			passwordText.y = 100;
			passwordText.textRendererProperties.textFormat = ConstTextFormat.twnormaltextformat;
			content.addChild(passwordText);
			
			var surePasswordText:Label = new Label;
			surePasswordText.text = CJLang("TW_SUREPASSWORD");
			surePasswordText.x = 20;
			surePasswordText.y = 146;
			surePasswordText.textRendererProperties.textFormat = ConstTextFormat.twnormaltextformat;
			content.addChild(surePasswordText);
			
			var accountBgTexture:Scale9Textures = new Scale9Textures(SApplication.assets.getTexture("kuang"),new Rectangle(12,14,16,16));
			var accountInputBg:Scale9Image = new Scale9Image(accountBgTexture);
			accountInputBg.width = 158;
			accountInputBg.height = 31;
			accountInputBg.x = 121;
			accountInputBg.y = 52;
			content.addChild(accountInputBg);
			
			var pwdBgTexture:Scale9Textures = new Scale9Textures(SApplication.assets.getTexture("kuang"),new Rectangle(12,14,16,16));
			var pwdInputBg:Scale9Image = new Scale9Image(pwdBgTexture);
			pwdInputBg.width = 158;
			pwdInputBg.height = 31;
			pwdInputBg.x = 121;
			pwdInputBg.y = 96;
			content.addChild(pwdInputBg);
			
			var surePwdBgTexture:Scale9Textures = new Scale9Textures(SApplication.assets.getTexture("kuang"),new Rectangle(12,14,16,16));
			var surePwdInputBg:Scale9Image = new Scale9Image(pwdBgTexture);
			surePwdInputBg.width = 158;
			surePwdInputBg.height = 31;
			surePwdInputBg.x = 121;
			surePwdInputBg.y = 138;
			content.addChild(surePwdInputBg);
			
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
			accountTextInput.x = accountInputBg.x;
			accountTextInput.y = accountInputBg.y;
			accountTextInput.isEditable = false;
			content.addChild(accountTextInput);
			
			passwordTextInput = new TextInput;
			fontFormat = passwordTextInput.textEditorProperties
			fontFormat.fontFamily = "宋体";
			fontFormat.color = 0xFFFFFFFF;
			fontFormat.displayAsPassword = true;
			fontFormat.fontSize = 20;
			fontFormat.maxChars = 18;
			fontFormat.restrict = ConstRegistAccount.ConstPasswordRestrict;
			passwordTextInput.textEditorProperties = fontFormat;
			passwordTextInput.width = pwdInputBg.width;
			passwordTextInput.height = pwdInputBg.height;
			passwordTextInput.x = pwdInputBg.x + 6;
			passwordTextInput.y = pwdInputBg.y + 2;
			content.addChild(passwordTextInput)
			
			
			var surePasswordTextInput:TextInput = new TextInput;
			fontFormat = surePasswordTextInput.textEditorProperties
			fontFormat.fontFamily = "宋体";
			fontFormat.color = 0xFFFFFFFF;
			fontFormat.displayAsPassword = true;
			fontFormat.fontSize = 20;
			fontFormat.maxChars = 18;
			fontFormat.restrict = ConstRegistAccount.ConstPasswordRestrict;
			surePasswordTextInput.textEditorProperties = fontFormat;
			surePasswordTextInput.width = surePwdInputBg.width;
			surePasswordTextInput.height = surePwdInputBg.height;
			surePasswordTextInput.x = surePwdInputBg.x + 6;
			surePasswordTextInput.y = surePwdInputBg.y + 2;
			content.addChild(surePasswordTextInput)
			
			var loginBtn:Button = CJButtonUtil.createCommonButton(CJLang("COMMON_TRUE"));
			loginBtn.x = 111;
			loginBtn.y = 178;
			loginBtn.addEventListener(Event.TRIGGERED,function(e:Event):void
			{
				if(checkValid(passwordTextInput.text,surePasswordTextInput.text))
				{
					var iPlatform:ISPlatfrom = (SApplication.appInstance as MainApplication).platform;
					(iPlatform as SPlatform9splay).modifyPwd(accountTextInput.text,this.oldPwd,passwordTextInput.text);
				}
			});
			content.addChild(loginBtn);
		}
		
		public function set account(name:String):void
		{
			accountTextInput.text = name;
		}
		public function set oldpwd(pwd:String):void
		{
			this.oldPwd = pwd;
		}
		public function get newpwd():String
		{
			return passwordTextInput.text
		}
		public function get account():String
		{
			return accountTextInput.text;
		}
		
		private function checkValid(password:String,npassword:String):Boolean
		{
			// 检测密码长度是否在6～12之间
			if (password.length < ConstRegistAccount.ConstMinPassWordCount || npassword.length < ConstRegistAccount.ConstMinPassWordCount)
			{
				CJMessageBox(CJLang("ERROR_LOGIN_PASSWD_LEN"));
				return false;
			}
			// 检测帐号是否与密码相同
			if (password != npassword)
			{
				CJMessageBox(CJLang("TW_PASSWORD_UNSAME"));
				return false;
			}
			return true;
		}
	}
}