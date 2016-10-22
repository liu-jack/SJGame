package SJ.Game.vip
{
	import SJ.Common.Constants.ConstVip;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.formation.CJTurnPage;
	
	import engine_starling.display.SLayer;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	
	/**
	 * VIP水平滑动面板
	 * @author longtao
	 */
	public class CJVipHPanel extends SLayer
	{
		private const TURN_PAGE_WIDTH:int = 480;
		private const TURN_PAGE_HEIGHT:int = 320;
		
		public function CJVipHPanel()
		{
			super();
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var item:CJVipHItem = new CJVipHItem;
			item.index = 0;
			addChild(item);
		}
		
		// -------------------- 不要左右滑动了 -------------------- \\
//		/**  **/
//		private var _turnPage:CJTurnPage;
//		
//		
//		override protected function initialize():void
//		{
//			super.initialize();
//			
//			var listData:Array = _getDataArr();
//			//设置渲染属性
//			var groceryList:ListCollection = new ListCollection(listData);
//			// 添加数据监听
//			var listLayout:HorizontalLayout = new HorizontalLayout;
//			listLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_TOP;
//			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;// HorizontalLayout.HORIZONTAL_ALIGN_RIGHT;
//			listLayout.gap = 0;
//			if (_turnPage)
//			{
//				_turnPage.removeFromParent(true);
//				_turnPage = null;
//			}
//			_turnPage = new CJTurnPage(1, CJTurnPage.SCROLL_H, true);
//			_turnPage.layout = listLayout;
//			_turnPage.dataProvider = groceryList;
//			_turnPage.itemRendererFactory = function _getRenderFatory():IListItemRenderer
//			{
//				const render:CJVipHItem = new CJVipHItem();
//				render.owner = _turnPage;
//				return render;
//			};
//			_turnPage.setRect(TURN_PAGE_WIDTH , TURN_PAGE_HEIGHT);
//			addChild(_turnPage);
//		}
//		
//		private function _getDataArr():Array
//		{
//			// 数据
//			var listData:Array = new Array();
//			// 配置vip最大等级
//			var maxVipLevel:uint = uint(CJDataOfGlobalConfigProperty.o.getData("VIP_MAX_LEVEL"));
//			// 页数
//			var pageNum:uint = maxVipLevel / ConstVip.VIP_MAX_FIELD + 1;
//			
//			var data:Object;
//			for (var i:int=0; i<pageNum; ++i)
//			{
//				data = {
//					page:i	// page
//				};
//				
//				listData.push(data);
//			}
//			
//			return listData;
//		}
		// -------------------- 不要左右滑动了 end -------------------- \\
	}
}