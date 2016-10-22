package SJ.Game.friends
{
	import SJ.Common.Constants.ConstFriend;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_friend;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFriends;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.Events.DataEvent;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;
	
	/**
	 * 好友管理层
	 * @author zhengzheng
	 * 
	 */	
	public class CJFriendManageLayer extends CJFriendBaseLayer
	{
		//显示面板
		private var _itemsPanel:CJTurnPage;
		//显示间隔
		private const CONST_ITEM_GAP:Number = 10;
		/**显示的数据*/
		private var _listData:Array = new Array();
		/**是否第一次加载*/
		private var _isFirst:Boolean;
		/** 好友数据 */
		private var _friendsInfo:CJDataOfFriends;
		
		public function CJFriendManageLayer()
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
			_listData.sort(CJFriendUtil.o.playerManageShowSort);
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
				const render:CJFriendManageItem = new CJFriendManageItem();
				render.owner = _itemsPanel;
				return render;
			};
			this.addChild(this._itemsPanel);
			
		}
		
		/**
		 * 为控件添加监听 
		 * 
		 */	
		private function _addListener():void
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onSocketFriendOnlineOffline);
			_friendsInfo.addEventListener(DataEvent.DataLoadedFromRemote, _updateMyFriendShow);
			btnSelectRegion.addEventListener(Event.TRIGGERED , this._selectOnlineFriendShow);
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