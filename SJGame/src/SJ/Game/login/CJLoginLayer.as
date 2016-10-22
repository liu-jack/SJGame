package SJ.Game.login
{
	import com.kaixin001.fxane.ADeviceInfo;
	
	import flash.system.Capabilities;
	
	import SJ.MainApplication;
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstPlatformId;
	import SJ.Common.Constants.ConstRegistAccount;
	import SJ.Game.Platform.ISPlatfrom;
	import SJ.Game.ServerList.CJServerList;
	import SJ.Game.SocketServer.SocketCommand_account;
	import SJ.Game.SocketServer.SocketCommand_push;
	import SJ.Game.SocketServer.SocketCommand_quicklogin;
	import SJ.Game.SocketServer.SocketCommand_record;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.core.TalkingDataService;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfAccounts;
	import SJ.Game.data.CJDataOfPlatformReceipt;
	import SJ.Game.data.json.Json_serverlist;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.utils.SApplicationUtils;
	import SJ.Game.utils.SNetWorkUtils;
	
	import engine_starling.SApplication;
	import engine_starling.data.SDataBase;
	import engine_starling.display.SLayer;
	import engine_starling.utils.Logger;
	import engine_starling.utils.SErrorUtil;
	import engine_starling.utils.SManufacturerUtils;
	import engine_starling.utils.SPlatformUtils;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.TextInput;
	
	import starling.events.Event;
	
	/**
	 * 登录界面
	 * @author longtao
	 * 
	 */
	public class CJLoginLayer extends SLayer
	{
		private var _imgLoginBG:ImageLoader
		/**  登录框背景图 **/
		public function get imgLoginBG():ImageLoader
		{
			return _imgLoginBG;
		}
		/** @private **/
		public function set imgLoginBG(value:ImageLoader):void
		{
			_imgLoginBG = value;
		}
		private var _imgLoginTinyBG:ImageLoader
		/**  注册底图 **/
		public function get imgLoginTinyBG():ImageLoader
		{
			return _imgLoginTinyBG;
		}
		/** @private **/
		public function set imgLoginTinyBG(value:ImageLoader):void
		{
			_imgLoginTinyBG = value;
		}
		private var _imgLoginUserName:ImageLoader
		/**  帐号文字图片 **/
		public function get imgLoginUserName():ImageLoader
		{
			return _imgLoginUserName;
		}
		/** @private **/
		public function set imgLoginUserName(value:ImageLoader):void
		{
			_imgLoginUserName = value;
		}
		private var _tiLoginUserName:TextInput
		/**  帐号输入框 输入框不可有name属性如 **/
		public function get tiLoginUserName():TextInput
		{
			return _tiLoginUserName;
		}
		/** @private **/
		public function set tiLoginUserName(value:TextInput):void
		{
			_tiLoginUserName = value;
		}
		private var _imgLoginPassword:ImageLoader
		/**  密码文字图片 **/
		public function get imgLoginPassword():ImageLoader
		{
			return _imgLoginPassword;
		}
		/** @private **/
		public function set imgLoginPassword(value:ImageLoader):void
		{
			_imgLoginPassword = value;
		}
		private var _tiLoginPassword:TextInput
		/**  密码输入框 **/
		public function get tiLoginPassword():TextInput
		{
			return _tiLoginPassword;
		}
		/** @private **/
		public function set tiLoginPassword(value:TextInput):void
		{
			_tiLoginPassword = value;
		}
		private var _btnLogin:Button
		/**  登录按钮 **/
		public function get btnLogin():Button
		{
			return _btnLogin;
		}
		/** @private **/
		public function set btnLogin(value:Button):void
		{
			_btnLogin = value;
		}
		private var _btnRegister:Button
		/**  注册按钮 **/
		public function get btnRegister():Button
		{
			return _btnRegister;
		}
		/** @private **/
		public function set btnRegister(value:Button):void
		{
			_btnRegister = value;
		}
		private var _btnTest:Button
		/**  测试 **/
		public function get btnTest():Button
		{
			return _btnTest;
		}
		/** @private **/
		public function set btnTest(value:Button):void
		{
			_btnTest = value;
		}
		
		/** 账号 **/
		private var _account:String;
		/** 
		 * 密码
		 * @note 该密码为MD5后 **/
		private var _password:String;
		/** md5值 **/
		private var _authorizationcode:String;
		private var _channelUserId:String;
		public function CJLoginLayer():void
		{
		}

		
		override protected function initialize():void
		{
			super.initialize();
			
//			CONFIG::tech
//			{
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
//				// 登录输入框设置字体
//				var fontFormat:Object = tiLoginUserName.textEditorProperties;
//				fontFormat.fontFamily = "宋体";
//				fontFormat.color = 0xFFFFFFFF;
//				fontFormat.displayAsPassword = false;
//				fontFormat.multiline = false;
//				fontFormat.fontSize = 20;
//				fontFormat.maxChars = ConstRegistAccount.ConstMaxAccountCount;
//				fontFormat.restrict = ConstRegistAccount.ConstUsernameRestrict;
//				tiLoginUserName.textEditorProperties = fontFormat;
//				
//				fontFormat = tiLoginPassword.textEditorProperties;
//				fontFormat.fontFamily = "宋体";
//				fontFormat.color = 0xFFFFFFFF;
//				fontFormat.displayAsPassword = true;
//				fontFormat.multiline = false;
//				fontFormat.fontSize = 20;
//				fontFormat.maxChars = ConstRegistAccount.ConstMaxPassWordCount;
//				fontFormat.restrict = ConstRegistAccount.ConstPasswordRestrict;
//				tiLoginPassword.textEditorProperties = fontFormat;
//				
//				//peng.zhi ++ 2013年4月11日
//				//自动填充
//				var userid:String = CJDataManager.o.DataOfAccounts.userID;
//				if(!SStringUtils.isEmpty(userid))
//				{
//					tiLoginUserName.text = CJDataManager.o.DataOfAccounts.accounts;
//					tiLoginPassword.text = CJDataManager.o.DataOfAccounts.password;
//				}
//				
//				// 注册按钮 
//				temp = SApplication.assets.getTexture("denglu_zhuce0");
//				_btnRegister.defaultSkin = new SImage(temp);
//				temp = SApplication.assets.getTexture("denglu_zhuce1");
//				_btnRegister.downSkin = new SImage(temp);
//				_btnRegister.addEventListener(starling.events.Event.TRIGGERED,function(e:*):void{
//					SApplication.moduleManager.exitModule("CJLoginModule");
//					SApplication.moduleManager.enterModule("CJRegisterModule");
//				});
//				
//				// 获取输入框纹理
//				var texture:Texture = SApplication.assets.getTexture("denglu_shuru");
//				var scale3texture:Scale3Textures = new Scale3Textures(texture,texture.width/2-1,1);
//				// 帐号输入框
//				var scale3Image:Scale3Image = new Scale3Image(scale3texture);
//				scale3Image.x = _tiLoginUserName.x-5;
//				scale3Image.y = _tiLoginUserName.y-5;
//				scale3Image.width = _tiLoginUserName.width;
//				addChild(scale3Image);
//				addChild(_tiLoginUserName);
//				// 密码输入框
//				scale3Image = new Scale3Image(scale3texture);
//				scale3Image.x = _tiLoginPassword.x-5;
//				scale3Image.y = _tiLoginPassword.y-5;
//				scale3Image.width = _tiLoginPassword.width;
//				addChild(scale3Image);
//				addChild(_tiLoginPassword);
//			}
			
//			CONFIG::localver{
//				// 非开发模式，直接快速登录
//				if (!CONFIG::tech)
//				{
//					_quickLogin();
//				}
//				// 自动登录 开发模式下自动登录
//				if (CONFIG::tech && !SStringUtils.isEmpty(tiLoginUserName.text) && !SStringUtils.isEmpty(tiLoginPassword.text))
//				{
//					_connectandLogin(CJDataManager.o.DataOfAccounts.accounts, CJDataManager.o.DataOfAccounts.password);
//				}
//			}
			
			_quickLogin();
		}
		
		
		// 快速登录
		private function _quickLogin():void
		{
//			var md5:String = SStringUtils.md5String("02:00:00:00:00:00");
			
			var iPlatform:ISPlatfrom = (SApplication.appInstance as MainApplication).platform;
			_authorizationcode = iPlatform.SessionId();
			_channelUserId = iPlatform.uid();
			_connectandquickLogin();
			
			// log
			Logger.log("Mac", iPlatform.SessionId());
			Logger.log("md5", _authorizationcode);
		}
		
		// 点击登录按钮回调
		private function _Login():void
		{
			// 用户名
			var username:String = tiLoginUserName.text;
			// 用户密码
			var password:String = tiLoginPassword.text;
			// 检测帐号长度是否在6～12之间
			if ( username.length < ConstRegistAccount.ConstMinAccountCount ||
				username.length > ConstRegistAccount.ConstMaxAccountCount)
			{
				CJMessageBox(CJLang("ERROR_LOGIN_USERNAME_LEN"));
				return;
			}
			// 检测密码长度是否在6～12之间
			if (password.length < ConstRegistAccount.ConstMinPassWordCount ||
				password.length > ConstRegistAccount.ConstMaxPassWordCount)
			{
				CJMessageBox(CJLang("ERROR_LOGIN_PASSWD_LEN"));
				return;
			}
			// 检测帐号是否与密码相同
			if (username == password)
			{
				CJMessageBox(CJLang("ERROR_LOGIN_SAME"));
				return;
			}
			_connectandLogin(username, SStringUtils.md5String(password));
		}
		
		/**
		 * 连接并登录 peng.zhi 
		 * @param username
		 * @param password	该密码为MD5之后的
		 * 
		 */		
		private function _connectandLogin(username:String,password:String):void
		{
//			if(SocketManager.o.connected)
//			{
//				__send();
//			}
//			else
//			{
//				SocketManager.o.connect(ConstGlobal.ServerSetting.serverip,ConstGlobal.ServerSetting.serverport);
//				SocketManager.o.addEventListener(CJSocketEvent.SocketEventConnect,function _e(e:Event):void
//				{
//					e.target.removeEventListener(e.type,_e);
//					__send();
//				});
//			}
//			
//			function __send():void
//			{

			// 临时记录账号密码	
			_account = username;
			_password = password;
				
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onLogined);
			SocketCommand_account.login(username, password);
//			}
			
		}
		
		/**
		 * 连接并快速登录
		 * @param mac MD5之后的Mac地址
		 * 
		 */
		private function _connectandquickLogin():void
		{
//			if(SocketManager.o.connected)
//			{
//				__quicklogin();
//			}
//			else
//			{
//				
//				SocketManager.o.connect(ConstGlobal.ServerSetting.serverip,ConstGlobal.ServerSetting.serverport);
//				SocketManager.o.addEventListener(CJSocketEvent.SocketEventConnect,function _e(e:Event):void
//				{
//					e.target.removeEventListener(e.type,_e);
//					__quicklogin();
//				});
//			}
//			
//			function __quicklogin():void
//			{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onGetServerStatus);
			SocketCommand_account.getServerStatus();
//			}
		}
		
		/**
		 * 获取服务器状态监听
		 * @param e
		 * 
		 */
		private function _onGetServerStatus(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_ACCOUNT_GET_SERVER_STATUS)
				return;
			e.target.removeEventListener(e.type, _onGetServerStatus);
			
			var rtnparams:Object = message.retparams;
			var onlineUserCount:int = rtnparams.onlineUserCount;
			var onlineMaxUserCount:int = rtnparams.onlineMaxUserCount;
			var isOpen:Boolean = rtnparams.isOpen;

			if (!isOpen)
			{
				CJMessageBox(CJLang("SELECT_SERVER_STATE_NOT_OPEN"), function ():void{
					SApplication.moduleManager.enterModule("CJSelectServerModule", {"beforeLogin":true});
				});
				return;
			}
			if (onlineUserCount >= onlineMaxUserCount)
			{
				CJMessageBox(CJLang("SELECT_SERVER_STATE_FULL"), function ():void{
					SApplication.moduleManager.enterModule("CJSelectServerModule", {"beforeLogin":true});
				});
				return;
			}
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onQuickLogin);
			SocketCommand_quicklogin.quicklogin20(_authorizationcode, _channelUserId);
		}
		/**
		 * 快速登录监听
		 * @param e
		 * 
		 */
		private function _onQuickLogin(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_QUICKLOGIN_QUICKLOGIN20)
				return;
			e.target.removeEventListener(e.type, _onQuickLogin);
			if (message.retcode != 0)
			{
				Logger.log("_onQuickLogin failed: retcode = ", "" + message.retcode);
				CJMessageBox("登陆错误 code = " + message.retcode,function():void
				{
					SApplicationUtils.exit();
				});
				return;
			}
			
			
			
			var rtnparams:Array = message.retparams;
			var username:String = rtnparams[0];
			var password:String = rtnparams[1];
			
			if(rtnparams.length > 3)
			{
				//360奇葩  支付需要accesstoken
				if(ConstGlobal.CHANNELID == ConstPlatformId.ID_ANDROID360)
				{
					var iPlatform:ISPlatfrom = (SApplication.appInstance as MainApplication).platform;
					iPlatform.accessToken = rtnparams[2]["accessToken"];
					iPlatform.setUid(rtnparams[3]);
				}
			}		

			_connectandLogin(username,password);
		}
		
		/**
		 * 登录监听
		 * @param e
		 * 
		 */
		private function _onLogined(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_LOGIN)
				return;
			
			e.target.removeEventListener(e.type,_onLogined);
			
			var retCode:uint = message.retcode;
			var rtnparams:Array = message.retparams;
			var isLogined:Boolean = rtnparams[0];
			var userid:String = rtnparams[1];
			var accountDB:CJDataOfAccounts = CJDataManager.o.DataOfAccounts;
					
			if(TalkingDataService.o.isSupported()){
				var json:Json_serverlist = CJServerList.getServerJS(CJServerList.getServerID());
				TalkingDataService.o.login(userid, json.servername);
			}
			
			
			switch(message.retcode)
			{
				case 0:
					break;
				case 1:
					CJMessageBox(CJLang("ERROR_LOGIN_FAIL"));
					return;
				case 2:
					CJMessageBox(CJLang("ERROR_LOGIN_LOGINED"));
					return;
				case 4:
					// 玩家被封号，提示语言：“账号无法登陆”
					CJMessageBox(CJLang("ERROR_LOGIN_BLACK"));
					return;
				case 5:
					// 未知错误
					CJMessageBox(CJLang("ERROR_LOGIN_UNKNOWN"));
					return;
				case 6:
					// 版本不是最新
//					CJMessageBox(CJLang("ERROR_LOGIN_VERSION"), function():void{});
					CJMessageBox(CJLang("ERROR_LOGIN_VERSION"));
					return;
				default:
					CJMessageBox(CJLang("ERROR_UNKNOWN")+ "CJLoginLayer._onLogined retcode="+message.retcode );
					return;
			}
			
			
			if(isLogined)
			{
				//向服务器注册Token,目前只有IOS有用
//				SocketCommand_push.registertoken();
				
				accountDB.userID = userid;
				accountDB.accounts = _account;//tiLoginUserName.text;
				accountDB.password = _password;//tiLoginPassword.text;
				accountDB.saveToCache();
				// 查看该帐号是否有角色
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onOwnRole);
				SocketCommand_role.own_role();
			}
			else
			{
				CJMessageBox(CJLang("ERROR_LOGIN_FAIL"));
			}
			
		}
		
		private function _onOwnRole(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_ROLE_IS_OWN)
				return;
			
			e.target.removeEventListener(e.type,_onOwnRole);
			
			var retCode:uint = message.params(0);
			var isOwn:Boolean = message.params(1);
			
			if (!isOwn) // 没有创建
			{
				SApplication.moduleManager.exitModule("CJLoginModule");
				SApplication.moduleManager.enterModule("CJCreateModule");
				//标记没有播放收场战斗
				//peng.zhi ++
				CJDataManager.o.DataOfAccounts.fristbattleplayed = false;
				CJDataManager.o.DataOfAccounts.saveToCache();
				
				CJDataManager.o.DataOfRole.hasRoleInfo = false; // add by longtao
			}
			else	// 直接进入游戏
			{
				//peng.zhi ++ 2013年4月11日
				//读取帐号信息
				CJDataManager.o.DataOfRole.hasRoleInfo = true; // add by longtao
				//保存错误日志
				this._saveErrorLog();
				this._checkPlatformReceipt();
				
				SApplication.moduleManager.exitModule("CJLoginModule");
				SApplication.stateManager.ChangeState("GameStateGaming");
				
			}
		}
		
		private function _saveErrorLog():void
		{
			var localErrorLog:SDataBase = SErrorUtil.getReportError();
			
			var allLogData:Array = new Array();
			var dev:Object = new Object();
			dev['device'] = ConstGlobal.DeviceInfo.DeviceName;
			dev['guid'] = SNetWorkUtils.hardAddress;
			dev['deviceType'] = SManufacturerUtils.getManufacturerType();
			dev['version'] = Capabilities.os;
			dev['channel'] = ConstGlobal.CHANNELNAME;
			dev['clientVersion'] = SPlatformUtils.getApplicationVersion();
			
			for(var key:String in localErrorLog.dataContains)
			{
				var logData:Object = new Object();
				logData["error"] = localErrorLog.dataContains[key];
				logData['dev'] = dev;
				allLogData.push(logData);
			}
			
			if(allLogData.length == 0)
			{
				return;
			}
			SErrorUtil.clearReportError();
			
			var json:String = JSON.stringify(allLogData);
			if(json)
			{
				SocketCommand_record.clienterrorall(json);
			}
		}
		
		/**
		 * 检验是否有未发送的充值票据, 如果有则再次发送
		 * 
		 */		
		private function _checkPlatformReceipt():void
		{
			var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
			// 加载本地缓存数据
			dataReceipt.loadCache();
			// 检验并发送未发送充值票据到服务器
			dataReceipt.clearVerifyreceiptTimes();
			dataReceipt.checkAndSend();
		}
	}
}