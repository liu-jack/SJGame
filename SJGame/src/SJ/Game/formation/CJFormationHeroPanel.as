package SJ.Game.formation
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFormation;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;

	/**
	 +------------------------------------------------------------------------------
	 * @name 阵型英雄面板 负责该面板的翻页，拖拽事件
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-11 下午12:09:04  
	 +------------------------------------------------------------------------------
	 */
	public class CJFormationHeroPanel extends SLayer
	{
		/*用户武将信息*/
		private var _heroList:CJDataOfHeroList;
		/*武将头像面板*/
		private var _heroPanel:CJTurnPage;
		/*初始英雄页面号*/
		private var _currentHeroPage:int = 0;
		/*英雄页面总数*/
		private var _totalHeroPage:int = 4;
		
		private var _bg:Scale9Image;

		private var _formationData:CJDataOfFormation;
		
		public function CJFormationHeroPanel()
		{
			super();
		}
		
		override protected function initialize():void
		{
			this._drawContent();
			this._initData();
			super.initialize();
		}
		
		private function _drawContent():void
		{
			this._bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_wujiangxuanzedi") , new Rectangle(14,14 ,1,1)));
			this._bg.width = 66;
			this._bg.height = 272;
			this.addChildTo(this._bg , 0 , 0);
			
			this._heroPanel = new CJTurnPage(3 , CJTurnPage.SCROLL_V , true);
			this._heroPanel.setRect(63 , 200);
			this._heroPanel.y = 35;
//			this._heroPanel.stopScrolling();
			this.addChild(this._heroPanel);
			
			this._heroPanel.preButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeup01"));
			this._heroPanel.preButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeup03"));
			this._heroPanel.preButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeup02"));
			this._heroPanel.preButton.x = 11;
			this._heroPanel.preButton.y = -32;
			
			this._heroPanel.nextButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeup01"));
			this._heroPanel.nextButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeup03"));
			this._heroPanel.nextButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeup02"));
			this._heroPanel.nextButton.scaleY = -1;
			this._heroPanel.nextButton.x = 11;
			this._heroPanel.nextButton.y = 234;
		}
		
		private function _initData():void
		{
			this._heroList = CJDataManager.o.DataOfHeroList;
			_formationData = CJDataManager.o.DataOfFormation;
			
			_formationData.addEventListener(CJDataOfFormation.FORMATION_DATA_CHANGED , this._update);
			if(this._heroList.dataIsEmpty)
			{
				return;
			}
			else
			{
				this._doInit();
			}
		}
		
		private function _update(e:Event):void
		{
			var groceryList:ListCollection = new ListCollection(_getUnplacedHeroList());
			this._heroPanel.dataProvider = groceryList;
		}
		
		/**
		 * 获得所有的未放置的武将列表
		 */		
		private function _getUnplacedHeroList():Array
		{
			var heroDict:Dictionary = CJDataManager.o.DataOfHeroList.herolist;
			var listData:Array = new Array();
			for each(var heroData:CJDataOfHero in heroDict)
			{
				//过滤所有放置过的武将
				if(!_formationData.isHeroPlaced(heroData.heroid))
				{
					var data:Object = {
						heroId:heroData.heroid,
						isnew:CJDataManager.o.DataOfHeroList.isNewHero(heroData.heroid),
						quality:heroData.heroProperty.quality,
						templeteid:heroData.templateid}
					listData.unshift(data);
				}
			}
			
			listData.sort(this._sortHero);
			
			return listData;
		}
		
		private function _sortHero(oa:Object , ob:Object):int
		{
			if(oa.isnew && ob.isnew)
			{
				return oa.quality >= ob.quality ? -1 : 1;
			}
			
			if(oa.isnew)
			{
				return -1;
			}
			else if (ob.isnew)
			{
				return 1;	
			}
			else
			{
				return oa.quality >= ob.quality ? -1 : 1;
			}
		}
		
		private function _doInit():void
		{
			const listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout.gap = 5;
			_heroPanel.paddingTop = -12;
			this._heroPanel.layout = listLayout;
			var groceryList:ListCollection = new ListCollection(_getUnplacedHeroList());
			this._heroPanel.dataProvider = groceryList;
			this._heroPanel.itemRendererFactory = function _getRenderFatory():IListItemRenderer
			{
				const render:CJItemHero = new CJItemHero();
				render.owner = _heroPanel;
				return render;
			}
		}
		
		
		public function getTouchedHero():CJItemHero
		{
			return this._heroPanel.selectedItem as CJItemHero;
		}
	}
}