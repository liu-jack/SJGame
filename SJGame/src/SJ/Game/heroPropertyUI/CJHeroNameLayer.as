package SJ.Game.heroPropertyUI
{
	import SJ.Common.Constants.ConstPlayer;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfHeroTagProperty;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.lang.CJLang;
	
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
	
	import lib.engine.utils.functions.Assert;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 绘制英雄名称图层
	 * @author longtao
	 * 
	 */
	public class CJHeroNameLayer extends SLayer
	{
		/*武将头像面板*/
		private var _heroPanel:CJTurnPage;
		
		/*初始英雄页面号*/
		private var _currentHeroPage:int = 0;
		/*英雄页面总数*/
		private var _totalHeroPage:int = 4;
		
		private const CONST_ITEM_GAP:Number = 2;
		
		/* 武将战斗力 */
		private var _heroFightValue:Object;

		
		public function CJHeroNameLayer( value:Object )
		{
			super();
			
			_heroFightValue = value;
		}

		/**
		 * 删除所有监听
		 */
		public function removeAllEL():void
		{
			CJDataManager.o.DataOfHeroList.removeEventListener(DataEvent.DataLoadedFromRemote , _doInit);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_doInit();
		}
		
		private function _drawContent():void
		{
			this._heroPanel.preButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeup01"));
			this._heroPanel.preButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeup03"));
			this._heroPanel.preButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeup02"));
			this._heroPanel.preButton.x = 25;
			this._heroPanel.preButton.y = -28;
			
			this._heroPanel.nextButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeup01"));
			this._heroPanel.nextButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeup03"));
			this._heroPanel.nextButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeup02"));
			this._heroPanel.nextButton.scaleY = -1;
			this._heroPanel.nextButton.x = this._heroPanel.preButton.x;
			this._heroPanel.nextButton.y = height+28;
		}
		
		private function _doInit():void
		{
			_heroPanel = new CJTurnPage(5);
			_heroPanel.setRect(width , height);
			_heroPanel.x = 0;
			_heroPanel.y = 1;
			_heroPanel.type = CJTurnPage.SCROLL_V;
			
			_drawContent();
			
			var listData:Array = _getDataArr();
			//设置渲染属性
			var groceryList:ListCollection = new ListCollection(listData);
			// 添加数据监听
			var listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_RIGHT;
			listLayout.gap = CONST_ITEM_GAP;
			_heroPanel.layout = listLayout;
			_heroPanel.dataProvider = groceryList;
			_heroPanel.itemRendererFactory = function _getRenderFatory():IListItemRenderer
			{
				const render:CJHeroNameItem = new CJHeroNameItem();
				render.owner = _heroPanel;
				return render;
			};
			addChild(_heroPanel);
		}
		
		
		// 获取数据
		private function _getDataArr():Array
		{
			var listData:Array = new Array();
			// 所有的tag
			var heroTagArr:Array = CJDataOfHeroTagProperty.o.heroTagArr;
			var i:int = 0;
			var data:Object;
			for (; i<heroTagArr.length; ++i)
			{
				data = {heroId: 0,
						quality:0,
						templeteid:0,
						isSelected:false,
						isUsable:false,
						weight:-i,
						index:i,
						tag:i  //该值不变，对应"CJDataOfHeroTagProperty"的json数据信息索引
				}
				listData.push(data);
			}
			
			// 开始的tag索引保存
			var openIndexArr:Array = new Array;
			// 开启的tag
			var herotagopen:Array = CJDataManager.o.DataOfHeroTag.herotaglist;
			for(i=0; i<herotagopen.length; ++i)
			{
				// 开启的索引
				var openIndex:int = int(herotagopen[i]);
				data = listData[openIndex];
				data.isUsable = true;
				data.weight = 0;
				openIndexArr.push(openIndex);
			}
			
			// 将有武将的开启
			i = 0;
			var heroDict:Dictionary = CJDataManager.o.DataOfHeroList.herolist;
			for each (var heroData:CJDataOfHero in heroDict)
			{
				var temp:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(int(heroData.templateid));
				
				var fightValue:int = _heroFightValue[heroData.heroid].battleeffect;
				
				data = listData[openIndexArr[i]];
				Assert(data!=null, "CJHeroNameLayer._getDataArr  data!=null");
				if (data == null)
					continue;
				data.heroId = heroData.heroid;
				data.quality = int(heroData.heroProperty.quality);
				data.templeteid = heroData.templateid;
				data.weight = int(fightValue); // 为排序故将武将权重变化
				data.isUsable = true;
				data.heroname = CJLang(temp.name);
				if (temp.type == ConstPlayer.SConstPlayerTypePlayer)
				{
					data.weight = 0xFFFFFFFF; // 主角权重值最高
					data.heroname = CJDataManager.o.DataOfRole.name;
					data.isSelected = true;
				}
				i++;
			}
			
			// 对武将进行排序
			listData.sortOn("weight", Array.NUMERIC|Array.DESCENDING);
			// 重新对index排序
			for(i=0; i<listData.length; ++i)
			{
				listData[i].index = i;
				listData[i].name = "herotouxiang_"+i;
			}
				

			return listData;
		}
		
		/** 
		 * 更新界面
		 * @note 该函数仅对存在有效数据起作用，如不存在有效数据则直接返回
		 * */
		public function updateLayer():void
		{
			if (_heroPanel.dataProvider.data == null)
				return;
			var arr:Array = _getDataArr();
			for(var i:int=0; i<arr.length; ++i)
				_heroPanel.updateItem(arr[i], arr[i].index);
		}
		
		public function get dataProvider():Object
		{
			return _heroPanel.dataProvider as Object;
		}
		
		public function get turnPanel():CJTurnPage
		{
			return _heroPanel;
		}
	}
}