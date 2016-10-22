package SJ.Game.herotrain
{
	import SJ.Game.formation.CJTurnPage;
	
	import engine_starling.display.SLayer;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	public class CJHeroTrainStartPanel extends SLayer
	{
		/** 每页最大个数 **/
		private const CONST_ITEM_PERPAGE_COUNT:int = 10;
		/** item之间间隙 **/
		private const CONST_ITEM_GAP:int = 0;
		
		/** 翻页栏 **/
		private var _turnPage:CJTurnPage = new CJTurnPage;
		/** 当前数据 **/
		private var _data:Array;
		
		public function CJHeroTrainStartPanel(width:int, height:int)
		{
			super();
			
			this.width = width;
			this.height = height;
		}
		
		override protected function initialize():void
		{
			_initData();
			super.initialize();
		}
		
		private function _initData():void
		{
			addChild(_turnPage);
			
			//设置渲染属性
			var listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_RIGHT;
			listLayout.gap = CONST_ITEM_GAP;
			_turnPage.layout = listLayout;
			_turnPage.itemRendererFactory =  function _getRenderFatory():IListItemRenderer
			{
				const render:CJHeroTrainStartItem = new CJHeroTrainStartItem();
				render.owner = _turnPage;
				return render;
			};
			_turnPage.setRect(width, 200);
			addChild(_turnPage);
		}
		
		
		
		
		private function _updateLayer():void
		{
			var groceryList:ListCollection = new ListCollection(_data);
			_turnPage.dataProvider = groceryList;
		}
		
		public function set data( value:Array ):void
		{
			_data = value;
			_updateLayer();
		}
		
	}
}