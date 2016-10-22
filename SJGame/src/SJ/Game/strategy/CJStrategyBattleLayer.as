package SJ.Game.strategy
{
	import SJ.Common.Constants.ConstStrategy;
	import SJ.Game.data.config.CJDataOfStrategyProperty;
	import SJ.Game.formation.CJTurnPage;
	
	import engine_starling.display.SLayer;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;


	/**
	 * 攻略战斗力层
	 * @author zhengzheng
	 * 
	 */	
	public class CJStrategyBattleLayer extends SLayer
	{
		//显示面板
		private var _itemsPanel:CJTurnPage;
		//显示间隔
		private const CONST_ITEM_GAP:Number = 0;
		/**显示的数据*/
		private var _listData:Array = new Array();
		
		public function CJStrategyBattleLayer()
		{
			super();
			ConstStrategy.STRATEGY_TYPE = ConstStrategy.STRATEGY_TYPE_BATTLE;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_initData();
			_drawContent();
			_addListener();
		}
		/**
		 * 初始化数据
		 * 
		 */		
		private function _initData():void
		{
			_listData = CJDataOfStrategyProperty.o.getStrategySettingTemplatesByType(ConstStrategy.STRATEGY_TYPE);
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		/**
		 * 绘制界面内容
		 */	
		private function _drawContent():void
		{
			this._itemsPanel = new CJTurnPage(ConstStrategy.STRATEGY_PER_PAGE_ITEM_NUM);
			this._itemsPanel.setRect(348, 210);
			this._itemsPanel.type = CJTurnPage.SCROLL_V;
			this._itemsPanel.x = 3;
			this._itemsPanel.y = 25;
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
				const render:CJStrategyItem = new CJStrategyItem();
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
			
		}
	}
}