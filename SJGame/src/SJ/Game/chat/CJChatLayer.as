package SJ.Game.chat
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstChat;
	import SJ.Common.Constants.ConstRichText;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_chat;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.richtext.CJRTElement;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TabBar;
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 +------------------------------------------------------------------------------
	 * 聊天主面板
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-8 下午12:03:44  
	 +------------------------------------------------------------------------------
	 */
	public class CJChatLayer extends SLayer
	{
		/*上面tab的名字*/
		public const NAME_TAB_LIST:Array = ["ALL" , "WORLD" , "ARMY" , "PRIVATE" , "NOTICE"]; 
		private var _btnClose:Button;
		/*中间的选项卡*/
		private var _screenNavigator:ScreenNavigator;
		/*按钮切换*/
		private var _tabBar:TabBar;
		/*发送按钮*/
		private var _buttonSend:Button;
		/*输入框*/
		private var _inputText:TextInput;
		/*左下状态按钮*/
		private var _channelButton:Button;
		/*点击频道按钮弹出菜单*/
		private var _channelMenu:CJChatButtonMenu;
		/*点击名字弹出菜单*/
		private var _nameMenu:CJChatNameMenu;

		private var _privateChatClickedElement:CJRTElement;
		
		private var _params:Object;

		
		public function CJChatLayer(params:Object = null)
		{
			super();
			this._params = params;
		}
		
		override protected function initialize():void
		{
			this._drawContent();
			this._addLiteners();
			this._afterInitialize();
		}
		
		private function _afterInitialize():void
		{
			if(this._params != null && this._params.fromuid)
			{
				//更改按钮的lablel
				this._channelButton.label = CJLang("CHAT_PRIVATE");
				//			设置主框的选中页
				this._tabBar.selectedIndex = 3;
				
				this._inputText.text = "";
				this._inputText.text = this._params.rolename+":";
				this._inputText.selectRange(_inputText.text.length);
				this._inputText.setFocus();
				
				_privateChatClickedElement = new CJRTElement(ConstRichText.CJRT_ELEMENT_TYPE_LABEL);
				_privateChatClickedElement.data.rolename = this._params.rolename;
				_privateChatClickedElement.data.fromuid = this._params.fromuid;
			}
		}		
		
		private function _drawContent():void
		{
			this._drawTitle();
			this._drawTabBar();
			this._drawScreenNatigator();
			this._drawBottom();
		}
		
		private function _drawBottom():void
		{
			_channelButton = new Button();
			_channelButton.labelFactory = textRender.htmlTextRender;
			_channelButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_channelButton.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_channelButton.x = 75;
			_channelButton.y = 272;
			_channelButton.width = 62;
			_channelButton.height = 25;
			this._channelButton.name = "channel";
			
			var format:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI , 14 , 0xBDAB83 , null , null , null , null , null , TextFormatAlign.CENTER);
			_channelButton.defaultLabelProperties.textFormat = format
			_channelButton.label = CJLang("CHAT_"+NAME_TAB_LIST[1]);
			this.addChild(_channelButton);
			
			_inputText = new TextInput();
			_inputText.width = 212;
			_inputText.height = 26;
			_inputText.maxChars = 30;
			_inputText.x = 142;
			_inputText.y = 272;
			_inputText.paddingTop = 3;
			_inputText.paddingBottom = 3;
			_inputText.paddingLeft = 5;
			_inputText.backgroundSkin = new Scale9Image( new Scale9Textures(SApplication.assets.getTexture("common_liaotian_wenzidi") , new Rectangle(4 , 4 , 1, 1)));
			_inputText.textEditorFactory = function():ITextEditor
			{
				var editor:StageTextTextEditor = new StageTextTextEditor();
				editor.fontFamily = ConstTextFormat.FONT_FAMILY_HEITI;
				editor.fontSize = 16;
				editor.color = 0xffffff;
				return editor;
			}
			this.addChild(_inputText);
			
			_buttonSend = new Button();
			_buttonSend.labelFactory = textRender.htmlTextRender;
			_buttonSend.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_buttonSend.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_buttonSend.x = 357;
			_buttonSend.y = 272;
			_buttonSend.width = 62;
			_buttonSend.height = 25;
			_buttonSend.name = "send";
			_buttonSend.defaultLabelProperties.textFormat = format;
			_buttonSend.label = CJLang("CHAT_FASONG");
			this.addChild(_buttonSend);
		}
		
		private function _drawTitle():void
		{
			var bg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew") , new Rectangle(1 ,1 , 1, 1)));
			bg.width = SApplicationConfig.o.stageWidth;
			bg.height = SApplicationConfig.o.stageHeight;
			this.addChild(bg);
			
			//头部绿条
			var bar:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			bar.width = SApplicationConfig.o.stageWidth;
			this.addChild(bar);
			
			var bgWrap:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_quanpingzhuangshi") , new Rectangle(15 ,13 , 1, 1)));
			bgWrap.width = SApplicationConfig.o.stageWidth;
			bgWrap.height = SApplicationConfig.o.stageHeight;
			this.addChild(bgWrap);
			
			_btnClose = new Button();
			_btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu01"));
			_btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu02"));
			_btnClose.x = 438;
			_btnClose.y = 0;
			_btnClose.name = "close";
			this.addChild(_btnClose);
			
			var title:CJPanelTitle = new CJPanelTitle( CJLang("CHAT_LIAOTIAN"));
			this.addChild(title);
			title.fullScreen = 1;
		}
		
		private function _drawTabBar():void
		{
			this._tabBar = new TabBar();
			this._tabBar.name = "mainbar";
			this._tabBar.x = 4;
			this._tabBar.y = 36;
			this._tabBar.direction = TabBar.DIRECTION_VERTICAL;
			this._tabBar.gap = 8;
			this._tabBar.selectedIndex = 1;
			
			this._setTabBarData();
			this._setTabRender();
			
			this.addChild(this._tabBar);
		}
		
		private function _setTabRender():void
		{
			_tabBar.tabFactory = function():Button
			{
				var btn:Button = new Button();
				btn.defaultSkin = new SImage(SApplication.assets.getTexture("common_xuanxiangka02"));
				btn.defaultSelectedSkin = new SImage(SApplication.assets.getTexture("common_xuanxiangka01"));
				btn.width = 57;
				btn.height = 42;
				var format:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI , 14 , 0xffffff , null , null , null , null , null , TextFormatAlign.CENTER);
				btn.defaultLabelProperties.textFormat = format;
				btn.labelFactory = textRender.htmlTextRender;
				return btn;
			}
		}
		
		private function _setTabBarData():void
		{
			var data:Array = new Array();
			for(var i:String in NAME_TAB_LIST)
			{
				data.push({label : CJLang("CHAT_"+NAME_TAB_LIST[i]) , name:NAME_TAB_LIST[i]});
			}
			this._tabBar.dataProvider = new ListCollection(data);
		}
		
		private function _drawScreenNatigator():void
		{
			this._screenNavigator = new ScreenNavigator();
			for(var i:String in NAME_TAB_LIST)
			{
				var item:ScreenNavigatorItem = new ScreenNavigatorItem(CJChatScreen , null , {key:NAME_TAB_LIST[i], owner:_screenNavigator});
				this._screenNavigator.addScreen(NAME_TAB_LIST[i] ,item);
			}
			this._screenNavigator.showScreen(NAME_TAB_LIST[1]);
			this._screenNavigator.x = 60;
			this._screenNavigator.y = 19;
			this.addChildAt( this._screenNavigator , 3);
		}
		
		/**
		 * 添加相关监听器
		 */
		private function _addLiteners():void
		{
			this._btnClose.addEventListener(Event.TRIGGERED , this._closeDialog);
			this._buttonSend.addEventListener(Event.TRIGGERED , this._sendContent);
			this._tabBar.addEventListener(Event.CHANGE, tabs_changeHandler);
			this._channelButton.addEventListener(Event.TRIGGERED , this._showOrHideChannelMenu);
			this.addEventListener(TouchEvent.TOUCH , this._touchHandler);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_CHAT_PRIVATE , this._privateChatHandler);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_RICH_TEXT_CLICK_EVENT , this._richTextClicked);
		}
		
		private function _richTextClicked(e:Event):void
		{
			if(e.type != CJEvent.EVENT_RICH_TEXT_CLICK_EVENT)
			{
				return;
			}
			
			var data:Object = e.data;
			if(null == data)
			{
				return;
			}
			
			_privateChatClickedElement = data.elementdata as CJRTElement;
			
			if(_privateChatClickedElement && _privateChatClickedElement.clickable)
			{
				//判断 ，如果是自己，跳出
				var userName:String = CJDataManager.o.DataOfRole.name;
				if(String(_privateChatClickedElement.text).indexOf(userName) != -1)
				{
					return;
				}
				this._inputText.text = "";
				this._inputText.text = _privateChatClickedElement.data.rolename+":";
			}
			else
			{
				this._inputText.text = "";
			}
		}
		
		private function _privateChatHandler(e:Event):void
		{
			if(e.type != CJEvent.EVENT_CHAT_PRIVATE)
			{
				return;
			}
			_privateChatClickedElement = e.data as CJRTElement;
			this._inputText.setFocus();
			this._inputText.text = _privateChatClickedElement.data.rolename+":";
			this._inputText.selectRange(_inputText.text.length , _inputText.text.length);
		}
		
		private function _touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(null != touch && touch.phase == TouchPhase.ENDED)
			{
				var globalPoint:Point = new Point( touch.globalX , touch.globalY);
				if(this._channelMenu != null 
					&& !this._channelMenu.hitTest(this._channelMenu.globalToLocal(globalPoint))
					&& !this._channelButton.hitTest(this._channelButton.globalToLocal(globalPoint)))
				{
					this._closeChannelMenu();
				}
				
				if(this._nameMenu != null 
					&& !this._nameMenu.hitTest(this._nameMenu.globalToLocal(globalPoint)) 
					&& !this._channelButton.hitTest(this._channelButton.globalToLocal(globalPoint)))
				{
					this._nameMenu.closeMenu();
				}
			}
		}
		
		private function _showOrHideChannelMenu(e:Event):void
		{
			if(!e.target is Button  || (e.target as Button).name != "channel")
			{
				return;
			}
			if(this._channelMenu == null)
			{
				this._channelMenu = new CJChatButtonMenu();
				this._channelMenu.x = 76 ;
				this._channelMenu.y = 165 ;
				this.addChild(this._channelMenu);
				this._channelMenu.addEventListener("channelmenuclicked" , this._channelChangedHandler);
			}
			else
			{
				this._closeChannelMenu();
			}
		}
		
		private function _closeChannelMenu():void
		{
			this._channelMenu.closeMenu();
			this._channelMenu = null;
		}
		
		private function _channelChangedHandler(e:Event):void
		{
			if(e.type != "channelmenuclicked")
			{
				return;
			}
			//更改按钮的lablel
			this._channelButton.label = CJLang("CHAT_"+e.data.menu);
			//			设置主框的选中页
			this._tabBar.selectedIndex = NAME_TAB_LIST.indexOf(e.data.menu);
			//			关闭弹出菜单
			this._closeChannelMenu();
		}
		
		private function _sendContent(e:Event):void
		{
			if((e.target as Button).name != "send")
			{
				return;
			}
			var content:String = _inputText.text;
			if(content.length == 0)
			{
				CJMessageBox(CJLang("CHAT_FAYANTISHI"));
				return;
			}
			var channel:CJChatScreen = this._screenNavigator.activeScreen as CJChatScreen;
			
			if(!CJChatUtil.checkCanSend(channel.screenID))
			{
				return;
			}
			
			if(channel.screenID == "ARMY")
			{
				SocketCommand_chat.chat(ConstChat.CHAT_TYPE_ARMY ,content ,"-1");
				CJDataManager.o.DataOfChat.lastChatTime = new Date().time;
				_inputText.text = "";
			}
			else if(channel.screenID == "WORLD")
			{
				SocketCommand_chat.chat(ConstChat.CHAT_TYPE_WORLD ,content ,"-1");
				CJDataManager.o.DataOfChat.lastChatTime = new Date().time;
				_inputText.text = "";
				CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false , {"key":CJActivityEventKey.ACTIVITY_CHAT});
			}
			else if(channel.screenID == "PRIVATE")
			{
				if(content.indexOf(":") == -1)
				{
					CJMessageBox(CJLang("CHAT_SILIAO"));
				}
				else
				{
					content = content.substring(content.indexOf(":")+1 , content.length);
					SocketCommand_chat.chat(ConstChat.CHAT_TYPE_PRIVATE ,content ,_privateChatClickedElement.data.fromuid);
					CJDataManager.o.DataOfChat.lastChatTime = new Date().time;
					_inputText.text = _privateChatClickedElement.data.rolename+":";
					CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false , {"key":CJActivityEventKey.ACTIVITY_CHAT});
				}
			}
		}
		
		private function tabs_changeHandler(e:Event):void
		{
			if(e.target is TabBar && (e.target as TabBar).name == "mainbar")
			{
				var tabs:TabBar = e.currentTarget as TabBar;
				var selectedIndex:int = tabs.selectedIndex;
				this._screenNavigator.showScreen(NAME_TAB_LIST[selectedIndex]);
				if(selectedIndex == 1 || selectedIndex == 2 || selectedIndex == 3)
				{
					_channelButton.label = CJLang("CHAT_"+NAME_TAB_LIST[selectedIndex]);
					_inputText.isEnabled = true;
					_inputText.alpha = 1;
					_buttonSend.isEnabled = true;
				}
				else
				{
					_inputText.isEnabled = false;
					_inputText.alpha = 0.4;
					_buttonSend.isEnabled = false;
				}
			}
		}
		
		private function _closeDialog(e:Event):void
		{
			if((e.target as Button).name != "close")
			{
				return;
			}
			this._btnClose.removeEventListener(Event.TRIGGERED , this._closeDialog);
			this._buttonSend.removeEventListener(Event.TRIGGERED , this._sendContent);
			this._tabBar.removeEventListener(Event.CHANGE, tabs_changeHandler);
			this._channelButton.removeEventListener(Event.TRIGGERED , this._showOrHideChannelMenu);
			SApplication.moduleManager.exitModule(CJChatModule.MOUDLE_NAME);
		}

		override public function dispose():void
		{
			super.dispose();
			this._btnClose.removeEventListener(Event.TRIGGERED , this._closeDialog);
			this._buttonSend.removeEventListener(Event.TRIGGERED , this._sendContent);
			this._tabBar.removeEventListener(Event.CHANGE, tabs_changeHandler);
			this._channelButton.removeEventListener(Event.TRIGGERED , this._showOrHideChannelMenu);
			this.removeEventListener(TouchEvent.TOUCH , this._touchHandler);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_CHAT_PRIVATE , this._privateChatHandler);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_RICH_TEXT_CLICK_EVENT , this._richTextClicked);
			
			_privateChatClickedElement = null;
			_nameMenu = null;
		}
		
		public function get channelButton():Button
		{
			return _channelButton;
		}

		public function get tabBar():TabBar
		{
			return _tabBar;
		}
	}
}