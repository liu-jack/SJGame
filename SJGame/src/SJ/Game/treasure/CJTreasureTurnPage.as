package SJ.Game.treasure
{
	import SJ.Common.Constants.ConstTreasure;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfTreasureList;
	import SJ.Game.formation.CJTurnPage;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalLayout;
	
	/**
	 +------------------------------------------------------------------------------
	 * 聚灵 - 灵丸滑动面板
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-3 上午11:08:56  
	 +------------------------------------------------------------------------------
	 */
	public class CJTreasureTurnPage extends CJTurnPage
	{
		private var _bag:int;
		
		public function CJTreasureTurnPage(bag:int)
		{
			this._bag = bag;
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._drawContent();
		}
		
		private function _drawContent():void
		{
			//设置渲染属性
			this._setLayout();
			this._setRenerItem();
			this.setDataProvider();
		}
		
		override protected function draw():void
		{
			super.draw();
		}
		
		private function _setRenerItem():void
		{
			var pthis:* = this;
			this.itemRendererFactory = function _getRenderFatory():IListItemRenderer
			{
				const render:CJTreasureItem = new CJTreasureItem();
				render.owner = pthis;
				return render;
			};
		}
		
		private function _setLayout():void
		{
			const listLayout:TiledRowsLayout  = new TiledRowsLayout();
			listLayout.tileHorizontalAlign = TiledColumnsLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout.tileVerticalAlign = TiledColumnsLayout.VERTICAL_ALIGN_TOP;
			listLayout.gap = 48;
			listLayout.paging = TiledColumnsLayout.PAGING_HORIZONTAL;
			this.layout = listLayout;
		}
		
		public function setDataProvider():void
		{
			var treasureList:Array = null;
			if(this._bag == ConstTreasure.TREASURE_PLACE_TEMP_BAG)
			{
				treasureList = CJDataManager.o.DataOfTreasureList.treasureTempBagList;
			}
			else
			{
				treasureList = CJDataManager.o.DataOfTreasureList.treasureUserBagList;
			}
			this.dataProvider = new ListCollection(treasureList);
		}
		
	}
}