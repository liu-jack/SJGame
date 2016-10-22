package SJ.Game.friends
{
	import SJ.Common.Constants.ConstFriend;
	import SJ.Game.SocketServer.SocketCommand_friend;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFriends;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.Events.DataEvent;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;


	/**
	 * 好友申请层
	 * @author zhengzheng
	 * 
	 */	
	public class CJFriendRequestLayer extends CJFriendBaseLayer
	{
		//显示面板
		private var _itemsPanel:CJTurnPage;
		//显示间隔
		private const CONST_ITEM_GAP:Number = 0;
		/**显示的数据*/
		private var _listData:Array = new Array();
		/**是否第一次加载*/
		private var _isFirst:Boolean;
		/** 好友数据 */
		private var _friendsInfo:CJDataOfFriends;
		public function CJFriendRequestLayer()
		{
			super();
			_isFirst = true;
			ConstFriend.isShowOnlyOnline = false;
			_friendsInfo = CJDataManager.o.DataOfFriends;
			ConstFriend.FRIEND_SHOW_TYPE = ConstFriend.FRIEND_SHOW_TYPE_REQUEST;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_updatePlayerRequestShow();
		}
		
		override public function dispose():void
		{
			if (_friendsInfo)
			{
				_friendsInfo.removeEventListener(DataEvent.DataLoadedFromRemote, _updatePlayerRequestShow);
			}
			super.dispose();
		}
		/**
		 * 更新玩家显示
		 * @return 
		 * 
		 */		
		private function _updatePlayerRequestShow():void
		{
			_friendsInfo = CJDataManager.o.DataOfFriends;
			if (!ConstFriend.isShowOnlyOnline)
			{
				_listData = _friendsInfo.friendsDic["REQUEST"];
			}
			_listData.sort(_friendRequestShowSort, Array.DESCENDING);
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
		 *  好友申请显示排序
		 * 
		 */		
		private function _friendRequestShowSort(playerInfo0:Object, playerInfo1:Object):Number
		{
			var num0:Number = Number(playerInfo0.lately_login);
			var num1:Number = Number(playerInfo1.lately_login);
			if (num0 > num1)
			{
				return 1;
			}
			else if (num0 < num1)
			{
				return -1;
			}
			else
			{
				return 0;
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
			this._itemsPanel = new CJTurnPage(ConstFriend.FRIEND_REQUEST_PER_PAGE_ITEM_NUM);
			this._itemsPanel.setRect(300, 207);
			this._itemsPanel.type = CJTurnPage.SCROLL_V;
			this._itemsPanel.x = 6;
			this._itemsPanel.y = 20;
			//设置渲染属性
			var groceryList:ListCollection = new ListCollection(_listData);
			// 添加数据监听
			var listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout.gap = CONST_ITEM_GAP;
			this._itemsPanel.layout = listLayout;
			this._itemsPanel.dataProvider = groceryList;
			this._itemsPanel.itemRendererFactory = function _getRenderFatory():IListItemRenderer
			{
				const render:CJFriendRequestItem = new CJFriendRequestItem();
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
			_friendsInfo.addEventListener(DataEvent.DataLoadedFromRemote, _updatePlayerRequestShow);
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
			_updateShowOnlinePlayerRequest(btnSelect.isSelected);
		}
		/**
		 * 更新显示在线玩家请求
		 * 
		 */		
		private function _updateShowOnlinePlayerRequest(showOnlineOnly:Boolean):void
		{
			
			if (showOnlineOnly)
			{
				ConstFriend.isShowOnlyOnline = true;
				var arrayTemp:Array = new Array();
				for (var i:int = 0; i < _listData.length; i++) 
				{
					if (_listData[i].online == 1)
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
			_updatePlayerRequestShow();
		}
	}
}