package SJ.Game.Platform
{
	import flash.net.URLVariables;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.HttpServer;
	import SJ.Game.event.CJEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLayerRandomBackGround;
	import SJ.Game.layer.CJMessageBox;
	
	import engine_starling.SApplication;
	import engine_starling.utils.SManufacturerUtils;
	import engine_starling.utils.SStringUtils;

	public class SPlatform9splay extends SPlatformDefault
	{
		private const appid:String = "SANOW";
		private const apikey:String = "288d896ef6dd9443f92a0526233a926e";
		private const domain:String = "https://api.9splay.com";
		private var httpServer:HttpServer;
		private var loadingStyle:String = CJLayerRandomBackGround.status_NormalLoad;
		public function SPlatform9splay()
		{
			//TODO: implement function
			super();
			httpServer = HttpServer.getInstance();
			httpServer.domain = domain;
		}

		override public function startup(params:Object):void
		{
			this._dispatch_init(true);
		}
		
		public function register(username:String,password:String):void
		{
			var manufacturerType:String = SManufacturerUtils.getManufacturerType();
			var para:URLVariables = new URLVariables;
			para.appid = appid
			para.userid = username;
			para.pwd = password;
			para.devid = _account.getData("username");
			para.ostype = (manufacturerType == SManufacturerUtils.TYPE_ANDROID)?1:0;
			para.sign = getRegSign(username,para.devid);
			httpServer.request(ConstNetCommand.NINESPLAY_REGISTER,regRet,para);
		}
		public function registerQuick():void
		{
			var manufacturerType:String = SManufacturerUtils.getManufacturerType();
			var para:URLVariables = new URLVariables;
			para.appid = appid;
			para.devid = _account.getData("username");
			para.sign = getRegQuickSign(para.devid);
			httpServer.request(ConstNetCommand.NINESPLAY_REGISTERQUICK,quickRet,para);
		}
		public function loginPlat(username:String,password:String):void
		{
			var para:URLVariables = new URLVariables;
			para.appid = appid;
			para.userid = username;
			para.pwd = password;
			para.devid = _account.getData("username");
			para.sign = getLoginSign(username,password);
			httpServer.request(ConstNetCommand.NINESPLAY_LOGIN,loginRet,para);
		}
		public function modifyPwd(username:String,password:String,newpassword:String):void
		{
			var para:URLVariables = new URLVariables;
			para.appid = appid;
			para.userid = username;
			para.pwd = password;
			para.newpwd = newpassword;
			para.devid = _account.getData("username");
			para.sign = getLoginSign(username,password);
			httpServer.request(ConstNetCommand.NINESPLAY_MODPWD,modifyRet,para);
		}
		private function regRet(data:Object):void
		{
			var regData:Object = data;
			switch(regData.Code)
			{
				case 1:	
					this._authorizationcode = regData.uid;
					SApplication.moduleManager.exitModule("CJTwloginModule");
					_dispatch_login(true, "");
					CJLayerRandomBackGround.Show(CJLayerManager.o.rootLayer.normalLayer,loadingStyle);
					break;
				case -2:
					CJMessageBox(CJLang("TW_ACCOUNT_ERROR"));
					break;
				case -3:
					CJMessageBox(CJLang("TW_PASSWORD_LENGTH_ERROR"));
					break;
				case -4:
					CJMessageBox(CJLang("TW_ACCOUNT_HAS_OWN"));
					break;
				case -6:
					CJMessageBox(CJLang("TW_ACCOUNT_HAS_INVILID_CHAR"));
					break;
				case -7:
					CJMessageBox(CJLang("TW_PASSWORD_HAS_INVILID_CHAR"));
					break;
				case -97:
					CJMessageBox(CJLang("TW_CHECKMASK_ERROR"));
					break;
				case -98:
					CJMessageBox(CJLang("TW_SYS_ERROR"));
					break;
				case -99:
					CJMessageBox(CJLang("TW_PROGRESS_ERROR"));
					break;
			}

		}
		private function quickRet(data:Object):void
		{
			var quickData:Object = data;
			switch(quickData.Code)
			{
				case 1:
					this._authorizationcode = quickData.useruid;
					this.dispatchEventWith(CJEvent.EVENT_NINESPLAY_REG_SUCC,false,quickData);
					break;
				case -2:
					CJMessageBox(CJLang("TW_SYS_ERROR"));
					break;
				case -97:
					CJMessageBox(CJLang("TW_CHECKMASK_ERROR"));
					break;
				case -98:
					CJMessageBox(CJLang("TW_SYS_ERROR"));
					break;
				case -99:
					CJMessageBox(CJLang("TW_PROGRESS_ERROR"));
					break;
			}
		}
		private function loginRet(data:Object):void
		{
			var loginData:Object = data;
			switch(loginData.Code)
			{
				case 1:
					this._authorizationcode = loginData.uid;
					SApplication.moduleManager.exitModule("CJTwloginModule");
					_dispatch_login(true, "");
					CJLayerRandomBackGround.Show(CJLayerManager.o.rootLayer.normalLayer,loadingStyle);
					break;
				case -4:
					CJMessageBox(CJLang("TW_LOGIN_FAIL"));
					break;
				case -97:
					CJMessageBox(CJLang("TW_CHECKMASK_ERROR"));
					break;
				case -98:
					CJMessageBox(CJLang("TW_SYS_ERROR"));
					break;
				case -99:
					CJMessageBox(CJLang("TW_PROGRESS_ERROR"));
					break;
			}
		}
		private function modifyRet(data:Object):void
		{
			var modifyData:Object = data;
			switch(modifyData.Code)
			{
				case 1:
					CJMessageBox(CJLang("TW_MODIFYPASSWORD_SUCC"),function():void{
						this.dispatchEventWith(CJEvent.EVENT_NINESPLAY_MODYPWD_SUCC);
					});
					break;
				case -2:
					CJMessageBox(CJLang("TW_ACCOUNT_LENGTH_ERROR"));
					break;
				case -3:
					CJMessageBox(CJLang("TW_LOGIN_FAIL"));
					break;
				case -4:
					CJMessageBox(CJLang("TW_NEWPWD_LENGTH_ERROR"));
					break;
				case -5:
					CJMessageBox(CJLang("TW_PWD_ERROR"));
					break;
				case -6:
					CJMessageBox(CJLang("TW_ACCOUNT_HAS_INVILID_CHAR"));
					break;
				case -7:
					CJMessageBox(CJLang("TW_PASSWORD_HAS_INVILID_CHAR"));
					break;
				case -8:
					CJMessageBox(CJLang("TW_NEWPWD_HAS_INVILID_CHAR"));
					break;
				case -97:
					CJMessageBox(CJLang("TW_CHECKMASK_ERROR"));
					break;
				case -98:
					CJMessageBox(CJLang("TW_SYS_ERROR"));
					break;
				case -99:
					CJMessageBox(CJLang("TW_PROGRESS_ERROR"));
					break;
			}
		}
		
		override public function login(callback:Function):void
		{
//			super.login(callback);
			CJLayerRandomBackGround.Close();
			SApplication.moduleManager.enterModule("CJTwloginModule");

		}
		
		override public function logout(callback:Function):void
		{
			
		}
		private function getRegSign(username:String,devid:String):String
		{
			var sign:String = apikey + 	appid + username + devid + apikey;
			var asmd5sign:String = SStringUtils.md5String(sign);
			return SStringUtils.md5String(sign);
		}
		
		private function getRegQuickSign(devid:String):String
		{
			var sign:String = apikey + appid + devid + apikey
			return SStringUtils.md5String(sign);
		}
		
		private function getLoginSign(username:String,password:String):String
		{
			var sign:String = apikey + appid + username + password + apikey
			return SStringUtils.md5String(sign);
		}
	}
}