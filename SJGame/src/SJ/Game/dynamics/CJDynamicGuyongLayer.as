package SJ.Game.dynamics
{
	import SJ.Common.Constants.ConstDynamic;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	import SJ.Game.formation.CJTurnPage;
	
	import engine_starling.display.SLayer;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;
	
	/**
	 * 动态雇佣层
	 * @author zhengzheng
	 * 
	 */	
	public class CJDynamicGuyongLayer extends SLayer
	{
		//显示面板
		private var _itemsPanel:CJTurnPage;
		//显示间隔
		private const CONST_ITEM_GAP:Number = 10;
		/**显示的数据*/
		private var _listData:Object;
		
		public function CJDynamicGuyongLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			_drawContent();
			CJDataManager.o.DataOfDuoBaoEmploy.addEventListener(CJEvent.EVENT_DUOBAO_APPLY_CHANGE , this._onApplyChange);
			_updateFriendShow();
		}
		
		private function _onApplyChange(e:Event):void
		{
			if(e.type == CJEvent.EVENT_DUOBAO_APPLY_CHANGE)
			{
				_updateFriendShow();
			}
		}
		
		/**
		 * 更新系统邮件显示
		 * 
		 */		
		private function _updateFriendShow():void
		{
			_listData = CJDataManager.o.DataOfDuoBaoEmploy.applyList;
			var groceryList:ListCollection = new ListCollection(_listData);
			_itemsPanel.dataProvider = groceryList;
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
				const render:CJDynamicGuyongItem = new CJDynamicGuyongItem();
				render.owner = _itemsPanel;
				return render;
			}
			this.addChild(this._itemsPanel);
		}
		
		override public function dispose():void
		{
			super.dispose();
			CJDataManager.o.DataOfDuoBaoEmploy.removeEventListener(CJEvent.EVENT_DUOBAO_APPLY_CHANGE, this._onApplyChange)
		}
		
	}
}