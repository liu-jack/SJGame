package SJ.Game.equipment
{
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstItemMake;
	import SJ.Game.formation.CJTurnPage;
	
	import engine_starling.display.SLayer;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;

	/**
	 * @author zhengzheng
	 * 创建时间：Apr 24, 2013 8:25:41 PM
	 * 可铸造装备显示层
	 */
	public class CJItemMakeItemShowLayer extends SLayer
	{
		//可铸造装备面板
		private var _itemsPanel:CJTurnPage;
		//可铸造装备显示间隔
		private const CONST_ITEM_GAP:Number = 4;
		/**可铸造装备面板要显示的数据*/
		private var _listData:Array;
		
		public function CJItemMakeItemShowLayer()
		{
			super();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._drawContent();
			this._initData();
			this._addListener();
		}
		/**
		 * 绘制界面内容 
		 * 
		 */		
		private function _drawContent():void
		{
			this._itemsPanel = new CJTurnPage(ConstItemMake.ITEMS_PANEL_PER_PAGE);
			this._itemsPanel.setRect(this.width, this.height);
			_itemsPanel.type = CJTurnPage.SCROLL_V;
		}
		/**
		 * 初始化数据 
		 * 
		 */		
		private function _initData():void
		{
			//得到所有的装备
			_listData = CJItemMakeUtil.o.getItemsByItemType(ConstItem.SCONST_ITEM_SUBTYPE_ALL);
			_setFirstShowItem(_listData);
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
				const render:CJItemMakeItem = new CJItemMakeItem();
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
			this.addEventListener(ConstItemMake.ITEM_SHOW_CHANGED, _setDataProvider);
		}
		
		override public function dispose():void
		{
			this.removeEventListener(ConstItemMake.ITEM_SHOW_CHANGED, _setDataProvider);
			super.dispose();
		}
		
		
		/**
		 * 设置面板的显示数据 
		 * 
		 */		
		private function _setDataProvider(e:Event):void
		{
			var itemSubType:int = e.data.itemSubType;
			var itemTemplateId:int = e.data.itemTemplateId;
			var dataProvider:Array = CJItemMakeUtil.o.getItemsByItemType(itemSubType);
			var groceryList:ListCollection = new ListCollection(dataProvider);
			if (!ConstItemMake.isMakingItem)
			//不正在铸造中
			{
				_setFirstShowItem(dataProvider);
				this._itemsPanel.dataProvider = groceryList;
				this._itemsPanel.invalidate();
			}
			else
			//正在铸造中
			{
				for (var i:int=0; i<dataProvider.length; ++i)
				{
					_itemsPanel.updateItem(dataProvider[i] , i);
				}
				//把正在铸造中还原为没有正在铸造
				ConstItemMake.isMakingItem = false;
			}
			
		}
		/**
		 * 设置第一个默认显示的装备铸造信息
		 * @param dataProvider 可显示铸造装备的数据集
		 * 
		 */		
		private function _setFirstShowItem(dataProvider:Array):void
		{
			//判断是不是有数据
			if(dataProvider.length == 0)
			{
				this.dispatchEventWith(ConstItemMake.ITEM_MAKE_CHANGED, false, {"templateId":0});
			}
			else if (dataProvider.length > 0)
			{
				var templateId:int = dataProvider[0].id;
				this.dispatchEventWith(ConstItemMake.ITEM_MAKE_CHANGED, false, {"templateId":templateId});
			}
		}
	}
}