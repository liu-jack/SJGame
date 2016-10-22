package SJ.Game.equipment
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.formation.CJTurnPage;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 装备洗练武将头像层
	 * @author zhengzheng
	 */	
	public class CJItemRecastHeroLayer extends SLayer
	{
		/** 翻页按钮宽度 **/
		private const CONST_BUTTON_WIDTH:int = 41;
		/** 翻页按钮高度 **/
		private const CONST_BUTTON_HEIGHT:int = 26;
		/** 按钮相对面板的X轴偏移量 **/
		private const CONST_BUTTON_OFFSET_X:int = 11;
		/** 按钮相对面板的Y轴偏移量 **/
		private const CONST_BUTTON_OFFSET_Y:int = -25;
		/** 每页Item显示最大数量 **/
		private const CONST_MAX_ITEM_COUNT:int = 3;
		/** Item间隙 **/
		private const CONST_ITEM_GAP:Number = -5;
		/** 滑动面板X轴偏移 **/
		private const CONST_PANEL_OFFSET_X:int = 2;
		/** 滑动面板Y轴偏移 **/
		private const CONST_PANEL_OFFSET_Y:int = 0;
		/** 宽度缩减 **/
		private const CONST_PANEL_CUT_WIDTH:int = 2;
		/** 高度缩减 **/
		private const CONST_PANEL_CUT_HEIGHT:int = 4;
		
		
		/**用户武将信息**/
		private var _heroList:CJDataOfHeroList;
		/**武将头像面板**/
		private var _heroPanel:CJTurnPage;
		
		/** 武将配置 */
		private var _heroConfig:CJDataOfHeroPropertyList;
		
		private var _isInit:Boolean = false;
		
		public function CJItemRecastHeroLayer()
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
		
		
		// 初始化
		override protected function initialize():void
		{
			_drawContent();
			_initData();
			super.initialize();
			
			this._isInit = true;
		}
		
		// 初始化包含的显示对象
		private function _drawContent():void
		{
			// 修饰框
			var _bg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_wujiangxuanzedi") , new Rectangle(15,15,3,3)));
			_bg.width = width;
			_bg.height = height;
			addChild(_bg);
			
			// 滚动面板
			_heroPanel = new CJTurnPage(CONST_MAX_ITEM_COUNT , CJTurnPage.SCROLL_V);
			_heroPanel.x = CONST_PANEL_OFFSET_X;
			_heroPanel.y = CONST_PANEL_OFFSET_Y + CONST_BUTTON_HEIGHT + 2;
			_heroPanel.setRect(width-CONST_PANEL_CUT_WIDTH , height - CONST_BUTTON_HEIGHT - CONST_BUTTON_HEIGHT);
			
			this._heroPanel.preButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeup01"));
			this._heroPanel.preButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeup03"));
			this._heroPanel.preButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeup02"));
			this._heroPanel.preButton.width = CONST_BUTTON_WIDTH;
			this._heroPanel.preButton.height = CONST_BUTTON_HEIGHT;
			this._heroPanel.preButton.x = CONST_BUTTON_OFFSET_X;
			this._heroPanel.preButton.y = CONST_BUTTON_OFFSET_Y;
			
			this._heroPanel.nextButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeup01"));
			this._heroPanel.nextButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeup03"));
			this._heroPanel.nextButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeup02"));
			this._heroPanel.nextButton.width = CONST_BUTTON_WIDTH;
			this._heroPanel.nextButton.height = CONST_BUTTON_HEIGHT;
			this._heroPanel.nextButton.x = CONST_BUTTON_OFFSET_X;
			this._heroPanel.nextButton.y = this.height + CONST_BUTTON_OFFSET_Y - 3;
			this._heroPanel.nextButton.scaleY = -1;	// 上下翻转按钮
		}
		
		/**
		 * 初始化数据
		 */
		private function _initData():void
		{
			this._heroConfig = CJDataOfHeroPropertyList.o;
			// 武将字典< heroid, heroInfo >
			_heroList = CJDataManager.o.DataOfHeroList;
			if(_heroList.dataIsEmpty) // 数据位空则请求数据
			{
				CJDataManager.o.DataOfHeroList.addEventListener(DataEvent.DataLoadedFromRemote , _doInit);
				CJDataManager.o.DataOfHeroList.loadFromRemote();
			}
			else //
			{
				_doInit();
			}
		}
		override public function dispose():void
		{
			CJDataManager.o.DataOfHeroList.removeEventListener(DataEvent.DataLoadedFromRemote , _doInit);
			super.dispose();
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
			listLayout.paddingTop = -5 ;
			// 设置头像面板
			_heroPanel.layout = listLayout; // 设置渲染属性
			_heroPanel.dataProvider = groceryList;// 设置武将头像面板数据
			_heroPanel.itemRendererFactory = function _getRenderFatory():IListItemRenderer
			{
				const render:CJItemRecastHeroHeadItem = new CJItemRecastHeroHeadItem();
				render.owner = _heroPanel;
				return render;
			}; // 设置Item工厂函数指针
			addChild(_heroPanel); // 
		}
		
		/**
		 * 实例化工厂
		 * @return IListItemRenderer
		 */
		
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
				data.templateid = heroData.templateid;
				data.isRole = heroData.isRole;
				// 为排序故将武将权重变化
				data.weight = int(heroData.heroProperty.quality)*100000+int(heroData.templateid); 
				data.isSelected = false;
				listData.push(data);
			}
			// 对数据进行排序
			listData.sort(_heroSort);
			// 重新设置index
			for(; i<listData.length; i++)
				listData[i].index = i;
			
			listData[0].isSelected = true;
			
			return listData;
		}
		
		private function _heroSort(heroA:Object, heroB:Object):int
		{
			if (heroA.isRole)
			{
				return -1;
			}
			if (heroB.isRole)
			{
				return 1;
			}
			if (int(heroA.weight) > int(heroB.weight))
			{
				return -1;
			}
			else if (int(heroA.weight) < int(heroB.weight))
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		/**
		 * 移除所有事件监听
		 * 
		 */		
		public function removeAllEventListener():void
		{
			if (this._isInit == true)
			{
				CJDataManager.o.DataOfHeroList.removeEventListener(DataEvent.DataLoadedFromRemote , _doInit);
			}
		}
		
		/**
		 * 选中武将
		 * @param heroId	武将唯一id
		 * 
		 */		
		public function selectHero(heroId:String):void
		{
			// 将所有的设置为非选中状态
			var arr:Array = this._heroPanel.getAllItemDatas();
			for (var i:int; i<arr.length; ++i)
			{
				if (String(arr[i].heroid) == heroId)
				{
					arr[i].isSelected = true;
					_heroPanel.selectedIndex = i;
				}
				else
				{
					arr[i].isSelected = false;
				}
				this._heroPanel.updateItemAt(arr[i].index);
			}
		}
	}
}