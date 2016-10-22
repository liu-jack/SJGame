package SJ.Game.friends
{
	import SJ.Common.Constants.ConstFriend;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_friend;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFriends;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.SApplication;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import flash.geom.Point;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 我的好友层
	 * @author zhengzheng
	 * 
	 */	
	public class CJFriendMyFriendLayer extends CJFriendBaseLayer
	{
		//显示面板
		private var _itemsPanel:CJTurnPage;
		//显示间隔
		private const CONST_ITEM_GAP:Number = 10;
		/**显示的数据*/
		private var _listData:Array = new Array();
		/**是否第一次加载*/
		private var _isFirst:Boolean;
		/** 点击好友玩家单元弹出的菜单 */
		private var _menuClickItem:CJFriendPlayerItemClickMenu;
		/** 点击好友玩家数据 */
		private var _playerInfo:Object;
		/** 判断玩家是否被选中 */
		private var _itemIsSelected:Boolean;
		/** 好友数据 */
		private var _friendsInfo:CJDataOfFriends;
		
		public function CJFriendMyFriendLayer()
		{
			super();
			_isFirst = true;
			ConstFriend.isShowOnlyOnline = false;
			_friendsInfo = CJDataManager.o.DataOfFriends;
			ConstFriend.FRIEND_SHOW_TYPE = ConstFriend.FRIEND_SHOW_TYPE_MY_FRIEND;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_updateMyFriendShow();
		}
		
		override public function dispose():void
		{
			if (_friendsInfo)
			{
				_friendsInfo.removeEventListener(DataEvent.DataLoadedFromRemote, _updateMyFriendShow);
			}
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onSocketFriendOnlineOffline);
			CJEventDispatcher.o.removeEventListener(("selectPlayerInfoEvent" + ConstFriend.FRIEND_SHOW_TYPE) ,_getSelectPlayerInfo);
			CJEventDispatcher.o.removeEventListener(("friendPlayerItemMenuClicked" + ConstFriend.FRIEND_SHOW_TYPE), this._nameMenuClickHandler);
			CJFriendUtil.o.dipose();
			super.dispose();
		}
		
		
		/**
		 * 更新我的好友显示
		 * 
		 */		
		private function _updateMyFriendShow():void
		{
			if (!ConstFriend.isShowOnlyOnline)
			{
				_listData = _friendsInfo.friendsDic["MY_FRIEND"];
			}
			_listData.sort(CJFriendUtil.o.playerShowSort);
			if (_isFirst)
			{
				_initialize();
				_isFirst = false;
			}
			else
			{
				_itemsPanel.removeFromParent(true);
				_itemsPanel = null;
				_drawContent();
			}
			if (_menuClickItem && _menuClickItem.parent)
			{
				this._menuClickItem.closeMenu();
			}
		}
		/**
		 * 好友上下线通知
		 * @param e
		 * 
		 */
		private function _onSocketFriendOnlineOffline(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() == ConstNetCommand.SC_SYNC_FRIEND_ONLINE
				|| message.getCommand() == ConstNetCommand.SC_SYNC_FRIEND_OFFLINE)
			{
				// 添加网络锁
//				SocketLockManager.KeyLock(ConstNetCommand.CS_FRIEND_GET_ALL_FRIEND_INFO);
				SocketCommand_friend.getAllFriendInfo();
			}
		}
		/**
		 * 第一次初始化
		 * 
		 */		
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
			
			this._itemsPanel = new CJTurnPage(ConstFriend.FRIEND_PLAYER_PER_PAGE_ITEM_NUM , CJTurnPage.SCROLL_V);
			this._itemsPanel.setRect(290, 200);
			this._itemsPanel.x = 16;
			this._itemsPanel.y = 25;
			//设置渲染属性
			var groceryList:ListCollection = new ListCollection(_listData);
			// 添加数据监听
			var listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout.gap = CONST_ITEM_GAP;
			listLayout.paddingBottom = 3;
			this._itemsPanel.layout = listLayout;
			this._itemsPanel.dataProvider = groceryList;
			this._itemsPanel.itemRendererFactory = function _getRenderFatory():IListItemRenderer
			{
				const render:CJFriendPlayerItem = new CJFriendPlayerItem();
				render.owner = _itemsPanel;
				return render;
			};
			this.addChild(this._itemsPanel);
			
		}
		/**
		 * 触发点击一个Item事件
		 * @param event
		 * 
		 */
		private function _onClickItem(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if ((!touch || touch.phase != TouchPhase.ENDED || !_itemIsSelected))
			{
				return;
			}
			if (touch.target.parent is CJFriendPlayerItem || touch.target.parent is CJHeroHeadIconItem)
			{
				_itemIsSelected = false;
				if(_menuClickItem && _menuClickItem.parent)
				{
					_menuClickItem.closeMenu();
				}
				_menuClickItem = new CJFriendPlayerItemClickMenu();
				//设置弹出菜单的边界值
				var targetPoint:Point = touch.getLocation(this);
				if (touch.globalX <= 335)
				{
					_menuClickItem.x = targetPoint.x;
				}
				else
				{
					_menuClickItem.x = 223;
				}
				if (touch.globalY <= 192)
				{
					_menuClickItem.y = targetPoint.y;
				}
				else
				{
					_menuClickItem.y = 162;
				}
				this.addChild(_menuClickItem);
				
			}
		}
		
		/**
		 * 为控件添加监听 
		 * 
		 */	
		private function _addListener():void
		{
			this.addEventListener(starling.events.TouchEvent.TOUCH, _onClickItem);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onSocketFriendOnlineOffline);
			_friendsInfo.addEventListener(DataEvent.DataLoadedFromRemote, _updateMyFriendShow);
			btnSelectRegion.addEventListener(Event.TRIGGERED , this._selectOnlineFriendShow);
			//监听item菜单点击事件
			CJEventDispatcher.o.addEventListener(("selectPlayerInfoEvent" + ConstFriend.FRIEND_SHOW_TYPE) ,_getSelectPlayerInfo);
			CJEventDispatcher.o.addEventListener(("friendPlayerItemMenuClicked" + ConstFriend.FRIEND_SHOW_TYPE), this._nameMenuClickHandler);
		}
		/**
		 * 获取点击玩家的数据信息
		 * @param event
		 * 
		 */		
		private function _getSelectPlayerInfo(event:Event):void
		{
			_playerInfo = event.data.selectPlayerInfo;
			_itemIsSelected = event.data.itemIsSelected;
		}
		
		/**
		 * item菜单点击事件
		 * @param e
		 * 
		 */		
		private function _nameMenuClickHandler(e:Event):void
		{
			
			if(e.type != ("friendPlayerItemMenuClicked" + ConstFriend.FRIEND_SHOW_TYPE_MY_FRIEND))
			{
				return;
			}
			if(e.data.menu == "CHECK")
			{
				SApplication.moduleManager.exitModule("CJFriendModule");
				SApplication.moduleManager.enterModule("CJHeroPropertyUIModule", {"uid":_playerInfo.frienduid});
			}
			else if (e.data.menu == "PRIVATE_CHAT")
			{
				if (int(_playerInfo.online) == 0)
				{
//					CJMessageBox(CJLang("FRIEND_CANNOT_PRIVATE_CHAT"));
					CJFlyWordsUtil(CJLang("FRIEND_CANNOT_PRIVATE_CHAT"));
				}
				else 
				{
					// 退出好友模块
					SApplication.moduleManager.exitModule("CJFriendModule");
					//进入聊天模块
					SApplication.moduleManager.enterModule("CJChatModule", {"rolename":_playerInfo.rolename , "fromuid":_playerInfo.frienduid});
				}
			}
			else if(e.data.menu == "DELETE")
			{
				CJConfirmMessageBox(CJLang("FRIEND_DELETE_FRIEND_OR_NOT"), _confirmDelFriend);
			}
			if (_menuClickItem && _menuClickItem.parent)
			{
				this._menuClickItem.closeMenu();
			}
		}
		
		/**
		 * 确定删除好友
		 * @param e Event
		 * 
		 */		
		public function _confirmDelFriend():void
		{
			// 添加网络锁
//			SocketLockManager.KeyLock(ConstNetCommand.CS_FRIEND_DEL_FRIEND);
			CJFriendUtil.o.delFriendRetTips();
			SocketCommand_friend.delFriend(_playerInfo.frienduid);
		}
		/**
		 * 选择显示在线好友
		 * 
		 */	
		private function _selectOnlineFriendShow(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			btnSelect.isSelected = !btnSelect.isSelected;
			_updateShowOnlinePlayer(btnSelect.isSelected);
		}
		/**
		 * 更新显示在线玩家请求
		 * 
		 */		
		private function _updateShowOnlinePlayer(showOnlineOnly:Boolean):void
		{
			
			if (showOnlineOnly)
			{
				ConstFriend.isShowOnlyOnline = true;
				var arrayTemp:Array = new Array();
				for (var i:int = 0; i < _listData.length; i++) 
				{
					if (int(_listData[i].online) == 1)
					{
						arrayTemp.push(_listData[i]);
					}
				}
				_listData = arrayTemp;
			}
			else 
			{
				ConstFriend.isShowOnlyOnline = false;
			}
			_updateMyFriendShow();
		}
		
	}
}