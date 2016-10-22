package SJ.Game.dynamics
{
	import SJ.Common.Constants.ConstItemMake;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_fuben;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.formation.CJTurnPage;
	
	import engine_starling.display.SLayer;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;

	/**
	 * @author zhengzheng
	 * 助战好友显示层
	 */
	public class CJDynamicAssistantShowLayer extends SLayer
	{
		//助战好友面板
		private var _itemsPanel:CJTurnPage;
		//助战好友显示间隔
		private const CONST_ITEM_GAP:Number = 2;
		/**助战好友面板要显示的数据*/
		private var _listData:Array = new Array();
		/**是否第一次加载*/
		private var _isFirst:Boolean;
		
		public function CJDynamicAssistantShowLayer()
		{
			super();
			_isFirst = true;
			//添加数据到达监听 
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadAssistantInfo);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadFlushInviteHerosInfo);
			SocketCommand_fuben.getInviteHeros();
		}

		override public function dispose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadAssistantInfo);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadFlushInviteHerosInfo);
			super.dispose();
		}
		/**
		 * 加载服务器助战好友数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadAssistantInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_FUBEN_GET_INVITE_HEROS)
			{
				if (message.retcode == 0)
				{
					_listData = message.retparams as Array;
					_updateAssistantShow();
				}
			}
		}
		
		/**
		 * 加载服务器刷新助战好友数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadFlushInviteHerosInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_FUBEN_FLUSH_INVITE_HEROS)
			{
				if (message.retcode == 0)
				{
					_listData = message.retparams as Array;
					_updateAssistantShow();
				}
			}
		}
		/**
		 * 更新助战好友数据显示
		 * 
		 */		
		private function _updateAssistantShow():void
		{
			if (_isFirst)
			{
				_initialize();
				_isFirst = false;
			}
			else
			{
				var groceryList:ListCollection = new ListCollection(_listData);
				this._itemsPanel.dataProvider = groceryList;
				this._itemsPanel.invalidate();
			}
		}
		/**
		 * 第一次初始化
		 * 
		 */		
		private function _initialize():void
		{
			this._drawContent();
			this._initData();
		}
		/**
		 * 绘制界面内容 
		 * 
		 */		
		private function _drawContent():void
		{
			this._itemsPanel = new CJTurnPage(ConstItemMake.ITEMS_PANEL_PER_PAGE);
			this._itemsPanel.setRect(258, 240);
			_itemsPanel.type = CJTurnPage.SCROLL_V;
		}
		/**
		 * 初始化数据 
		 * 
		 */		
		private function _initData():void
		{
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
				const render:CJDynamicAssistantItem = new CJDynamicAssistantItem();
				render.owner = _itemsPanel;
				return render;
			}
			this.addChild(this._itemsPanel);
		}


		public function get itemsPanel():CJTurnPage
		{
			return _itemsPanel;
		}

		
	}
}