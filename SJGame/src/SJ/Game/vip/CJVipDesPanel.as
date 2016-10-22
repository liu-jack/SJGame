package SJ.Game.vip
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.display.SLayer;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	/**
	 * vip特权详细说明面板框
	 * @author longtao
	 * 
	 */
	public class CJVipDesPanel extends SLayer
	{
		private var _turnPage:CJTurnPage;
		
		public function CJVipDesPanel()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			// 获取当前玩家信息
			var vipLevel:uint = CJDataManager.o.DataOfRole.vipLevel;
//			if (vipLevel == 0)
//				vipLevel += 1;
			var str:String = CJLang("vip_describe_"+vipLevel);
			if (null == str) str = "";
			var arr:Array = str.split("\n");
			
			_turnPage = new CJTurnPage(6);
			_turnPage.x = 0;
			_turnPage.y = 0;
			_turnPage.setRect(width, height);
			var listData:Array = __getDataArr();
			function __getDataArr():Array
			{
				const cutWordCount:uint = 12; // 12字长将会截取
				// 数据
				var listData:Array = new Array();
				for (var i:int=0; i<arr.length; ++i)
				{
					var str:String = arr[i] as String;
					if (str.length > cutWordCount)
					{
						var searchIndex:int = str.indexOf(".");
						var str1:String = str.substring(0, cutWordCount);
						var addstr:String = searchIndex==1 ? "  " : "   ";
						var str2:String = addstr + str.substring(cutWordCount);
						listData.push({text:str1});
						listData.push({text:str2});
					}
					else
						listData.push({text:arr[i]});
				}
				return listData;
			}
			//设置渲染属性
			var listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			_turnPage.layout = listLayout;
			_turnPage.dataProvider = new ListCollection(listData);
			_turnPage.itemRendererFactory = function _getRenderFatory():IListItemRenderer
			{
				const render:CJVipDesItem = new CJVipDesItem();
				render.owner = _turnPage;
				return render;
			};
			addChild(_turnPage);

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
//			_turnPage = new CJTurnPage;
//			_turnPage.layout = listLayout;
//			_turnPage.dataProvider = groceryList;
//			_turnPage.itemRendererFactory = function _getRenderFatory():IListItemRenderer
//			{
//				const render:CJVipDesItem = new CJVipDesItem();
//				render.owner = _turnPage;
//				return render;
//			};
//			_turnPage.setRect(125 , 195);
//			addChild(_turnPage);
		}
		
		
	}
}