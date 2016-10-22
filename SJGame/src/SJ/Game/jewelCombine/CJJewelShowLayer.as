package SJ.Game.jewelCombine
{
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstJewelCombine;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.formation.CJTurnPage;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;

	/**
	 * 背包中的宝石显示层
	 * @author zhengzheng
	 * 
	 */	
	public class CJJewelShowLayer extends SLayer
	{
		//背包中的宝石显示面板
		private var _itemsPanel:CJTurnPage;
		//背包中的宝石显示间隔
		private const CONST_ITEM_GAP:Number = 2;
		//背包中的宝石显示的数据
		private var _listData:Array;
		/**背包数据*/
		private var _bagData:CJDataOfBag;
		
		public function CJJewelShowLayer()
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
			
			this._itemsPanel = new CJTurnPage(ConstJewelCombine.ITEMS_PANEL_PER_PAGE);
			this._itemsPanel.setRect(this.width, this.height);
			
			this._itemsPanel.preButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeup01"));
			this._itemsPanel.preButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeup03"));
			this._itemsPanel.preButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeup02"));
			this._itemsPanel.preButton.width = 41;
			this._itemsPanel.preButton.height = 26;
			this._itemsPanel.preButton.x = 52;
			this._itemsPanel.preButton.y = -30;
			
			this._itemsPanel.nextButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeup01"));
			this._itemsPanel.nextButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeup03"));
			this._itemsPanel.nextButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeup02"));
			this._itemsPanel.nextButton.width = 41;
			this._itemsPanel.nextButton.height = 26;
			this._itemsPanel.nextButton.x = 52;
			this._itemsPanel.nextButton.y = this.height + 31;
			this._itemsPanel.nextButton.scaleY = -1;	// 上下翻转按钮
		}
		
		/**
		 * 初始化数据 
		 * 
		 */		
		private function _initData():void
		{
			_bagData = CJDataManager.o.getData("CJDataOfBag");
			_listData = _bagData.getItemsByItemType(ConstBag.BAG_TYPE_JEWEL);
			//设置渲染属性
			var groceryList:ListCollection = new ListCollection(_listData);
			// 添加数据监听
			var listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout.gap = CONST_ITEM_GAP;
			this._itemsPanel.layout = listLayout;
			this._itemsPanel.dataProvider = groceryList;
			this._itemsPanel.itemRendererFactory = function ():IListItemRenderer
			{
				const render:CJJewelCombineItem = new CJJewelCombineItem();
				render.owner = _itemsPanel;
				return render;
			}
			this.addChild(this._itemsPanel);
			
		}
		
		/**
		 * 为控件添加监听 
		 * 
		 */		
		private function _addListener():void
		{
			//添加背包数据改变监听
			_bagData.addEventListener(DataEvent.DataLoadedFromRemote , this._setDataProvider);
		}
		
		override public function dispose():void
		{
			if (_bagData)
			{
				_bagData.removeEventListener(DataEvent.DataLoadedFromRemote , this._setDataProvider);
			}
			super.dispose();
		}
		
		
		/**
		 * 设置面板的显示数据 
		 * 
		 */		
		private function _setDataProvider(e:Event):void
		{
			if (e.target is CJDataOfBag)
			{
				_listData = _bagData.getItemsByItemType(ConstBag.BAG_TYPE_JEWEL);
				var groceryList:ListCollection = new ListCollection(_listData);
				// 添加数据监听
				var listLayout:VerticalLayout = new VerticalLayout();
				this._itemsPanel.dataProvider = groceryList;
				_itemsPanel.invalidate();
//				for (var i:int=0; i< _listData.length; i++)
//				{
//					_itemsPanel.updateItem(_listData[i], i);
//				}
			}
		}
	}
}