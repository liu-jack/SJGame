package SJ.Game.chat
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import SJ.Game.SocketServer.SocketCommand_friend;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.friends.CJFriendUtil;
	import SJ.Game.lang.CJLang;
	import SJ.Game.richtext.CJRTElement;
	
	import engine_starling.SApplication;
	
	import feathers.controls.IScrollBar;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.ScrollBar;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 聊天内容面板
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-9 下午1:45:28  
	 +------------------------------------------------------------------------------
	 */
	public class CJChatScreen extends Screen
	{
		private var _turnPage:List;
		
		private var _key:String;
		/*点击名字弹出菜单*/
		private var _nameMenu:CJChatNameMenu;

		private var _clickedElement:CJRTElement;
		/*总高度*/
		private var _totalHeight:Number;
		/*开始位置*/	
		private var beginx:Number = 23;
		private var beginy:Number = 3;
		
		public function CJChatScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			this._drawContent();
			this._addListeners();
		}
		
		private function _drawContent():void
		{
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(410 , 282);
			bgBall.width = 320;
			bgBall.height = 180;
			bgBall.x = 5;
			bgBall.y = 5;
			this.addChild(bgBall);
			
			
			var bgWrap:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangnew") , new Rectangle(15 ,15 , 1, 1)));
			bgWrap.width = 420;
			bgWrap.height = 292;
			this.addChild(bgWrap);
			
			var fontBg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_liaotian_wenzidi") , new Rectangle(10 ,10 , 3, 3)));
			fontBg.width = 343;
			fontBg.height = 238;
			fontBg.x = 15;
			fontBg.y = 13;
			this.addChild(fontBg);
			
			_turnPage = new List();
			_turnPage.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			_turnPage.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			_turnPage.x = 18;
			_turnPage.y = 16;
			_turnPage.setSize(343, 233);
			_turnPage.visible = false;
			this.addChild(_turnPage);
			
			const listLayout:VerticalLayout = new VerticalLayout();
			listLayout.hasVariableItemDimensions = true;
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
//			listLayout.scrollPositionVerticalAlign = VerticalLayout.VERTICAL_ALIGN_BOTTOM;
			this._turnPage.layout = listLayout;
			
			_turnPage.interactionMode = Scroller.INTERACTION_MODE_TOUCH;
			_turnPage.verticalScrollBarFactory = function():IScrollBar
			{
				var bar:ScrollBar = new ScrollBar();
				bar.direction = ScrollBar.DIRECTION_VERTICAL;
				var sc:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture("huoyuedu_gundonghuakuai"),2,1, Scale3Textures.DIRECTION_VERTICAL);
				var barImage:Scale3Image = new Scale3Image(sc);
				barImage.height = 5;
				bar.thumbProperties.defaultSkin = barImage;
				return bar;
			}
			_turnPage.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
			
			this._turnPage.itemRendererFactory = function ():IListItemRenderer
			{
				const render:CJRichTextWrapper = new CJRichTextWrapper();
				render.owner = _turnPage;
				return render;
			};
			
		}
		
		override protected function draw():void
		{
			// TODO Auto Generated method stub
			super.draw();
			_initChatContent();
		}
		
		
		override public function dispose():void
		{
			CJFriendUtil.o.dipose();
			super.dispose();
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_RICH_TEXT_CLICK_EVENT , this._richTextClickHandler);
			CJEventDispatcher.o.removeEventListener("namemenuclicked" , this._nameMenuClickHandler);
//			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_CHAT_INIT_MESSAGE , _initChatContent);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_CHAT_NEW_MESSAGE , _newMessageHandler);
		}
		
		private function _refreshChatContent():void
		{
			_turnPage.dataProvider.data = CJDataManager.o.DataOfChat.elementDic[_key];
			_turnPage.verticalScrollPosition = _turnPage.maxVerticalScrollPosition - 0.01;
			
			Starling.juggler.delayCall(function(turnPage:List):void
			{
				turnPage.scrollToPosition( turnPage.horizontalScrollPosition, turnPage.maxVerticalScrollPosition,
					0.7);
			}, 0.5, _turnPage);
		}
		private function _initChatContent():void
		{
			this._turnPage.dataProvider = new ListCollection(CJDataManager.o.DataOfChat.elementDic[_key]);
			_turnPage.verticalScrollPosition = _turnPage.maxVerticalScrollPosition + 0.01;
			Starling.juggler.delayCall(function(turnPage:List):void
			{
				turnPage.scrollToPosition( turnPage.horizontalScrollPosition, turnPage.maxVerticalScrollPosition);
				Starling.juggler.delayCall(function():void
				{
					turnPage.visible = true;
				},0.1);
				
			}, 0.5, _turnPage);
		}
		private function _addListeners():void
		{
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_RICH_TEXT_CLICK_EVENT , this._richTextClickHandler);
			CJEventDispatcher.o.addEventListener("namemenuclicked" , this._nameMenuClickHandler);
//			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_CHAT_INIT_MESSAGE , _initChatContent);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_CHAT_NEW_MESSAGE , this._newMessageHandler);
		}
		
		private function _newMessageHandler(e:Event):void
		{
			if(e.type != CJEvent.EVENT_CHAT_NEW_MESSAGE)
			{
				return;
			}
			if(this.owner != null)
			{
				_refreshChatContent();
			}
		}

		private function _nameMenuClickHandler(e:Event):void
		{
			if(e.type != "namemenuclicked")
			{
				return;
			}
//			仅仅被激活的时候才会有owner
			if(this.owner)
			{
				var playerUid:String = _clickedElement.data.fromuid;
				if(e.data.menu == "PRIVATE")
				{
					var mainLayer:CJChatLayer = this.owner.parent as CJChatLayer;
					//更改按钮的lablel
					mainLayer.channelButton.label = CJLang("CHAT_"+e.data.menu);
					//			设置主框的选中页
					mainLayer.tabBar.selectedIndex = mainLayer.NAME_TAB_LIST.indexOf(e.data.menu);
					CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_CHAT_PRIVATE , false , _clickedElement);
				}
				else if (e.data.menu == "FRIEND")
				{
					CJFriendUtil.o.requestRetTips();//zhengzheng++
					SocketCommand_friend.requestAddFriend(playerUid);
				}
				else if(e.data.menu == "REMOVE")
				{
					CJFriendUtil.o.addBlacklistRetTips();//zhengzheng++
					SocketCommand_friend.addBlacklist(playerUid);
				}
				else if(e.data.menu == "VIEW")
				{
					SApplication.moduleManager.enterModule("CJHeroPropertyUIModule", {"uid":playerUid});
				}
			}
			//			关闭弹出菜单
			this._closeNameMenu();
		}	
		
		private function _closeNameMenu():void
		{
			this._nameMenu.closeMenu();
		}
		
		private function _richTextClickHandler(e:Event):void
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
			_clickedElement = data.elementdata as CJRTElement;
			var globalPoint:Point = data.point;
			if(_clickedElement && _clickedElement.clickable)
			{
//				判断 ，如果是自己，不弹出
				var userName:String = CJDataManager.o.DataOfRole.name;
				if(String(_clickedElement.text).indexOf(userName) != -1)
				{
					return;
				}
				
				if(this._nameMenu != null)
				{
					this._nameMenu.removeFromParent();
				}
				
				this._nameMenu = new CJChatNameMenu();
				var localPoint:Point = this.globalToLocal(globalPoint);
				
				//超出界限处理
				this._nameMenu.x = localPoint.x >> 1 ;
				this._nameMenu.y = localPoint.y >> 1;
				this.addChild(this._nameMenu);
			}
		}

		public function get key():String
		{
			return _key;
		}
		
		public function set key(value:String):void
		{
			_key = value;
		}
	}
}