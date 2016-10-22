package SJ.Game.dynamics
{
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstFriend;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_friend;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.friends.CJHeroHeadIconItem;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale9Image;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class CJDynamicAddFriendLayer extends SLayer
	{
		/**标题左边亮线*/
		private var _imgTitleleft:SImage;
		/**标题右边亮线*/
		private var _imgTitleRight:ImageLoader;
		/**标题 */
		private var _labTitle:Label;
		/**玩家单元*/
		private var _itemHero:CJHeroHeadIconItem;
		/**玩家等级*/
		private var _labHeroLevel:Label;
		/**玩家名称*/
		private var _labHeroName:Label;
		/**玩家战斗力*/
		private var _labBattlePower:Label;
		/**描述内容 */
		private var _labDesc:Label;
//		/**关闭按钮*/
//		private var _btnClose:Button;
		/**确定按钮*/
		private var _btnConfirm:Button;
//		/**取消按钮*/
//		private var _btnCancel:Button;
		/**要添加好友的uid*/
		private var _uid:String;
		/**要添加好友信息*/
		private var _playerInfo:Object;
		/**可点击背景*/
		private var _quad:Quad;
		public function CJDynamicAddFriendLayer(uid:String)
		{
			super();
			_uid = uid;
			this.setSize(200, 162);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			//添加数据到达监听 
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadOtherRoleInfo);
			SocketCommand_role.get_other_role_info(_uid);
		}
		
		
		override public function dispose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadOtherRoleInfo);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadRequest);
			super.dispose();
		}
		/**
		 * 加载服务器其他角色数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadOtherRoleInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_ROLE_GET_OTHER_ROLE_INFO)
			{
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadOtherRoleInfo);
				if (message.retcode == 0)
				{
					_playerInfo = message.retparams;
					_initialize();
				}
			}
		}
		
		private function _initialize():void
		{
			_drawContent();
			_addListener();
		}
		
		/**
		 * 绘制界面内容
		 */	
		private function _drawContent():void
		{
			_quad = new Quad(SApplicationConfig.o.stageWidth, SApplicationConfig.o.stageHeight);
			_quad.alpha = 0;
			_quad.x = (this.width - SApplicationConfig.o.stageWidth) / 2;
			_quad.y = (this.height - SApplicationConfig.o.stageHeight) / 2;
			this.addChild(_quad);
			
			//	 整体外框
			var imgFrame:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_tankuangdi", 19,19,1,1);
			imgFrame.width = 200;
			imgFrame.height = 162;
//			imgFrame.y = 14;
			this.addChild(imgFrame);
			
			_imgTitleleft = new SImage(SApplication.assets.getTexture("common_tankuangbiaotouzhuangshixian"));
			_imgTitleleft.x = 10;
			_imgTitleleft.y = 11;
			_imgTitleleft.width = 46;
			this.addChild(_imgTitleleft);
			
			_imgTitleRight = new ImageLoader();
			_imgTitleRight.source = SApplication.assets.getTexture("common_tankuangbiaotouzhuangshixian");
			_imgTitleRight.width = 46;
			_imgTitleRight.x = 146 + _imgTitleRight.width;
			_imgTitleRight.y = 12;
			_imgTitleRight.scaleX = -1;
			this.addChild(_imgTitleRight);
			
			_labTitle = new Label();
			_labTitle.x = 67;
			_labTitle.y = 2;
			_labTitle.text = CJLang("DYNAMIC_ADD_FRIEND");
			this.addChild(_labTitle);
			
			//	 下方装饰框
			var imgBottomFrame:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_tankuangwenzidi", 11, 11,1,1);
			imgBottomFrame.width = 190;
			imgBottomFrame.height = 134;
			imgBottomFrame.x = 5;
			imgBottomFrame.y = 22;
			this.addChild(imgBottomFrame);
			
			if (_playerInfo && _playerInfo.hasOwnProperty("templateid"))
			{
				var heroTmpl:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(_playerInfo.templateid);
				_itemHero = new CJHeroHeadIconItem();
				_itemHero.x = 17;
				_itemHero.y = 51;
				_itemHero.setHeadImg(heroTmpl.headicon);
				this.addChild(_itemHero);
			}
			
			_labHeroLevel = new Label();
			_labHeroLevel.x = 18;
			_labHeroLevel.y = 82;
			_labHeroLevel.width = 50;
			if (_playerInfo && _playerInfo.hasOwnProperty("level"))
			{
				_labHeroLevel.text = "LV：" + _playerInfo.level;
			}
			this.addChild(_labHeroLevel);
			
			_labHeroName = new Label();
			_labHeroName.x = 75;
			_labHeroName.y = 58;
			if (_playerInfo && _playerInfo.hasOwnProperty("rolename"))
			{
				_labHeroName.text = _playerInfo.rolename;
			}
			this.addChild(_labHeroName);
			
			_labBattlePower = new Label();
			_labBattlePower.x = 75;
			_labBattlePower.y = 78;
			if (_playerInfo && _playerInfo.hasOwnProperty("battleeffectsum"))
			{
				_labBattlePower.text = CJLang("DYNAMIC_BATTLE_POWER").replace("{battlepower}", _playerInfo.battleeffectsum);
			}
			this.addChild(_labBattlePower);
			
			_labDesc = new Label();
			_labDesc.x = 17;
			_labDesc.y = 100;
			if (_playerInfo && _playerInfo.hasOwnProperty("templateid") && _uid)
			{
				_labDesc.text = CJLang("DYNAMIC_ADD_FRIEND_OR_NOT");
			}
			else
			{
				_labDesc.y = 25;
				_labDesc.text = CJLang("DYNAMIC_GET_FRIEND_INFO_FAIL");
			}
			this.addChild(_labDesc);
			
//			this._btnClose = new Button();
//			this._btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
//			this._btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
//			this._btnClose.width = 35;
//			this._btnClose.height = 35;
//			this._btnClose.x = 183;
//			this._btnClose.y = -1;
//			this.addChild(_btnClose);
			
			//确定按钮
			_btnConfirm = new Button();
			_btnConfirm.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_btnConfirm.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_btnConfirm.x = 73;
			_btnConfirm.y = 123;
			_btnConfirm.width = 53;
			_btnConfirm.height = 28;
			_btnConfirm.labelOffsetY = -1;
			this.addChild(_btnConfirm);
			
//			//取消按钮
//			_btnCancel = new Button();
//			_btnCancel.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
//			_btnCancel.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
//			_btnCancel.x = 113;
//			_btnCancel.y = 142;
//			_btnCancel.width = 52;
//			_btnCancel.height = 23;
//			_btnCancel.labelOffsetY = -1;
//			this.addChild(_btnCancel);
			
			_setTextFormat();
		}
		/**
		 * 
		 * 设置文本格式
		 */		
		private function _setTextFormat():void
		{
			var fontFormat:TextFormat = new TextFormat( "黑体", 12, 0xC7B88F);
			_btnConfirm.defaultLabelProperties.textFormat = fontFormat;
			_btnConfirm.label = CJLang("DYNAMIC_CONFIRM");
			
//			_btnCancel.defaultLabelProperties.textFormat = fontFormat;
//			_btnCancel.label = CJLang("DYNAMIC_CANCEL");
			
			_labDesc.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			
			fontFormat = new TextFormat( "隶书", 16, 0xFEFE68,"bold");
			_labTitle.textRendererProperties.textFormat = fontFormat;
			_labTitle.textRendererFactory = this._getTextRender;
			
			_labHeroLevel.textRendererProperties.textFormat = ConstTextFormat.textformatgreencenter;
			fontFormat = new TextFormat( "Arial", 10, 0xD48C03);
			_labHeroName.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0xEF9D00);
			_labBattlePower.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0xBF5B18);
			_labBattlePower.textRendererFactory = textRender.standardTextRender;
		}
		
		/**
		 * 卷积，发光
		 */		
		private function _getTextRender():ITextRenderer
		{
			var _htmltextRender:TextFieldTextRendererEx;
			_htmltextRender = new TextFieldTextRendererEx()
			_htmltextRender.isHTML = true;
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			
			_htmltextRender.nativeFilters = [new ConvolutionFilter(3,3,matrix,3) , new GlowFilter(0x16241D,1.0,2.0,2.0,5,2)];
			return _htmltextRender;
		}
		/**
		 * 为控件添加监听 
		 * 
		 */	
		private function _addListener():void
		{
			_quad.addEventListener(TouchEvent.TOUCH, _onClickQuad);
//			_btnClose.addEventListener(Event.TRIGGERED , this._btnCloseTriggered);
			_btnConfirm.addEventListener(Event.TRIGGERED , this._btnConfirmTriggered);
//			_btnCancel.addEventListener(Event.TRIGGERED , this._btnCancelTriggered);
		}
		/**
		 * 触发关闭事件
		 * @param e
		 * 
		 */		
		private function _onClickQuad(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(_quad,TouchPhase.ENDED);
			if (!touch)
			{
				return;	
			}
			this.removeFromParent(true);
		}
//		/**
//		 * 触发关闭事件
//		 * 
//		 */		
//		private function _btnCloseTriggered():void
//		{
//			this.removeFromParent(true);
//		}
		/**
		 * 触发确定事件
		 * 
		 */
		private function _btnConfirmTriggered():void
		{
			SSoundEffectUtil.playButtonNormalSound();
			//添加数据到达监听 
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadRequest);
			if (_playerInfo && _playerInfo.hasOwnProperty("templateid") && _uid)
			{
				SocketCommand_friend.requestAddFriend(_uid);
			}
			else
			{
				_btnCancelTriggered();
			}
		}
		/**
		 * 加载服务器返回数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadRequest(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_FRIEND_REQUEST_ADD_FRIEND)
			{
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadRequest);
				switch(message.retcode)
				{
					case ConstFriend.FRIEND_RETCODE_SUCC:
						CJFlyWordsUtil(CJLang("FRIEND_SEND_REQUEST_SUCCESS"));
						SocketCommand_friend.getAllRequestsInfo();
						//活跃度
						CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false , {"key":CJActivityEventKey.ACTIVITY_ADDFRIEND});
						break;
					case ConstFriend.FRIEND_RETCODE_FRIEND_FULL:
						CJFlyWordsUtil(CJLang("FRIEND_FULL"));
						break;
					case ConstFriend.FRIEND_RETCODE_IS_SELF:
						CJFlyWordsUtil(CJLang("FRIEND_IS_SELF"));
						break;
					case ConstFriend.FRIEND_RETCODE_OFFLINE:
						CJFlyWordsUtil(CJLang("FRIEND_PLAYER_OFFLINE"));
						break;
					case ConstFriend.FRIEND_RETCODE_ALREADY_IN_REQUEST_LIST:
						CJFlyWordsUtil(CJLang("FRIEND_ALREADY_IN_REQUEST_LIST"));
						break;
					case ConstFriend.FRIEND_RETCODE_ALREADY_FRIEND:
						CJFlyWordsUtil(CJLang("FRIEND_ALERADY_FRIEND"));
						break;
					case ConstFriend.FRIEND_OTHER_FULL:
						CJFlyWordsUtil(CJLang("FRIEND_OTHER_FULL"));
						break;
					case ConstFriend.FRIEND_RETCODE_UNKNOWN:
						CJFlyWordsUtil(CJLang("FRIEND_UNKNOWN_ERROR"));
						break;
					default:
						break;
				}
				this.removeFromParent(true);
			}
		}
		/**
		 * 触发取消事件
		 * 
		 */
		private function _btnCancelTriggered():void
		{
			SSoundEffectUtil.playButtonNormalSound();
			this.removeFromParent(true);
		}
	}
}