package SJ.Game.treasure
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.Constants.ConstTreasure;
	import SJ.Common.global.textRender;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfTreasureList;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.util.CJTaskLabel;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;
	import feathers.events.FeathersEventType;
	
	import flash.sampler.NewObjectSample;
	
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 +------------------------------------------------------------------------------
	 * 临时灵丸背包面板
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-31 下午5:52:05  
	 +------------------------------------------------------------------------------
	 */
	public class CJTreasureTempBagPanel extends CJTreasurePanelBase
	{
		private var _buttonPre:Button;
		private var _buttonNext:Button;
		private var _treasureList:CJDataOfTreasureList;

		private var _currentNumLabel:CJTaskLabel;
		
		private var _currentPageLabel:CJTaskLabel;
		
		private var _treasureTurnPage:CJTreasureTurnPage;
		
		public function CJTreasureTempBagPanel()
		{
			super();
			_treasureList = CJDataManager.o.DataOfTreasureList;
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_TREASURE_DATA_CHANGE , this._updateContent);
		}
		
		private function _updateContent(e:Event):void
		{
			this._updateCurrentText();
			this._updatePage();
			this._treasureTurnPage.setDataProvider();
		}
		
		override protected function draw():void
		{
			super.draw();
			this._updateCurrentText();
			this._updatePage();	
		}
		
		/**
		 * 更新背包页数
		 */		
		private function _updatePage():void
		{
			_currentPageLabel.text = ""+(_treasureTurnPage.currentPage+1)+"/"+(_treasureTurnPage.totalPage+1);
		}
		
		/**
		 * 更新当前灵丸数
		 */		
		private function _updateCurrentText():void
		{
			var currentTreasureNum:int = _treasureList.treasureTempBagList.length;
			_currentNumLabel.text = "灵丸&nbsp;"+currentTreasureNum+"/"+ConstTreasure.TREASURE_TEMP_BAG_TOTAL;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._drawContent();
			this._addEventListeners();
		}
		
		private function _addEventListeners():void
		{
			//左右翻hero列表
			this._buttonPre.addEventListener(Event.TRIGGERED , this._turnPage);
			this._buttonNext.addEventListener(Event.TRIGGERED , this._turnPage);
			this._treasureTurnPage.addEventListener(FeathersEventType.SCROLL_COMPLETE , this._updatePage);
		}
		
		private function _turnPage(e:Event):void
		{
			if(e.target is Button)
			{
				var btn:Button = e.target as Button;
				if(btn.name == "pre")
				{
					this._treasureTurnPage.prevPage();
				}
				else
				{
					this._treasureTurnPage.nextPage();
				}
			}
		}
		
		private function _drawContent():void
		{
//			左右翻页箭头
			_buttonNext = new Button();
			_buttonNext.defaultSkin = new SImage(SApplication.assets.getTexture("common_jiantou1"));
			_buttonNext.x = 434;
			_buttonNext.y = 100;
			_buttonNext.name = "next";
			this.addChild(_buttonNext);
			
			_buttonPre = new Button();
			_buttonPre.defaultSkin = new SImage(SApplication.assets.getTexture("common_jiantou1"));
			_buttonPre.scaleX = -1;
			_buttonPre.x = 35;
			_buttonPre.y = 100;
			_buttonPre.name = "pre";
			this.addChild(_buttonPre);
			
//			当前灵丸数
			_currentNumLabel = new CJTaskLabel();
			_currentNumLabel.fontColor = 0xFFDC64;
			_currentNumLabel.text = "";
			_currentNumLabel.x = 190;
			_currentNumLabel.y = 5;
			this.addChild(_currentNumLabel);
			
			var line:SImage = new SImage(SApplication.assets.getTexture("common_fengetiao"));
			line.x = 35;
			line.y = 215;
			line.width = 400;
			this.addChild(line);
			
//			中间的灵丸
			_treasureTurnPage = new CJTreasureTurnPage(ConstTreasure.TREASURE_PLACE_TEMP_BAG);
			_treasureTurnPage.type = CJTurnPage.SCROLL_H;
			_treasureTurnPage.itemPerPage = 32;
			_treasureTurnPage.x = 42;
			_treasureTurnPage.y = 28;
			_treasureTurnPage.setRect(385,190);
			this.addChild(_treasureTurnPage);
			
//			当前页面数
			_currentPageLabel = new CJTaskLabel();
			_currentPageLabel.x = 230;
			_currentPageLabel.y = 220;
			_currentPageLabel.fontColor = 0xFFDC64;
			_currentPageLabel.text = "";
			this.addChild(_currentPageLabel);
			
			
			this._updateCurrentText();
			this._updatePage();
		}
	}
}