package SJ.Game.bag
{
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.config.CJDataOfBagProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.json.Json_bag_property_setting;
	import SJ.Game.formation.CJTurnPage;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * 背包翻页层
	 * @author sangxu
	 * @date 2013-08-21
	 */	
	public class CJBagTurnPageLayer extends SLayer
	{
		/** 翻页按钮宽度 **/
		private const CONST_BUTTON_WIDTH:int = 17;
		/** 翻页按钮高度 **/
		private const CONST_BUTTON_HEIGHT:int = 22;
		/** 按钮相对面板的X轴偏移量 **/
		private const CONST_BUTTON_OFFSET_X:int = 10;
		/** 按钮相对面板的Y轴偏移量 **/
		private const CONST_BUTTON_OFFSET_Y:int = -28;
		/** 每页Item显示最大数量 **/
		private const CONST_MAX_ITEM_COUNT:int = 1;
		/** Item间隙 **/
		private const CONST_ITEM_GAP:Number = 0;
		/** 滑动面板X轴偏移 **/
		private const CONST_PANEL_OFFSET_X:int = 2;
		/** 滑动面板Y轴偏移 **/
		private const CONST_PANEL_OFFSET_Y:int = 0;
		/** 宽度缩减 **/
		private const CONST_PANEL_CUT_WIDTH:int = 2;
		/** 高度缩减 **/
		private const CONST_PANEL_CUT_HEIGHT:int = 2;
		
		/** 背包翻页面板 */
		private var _bagPanel:CJTurnPage;
		
		/** 背包信息 */
		private var _dataBag:CJDataOfBag;
		/** 道具容器配置数据 - 背包 */
		private var _bagSetting:Json_bag_property_setting;
		
		
		/** 背包标签类型 */
		private var _bagType:int;
		/** 初始化状态位 */
		private var _isInit:Boolean = false;
		
		/** 物品框总页数 */ 
		private var _pageNum:uint;
		/** 当前页索引,默认是第一页 */
		private var _currentPage:uint = 1;
		/** 背包容量上限 */
		private var _bagMaxCount:uint = 10;
		/** 单页行数 */
		private var _bagRowNum:uint = 5;
		/** 单页列数 */
		private var _bagColNum:uint = 4;
		/** 单页格子数量 */
		private var _onePageNum:uint = _bagRowNum * _bagColNum;
		
		public function CJBagTurnPageLayer()
		{
			super();
		}
		
		/**
		 * 获取面板保存数据
		 * @return 武将头像面板数据
		 * @return type: Object
		 * @Note: 返回信息格式 {0:{heroid,quality,templeteid,weight},1:{heroid,quality,templeteid,weight}...}
		 */
		public function get dataProvider():Object
		{
			return _bagPanel.dataProvider as Object;
		}
		
		
		// 初始化
		override protected function initialize():void
		{
			_initData();
			
			_initControls();
			//添加事件
			_addListeners();
			
			_doInit();
			
			super.initialize();
			this._isInit = true;
		}
		
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
			// 滚动面板
			_bagPanel = new CJTurnPage(1, CJTurnPage.SCROLL_H, true);
			_bagPanel.x = 10;
			_bagPanel.y = CONST_PANEL_OFFSET_Y;
			_bagPanel.setRect(312, 250);
//			_bagPanel.paddingLeft = -5;
			
//			_bagPanel.itemPerPage = CONST_MAX_ITEM_COUNT;
//			_bagPanel.type = CJTurnPage.SCROLL_H;
			
			this._bagPanel.preButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
			this._bagPanel.preButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeright03"));
			this._bagPanel.preButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeright02"));
			this._bagPanel.preButton.width = CONST_BUTTON_WIDTH;
			this._bagPanel.preButton.height = CONST_BUTTON_HEIGHT;
			this._bagPanel.preButton.x = 124;
			this._bagPanel.preButton.y = 255;
			this._bagPanel.preButton.scaleX = -1;	// 左右翻转按钮
			
			this._bagPanel.nextButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
			this._bagPanel.nextButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeright03"));
			this._bagPanel.nextButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeright02"));
			this._bagPanel.nextButton.width = CONST_BUTTON_WIDTH;
			this._bagPanel.nextButton.height = CONST_BUTTON_HEIGHT;
			this._bagPanel.nextButton.x = 212 - this._bagPanel.nextButton.width;
			this._bagPanel.nextButton.y = 255;
			
			// 页码条
			imgYemaditiao = new Button();
			// 获取页码底条纹理
			var texture:Texture = SApplication.assets.getTexture("common_fanyeyemawenzidi");
			// 设置伸缩纹理
			var scale9texture:Scale9Textures = new Scale9Textures(texture, new Rectangle(5, 5, 1, 1));
			imgYemaditiao.defaultSkin= new Scale9Image(scale9texture);
			// 设置页码的字体格式
			var fontFormat:TextFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xFFFFFF );
			imgYemaditiao.x = 140;
			imgYemaditiao.y = 257;
			imgYemaditiao.width = 59;
			imgYemaditiao.height = 17;
			imgYemaditiao.defaultLabelProperties.textFormat = fontFormat;
			this.addChild(imgYemaditiao);
			
			this._setPageIndexLabel();
		}
		
		/**
		 * 设置页码索引
		 * @param scrollPage 
		 * @param imgYemaditiao
		 * 
		 */		
		private function _setPageIndexLabel():void
		{
			this._imgYemaditiao.label = this._currentPage + " / " + this._pageNum;
		}
		
		// 添加所有监听
		private function _addListeners():void
		{
//			_bagPanel.addEventListener(TouchEvent.TOUCH, _touchHandler);
			_bagPanel.addEventListener(FeathersEventType.SCROLL_COMPLETE , this._updatePage);
		}
		
		private function _updatePage(event:Event):void
		{
			this._currentPage = _bagPanel.currentPage + 1;
			_setPageIndexLabel();
		}
		
		public function setBagType(bagType:int):void
		{
			this._bagType = bagType;
			
			if (_bagPanel != null)
			{
				var listData:Array = _getDataArr();
				var groceryList:ListCollection = new ListCollection(listData);
				_bagPanel.dataProvider = groceryList;// 设置面板数据
				
				this._currentPage = 1;
				_setPageIndexLabel();
			}
		}
		
		/**
		 * 点击面板
		 * @param e
		 */
		private function _touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch != null && touch.phase == TouchPhase.BEGAN && touch.target is Button)
			{
				var itemDataList:Array = _bagPanel.getAllItemDatas();
				for(var i:int = 0 ; i < itemDataList.length ; i++)
				{
					itemDataList[i].isSelected = false;
					_bagPanel.updateItem(itemDataList[i] , i);
				}
			}
		}
		
		/**
		 * 初始化数据
		 */
		private function _initData():void
		{
			this._dataBag = CJDataManager.o.DataOfBag;
			this._bagSetting = CJDataOfBagProperty.o.getBagType(ConstBag.CONTAINER_TYPE_BAG);
			
			// 背包容量上限
			this._bagMaxCount = int(this._bagSetting.maxcount);
			// 单页行数
			this._bagRowNum = int(this._bagSetting.rownum);
			// 单页列数
			this._bagColNum = int(this._bagSetting.colnum);
			this._onePageNum = _bagRowNum * _bagColNum;
			
			//物品框总页数
			this._pageNum = this._bagMaxCount % this._onePageNum > 0 ? 
				(this._bagMaxCount / this._onePageNum + 1) :
				this._bagMaxCount / this._onePageNum;
			
			
		}
		
		/**
		 * 数据初始化完成
		 */
		private function _doInit():void
		{
			// 获信息(已排序)   构造面板数据
			var listData:Array = _getDataArr();
			var groceryList:ListCollection = new ListCollection(listData);
			// 渲染属性
			var listLayout:HorizontalLayout = new HorizontalLayout();
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
//			listLayout.gap = CONST_ITEM_GAP; // item间隙
//			listLayout.paddingLeft = -10;
			
			// 设置面板
			_bagPanel.layout = listLayout; // 设置渲染属性
			_bagPanel.dataProvider = groceryList;// 设置面板数据
			_bagPanel.itemRendererFactory = _getRenderFatory; // 设置Item工厂函数指针
			
			addChild(_bagPanel); // 
		}
		
		/**
		 * 实例化工厂
		 * @return IListItemRenderer
		 */
		private function _getRenderFatory():IListItemRenderer
		{
			const render:CJBagTurnPageItem = new CJBagTurnPageItem();
			render.owner = _bagPanel;
			return render;
		}
		
		/**
		 * 获取数据并排序
		 * @return Array
		 * @type [{heroid,quality,templeteid,weight},{heroid,quality,templeteid,weight}...]
		 */
		private function _getDataArr():Array
		{
			var listData:Array = new Array();
			var data:Object;
			
			var bagSetting:Json_bag_property_setting = CJDataOfBagProperty.o.getBagType(ConstBag.CONTAINER_TYPE_BAG);
			// 背包容量上限
			var bagMaxCount:int = parseInt(bagSetting.maxcount);
			var onePageNum:int = int(bagSetting.rownum) * int(bagSetting.colnum);
			var pageNum:int = bagMaxCount % onePageNum > 0 ? 
				(bagMaxCount / onePageNum + 1) :
				bagMaxCount / onePageNum;
			for (var i:int = 0; i < pageNum; i++)
			{
				data = new Object;
				data.page = i + 1;
				data.bagtype = _bagType;
				listData.push(data);
			}
			
			return listData;
		}
		
		private function _heroSort(heroA:Object, heroB:Object):int
		{
//			if (heroA.isRole)
//			{
//				return -1;
//			}
//			if (heroB.isRole)
//			{
//				return 1;
//			}
//			var heroATmpl:CJDataHeroProperty = this._heroConfig.getProperty(heroA.templateid);
//			var heroBTmpl:CJDataHeroProperty = this._heroConfig.getProperty(heroB.templateid);
//			if (int(heroATmpl.quality) > int(heroBTmpl.quality))
//			{
//				return -1;
//			}
//			else if (int(heroATmpl.quality) < int(heroBTmpl.quality))
//			{
//				return 1;
//			}
//			else
//			{
//				return 0;
//			}
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
				_bagPanel.removeEventListener(TouchEvent.TOUCH, _touchHandler);
				CJDataManager.o.DataOfHeroList.removeEventListener(DataEvent.DataLoadedFromRemote , _doInit);
			}
		}
		
		/** Controls */
		/** *页码底条图片 */
		private var _imgYemaditiao:Button;
		
		/** Controlers getter */
		/** 页码底条图片 */
		public function get imgYemaditiao():Button
		{
			return _imgYemaditiao;
		}
		
		/** Controlers setter */
		public function set imgYemaditiao(value:Button):void
		{
			_imgYemaditiao = value;
		}
	}
}