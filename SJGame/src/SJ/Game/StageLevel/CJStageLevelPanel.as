package SJ.Game.StageLevel
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstStageLevel;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfStageLevel;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.formation.CJTurnPage;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SLayer;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	
	import starling.events.Event;
	
	
	/**
	 * 主角升阶星象面板
	 * 该面板放入  青龙、白虎、朱雀、玄武 四张星图
	 * @author longtao
	 * 
	 */
	public class CJStageLevelPanel extends SLayer
	{
		private const TURN_PAGE_WIDTH:int = 361;
		private const TURN_PAGE_HEIGHT:int = 261;
		/*放置技能图标的面板*/
		private var _turnPage:CJTurnPage;// = new CJTurnPage();
		/*item 间距*/
		public const CONST_ITEM_GAP:int = 0;
		
		public function CJStageLevelPanel()
		{
			super();
		}
		
		override public function dispose():void
		{
			// 移除事件
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_STAGE_LEVEL_UPDATE_PANEL, _onUpdatePanel);
			
			super.dispose();
		}
		override protected function initialize():void
		{
			super.initialize();
			
			// 初始化数据
			/// 主角升阶信息
			var stageLevel:CJDataOfStageLevel = CJDataManager.o.DataOfStageLevel;
			if(stageLevel.dataIsEmpty)
			{
				stageLevel.addEventListener(DataEvent.DataLoadedFromRemote , _doInit);
				stageLevel.loadFromRemote();
			}
			
			_doInit();
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_STAGE_LEVEL_UPDATE_PANEL, _onUpdatePanel);
		}
		
		private function _doInit():void
		{
			/// 主角升阶信息
			var stageLevel:CJDataOfStageLevel = CJDataManager.o.DataOfStageLevel;
			if(stageLevel.dataIsEmpty)
				return;
			// 移除监听
			stageLevel.removeEventListener(DataEvent.DataLoadedFromRemote , _doInit);
			
			var listData:Array = _getDataArr();
			//设置渲染属性
			var groceryList:ListCollection = new ListCollection(listData);
			// 添加数据监听
			var listLayout:HorizontalLayout = new HorizontalLayout;
			listLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_RIGHT;// HorizontalLayout.HORIZONTAL_ALIGN_RIGHT;
			listLayout.gap = CONST_ITEM_GAP;
			if (_turnPage)
			{
				_turnPage.removeFromParent(true);
				_turnPage = null;
			}
			_turnPage = new CJTurnPage(1, CJTurnPage.SCROLL_H, true);
			_turnPage.layout = listLayout;
			_turnPage.dataProvider = groceryList;
			_turnPage.itemRendererFactory = function _getRenderFatory():IListItemRenderer
			{
				const render:CJStageLevelItem = new CJStageLevelItem();
				render.owner = _turnPage;
				return render;
			};
			_turnPage.setRect(TURN_PAGE_WIDTH , TURN_PAGE_HEIGHT);
			_turnPage.currentPage = ConstStageLevel.ConstMaxStage;
			addChild(_turnPage);
			
			this.invalidate();
			
			
			//处理指引，必须在它的信息加载完成以后，否则取不到按钮
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			
		}
		
		
		private function _getDataArr():Array
		{
			// 主角升阶信息
			var stageLevel:CJDataOfStageLevel = CJDataManager.o.DataOfStageLevel;
			// 数据
			var listData:Array = new Array();
			
			// 最大显示页数
			var pageNum:int;
			if(stageLevel.forceStar % ConstStageLevel.ConstMaxStar == 0)
				pageNum = stageLevel.forceStar / ConstStageLevel.ConstMaxStar + 1;
			else
				pageNum = Math.ceil(stageLevel.forceStar / ConstStageLevel.ConstMaxStar);
			pageNum = pageNum > ConstStageLevel.ConstMaxStage ? ConstStageLevel.ConstMaxStage : pageNum
			
			var data:Object;
			for (var i:int=0; i<pageNum; ++i)
			{
				data = {
					stageLevel:i+1	// 升阶等级
				};
				
				listData.push(data);
			}
			
			return listData;
		}
		
		// 更新面板
		private function _onUpdatePanel():void
		{
			_doInit();
		}
		
	}
}