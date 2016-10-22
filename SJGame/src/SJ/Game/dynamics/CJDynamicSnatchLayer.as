package SJ.Game.dynamics
{
	import SJ.Common.Constants.ConstDynamic;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfMail;
	import SJ.Game.formation.CJTurnPage;
	
	import engine_starling.display.SLayer;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	/**
	 * 动态夺宝层
	 * @author zhengzheng
	 * 
	 */	
	public class CJDynamicSnatchLayer extends SLayer
	{
		//显示面板
		private var _itemsPanel:CJTurnPage;
		//显示间隔
		private const CONST_ITEM_GAP:Number = 10;
		/**显示的数据*/
		private var _listData:Array;
		/**是否第一次加载*/
		private var _isFirst:Boolean;
		/** 邮件数据 */
		private var _mailData:CJDataOfMail;
		public function CJDynamicSnatchLayer()
		{
			super();
			_isFirst = true;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_mailData = CJDataManager.o.DataOfMail;
			_updateFriendShow();
		}
		
		override public function dispose():void
		{
			_mailData.removeEventListener(ConstDynamic.DYNAMIC_MAIL_CHANGED, _updateFriendShow);
			super.dispose();
		}
		
		/**
		 * 更新系统邮件显示
		 * 
		 */		
		private function _updateFriendShow():void
		{
			_listData = _mailData.snatchMailData;
			_listData.sort(CJDynamicUtil.o.mailShowSort, Array.DESCENDING);
			if (_isFirst)
			{
				_initialize();
				_isFirst = false;
			}
			else
			{
				var groceryList:ListCollection = new ListCollection(_listData);
				_itemsPanel.dataProvider = groceryList;
				_itemsPanel.invalidate();
			}
			
		}
		
		/**
		 * 第一次初始化
		 * 
		 */		
		private function _initialize():void
		{
			_drawContent();
			_addLiteners();
		}
		/**
		 * 绘制界面内容
		 */	
		private function _drawContent():void
		{
			
			this._itemsPanel = new CJTurnPage(ConstDynamic.DYNAMIC_PER_PAGE_ITEM_NUM);
			this._itemsPanel.setRect(400, 238);
			_itemsPanel.type = CJTurnPage.SCROLL_V;
			_itemsPanel.x = 14;
			_itemsPanel.y = 27;
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
				const render:CJDynamicSnatchItem = new CJDynamicSnatchItem();
				render.owner = _itemsPanel;
				return render;
			}
			this.addChild(this._itemsPanel);
			
		}
		private function _addLiteners():void
		{
			_mailData.addEventListener(ConstDynamic.DYNAMIC_MAIL_CHANGED, _updateFriendShow);
		}

	}
}