package SJ.Game.register
{
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstRegistAccount;
	import SJ.Game.SocketServer.SocketCommand_account;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfAccounts;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.TextInput;
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class CJRegisterLayer extends SLayer
	{
		private var _imgRegisterBG:ImageLoader;
		/** 背景图 **/
		public function get imgRegisterBG():ImageLoader
		{
			return _imgRegisterBG;
		}
		/**
		 * @private
		 */
		public function set imgRegisterBG(value:ImageLoader):void
		{
			_imgRegisterBG = value;
		}

		private var _imgRegisterTinyBG:ImageLoader;

		/**
		 * 注册底图
		 */
		public function get imgRegisterTinyBG():ImageLoader
		{
			return _imgRegisterTinyBG;
		}

		/**
		 * @private
		 */
		public function set imgRegisterTinyBG(value:ImageLoader):void
		{
			_imgRegisterTinyBG = value;
		}

	
		private var _btnRegisterOK:Button;

		/**
		 * 提交按钮
		 */
		public function get btnRegisterOK():Button
		{
			return _btnRegisterOK;
		}

		/**
		 * @private
		 */
		public function set btnRegisterOK(value:Button):void
		{
			_btnRegisterOK = value;
		}
		
		
		private var _btnRegisterReturn:Button;

		/**
		 * 返回按钮
		 */
		public function get btnRegisterReturn():Button
		{
			return _btnRegisterReturn;
		}

		/**
		 * @private
		 */
		public function set btnRegisterReturn(value:Button):void
		{
			_btnRegisterReturn = value;
		}

		
		private var _imgRegisterUserName:ImageLoader;

		/**
		 * 帐号文字图片
		 */
		public function get imgRegisterUserName():ImageLoader
		{
			return _imgRegisterUserName;
		}

		/**
		 * @private
		 */
		public function set imgRegisterUserName(value:ImageLoader):void
		{
			_imgRegisterUserName = value;
		}

		private var _tiRegisterUserName:TextInput;

		/**
		 * 帐号输入框
		 */
		public function get tiRegisterUserName():TextInput
		{
			return _tiRegisterUserName;
		}

		/**
		 * @private
		 */
		public function set tiRegisterUserName(value:TextInput):void
		{
			_tiRegisterUserName = value;
		}

		
		private var _imgRegisterPassword:ImageLoader;

		/**
		 * 密码文字图片
		 */
		public function get imgRegisterPassword():ImageLoader
		{
			return _imgRegisterPassword;
		}

		/**
		 * @private
		 */
		public function set imgRegisterPassword(value:ImageLoader):void
		{
			_imgRegisterPassword = value;
		}

		private var _tiRegisterPassword:TextInput;

		/**
		 * 密码输入框
		 */
		public function get tiRegisterPassword():TextInput
		{
			return _tiRegisterPassword;
		}

		/**
		 * @private
		 */
		public function set tiRegisterPassword(value:TextInput):void
		{
			_tiRegisterPassword = value;
		}

		
		private var _imgRegisterPasswordMore:ImageLoader;

		/**
		 * 重复密码文字图片
		 */
		public function get imgRegisterPasswordMore():ImageLoader
		{
			return _imgRegisterPasswordMore;
		}

		/**
		 * @private
		 */
		public function set imgRegisterPasswordMore(value:ImageLoader):void
		{
			_imgRegisterPasswordMore = value;
		}

		private var _tiRegisterPasswordMore:TextInput;

		/**
		 * 重复密码输入框 
		 */
		public function get tiRegisterPasswordMore():TextInput
		{
			return _tiRegisterPasswordMore;
		}

		/**
		 * @private
		 */
		public function set tiRegisterPasswordMore(value:TextInput):void
		{
			_tiRegisterPasswordMore = value;
		}

		
		public function CJRegisterLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var temp:Texture;
			// 提交按钮
			temp = SApplication.assets.getTexture("denglu_tijiao0");
			_btnRegisterOK.defaultSkin = new SImage(temp);
			temp = SApplication.assets.getTexture("denglu_tijiao1");
			_btnRegisterOK.downSkin = new SImage(temp);
			_btnRegisterOK.addEventListener(starling.events.Event.TRIGGERED,function(e:*):void{
				// 检测密码是否一致
				if ( tiRegisterPassword.text != tiRegisterPasswordMore.text )
				{
					CJMessageBox(CJLang("ERROR_REGISTER_PW_DIFF"));
					return;
				}
				// 用户名
				var username:String = tiRegisterUserName.text;
				// 用户密码
				var password:String = tiRegisterPassword.text;
				// 检测帐号长度是否在6～12之间
				if ( username.length < ConstRegistAccount.ConstMinAccountCount ||
					username.length > ConstRegistAccount.ConstMaxAccountCount)
				{
					CJMessageBox(CJLang("ERROR_REGISTER_UN_LEN"));
					return;
				}
				// 检测密码长度是否在6～12之间
				if (password.length < ConstRegistAccount.ConstMinPassWordCount ||
					password.length > ConstRegistAccount.ConstMaxPassWordCount)
				{
					CJMessageBox(CJLang("ERROR_REGISTER_PW_LEN"));
					return;
				}
				// 检测帐号是否与密码相同
				if (username == password)
				{
					CJMessageBox(CJLang("ERROR_REGISTER_SAME"));
					return;
				}
				
				_connectandRegisted(tiRegisterUserName.text, tiRegisterPassword.text);
			});
			
			// 返回按钮 
			temp = SApplication.assets.getTexture("denglu_fanhui0");
			_btnRegisterReturn.defaultSkin = new SImage(temp);
			temp = SApplication.assets.getTexture("denglu_fanhui1");
			_btnRegisterReturn.downSkin = new SImage(temp);
			_btnRegisterReturn.addEventListener(starling.events.Event.TRIGGERED,function(e:*):void{
				SApplication.moduleManager.exitModule("CJRegisterModule");
				SApplication.moduleManager.enterModule("CJLoginModule");
			});
			
			// 获取输入框纹理
			var texture:Texture = SApplication.assets.getTexture("denglu_shuru");
			var scale3texture:Scale3Textures = new Scale3Textures(texture,texture.width/2-1,1);
			var scale3Image:Scale3Image;
			
//			// 帐号输入框
//			_tiRegisterUserName.backgroundSkin = new Scale3Image(scale3texture);
//			// 密码输入框
//			_tiRegisterPassword.backgroundSkin = new Scale3Image(scale3texture);
//			// 再次密码输入
//			_tiRegisterPasswordMore.backgroundSkin = new Scale3Image(scale3texture);
			
			// 设置输入框字体格式
			var fontFormat:Object = _tiRegisterUserName.textEditorProperties; 
			fontFormat.fontFamily = "宋体";
			fontFormat.color = 0xFFFFFFFF;
			fontFormat.displayAsPassword = false;
			fontFormat.fontSize = 20;
			fontFormat.maxChars = 10;
			fontFormat.restrict = ConstRegistAccount.ConstUsernameRestrict;
			_tiRegisterUserName.textEditorProperties = fontFormat;
			scale3Image = new Scale3Image(scale3texture);
			scale3Image.x = _tiRegisterUserName.x-5;
			scale3Image.y = _tiRegisterUserName.y-5;
			scale3Image.width = _tiRegisterUserName.width;
			scale3Image.height = _tiRegisterUserName.height;
			addChild(scale3Image);
			addChild(_tiRegisterUserName);
			
			fontFormat = _tiRegisterPassword.textEditorProperties
			fontFormat.fontFamily = "宋体";
			fontFormat.color = 0xFFFFFFFF;
			fontFormat.displayAsPassword = true;
			fontFormat.fontSize = 20;
			fontFormat.maxChars = 18;
			fontFormat.restrict = ConstRegistAccount.ConstPasswordRestrict;
			_tiRegisterPassword.textEditorProperties = fontFormat;
			scale3Image = new Scale3Image(scale3texture);
			scale3Image.x = _tiRegisterPassword.x-5;
			scale3Image.y = _tiRegisterPassword.y-5;
			scale3Image.width = _tiRegisterPassword.width;
			scale3Image.height = _tiRegisterPassword.height;
			addChild(scale3Image);
			addChild(_tiRegisterPassword);
			
			fontFormat = _tiRegisterPasswordMore.textEditorProperties; 
			fontFormat.fontFamily = "宋体";
			fontFormat.color = 0xFFFFFFFF;
			fontFormat.displayAsPassword = true;
			fontFormat.fontSize = 20;
			fontFormat.maxChars = 18;
			fontFormat.restrict = ConstRegistAccount.ConstPasswordRestrict;
			_tiRegisterPasswordMore.textEditorProperties = fontFormat;
			scale3Image = new Scale3Image(scale3texture);
			scale3Image.x = _tiRegisterPasswordMore.x-5;
			scale3Image.y = _tiRegisterPasswordMore.y-5;
			scale3Image.width = _tiRegisterPasswordMore.width;
			scale3Image.height = _tiRegisterPasswordMore.height;
			addChild(scale3Image);
			addChild(_tiRegisterPasswordMore);
		}
		
		/**
		 * 连接服务器并请求注册
		 * @param username
		 * @param passward
		 */
		private function _connectandRegisted(username:String, password:String):void
		{
			if(SocketManager.o.connected)
			{
				__send();
			}
			else
			{

				SocketManager.o.connect(ConstGlobal.ServerSetting.serverip,ConstGlobal.ServerSetting.serverport);
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventConnect,function _e(e:Event):void
				{
					e.target.removeEventListener(e.type,_e);
					__send();
				});
			}
			
			function __send():void
			{
				
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onRegisted);
				SocketCommand_account.create_account(username, SStringUtils.md5String(password));
				
				
				// 保存
				var accountDB:CJDataOfAccounts = CJDataManager.o.DataOfAccounts;
				accountDB.accounts = username;;
				accountDB.password = password;
				accountDB.saveToCache();
			}
		}
		
		/**
		 * 注册消息返回
		 * @param e
		 */
		private function _onRegisted(e:Event) : void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_ACCOUNT_CREATE)
				return;
			
			e.target.removeEventListener(e.type,_onRegisted);
			
			var retCode:uint = message.params(0);
			var isSucceed:Boolean = message.params(1)[0];	// 注册成功
			var userName:String = message.params(1)[1];	// 用户名
			var password:String = message.params(1)[2];	// 密码
			
			switch(retCode)
			{
				case 0:
					break;
				case 1:
					CJMessageBox(CJLang("ERROR_REGISTER_USERNAME_SAME"));
					return;
				case 2:
					// 非法字符
					CJMessageBox(CJLang("ERROR_REGISTER_USERNAME_INVALID"));
					return;
				case 3:
					// 名字为空
					CJMessageBox(CJLang("ERROR_REGISTER_USERNAME_EMPTY"));
					return;
				default:
					CJMessageBox(CJLang("ERROR_UNKNOWN")+ "CJRegisterLayer._onRegisted retcode="+message.retcode );
					return;
			}
			
			if (isSucceed)
			{
//				SApplication.moduleManager.exitModule("CJRegisterModule");
//				SApplication.moduleManager.enterModule("CJCreateModule");
				
				/// 进行登录操作
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onLogined);
				SocketCommand_account.login(userName, password);
				
//				// 保存
//				var accountDB:CJDataOfAccounts = CJDataManager.o.DataOfAccounts;
//				accountDB.accounts = userName;;
//				accountDB.password = password;
//				accountDB.saveToCache();
			}
		}
		
		/**
		 * 登录监听
		 * @param e
		 * 
		 */
		private function _onLogined( e:Event ):void
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
			if(isLogined)
			{
				accountDB.userID = userid;
				accountDB.saveToCache();
				// 查看该帐号是否有角色
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onOwnRole);
				SocketCommand_role.own_role();
			}
			else
			{
				accountDB.clearAll();
				accountDB.saveToCache();
			}
		}
		
		private function _onOwnRole( e:Event ):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_ROLE_IS_OWN)
				return;
			
			e.target.removeEventListener(e.type,_onOwnRole);
			
			var retCode:uint = message.params(0);
			var isOwn:Boolean = message.params(1);
			
			if (!isOwn) // 没有创建
			{
				SApplication.moduleManager.exitModule("CJRegisterModule");
				SApplication.moduleManager.enterModule("CJCreateModule");
			}
			else	// 直接进入游戏
			{
				SApplication.moduleManager.exitModule("CJRegisterModule");
				SApplication.stateManager.ChangeState("GameStateGaming");
			}
		}
		
		
	}
}