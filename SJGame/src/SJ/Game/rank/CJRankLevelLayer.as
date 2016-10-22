package SJ.Game.rank
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstRank;
	import SJ.Game.SocketServer.SocketCommand_friend;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfRanklist;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.friends.CJFriendUtil;
	import SJ.Game.lang.CJLang;
	
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
	 * 等级排行榜层
	 * @author zhengzheng
	 * 
	 */	
	public class CJRankLevelLayer extends CJRankBaseOperateLayer
	{
		//显示面板
		private var _itemsPanel:CJTurnPage;
		//显示间隔
		private const CONST_ITEM_GAP:Number = 0;
		/**显示的数据*/
		private var _listData:Array;
		/** 其他玩家角色信息 */
		private var _otherRoleInfo:Object;
		/** 点击玩家数据 */
		private var _playerInfo:Object;
		/** 判断玩家是否被选中 */
		private var _rankItemIsSelected:Boolean;
		/** 判断自己是否上榜 */
		private var _isOnRankList:Boolean;
		/** 自己的角色数据 */
		private var _roleData:CJDataOfRole;
		/** 排行榜数据 */
		private var _rankData:CJDataOfRanklist;
		/** 点击排行榜单元弹出的菜单 */
		private var _menuClickItem:CJRankItemClickMenu;
		/** 主将的等级 */
		private var _mainHeroLevel:int;
		public function CJRankLevelLayer()
		{
			super();
			ConstRank.RANK_TYPE = ConstRank.RANK_TYPE_RANK_LEVEL;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_initData();
		}
		
		private function _initialize():void
		{
			_drawContent();
			_addListener();
		}
		/**
		 * 初始化数据
		 */	
		private function _initData():void
		{
			_roleData = CJDataManager.o.DataOfRole;
			_mainHeroLevel = int(CJDataManager.o.DataOfHeroList.getMainHero().level)
			_rankData = CJDataManager.o.DataOfRanklist;
			if (_rankData.dataIsEmpty)
			{
				_rankData.addEventListener(DataEvent.DataLoadedFromRemote , _initialize);
				_rankData.loadFromRemote();
			}
			else
			{
				_initialize();
			}
		}
		/**
		 * 绘制界面内容
		 */	
		private function _drawContent():void
		{
			_listData = _rankData.rankLevelData;
			this._itemsPanel = new CJTurnPage(ConstRank.RANK_PLAYER_PER_PAGE_ITEM_NUM , CJTurnPage.SCROLL_V);
			this._itemsPanel.setRect(405, 200);
			this._itemsPanel.x = 6;
			this._itemsPanel.y = 30;
			//设置渲染属性
			var groceryList:ListCollection = new ListCollection(_listData);
			// 添加数据监听
			var listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout.gap = CONST_ITEM_GAP;
			this._itemsPanel.layout = listLayout;
			this._itemsPanel.dataProvider = groceryList;
			this._itemsPanel.itemRendererFactory =  function _getRenderFatory():IListItemRenderer
			{
				const render:CJRankItem = new CJRankItem();
				render.owner = _itemsPanel;
				return render;
			};
			this.addChild(this._itemsPanel);
			//设置我的排名
			for (var i:int = 0; i < _listData.length; i++)
			{
				if (_listData[i].name == _roleData.name)
				{
					labelMyRankContent.text = _listData[i].rankid + 1;
					_isOnRankList = true;
					break;
				}
			}
			//判断自己是否上榜
			if (!_isOnRankList)
			{
				labelMyRankContent.text = CJLang("RANK_NOT_IN_RANK_LIST");
			}
			labelMyCurData.text = CJLang("RANK_MY_LEVEL", {"myLevel":_mainHeroLevel});
		}
		/**
		 * 触发点击一个CJRankItem事件
		 * @param event
		 * 
		 */
		private function _onClickItem(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if (!touch || touch.phase != TouchPhase.ENDED 
				|| !_rankItemIsSelected || !(touch.target.parent is CJRankItem))
			{
				return;
			}
			_rankItemIsSelected = false;
			if(_menuClickItem && _menuClickItem.parent)
			{
				_menuClickItem.closeMenu();
			}
			_menuClickItem = new CJRankItemClickMenu();
			
			//设置弹出菜单的边界值
			var targetPoint:Point = touch.getLocation(this);
			if (touch.globalX <= 371)
			{
				
				_menuClickItem.x = targetPoint.x;
			}
			else
			{
				_menuClickItem.x = 321;
			}
			if (touch.globalY <= 190)
			{
				_menuClickItem.y = targetPoint.y;
			}
			else
			{
				_menuClickItem.y = 160;
			}
			this.addChild(_menuClickItem);
		}
		/**
		 * 为控件添加监听 
		 * 
		 */	
		private function _addListener():void
		{
			this.addEventListener(starling.events.TouchEvent.TOUCH, _onClickItem);
			//监听item菜单点击事件
			CJEventDispatcher.o.addEventListener(("selectRankPlayerInfoEvent" + ConstRank.RANK_TYPE) ,_getSelectPlayerInfo);
			CJEventDispatcher.o.addEventListener(("rankItemMenuClicked" + ConstRank.RANK_TYPE), this._nameMenuClickHandler);
		}
		override public function dispose():void
		{
			if (_rankData)
			{
				_rankData.removeEventListener(DataEvent.DataLoadedFromRemote , _initialize);
			}
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadOtherRoleInfo);
			
			CJEventDispatcher.o.removeEventListener(("selectRankPlayerInfoEvent" + ConstRank.RANK_TYPE) ,_getSelectPlayerInfo);
			CJEventDispatcher.o.removeEventListener(("rankItemMenuClicked" + ConstRank.RANK_TYPE), this._nameMenuClickHandler);
			CJFriendUtil.o.dipose();
			super.dispose();
		}
		/**
		 * 获取点击玩家的数据信息
		 * @param event
		 * 
		 */		
		private function _getSelectPlayerInfo(event:Event):void
		{
			_playerInfo = event.data.selectRankPlayerInfo;
			_rankItemIsSelected = event.data.rankItemIsSelected;
		}
		
		/**
		 * item菜单点击事件
		 * @param e
		 * 
		 */		
		private function _nameMenuClickHandler(e:Event):void
		{
			
			if(e.type != ("rankItemMenuClicked" + ConstRank.RANK_TYPE))
			{
				return;
			}
			if(e.data.menu == "PRIVATE_CHAT")
			{
				// 添加网络锁
//				SocketLockManager.Lock(ConstNetLockID.CJRankModule);
				//添加数据到达监听 
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadOtherRoleInfo);
				SocketCommand_role.get_other_role_info_by_name(_playerInfo.name);
			}
			else if (e.data.menu == "FRIEND")
			{
				// 添加网络锁
//				SocketLockManager.Lock(ConstNetLockID.CJRankModule);
				CJFriendUtil.o.requestRetTips();
				SocketCommand_friend.requestAddFriend(_playerInfo.uid);
			}
			else if(e.data.menu == "CHECK")
			{
				SApplication.moduleManager.exitModule("CJRankModule");
				SApplication.moduleManager.enterModule("CJHeroPropertyUIModule", {"uid":_playerInfo.uid});
			}
			if (_menuClickItem && _menuClickItem.parent)
			{
				this._menuClickItem.closeMenu();
			}
		}	
		/**
		 * 加载其他玩家服务器返回数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadOtherRoleInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_ROLE_GET_OTHER_ROLE_INFO_BY_NAME)
			{
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadOtherRoleInfo);
				// 去除网络锁
//				SocketLockManager.UnLock(ConstNetLockID.CJRankModule);
				if (message.retcode == 0)
				{
					_otherRoleInfo = message.retparams;
					if (int(_otherRoleInfo.online) == 0)
					{
						CJFlyWordsUtil(CJLang("FRIEND_CANNOT_PRIVATE_CHAT"));
					}
					else 
					{
						//如果是自己，不能聊天 @caihua
						if(CJDataManager.o.DataOfAccounts.userID == _otherRoleInfo.userid)
						{
							CJFlyWordsUtil(CJLang("CHAT_TO_SELF_FAIL"));
							return;
						}
						
						SApplication.moduleManager.enterModule("CJChatModule", {"rolename":_otherRoleInfo.rolename , "fromuid":_otherRoleInfo.userid});
						// 退出排行榜模块
						SApplication.moduleManager.exitModule("CJRankModule");
					}
				}
			}
		}
	}
}