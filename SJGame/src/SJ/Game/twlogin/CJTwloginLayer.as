package SJ.Game.twlogin
{
	import SJ.MainApplication;
	import SJ.Common.Constants.ConstRegistAccount;
	import SJ.Game.Platform.ISPlatfrom;
	import SJ.Game.Platform.SPlatform9splay;
	import SJ.Game.controls.CJButtonUtil;
	import SJ.Game.event.CJEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.TextInput;
	
	import starling.events.Event;
	
	public class CJTwloginLayer extends SLayer
	{
		private var _quickRegLayer:CJTwRegQuickLayer;
		private var _regLayer:CJTwRegLayer;
		private var _modPwdLayer:CJTwModifyPwdLayer;
		private var passwordLogin:TextInput;
		private var accountLogin:TextInput;
		public function CJTwloginLayer()
		{
			super();
		}
		override protected function initialize():void
		{
			super.initialize();
			initListener();
			var iPlatform:ISPlatfrom = (SApplication.appInstance as MainApplication).platform;
			var loginBg:SImage = new SImage(SApplication.assets.getTexture("loginbg"));
			this.addChildAt(loginBg,0);
			//快速注册
			var regQuickBtn:Button = this.getChildByNameDeep("regquickbtn") as Button;
			CJButtonUtil.createLoginBtn(regQuickBtn,CJLang("TW_REGISETER_QUICK_TXT"));
			var own:SLayer = this;
			regQuickBtn.addEventListener(Event.TRIGGERED,function(e:*):void{
				(iPlatform as SPlatform9splay).registerQuick()
			});
			//登入按钮
			var loginBtn:Button = this.getChildByNameDeep("loginbtn") as Button;
			loginBtn.addEventListener(Event.TRIGGERED,function(e:Event):void
			{
				(iPlatform as SPlatform9splay).loginPlat(accountLogin.text,passwordLogin.text);
			});
			CJButtonUtil.createLoginBtn(loginBtn,CJLang("TW_LOGIN"));
			//注册按钮
			var regBtn:Button = this.getChildByNameDeep("registerbtn") as Button;
			regBtn.addEventListener(Event.TRIGGERED,function(e:Event):void
			{
				if(_regLayer == null)
				{
					_regLayer = new CJTwRegLayer;
					_regLayer.addEventListener(CJEvent.EVENT_NINESPLAY_CLOSE_REG,function():void
					{
						_regLayer.removeFromParent(true);
						own.visible = true;
						_regLayer = null;
					})
				}
				CJLayerManager.o.addModuleLayer(_regLayer);
				own.visible = false;
			});
			CJButtonUtil.createLoginBtn(regBtn,CJLang("TW_REGISTER"));
			
			//修改密码
			var modifyBtn:Button = this.getChildByNameDeep("modpasswd") as Button;
			CJButtonUtil.createLoginBtn(modifyBtn,CJLang("TW_MODIFYPASSWORD"));
			modifyBtn.addEventListener(Event.TRIGGERED,function(e:Event):void
			{
				openModPwdLayer(accountLogin.text,passwordLogin.text);
			});
			
			accountLogin = new TextInput;
			accountLogin.x = 142;
			accountLogin.y = 127;
			accountLogin.width = (this.getChildByNameDeep("account") as ImageLoader).width;
			accountLogin.height = (this.getChildByNameDeep("account") as ImageLoader).height;
			
			passwordLogin = new TextInput;
			passwordLogin.x = 142;
			passwordLogin.y = 174;
			//				var temp:Texture;
			//				// 登录按钮
			//				temp = SApplication.assets.getTexture("denglu_denglu0");
			//				_btnLogin.defaultSkin = new SImage(temp);
			//				temp = SApplication.assets.getTexture("denglu_denglu1");
			//				_btnLogin.downSkin = new SImage(temp);
			//				
			//				_btnLogin.addEventListener(starling.events.Event.TRIGGERED,function(e:*):void{
			//					_Login();
			//				});
			//				
			// 登录输入框设置字体
			var fontFormat:Object = accountLogin.textEditorProperties;
			fontFormat.fontFamily = "宋体";
			fontFormat.color = 0xFFFFFFFF;
			fontFormat.displayAsPassword = false;
			fontFormat.multiline = false;
			fontFormat.fontSize = 20;
			fontFormat.maxChars = ConstRegistAccount.ConstMaxAccountCount;
			fontFormat.restrict = ConstRegistAccount.ConstUsernameRestrict;
			accountLogin.textEditorProperties = fontFormat;
			accountLogin.text = "";
			this.addChild(accountLogin);
			//				
			fontFormat = passwordLogin.textEditorProperties;
			fontFormat.fontFamily = "宋体";
			fontFormat.color = 0xFFFFFFFF;
			fontFormat.displayAsPassword = true;
			fontFormat.multiline = false;
			fontFormat.fontSize = 20;
			fontFormat.maxChars = ConstRegistAccount.ConstMaxPassWordCount;
			fontFormat.restrict = ConstRegistAccount.ConstPasswordRestrict;
			passwordLogin.textEditorProperties = fontFormat;
			passwordLogin.text = "";
			passwordLogin.width = accountLogin.width;
			passwordLogin.height = accountLogin.height;
			this.addChild(passwordLogin);
		}
		
		private function initListener():void
		{
			var iPlatform:ISPlatfrom = (SApplication.appInstance as MainApplication).platform;
			var own:SLayer = this;
			//注册成功后的逻辑
			iPlatform.addEventListener(CJEvent.EVENT_NINESPLAY_REG_SUCC,function(e:Event):void
			{
				var regData:Object = e.data;
				if(_quickRegLayer == null)
				{
					_quickRegLayer = new CJTwRegQuickLayer;
					_quickRegLayer.addEventListener(CJEvent.EVENT_NINESPLAY_CLOSE_REGQUICK,function():void
					{
						_quickRegLayer.removeFromParent(true);
						own.visible = true;
						_quickRegLayer = null;
					})
					_quickRegLayer.addEventListener(CJEvent.EVENT_NINESPLAY_CLOSE_MODIFYPWD,function(e:Event):void
					{
						var d:Object = e.data;
						openModPwdLayer(d.username,d.password);
					})
				}
				own.visible = false;
				CJLayerManager.o.addModuleLayer(_quickRegLayer);
				_quickRegLayer.username = regData.userid;
				_quickRegLayer.password = regData.upd;
			});
			//修改密码成功后的逻辑
			iPlatform.addEventListener(CJEvent.EVENT_NINESPLAY_MODYPWD_SUCC,function(e:Event):void
			{
				if(_modPwdLayer && _modPwdLayer.parent)
				{
					passwordLogin.text = _modPwdLayer.newpwd;
					_modPwdLayer.removeFromParent(true);
					_modPwdLayer = null;
					this.visible = true;
				}
			})
		}
		
		private function openModPwdLayer(username:String,password:String):void
		{
			var own:SLayer = this
			if(_modPwdLayer == null)
			{
				_modPwdLayer = new CJTwModifyPwdLayer;
				_modPwdLayer.addEventListener(CJEvent.EVENT_NINESPLAY_CLOSE_MODIFYPWD,function():void
				{
					_modPwdLayer.removeFromParent(true);
					own.visible = true;
					_modPwdLayer = null;
				})
			}
			CJLayerManager.o.addModuleLayer(_modPwdLayer);
			own.visible = false;
			_modPwdLayer.account = username;
			_modPwdLayer.oldpwd = password;
		}
		
		override public function dispose():void
		{
			if(_quickRegLayer)
			{
				_quickRegLayer.removeFromParent(true);
				_quickRegLayer = null;
			}
			if(_regLayer)
			{
				_regLayer.removeFromParent(true);
				_regLayer = null;
			}
			if(_modPwdLayer)
			{
				_modPwdLayer.removeFromParent(true);
				_modPwdLayer = null;
			}
		}
	}
}