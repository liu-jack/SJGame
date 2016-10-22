package SJ.Game.heroStar
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.formation.CJTurnPage;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import flash.utils.Dictionary;
	
	import starling.events.Event;
	
	/**
     * ------------------------------------------------------------------------------
     * @name     武将头像
     * @comment  
     * @note:    
     * ------------------------------------------------------------------------------
     * @author   longtao   
     * @email    longtao1@corp.kaixin001.com
     * @date     2013-5-27    10:13
     * ------------------------------------------------------------------------------
	 */
	public class CJHeroStarHeadLayer extends SLayer
	{
		/** 翻页按钮宽度 **/
		private const CONST_BUTTON_WIDTH:int = 46;
		/** 翻页按钮高度 **/
		private const CONST_BUTTON_HEIGHT:int = 28;
		/** 按钮相对面板的X轴偏移量 **/
		private const CONST_BUTTON_OFFSET_X:int = 12;
		/** 每页Item显示最大数量 **/
		private const CONST_MAX_ITEM_COUNT:int = 3;
		/** Item间隙 **/
		private const CONST_ITEM_GAP:Number = 1;
		/** 滑动面板X轴偏移 **/
		private const CONST_PANEL_OFFSET_X:int = 2;
		/** 滑动面板Y轴偏移 **/
		private const CONST_PANEL_OFFSET_Y:int = 2;
		/** 宽度缩减 **/
		private const CONST_PANEL_CUT_WIDTH:int = 2;
		/** 高度缩减 **/
		private const CONST_PANEL_CUT_HEIGHT:int = 0;
		
		
		/**武将头像面板**/
		private var _heroPanel:CJTurnPage;
		
		
		public function CJHeroStarHeadLayer()
		{
			super();
		}
		
		/**
		 * 获取首个武将的heroid
		 * @return 武将id
		 * @return type: Stirng
		 */
		public function getFirstHeroid():String
		{
			if (null == _heroPanel || null == _heroPanel.dataProvider.data)
				return "";
			var data:Array = _heroPanel.dataProvider.data as Array;
			if (data.length == 0)
				return "";
			return data[0].heroid;
		}
		
		/**
		 * 获取面板保存数据
		 * @return 武将星级头像面板数据
		 * @return type: Object
		 * @Note: 返回信息格式 {0:{heroid,quality,templeteid,weight},1:{heroid,quality,templeteid,weight}...}
		 */
		public function get dataProvider():Object
		{
			return _heroPanel.dataProvider as Object;
		}
		
		/**
		 * 获取翻页面板
		 * @return CJTurnPage
		 */
		public function get turnPage():CJTurnPage
		{
			return _heroPanel;
		}
		
		
		// 初始化
		override protected function initialize():void
		{
			_drawContent();
			_initData();
			super.initialize();
		}
		
		// 初始化包含的显示对象
		private function _drawContent():void
		{
//			// 修饰框 
//			var _bg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_wujiangxuanzedi") , new Rectangle(13,11 ,2,6)));
//			_bg.width = width;
//			_bg.height = height;
//			addChild(_bg);
			
			// 滚动面板
			_heroPanel = new CJTurnPage(CONST_MAX_ITEM_COUNT);
			_heroPanel.x = CONST_PANEL_OFFSET_X;
			_heroPanel.y = CONST_PANEL_OFFSET_Y;
			_heroPanel.setRect(width-CONST_PANEL_CUT_WIDTH , height-CONST_PANEL_CUT_HEIGHT);
			_heroPanel.type = CJTurnPage.SCROLL_V;
			
			_heroPanel.preButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeup01"));
			_heroPanel.preButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeup03"));
			_heroPanel.preButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeup02"));
			_heroPanel.preButton.x = 10;
			_heroPanel.preButton.y = -28;
			
			_heroPanel.nextButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeup01"));
			_heroPanel.nextButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeup03"));
			_heroPanel.nextButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeup02"));
			_heroPanel.nextButton.scaleY = -1;
			_heroPanel.nextButton.x = _heroPanel.preButton.x;
			_heroPanel.nextButton.y = height+30;
		}
		
		// 根据 按钮名称 翻动武将名称列表
		private function _turnHeroPage(e:Event):void
		{
			if(e.target is Button)
			{
				var btn:Button = e.target as Button;
				if(btn.name == "pre")
				{
					_heroPanel.prevPage();
				}
				else
				{
					_heroPanel.nextPage();
				}
			}
		}
		
//		/**
//		 * 点击面板
//		 * @param e
//		 */
//		private function _touchHandler(e:TouchEvent):void
//		{
//			var touch:Touch = e.getTouch(this);
//			if(touch != null && touch.phase == TouchPhase.BEGAN && touch.target is Button)
//			{
//				var itemDataList:Array = _heroPanel.getAllItemDatas();
//				for(var i:int = 0 ; i < itemDataList.length ; i++)
//				{
//					itemDataList[i].isSelected = false;
//					_heroPanel.updateItem(itemDataList[i] , i);
//				}
//			}
//		}
		
		/**
		 * 初始化数据
		 */
		private function _initData():void
		{
			/// 武将字典< heroid, heroInfo >
			if(CJDataManager.o.DataOfHeroList.dataIsEmpty) // 数据位空则请求数据
			{
				CJDataManager.o.DataOfHeroList.addEventListener(DataEvent.DataLoadedFromRemote , _doInit);
				CJDataManager.o.DataOfHeroList.loadFromRemote();
			}
			else //
			{
				_doInit();
			}
		}
		
		/**
		 * 数据初始化完成
		 */
		private function _doInit():void
		{
			// 获信息(已排序)   构造面板数据
			var listData:Array = _getDataArr();
			var groceryList:ListCollection = new ListCollection(listData);
			// 武将头像面渲染属性
			var listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_RIGHT;
			listLayout.gap = CONST_ITEM_GAP; // item间隙
			// 设置头像面板
			_heroPanel.layout = listLayout; // 设置渲染属性
			_heroPanel.dataProvider = groceryList;// 设置武将头像面板数据
			_heroPanel.itemRendererFactory = function _getRenderFatory():IListItemRenderer
			{
				const render:CJHeroStarHeadItem = new CJHeroStarHeadItem();
				render.owner = _heroPanel;
				return render;
			}; // 设置Item工厂函数指针
			addChild(_heroPanel); // 
		}
		
		
		/**
		 * 获取数据并排序
		 * @return Array
		 * @type [{heroid,quality,templeteid,weight},{heroid,quality,templeteid,weight}...]
		 */
		private function _getDataArr():Array
		{
			var listData:Array = new Array();
			
			// 武将
			var i:int = 0;
			var data:Object;
			var heroDict:Dictionary = CJDataManager.o.DataOfHeroList.herolist;
			for each (var heroData:CJDataOfHero in heroDict)
			{
				data = new Object;
				data.heroid = heroData.heroid;
				data.quality = int(heroData.heroProperty.quality);
				data.templeteid = heroData.templateid;
				// 为排序故将武将权重变化
				data.weight = int(heroData.heroProperty.quality)*100000+int(heroData.templateid); 
				if (heroData.isRole) // 主将不可升星，故不放入
					continue;
				data.isSelected = false;
				listData.push(data);
			}
			// 对数据进行排序
			listData.sortOn("weight", Array.NUMERIC|Array.DESCENDING);
			
			// 重新设置index
			for(; i<listData.length; i++)
				listData[i].index = i;
			
			return listData;
		}
		
	}
}