package SJ.Game.selectServer
{
	import SJ.Common.Constants.ConstMainUI;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.ServerList.CJServerList;
	import SJ.Game.data.json.Json_serverlist;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.utils.SApplicationUtils;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class CJSelectServerLayer extends SLayer
	{
		private var _serverlistlayer:SLayer;
		/**  选择服务器列表 **/
		public function get serverlistlayer():SLayer
		{
			return _serverlistlayer;
		}
		/** @private **/
		public function set serverlistlayer(value:SLayer):void
		{
			_serverlistlayer = value;
		}
		private var _bgPos:Label;
		/**  底框 **/
		public function get bgPos():Label
		{
			return _bgPos;
		}
		/** @private **/
		public function set bgPos(value:Label):void
		{
			_bgPos = value;
		}
		private var _inBgPos:Label;
		/**  内框 **/
		public function get inBgPos():Label
		{
			return _inBgPos;
		}
		/** @private **/
		public function set inBgPos(value:Label):void
		{
			_inBgPos = value;
		}
		private var _miniBgPos:Label;
		/**  小框 **/
		public function get miniBgPos():Label
		{
			return _miniBgPos;
		}
		/** @private **/
		public function set miniBgPos(value:Label):void
		{
			_miniBgPos = value;
		}
		private var _latelyServerLabel:Label;
		/**  最近登录服务器label **/
		public function get latelyServerLabel():Label
		{
			return _latelyServerLabel;
		}
		/** @private **/
		public function set latelyServerLabel(value:Label):void
		{
			_latelyServerLabel = value;
		}
		private var _btnLatelyServer:Button;
		/**  最近登录服务器Button **/
		public function get btnLatelyServer():Button
		{
			return _btnLatelyServer;
		}
		/** @private **/
		public function set btnLatelyServer(value:Button):void
		{
			_btnLatelyServer = value;
		}
		private var _turnPagePos:Label;
		/**  翻页框 **/
		public function get turnPagePos():Label
		{
			return _turnPagePos;
		}
		/** @private **/
		public function set turnPagePos(value:Label):void
		{
			_turnPagePos = value;
		}
		private var _selectlayer:SLayer;
		/**  选择服务器 **/
		public function get selectlayer():SLayer
		{
			return _selectlayer;
		}
		/** @private **/
		public function set selectlayer(value:SLayer):void
		{
			_selectlayer = value;
		}
		private var _selectBGPos:Label;
		/**  底框 **/
		public function get selectBGPos():Label
		{
			return _selectBGPos;
		}
		/** @private **/
		public function set selectBGPos(value:Label):void
		{
			_selectBGPos = value;
		}
		private var _selectInBgPos:Label;
		/**  内框 **/
		public function get selectInBgPos():Label
		{
			return _selectInBgPos;
		}
		/** @private **/
		public function set selectInBgPos(value:Label):void
		{
			_selectInBgPos = value;
		}
		private var _btnReturnList:Button;
		/**  返回服务器列表 **/
		public function get btnReturnList():Button
		{
			return _btnReturnList;
		}
		/** @private **/
		public function set btnReturnList(value:Button):void
		{
			_btnReturnList = value;
		}
		private var _btnCurrServer:Button;
		/**  返回服务器列表 **/
		public function get btnCurrServer():Button
		{
			return _btnCurrServer;
		}
		/** @private **/
		public function set btnCurrServer(value:Button):void
		{
			_btnCurrServer = value;
		}
		private var _btnEnter:Button;
		/**  进入游戏 **/
		public function get btnEnter():Button
		{
			return _btnEnter;
		}
		/** @private **/
		public function set btnEnter(value:Button):void
		{
			_btnEnter = value;
		}
		private var _btnListClose:Button;
		/** 退出 **/
		public function get btnListClose():Button
		{
			return _btnListClose;
		}
		/** @private */
		public function set btnListClose(value:Button):void
		{
			_btnListClose = value;
		}
		private var _btnSelectClose:Button;
		/** 退出 **/
		public function get btnSelectClose():Button
		{
			return _btnSelectClose;
		}
		/** @private */
		public function set btnSelectClose(value:Button):void
		{
			_btnSelectClose = value;
		}

		
		private const _COLOR_:uint = 0x303030;
		
		/** 标题 **/
		private var _titleOfList:Label;
		/** 选择列表滑动面板 **/
		private var _panel:CJSelectServerPanel;
		/** 最近登录服务器按钮 **/
		private var _latelyServerBtn:CJSelectServerBtn;
		
		
		/** 标题 **/
		private var _titleOfStart:Label;
		/** 返回服务器列表 **/
		private var _returnToList:Button;
		/** 当前登录服务器按钮 **/
		private var _curServerBtn:CJSelectServerBtn;
		
		
		public function CJSelectServerLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
//			var btn:Button = new Button;
//			btn.x = 100;
//			btn.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeup01"));
//			btn.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeup03"));
//			btn.addEventListener(Event.TRIGGERED , function (e:Event):void{
//				SApplication.moduleManager.exitModule("CJSelectServerModule");
//			});
//			addChild(btn)
			
			
			// 设置宽高
			width = ConstMainUI.MAPUNIT_WIDTH;
			height = ConstMainUI.MAPUNIT_HEIGHT;
			
			// 关闭按钮纹理
			btnListClose.defaultSkin = new SImage( SApplication.assets.getTexture("common_guanbianniu01new") );
			btnListClose.downSkin = new SImage( SApplication.assets.getTexture("common_guanbianniu02new") );
			btnListClose.addEventListener(Event.TRIGGERED, function(e:Event):void{
				SApplication.moduleManager.exitModule("CJSelectServerModule");
			});
			
			// 关闭按钮纹理
			btnSelectClose.defaultSkin = new SImage( SApplication.assets.getTexture("common_guanbianniu01new") );
			btnSelectClose.downSkin = new SImage( SApplication.assets.getTexture("common_guanbianniu02new") );
			btnSelectClose.addEventListener(Event.TRIGGERED, function(e:Event):void{
				SApplication.moduleManager.exitModule("CJSelectServerModule");
			});
			
			/*-------------------------- 选择服务器列表 --------------------------*/
			var tindex:uint = 0;
			var _bg:Scale9Image;
			// 底框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tankuangdi") , new Rectangle(19,19,1,1)));
			_bg.x = bgPos.x;
			_bg.y = bgPos.y;
			_bg.width = bgPos.width;
			_bg.height = bgPos.height;
			serverlistlayer.addChildAt(_bg, tindex++);
			
			// 内框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew") , new Rectangle(1,1,2,2)));
			_bg.x = inBgPos.x;
			_bg.y = inBgPos.y;
			_bg.width = inBgPos.width;
			_bg.height = inBgPos.height;
			_bg.color = _COLOR_;
			serverlistlayer.addChildAt(_bg, tindex++);
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tanchuagnzhuangshi") , new Rectangle(9,8,1,1)));
			_bg.x = inBgPos.x+2;
			_bg.y = inBgPos.y+2;
			_bg.width = inBgPos.width-4;
			_bg.height = inBgPos.height-4;
			serverlistlayer.addChildAt(_bg, tindex++);
			
			// 左侧线
			var img:SImage = new SImage(SApplication.assets.getTexture("common_tankuangbiaotouzhuangshixian"));
			img.x = bgPos.x + 3;
			img.y = bgPos.y + 10;
			img.width = 80;
			serverlistlayer.addChild(img);
			img = new SImage(SApplication.assets.getTexture("common_tankuangbiaotouzhuangshixian"));
			img.x = bgPos.x + bgPos.width - 3;
			img.y = bgPos.y + 10;
			img.scaleX = -1;
			img.width = -80;
			serverlistlayer.addChild(img);
			
			// 标题
			_titleOfList = new Label();
			_titleOfList.x = bgPos.x;
			_titleOfList.y = bgPos.y;
			_titleOfList.width = bgPos.width;
			_titleOfList.height = 20;
			_titleOfList.textRendererProperties.textFormat = ConstTextFormat.textformatsubheading;
			_titleOfList.text = CJLang("SELECT_SERVER_LIST_TITLE");
			serverlistlayer.addChild(_titleOfList);
			
			// 面板
			_panel = new CJSelectServerPanel;
			_panel.x = inBgPos.x + 4;
			_panel.y = inBgPos.y + 4;
			_panel.width = 255;
			_panel.height = 118;
			serverlistlayer.addChild(_panel);
			
			// 小框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("zhuce_zuijindengludi") , new Rectangle(5,5,2,2)));
			_bg.x = miniBgPos.x;
			_bg.y = miniBgPos.y;
			_bg.width = miniBgPos.width;
			_bg.height = miniBgPos.height;
			serverlistlayer.addChildAt(_bg, tindex++);
			
			// 最近登录服务器提示文字
			latelyServerLabel.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			latelyServerLabel.text = CJLang("SELECT_SERVER_LATELY_LABEL");
			
			// 最近登录的服务器按钮
			var servername:String = CJServerList.getServerJS(CJServerList.getServerID()).servername;
			_latelyServerBtn = new CJSelectServerBtn(servername);
			_latelyServerBtn.serverid = CJServerList.getServerID();
			_latelyServerBtn.x = btnLatelyServer.x;
			_latelyServerBtn.y = btnLatelyServer.y;
			serverlistlayer.addChild(_latelyServerBtn);
			/*-------------------------- 选择服务器列表 end --------------------------*/
			
			/*-------------------------- 选择服务器 --------------------------*/
			selectlayer.visible = false;
			
			_titleOfStart = new Label();
			_titleOfStart.x = selectBGPos.x;
			_titleOfStart.y = selectBGPos.y;
			_titleOfStart.width = selectBGPos.width;
			_titleOfStart.height = 20;
			_titleOfStart.textRendererProperties.textFormat = ConstTextFormat.textformatsubheading;
			_titleOfStart.text = CJLang("SELECT_SERVER_START_TITLE");
			selectlayer.addChild(_titleOfStart);
			// 左侧线
			img = new SImage(SApplication.assets.getTexture("common_tankuangbiaotouzhuangshixian"));
			img.x = selectBGPos.x + 3;
			img.y = selectBGPos.y + 10;
			img.width = 80;
			selectlayer.addChild(img);
			img = new SImage(SApplication.assets.getTexture("common_tankuangbiaotouzhuangshixian"));
			img.x = selectBGPos.x + selectBGPos.width - 3;
			img.y = selectBGPos.y + 10;
			img.scaleX = -1;
			img.width = -80;
			selectlayer.addChild(img);
			
			tindex = 0;
			// 底框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tankuangdi") , new Rectangle(19,19,1,1)));
			_bg.x = selectBGPos.x;
			_bg.y = selectBGPos.y;
			_bg.width = selectBGPos.width;
			_bg.height = selectBGPos.height;
			selectlayer.addChildAt(_bg, tindex++);
			// 内框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew") , new Rectangle(1,1,2,2)));
			_bg.x = selectInBgPos.x;
			_bg.y = selectInBgPos.y;
			_bg.width = selectInBgPos.width;
			_bg.height = selectInBgPos.height;
			_bg.color = _COLOR_;
			selectlayer.addChildAt(_bg, tindex++);
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tanchuagnzhuangshi") , new Rectangle(9,8,1,1)));
			_bg.x = selectInBgPos.x+2;
			_bg.y = selectInBgPos.y+2;
			_bg.width = selectInBgPos.width-4;
			_bg.height = selectInBgPos.height-4;
			selectlayer.addChildAt(_bg, tindex++);
			
			// 返回服务器列表
			_returnToList = new Button;
//			_returnToList.defaultSkin = new SImage( SApplication.assets.getTexture("fuwuqi_fuwuqianniu01") );
			_returnToList.x = btnReturnList.x;
			_returnToList.y = btnReturnList.y;
			_returnToList.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
			_returnToList.label = CJLang("SELECT_SERVER_RETURN_LIST");
			selectlayer.addChild(_returnToList);
			_returnToList.addEventListener(Event.TRIGGERED, function (e:Event):void{
				serverlistlayer.visible = true;
				selectlayer.visible = false;
			});
			
			// 当前服务器按钮
			_curServerBtn = new CJSelectServerBtn;
			_curServerBtn.touchable = false;
			_curServerBtn.x = btnCurrServer.x;
			_curServerBtn.y = btnCurrServer.y;
			selectlayer.addChild(_curServerBtn);
			
			btnEnter.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniuda01new") );
			btnEnter.downSkin = new SImage( SApplication.assets.getTexture("common_anniuda02new") );
			btnEnter.addEventListener(Event.TRIGGERED, function (e:Event):void{
				
				CJConfirmMessageBox(CJLang("SELECT_SERVER_NOTICE"), function ():void
				{
					CJServerList.SelectServer(_curServerBtn.serverid);
					SApplicationUtils.exit();
				});
				
			});
			btnEnter.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
			btnEnter.label = CJLang("SELECT_SERVER_ENTER_GAME");
			/*-------------------------- 选择服务器 end --------------------------*/
			
			// 添加触摸事件
			addEventListener(TouchEvent.TOUCH, _touchHandler);
		}
		
		/** 检测移动范围 **/
		private var _checkPosY:int = 0;
		private function _touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if (touch == null)
				return;
			if (touch.phase == TouchPhase.BEGAN)
				_checkPosY = touch.globalY;
			if (touch.phase != TouchPhase.ENDED)
				return;
			if (Math.abs(_checkPosY-touch.globalY) > 5)
				return;
			
			if (!(touch.target is CJSelectServerBtn))
				return;
			
			var btn:CJSelectServerBtn = touch.target as CJSelectServerBtn;
			var json:Json_serverlist = CJServerList.getServerJS(btn.serverid);
			
			_curServerBtn.setServerID( btn.serverid );
			_curServerBtn.serverState = btn.serverState;
			_curServerBtn.isRecommend = int(json.recommend)==0 ? false : true;
			_curServerBtn.serverName = json.servername;
			
			switch(_curServerBtn.serverState)
			{
				case CJSelectServerBtn.SELECT_STATE_FULL:
					CJMessageBox(CJLang("SELECT_SERVER_STATE_FULL"));
					return;
				case CJSelectServerBtn.SELECT_STATE_MAINTAIN:
					CJMessageBox(CJLang("SELECT_SERVER_STATE_MAINTAIN"));
					return;	
				default:
					break;
			}
			serverlistlayer.visible = false;
			selectlayer.visible = true;
		}
	}
}