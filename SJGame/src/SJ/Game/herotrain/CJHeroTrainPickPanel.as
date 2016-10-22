package SJ.Game.herotrain
{
	import SJ.Common.Constants.ConstHeroTrain;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_heroTrain;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfHeroTrain;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfUpgradeProperty;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SLayer;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import flash.utils.Dictionary;
	
	import starling.events.Event;
	
	/**
	 * 训练列表
	 * @author longtao
	 * 
	 */
	public class CJHeroTrainPickPanel extends SLayer
	{
		/** 每页最大个数 **/
		private const CONST_ITEM_PERPAGE_COUNT:int = 10;
		/** item之间间隙 **/
		private const CONST_ITEM_GAP:int = 0;
		
		
		/** 翻页栏 **/
		private var _turnPage:CJTurnPage = new CJTurnPage(6);
		
		public function CJHeroTrainPickPanel(width:int, height:int)
		{
			super();
			this.width = width;
			this.height = height;
		}
		
		override protected function initialize():void
		{
			_drawContent();
			//添加事件
			_addListeners();
			_initData();
			super.initialize();
		}
		
		private function _drawContent():void
		{
			addChild(_turnPage);
		}
		
		private function _addListeners():void
		{
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			super.dispose();
		}
		
		
		private function _initData():void
		{
			// 添加数据监听
			var listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_RIGHT;
			listLayout.gap = CONST_ITEM_GAP;
			_turnPage.layout = listLayout;
			_turnPage.itemRendererFactory =  function _getRenderFatory():IListItemRenderer
			{
				const render:CJHeroTrainPickItem = new CJHeroTrainPickItem();
				render.owner = _turnPage;
				return render;
			};
				
			_turnPage.setRect(width, 198);
			addChild(_turnPage);
		}
		
//		private function _onloadcomplete(e:Event):void
//		{
//			var message:SocketMessage = e.data as SocketMessage;
//			if(message.getCommand() != ConstNetCommand.CS_HERO_TRAIN_GET_INFO)
//				return;
//			if(message.retcode != 0)
//				return;
//			
//			// 添加数据监听
//			var listLayout:VerticalLayout = new VerticalLayout();
//			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
//			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_RIGHT;
//			listLayout.gap = CONST_ITEM_GAP;
//			_turnPage.layout = listLayout;
//			_turnPage.itemRendererFactory = _getRenderFatory;
//			_turnPage.setRect(width, 200);
//			addChild(_turnPage);
//			
//			updateLayer();
//		}
		
		// 获取数据
		private function _getDataArr():Array
		{
			// 返回信息
			var listData:Array = new Array();
			// 数据信息
			var data:Object;
			// 训练中的武将
			var trainData:Object = CJDataManager.o.DataOfHeroTrain.getHroTrain();
			// 最大等级
			var maxLevel:int = int(CJDataOfGlobalConfigProperty.o.getData("HERO_MAX_LEVEL"));
			// 武将列表
			var heroDict:Dictionary = CJDataManager.o.DataOfHeroList.herolist;
			for each (var heroInfo:CJDataOfHero in heroDict)
			{
//				if (heroInfo.isRole) // 主角不可训练
//					continue;
				
				data = new Object;
				data.heroid = heroInfo.heroid;
				data.name = CJLang(heroInfo.heroProperty.name);
				data.quality = heroInfo.heroProperty.quality;
				data.level = heroInfo.level;
				// 武将状态
				if (trainData[heroInfo.heroid] != null)
					data.state = ConstHeroTrain.HERO_STATE_BUSY; //  训练中
				else
				{
					if (int(heroInfo.level) < maxLevel) // 最大等级
						data.state = ConstHeroTrain.HERO_STATE_IDLE; // 空闲中
					else
						data.state = ConstHeroTrain.HERO_STATE_FULL; // 满级
					
					// 当前经验最大值
					var maxExp:int = int(CJDataOfUpgradeProperty.o.getNeedEXP(heroInfo.level));
					// 判断该武将是否已与主将平级		只有普通武将才进行判断
					if (!heroInfo.isRole && // 不是主角
						int(heroInfo.level) >= int(CJDataManager.o.DataOfHeroList.getMainHero().level) && // 等级大于主角
						int(heroInfo.currentexp) == maxExp  ) // 经验值已达到最大
						data.state = ConstHeroTrain.HERO_STATE_LIMIT; // 不可超过主将等级(仅普通武将有该状态)
				}
				if (heroInfo.isRole)
				{
					data.name = CJDataManager.o.DataOfRole.name;
					data.isrole = 1;
				}
				else
					data.isrole = 0;
					
				// 权重值
				data.weight = data.state*1000000000 + data.isrole*100000000 + int(heroInfo.level)*100000 + int(heroInfo.templateid);
				// 训练剩余时间
				data.remaintime = uint(0);
				if (heroInfo.heroid in trainData)
					data.remaintime =  uint(trainData[heroInfo.heroid]);
				// 是否选中
				data.isSelected = false;
				
				listData.push(data);
			}
			
			// 排序
			listData.sortOn("weight", Array.NUMERIC|Array.DESCENDING);
			// 填入索引
			for ( var i:int=0; i<listData.length; ++i)
			{
				data = listData[i];
				data.index = i;
			}
			
			return listData;
		}
		
		
		
		/** 获取数据 **/
		public function get dataProvider():ListCollection
		{
			return _turnPage.dataProvider;
		}
		
		public function updateLayer():void
		{
			var listData:Array = _getDataArr();
			//设置渲染属性
			var groceryList:ListCollection = new ListCollection(listData);
			_turnPage.dataProvider = groceryList;
		}
		
		/** 更新单个item **/
		public function updateItem( index:int ):void
		{
			_turnPage.updateItemAt(index);
		}
	}
}