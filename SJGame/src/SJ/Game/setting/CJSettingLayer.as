package SJ.Game.setting
{
	import flash.geom.Rectangle;
	
	import SJ.MainApplication;
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstMainUI;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstPlatformId;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.ServerList.CJServerList;
	import SJ.Game.SocketServer.SocketCommand_account;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJButtonUtil;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfSetting;
	import SJ.Game.data.json.Json_serverlist;
	import SJ.Game.enhanceequip.CJEnhanceLayerCheckbox;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.utils.SApplicationUtils;
	import SJ.Game.utils.SCompileUtils;
	
	import engine_starling.SApplication;
	import engine_starling.data.SDataBase;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.SMuiscChannel;
	import engine_starling.utils.SPlatformUtils;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.TextInput;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 设置界面
	 * @author longtao
	 * 
	 */
	public class CJSettingLayer extends SLayer
	{
		private var _settingBG:SLayer;
		/**  设置面板 **/
		public function get settingBG():SLayer
		{
			return _settingBG;
		}
		/** @private **/
		public function set settingBG(value:SLayer):void
		{
			_settingBG = value;
		}
		private var _checkBG:SLayer;
		/**  设置面板 **/
		public function get checkBG():SLayer
		{
			return _checkBG;
		}
		/** @private **/
		public function set checkBG(value:SLayer):void
		{
			_checkBG = value;
		}
		private var _bgMusicCheckbox:Label;
		/**  背景音乐 **/
		public function get bgMusicCheckbox():Label
		{
			return _bgMusicCheckbox;
		}
		/** @private **/
		public function set bgMusicCheckbox(value:Label):void
		{
			_bgMusicCheckbox = value;
		}
		private var _bgMusicLabel:Label;
		/**  背景音乐 **/
		public function get bgMusicLabel():Label
		{
			return _bgMusicLabel;
		}
		/** @private **/
		public function set bgMusicLabel(value:Label):void
		{
			_bgMusicLabel = value;
		}
		private var _infoCheckbox:Label;
		/**  推送信息 **/
		public function get infoCheckbox():Label
		{
			return _infoCheckbox;
		}
		/** @private **/
		public function set infoCheckbox(value:Label):void
		{
			_infoCheckbox = value;
		}
		private var _infoLabel:Label;
		/**  推送信息 **/
		public function get infoLabel():Label
		{
			return _infoLabel;
		}
		/** @private **/
		public function set infoLabel(value:Label):void
		{
			_infoLabel = value;
		}
		private var _flowCheckbox:Label;
		/**  省流量 **/
		public function get flowCheckbox():Label
		{
			return _flowCheckbox;
		}
		/** @private **/
		public function set flowCheckbox(value:Label):void
		{
			_flowCheckbox = value;
		}
		private var _flowLabel:Label;
		/**  省流量 **/
		public function get flowLabel():Label
		{
			return _flowLabel;
		}
		/** @private **/
		public function set flowLabel(value:Label):void
		{
			_flowLabel = value;
		}
		private var _showOthersCheckbox:Label;
		/**  是否显示其他玩家 **/
		public function get showOthersCheckbox():Label
		{
			return _showOthersCheckbox;
		}
		/** @private **/
		public function set showOthersCheckbox(value:Label):void
		{
			_showOthersCheckbox = value;
		}
		private var _showOthersLabel:Label;
		/**  是否显示其他玩家 **/
		public function get showOthersLabel():Label
		{
			return _showOthersLabel;
		}
		/** @private **/
		public function set showOthersLabel(value:Label):void
		{
			_showOthersLabel = value;
		}
		private var _regionBG:Label;
		/**  分区面板 **/
		public function get regionBG():Label
		{
			return _regionBG;
		}
		/** @private **/
		public function set regionBG(value:Label):void
		{
			_regionBG = value;
		}
		private var _idLabel:Label;
		/**  ID编号 **/
		public function get idLabel():Label
		{
			return _idLabel;
		}
		/** @private **/
		public function set idLabel(value:Label):void
		{
			_idLabel = value;
		}
		private var _regionLabel:Label;
		/**  分区 **/
		public function get regionLabel():Label
		{
			return _regionLabel;
		}
		/** @private **/
		public function set regionLabel(value:Label):void
		{
			_regionLabel = value;
		}
		private var _btnSinaShare:Button;
		/**  新浪分享 **/
		public function get btnSinaShare():Button
		{
			return _btnSinaShare;
		}
		/** @private **/
		public function set btnSinaShare(value:Button):void
		{
			_btnSinaShare = value;
		}
		private var _btnProducer:Button;
		/**  制作人员 **/
		public function get btnProducer():Button
		{
			return _btnProducer;
		}
		/** @private **/
		public function set btnProducer(value:Button):void
		{
			_btnProducer = value;
		}
		private var _btnQuestion:Button;
		/**  问题反馈 **/
		public function get btnQuestion():Button
		{
			return _btnQuestion;
		}
		/** @private **/
		public function set btnQuestion(value:Button):void
		{
			_btnQuestion = value;
		}
		private var _btnChangeServer:Button;
		/**  切换服务器 **/
		public function get btnChangeServer():Button
		{
			return _btnChangeServer;
		}
		/** @private **/
		public function set btnChangeServer(value:Button):void
		{
			_btnChangeServer = value;
		}
		private var _btnChangeAccount:Button;
		/**  切换账号 **/
		public function get btnChangeAccount():Button
		{
			return _btnChangeAccount;
		}
		/** @private **/
		public function set btnChangeAccount(value:Button):void
		{
			_btnChangeAccount = value;
		}
		private var _btnUnbindAccount:Button;
		/**  删号重玩 **/
		public function get btnUnbindAccount():Button
		{
			return _btnUnbindAccount;
		}
		/** @private **/
		public function set btnUnbindAccount(value:Button):void
		{
			_btnUnbindAccount = value;
		}
		private var _linePos:Label;
		/**  分割线 **/
		public function get linePos():Label
		{
			return _linePos;
		}
		/** @private **/
		public function set linePos(value:Label):void
		{
			_linePos = value;
		}
		private var _producerLayer:SLayer;
		/**  制作人员 **/
		public function get producerLayer():SLayer
		{
			return _producerLayer;
		}
		/** @private **/
		public function set producerLayer(value:SLayer):void
		{
			_producerLayer = value;
		}
		private var _problemLayer:SLayer;
		/**  问题反馈 **/
		public function get problemLayer():SLayer
		{
			return _problemLayer;
		}
		/** @private **/
		public function set problemLayer(value:SLayer):void
		{
			_problemLayer = value;
		}
		private var _problemBG:Label;
		/**  底框 **/
		public function get problemBG():Label
		{
			return _problemBG;
		}
		/** @private **/
		public function set problemBG(value:Label):void
		{
			_problemBG = value;
		}
		private var _problemBG1:Label;
		/**  内底框 **/
		public function get problemBG1():Label
		{
			return _problemBG1;
		}
		/** @private **/
		public function set problemBG1(value:Label):void
		{
			_problemBG1 = value;
		}
		private var _problemBG2:Label;
		/**  内内底框 **/
		public function get problemBG2():Label
		{
			return _problemBG2;
		}
		/** @private **/
		public function set problemBG2(value:Label):void
		{
			_problemBG2 = value;
		}
		private var _problemLimitLabel:Label;
		/**  内容限制字数 **/
		public function get problemLimitLabel():Label
		{
			return _problemLimitLabel;
		}
		/** @private **/
		public function set problemLimitLabel(value:Label):void
		{
			_problemLimitLabel = value;
		}
		private var _problemLabel:TextInput;
		/**  内容 **/
		public function get problemLabel():TextInput
		{
			return _problemLabel;
		}
		/** @private **/
		public function set problemLabel(value:TextInput):void
		{
			_problemLabel = value;
		}
		private var _btnProblemClose:Button;
		/**  关闭 **/
		public function get btnProblemClose():Button
		{
			return _btnProblemClose;
		}
		/** @private **/
		public function set btnProblemClose(value:Button):void
		{
			_btnProblemClose = value;
		}
		private var _btnProblemSubmit:Button;
		/**  提交按钮 **/
		public function get btnProblemSubmit():Button
		{
			return _btnProblemSubmit;
		}
		/** @private **/
		public function set btnProblemSubmit(value:Button):void
		{
			_btnProblemSubmit = value;
		}
		private var _problemTitle:Label;
		/**  标题 **/
		public function get problemTitle():Label
		{
			return _problemTitle;
		}
		/** @private **/
		public function set problemTitle(value:Label):void
		{
			_problemTitle = value;
		}
		private var _labelVersion:Label;
		/**  版本号 **/
		public function get labelVersion():Label
		{
			return _labelVersion;
		}
		/** @private **/
		public function set labelVersion(value:Label):void
		{
			_labelVersion = value;
		}
		private var _labelTitle:Label;
		/**  标题框 **/
		public function get labelTitle():Label
		{
			return _labelTitle;
		}
		/** @private **/
		public function set labelTitle(value:Label):void
		{
			_labelTitle = value;
		}
		private var _btnClose:Button;
		/**  关闭界面 **/
		public function get btnClose():Button
		{
			return _btnClose;
		}
		/** @private **/
		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}



		
		/// 复选框名称
		private static const CONST_MUSIC:String = "CONST_MUSIC";
		private static const CONST_INFO:String = "CONST_INFO";
		private static const CONST_FLOW:String = "CONST_FLOW";
		private static const CONST_OTHERS:String = "CONST_OTHERS";
		
		/** 背景音乐复选框 **/
		private var _musicCX:CJEnhanceLayerCheckbox;
		/** 推送信息复选框 **/
		private var _infoCX:CJEnhanceLayerCheckbox;
		/** 省流量复选框 **/
		private var _flowCX:CJEnhanceLayerCheckbox;
		/** 是否显示其他人复选框 **/
		private var _othersCX:CJEnhanceLayerCheckbox;
		
		/** 标题框 **/
		private var _title:CJPanelTitle;
		
		/** 删号重玩二次确认框 **/
		private var _unbindAccountlayer:SLayer;
		
		public function CJSettingLayer()
		{
			super();
		}
		
		/** 添加所有监听 **/
		public function addAllEventListener():void
		{
			// 添加触摸事件
			addEventListener(TouchEvent.TOUCH, _touchHandler);
		}
		/** 删除所有监听 **/
		public function removeAllEventListener():void
		{
			// 删除触摸事件
			removeEventListener(TouchEvent.TOUCH, _touchHandler);
		}
		
		// 触摸事件
		private function _touchHandler(e:TouchEvent):void
		{
			_touchCheckbox(e);
		}
		
		// 触及复选框
		private function _touchCheckbox(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch == null)
				return;
			if (touch.phase != TouchPhase.ENDED)
				return;
			
			if( !(touch.target.parent is CJEnhanceLayerCheckbox) )
				return;
			
			var checkbox:CJEnhanceLayerCheckbox = touch.target.parent as CJEnhanceLayerCheckbox;
			
			// 系统设置信息
			var dataOfSetting:CJDataOfSetting = CJDataManager.o.DataOfSetting;
			switch(checkbox.name)
			{
				case CONST_MUSIC:	// 背景音乐
					dataOfSetting.isMusicPlay = !checkbox.isChecked;
					if (dataOfSetting.isMusicPlay)
						SMuiscChannel.global_volume = 1.0;
						// add by longtao
						// 2013.08.19 因声音不完善直接将声音置为0.0
//						SMuiscChannel.global_volume = 0.0;
						// add by longtao end
					else
						SMuiscChannel.global_volume = 0.0;
					break;
				case CONST_INFO:	// 推送信息
					dataOfSetting.isPushInfo = !checkbox.isChecked;
					break;
				case CONST_FLOW:	// 省流量
					dataOfSetting.isSaveFlow = !checkbox.isChecked;
					break;
				case CONST_OTHERS:	// 是否显示其他玩家
					dataOfSetting.isShowOthers = !checkbox.isChecked;
					if (CJDataManager.o.DataOfSetting.isShowOthers)// 显示
						CJEventDispatcher.o.dispatchEvent(new Event(CJEvent.EVENT_SCENEPLAYERMANAGER_FLASH));
					else // 不显示
						CJEventDispatcher.o.dispatchEvent(new Event(CJEvent.EVENT_SCENEPLAYERMANAGER_RESETANDPAUSE));
					break;
				default:
					return;
			}
			dataOfSetting.saveToCache();
			
			checkbox.toggle();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			// 设置宽高
			width = ConstMainUI.MAPUNIT_WIDTH;
			height = ConstMainUI.MAPUNIT_HEIGHT;
			
			_title = new CJPanelTitle(CJLang("TITLE_SETTING"));
			addChild(_title);
			_title.x = labelTitle.x;
			_title.y = labelTitle.y;
			
			// 关闭按钮
			btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			btnClose.addEventListener(Event.TRIGGERED, function (e:Event):void{
				SApplication.moduleManager.exitModule("CJSettingModule");
			});
			// 
			var tindex:uint = 0;
			var _bg:Scale9Image;
			
			// 底框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew") , new Rectangle(1,1 ,2,2)));
			_bg.x = settingBG.x;
			_bg.y = settingBG.y;
			_bg.width = settingBG.width;
			_bg.height = settingBG.height;
			addChildAt(_bg, tindex++);
			// 装饰花边
			var frame:CJPanelFrame = new CJPanelFrame(settingBG.width-6, settingBG.height-6);
			frame.x = settingBG.x + 3;
			frame.y = settingBG.y + 3;
			frame.touchable = false;
			addChildAt(frame, tindex++);
			
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinewzhezhao"), new Rectangle(43,43,2,2)));
			_bg.x = settingBG.x + 6;
			_bg.y = settingBG.y + 6;
			_bg.width = settingBG.width - 12;
			_bg.height = settingBG.height - 12;
			_bg.touchable = false;
			addChildAt(_bg, tindex++);
			
			// 外框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangnew") , new Rectangle(15 , 15 , 1, 1)));
			_bg.x = settingBG.x;
			_bg.y = settingBG.y;
			_bg.width = settingBG.width;
			_bg.height = settingBG.height;
			addChildAt(_bg, tindex++);
			
			// 复选背景框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_quanpingzhuangshidi") , new Rectangle(15, 13, 1, 1)));
			_bg.x = checkBG.x+8;
			_bg.y = checkBG.y+8;
			_bg.width = checkBG.width-16;
			_bg.height = checkBG.height-16;
			addChildAt(_bg, tindex++);
			
			// 系统设置信息
			var dataOfSetting:CJDataOfSetting = CJDataManager.o.DataOfSetting;
			// 声音
			_musicCX = new CJEnhanceLayerCheckbox;
			_musicCX.initLayer();
			_musicCX.x = bgMusicCheckbox.x;
			_musicCX.y = bgMusicCheckbox.y;
			_musicCX.checked = dataOfSetting.isMusicPlay;
			_musicCX.name = CONST_MUSIC;
			addChild(_musicCX);
			// 推送信息复选框
			_infoCX = new CJEnhanceLayerCheckbox;
			_infoCX.initLayer();
			_infoCX.x = infoCheckbox.x;
			_infoCX.y = infoCheckbox.y;
			_infoCX.checked = dataOfSetting.isPushInfo;
			_infoCX.name = CONST_INFO;
			addChild(_infoCX);
			// 省流量复选框
			_flowCX = new CJEnhanceLayerCheckbox;
			_flowCX.initLayer();
			_flowCX.x = flowCheckbox.x;
			_flowCX.y = flowCheckbox.y;
			_flowCX.checked = dataOfSetting.isSaveFlow;
			_flowCX.name = CONST_FLOW;
			addChild(_flowCX);
			// 是否显示其他玩家
			_othersCX = new CJEnhanceLayerCheckbox;
			_othersCX.initLayer();
			_othersCX.x = showOthersCheckbox.x;
			_othersCX.y = showOthersCheckbox.y;
			_othersCX.checked = dataOfSetting.isShowOthers;
			_othersCX.name = CONST_OTHERS;
			addChild(_othersCX);
			
			// 设置字体
			bgMusicLabel.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			infoLabel.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			flowLabel.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			showOthersLabel.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			// 设置文字
			bgMusicLabel.text = CJLang("SETTING_BG_MUSIC");
			infoLabel.text = CJLang("SETTING_INFO");
			flowLabel.text = CJLang("SETTING_FLOW");
			showOthersLabel.text = CJLang("SETTING_SHOWOTHERS");
			
			// id  分区  底框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_zuoshangjiaodi") , new Rectangle(10, 10, 6, 6)));
			_bg.x = regionBG.x;
			_bg.y = regionBG.y;
			_bg.width = regionBG.width;
			_bg.height = regionBG.height;
			addChildAt(_bg, tindex++);
			// id
			idLabel.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			idLabel.text = CJLang("SETTING_ID") + CJDataManager.o.DataOfAccounts.userID;
			// 区
			regionLabel.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			var json:Json_serverlist = CJServerList.getServerJS(CJServerList.getServerID());
			regionLabel.text = json.servername;// + CJLang("SETTING_REGION");
			// 新浪分享
			//根据91区分
			if(ConstGlobal.CHANNELID == ConstPlatformId.ID_91ANDROID ||
				ConstGlobal.CHANNELID == ConstPlatformId.ID_91IOS)
			{
				btnSinaShare.defaultSkin = new SImage(SApplication.assets.getTexture("shezhi_anniuBBS01"));
				btnSinaShare.downSkin = new SImage(SApplication.assets.getTexture("shezhi_anniuBBS02"));
			}
			else
			{
				btnSinaShare.defaultSkin = new SImage(SApplication.assets.getTexture("shezhi_anniuxinlang01"));
				btnSinaShare.downSkin = new SImage(SApplication.assets.getTexture("shezhi_anniuxinlang02"));
			}
			btnSinaShare.addEventListener(Event.TRIGGERED, function (e:Event):void{
				(SApplication.appInstance as MainApplication).platform.enterbbs();
			});
			//根据91区分
			if(ConstGlobal.CHANNELID == ConstPlatformId.ID_91ANDROID ||
				ConstGlobal.CHANNELID == ConstPlatformId.ID_91IOS)
			{
				// 制作人员
				btnProducer.defaultSkin = new SImage(SApplication.assets.getTexture("shezhi_91shequ01"));
				btnProducer.downSkin = new SImage(SApplication.assets.getTexture("shezhi_91shequ02"));
			}
			else
			{
				// 制作人员
				btnProducer.defaultSkin = new SImage(SApplication.assets.getTexture("shezhi_anniuzhizuorenyuan01"));
				btnProducer.downSkin = new SImage(SApplication.assets.getTexture("shezhi_anniuzhizuorenyuan02"));
			}
			btnProducer.addEventListener(Event.TRIGGERED, function (e:Event):void{
				(SApplication.appInstance as MainApplication).platform.enterplatform();
			});
			
			//根据91区分
			if(ConstGlobal.CHANNELID == ConstPlatformId.ID_91ANDROID ||
				ConstGlobal.CHANNELID == ConstPlatformId.ID_91IOS)
			{
				// 问题反馈
				btnQuestion.defaultSkin = new SImage(SApplication.assets.getTexture("shezhi_91anniuwenti01"));
				btnQuestion.downSkin = new SImage(SApplication.assets.getTexture("shezhi_91anniuwenti02"));
			}
			else
			{
				// 问题反馈
				btnQuestion.defaultSkin = new SImage(SApplication.assets.getTexture("shezhi_anniuwenti01"));
				btnQuestion.downSkin = new SImage(SApplication.assets.getTexture("shezhi_anniuwenti02"));		
			}
			btnQuestion.addEventListener(Event.TRIGGERED, function (e:Event):void{
				if(ConstGlobal.CHANNELID == ConstPlatformId.ID_91ANDROID ||
					ConstGlobal.CHANNELID == ConstPlatformId.ID_91IOS)
				{
					(SApplication.appInstance as MainApplication).platform.enterfeedback();
				}
				else
				{
					problemLayer.visible = true;
				}
			});
			
			// 切换服务器
			btnChangeServer.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			btnChangeServer.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			btnChangeServer.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniu03new"));
			btnChangeServer.addEventListener(Event.TRIGGERED, function (e:Event):void{
				SApplication.moduleManager.exitModule("CJSettingModule");
				SApplication.moduleManager.enterModule("CJSelectServerModule");
			});
			btnChangeServer.defaultLabelProperties.textFormat = ConstTextFormat.textformatyellow;
			btnChangeServer.label = CJLang("SETTING_CHANGE_SERVER");
			btnChangeServer.visible = !SCompileUtils.o.isOnVerify();
			
			// 切换账号 
			btnChangeAccount.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			btnChangeAccount.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			btnChangeAccount.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniu03new"));
			btnChangeAccount.addEventListener(Event.TRIGGERED, function (e:Event):void{
				(SApplication.appInstance as MainApplication).platform.logout(null);				
			});
			btnChangeAccount.defaultLabelProperties.textFormat = ConstTextFormat.textformatyellow;
			btnChangeAccount.label = CJLang("SETTING_CHANGE_ACCOUNT");
			CONFIG::CHANNELID_14 {
				btnChangeAccount.label = CJLang("SETTING_USER_MANAGE");
			}
			CONFIG::CHANNELID_19 {
				btnChangeAccount.label = CJLang("SETTING_USER_MANAGE");
			}
			
			// 删号重玩 
			btnUnbindAccount.defaultSkin = new SImage(SApplication.assets.getTexture("shezhi_anniushanhao01"));
			btnUnbindAccount.downSkin = new SImage(SApplication.assets.getTexture("shezhi_anniushanhao02"));
			btnUnbindAccount.addEventListener(Event.TRIGGERED, function (e:Event):void{
//				CJConfirmMessageBox(CJLang("SETTING_UNBIND"), __delroleAndrelogin);
				_unbindAccountlayer.visible = true;
				if (input) input.text = null;
			});
			
			/// 删号重玩二次提醒
//			// 面板
			_unbindAccountlayer = new SLayer;
			_unbindAccountlayer.width = ConstMainUI.MAPUNIT_WIDTH;
			_unbindAccountlayer.height = ConstMainUI.MAPUNIT_HEIGHT;
			addChild(_unbindAccountlayer);
			_unbindAccountlayer.visible = false;
			
			// 底框
			var texture9:Scale9Textures = new Scale9Textures(SApplication.assets.getTexture("common_tishikuang"),new Rectangle(16,16,1,1));
			var _image:Scale9Image = new Scale9Image(texture9);
			_image.width = 232;
			_image.height = 110;
			_image.x = (_unbindAccountlayer.width - _image.width) / 2;
			_image.y = (_unbindAccountlayer.height - _image.height) / 2;
			_unbindAccountlayer.addChild(_image);
			// 描述文字 
			var lable:Label = new Label;
			lable.x = _image.x + 10;
			lable.y = _image.y + 10;
			lable.width = _image.width - 20;
			lable.height = _image.height - 20;
			lable.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			lable.textRendererProperties.multiline = true; // 可显示多行
			lable.textRendererProperties.wordWrap = true; // 可自动换行
			lable.text = CJLang("SETTING_UNBIND_NOTICE");//删除账号将不可找回请慎重，请输入确认删除;
			_unbindAccountlayer.addChild(lable);
			
			// 输入框底框
			_image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("liaotian_wenzidikuang"),new Rectangle(6,6,2,2)));
			_image.width = 200;
			_image.height = 20;
			_image.x = 140;
			_image.y = 145;
			_unbindAccountlayer.addChild(_image);
			// 输入框
			var input:TextInput = new TextInput;
			input.x = _image.x;
			input.y = _image.y + 2;
			input.width = _image.width;
			input.height = _image.height;
			_unbindAccountlayer.addChild(input);
			// 设置名称输入框字体格式
			var fontFormat:Object = input.textEditorProperties;
			fontFormat.fontFamily = "宋体";
			fontFormat.color = 0xFFFFFFFF;
			fontFormat.displayAsPassword = false;
			fontFormat.textAlign = "center"; 
			fontFormat.maxChars = 10;
			input.textEditorProperties = fontFormat;
			
			// 确认按钮
			var okbtn:Button = CJButtonUtil.createCommonButton(CJLang("COMMON_TRUE"));
			okbtn.x = 150;
			okbtn.y = 170;
			okbtn.addEventListener(Event.TRIGGERED, function (e:Event):void{
				if (input.text == CJLang("SETTING_UNBIND_KEY"))
					CJConfirmMessageBox(CJLang("SETTING_UNBIND"), __delroleAndrelogin);
				else
					CJMessageBox(CJLang("SETTING_UNBIND_ERROR_KEY"));
			});
			_unbindAccountlayer.addChild(okbtn);
			
			// 取消
			var cancelbtn:Button = new Button;
			cancelbtn = CJButtonUtil.createCommonButton(CJLang("COMMON_CANCEL"));
			cancelbtn.x = 260;
			cancelbtn.y = okbtn.y;
			cancelbtn.addEventListener(Event.TRIGGERED, function (e:Event):void{
				_unbindAccountlayer.visible = false;
			});
			_unbindAccountlayer.addChild(cancelbtn);
			/// 删号重玩二次提醒 end
			
			// 版本号
			labelVersion.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			labelVersion.text = CJLang("SETTING_VERSION") + SPlatformUtils.getApplicationVersion();
			CONFIG::CHANNELID_0{
				labelVersion.text = CJLang("SETTING_VERSION") + SPlatformUtils.getApplicationVersion() + "/cmd:" + int(ConstGlobal.net_cmd_bytes/1024) + "KB";
			}
			
			// 初始化内容反馈界面
			_initProblemLayer();
		}
		
		// 初始化内容反馈界面
		private function _initProblemLayer():void
		{
			// 隐藏界面
			problemLayer.visible = false;
			addChild(problemLayer);
			
			var tindex:uint = 0;
			var _bg:Scale9Image;
			
			// 反馈标题
			problemTitle.textRendererProperties.textFormat = ConstTextFormat.textformatyellowcenter;
			problemTitle.text = CJLang("SETTING_PROBLEM_TITLE");
			// 关闭按钮
			btnProblemClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			btnProblemClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			btnProblemClose.addEventListener(Event.TRIGGERED, function (e:Event):void{
				problemLayer.visible = false;
				problemLabel.text = "";
			});
			
			// 底框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tankuangdi") , new Rectangle(19,19,1,1)));
			_bg.x = problemBG.x;
			_bg.y = problemBG.y;
			_bg.width = problemBG.width;
			_bg.height = problemBG.height;
			problemLayer.addChildAt(_bg, tindex++);
			// 内底框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_quanpingzhuangshidi") , new Rectangle(15, 13, 1, 1)));
			_bg.x = problemBG1.x;
			_bg.y = problemBG1.y;
			_bg.width = problemBG1.width;
			_bg.height = problemBG1.height;
			problemLayer.addChildAt(_bg, tindex++);
			// 内内底框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("shezhi_fankuidi") , new Rectangle(7,7,2,2)));
			_bg.x = problemBG2.x;
			_bg.y = problemBG2.y;
			_bg.width = problemBG2.width;
			_bg.height = problemBG2.height;
			problemLayer.addChildAt(_bg, tindex++);
			
			// 内容限制字数说明
			problemLimitLabel.textRendererProperties.textFormat = ConstTextFormat.textformatgreencenter;
			problemLimitLabel.text = CJLang("SETTING_PROBLEM_PROMPT");
			
			// 内容
			var fontFormat:Object = problemLabel.textEditorProperties;
			fontFormat.fontFamily = "黑体";
			fontFormat.multiline = true;
			fontFormat.fontSize = 10;
			fontFormat.maxChars = 100;
			problemLabel.textEditorProperties = fontFormat;
			
			// 提交按钮
			btnProblemSubmit.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			btnProblemSubmit.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			btnProblemSubmit.addEventListener(Event.TRIGGERED, _problemSubmit);
			btnProblemSubmit.defaultLabelProperties.textFormat = ConstTextFormat.textformatyellow;
			btnProblemSubmit.label = CJLang("SETTING_SUBMIT");
		}
		
		// 提交
		private function _problemSubmit(e:Event):void
		{
			
			
			if (problemLabel.text.length == 0)
			{
				CJMessageBox(CJLang("SETTING_SUBMIT_NULL"));
				return;
			}
			
			// 删除账号信息
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, __onProblemSubmit);
			SocketCommand_role.collect_problem(problemLabel.text);
		}
		
		/**
		 * 提交问题反馈
		 * */
		private function __onProblemSubmit(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_ROLE_COLLECT_PROBLEM)
				return;
			
			e.target.removeEventListener(e.type, _onUnbindQuickAccount);
			problemLayer.visible = false;
			problemLabel.text = "";
			// 提示
			CJMessageBox(CJLang("SETTING_SUBMIT_BACK"));
		}
		
		// 删号 登出
		private function __delroleAndrelogin():void
		{
			var md5:String = (SApplication.appInstance as MainApplication).platform.SessionId();
			var uid:String = (SApplication.appInstance as MainApplication).platform.uid();
			// 删除账号信息
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onUnbindQuickAccount);
			SocketCommand_account.unbind_quick_account(md5, uid);
		}
		
		/**
		 * 解绑账号
		 * */
		private function _onUnbindQuickAccount(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_ACCOUNT_QUICK_ACCOUNT)
				return;
			
			e.target.removeEventListener(e.type, _onUnbindQuickAccount);
			
			// 清除所有保存在内存中的数据
			//清除阵型指引的cache
			var formationDirectData:SDataBase = new SDataBase("CJDataOfFormation");
			formationDirectData.setData("formationdirected" , 0);
			formationDirectData.saveToCache();
			
			Starling.juggler.delayCall(function():void{
				CJDataManager.o.clearData();
				// 直接退出游戏
				SApplicationUtils.exit();
			} , 0.2);
			
//			// 退出Module
//			SApplication.moduleManager.exitModule("CJSettingModule");
//			// 登出
//			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onLogouted);
//			SocketCommand_account.logout();
		}
		
		/**
		 * 登出回调
		 * @param e
		 * add by longtao 
		 */
		private function _onLogouted(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_LOGOUT)
				return;
			
			e.target.removeEventListener(e.type,_onLogouted);
			var retCode:uint = message.params(0);
			var isLogout:Boolean = message.params(1);
			if (isLogout)
			{
				// 清除所有保存在内存中的数据
				CJDataManager.o.clearData();
				
				// 切换至登录状态
				SApplication.stateManager.ChangeState("GameStateLogin");
			}
		}
		
		
	}
}