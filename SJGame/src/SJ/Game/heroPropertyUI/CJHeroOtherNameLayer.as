package SJ.Game.heroPropertyUI
{
	import SJ.Common.Constants.ConstPlayer;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;
	
	public class CJHeroOtherNameLayer extends SLayer
	{
		/*武将头像面板*/
		private var _heroPanel:CJTurnPage;
		
		/*初始英雄页面号*/
		private var _currentHeroPage:int = 0;
		/*英雄页面总数*/
		private var _totalHeroPage:int = 4;
		
		private const CONST_ITEM_GAP:Number = 2;
		
		// 其他玩家名称
		private var _rolename:String;
		// 数据
		private var _data:Object;
		
		public function CJHeroOtherNameLayer(rolename:String, data:Object)
		{
			super();
			
			_rolename = rolename;
			_data = data;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			_drawContent();
			// 
			_doInit();
		}
		
		private function _drawContent():void
		{
			_heroPanel = new CJTurnPage(5);
			_heroPanel.setRect(width , height);
			_heroPanel.x = 0;
			_heroPanel.y = 1;
			_heroPanel.type = CJTurnPage.SCROLL_V;
			
			_heroPanel.preButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeup01"));
			_heroPanel.preButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeup03"));
			_heroPanel.preButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeup02"));
			_heroPanel.preButton.x = 25;
			_heroPanel.preButton.y = -28;
			
			_heroPanel.nextButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeup01"));
			_heroPanel.nextButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeup03"));
			_heroPanel.nextButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeup02"));
			_heroPanel.nextButton.scaleY = -1;
			_heroPanel.nextButton.x = _heroPanel.preButton.x;
			_heroPanel.nextButton.y = height+28;
		}
		
		private function _doInit():void
		{
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
			_heroPanel.itemRendererFactory =  function ():IListItemRenderer
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
			
			// 将有武将的开启
			var i:int = 0;
			for each (var heroData:Object in _data)
			{
				var temp:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(int(heroData.templateid));
				var data:Object = {heroId: heroData.prop.heroid,
							quality: int(temp.quality),
							templeteid: heroData.templateid,
							isSelected: false,
							weight: int(heroData.battleeffect),
							name: CJLang(temp.name),
							heroname: CJLang(temp.name)
							};
				if (temp.type == ConstPlayer.SConstPlayerTypePlayer)
				{
					data.weight = 0xFFFFFFFF; // 主角权重值最高
					data.name = _rolename; // 名字 
					data.heroname = _rolename; // 名字
				}
				listData.push(data);
			}
			
			// 对武将进行排序
			listData.sortOn("weight", Array.NUMERIC|Array.DESCENDING);
			// 重新对index排序
			for(i=0; i<listData.length; ++i)
				listData[i].index = i;
			
			return listData;
		}
		
		/**
		 * 获取翻页框
		 * @return 
		 */
		public function get turnPanel():CJTurnPage
		{
			return _heroPanel as CJTurnPage;
		}
	}
}