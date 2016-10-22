package SJ.Game.activity
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfActivity;
	import SJ.Game.data.config.CJDataOfActivityPropertyList;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.data.ListCollection;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 活跃度主界面
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-5 下午12:43:58  
	 +------------------------------------------------------------------------------
	 */
	public class CJActivityLayer extends SLayer
	{
		private var _btnClose:Button;
		/*进度条*/
		private var _activityBar:ProgressBar;
		/*进度条上的字*/
		private var _progressvalue:Label;
		/*总活跃度*/
		private var _activityscore:CJActivityScore;
		/*下面的滑动列表*/
		private var _turnPage:CJActivityActionListLayer;
		
		private var _item1:CJActivityRewardItem;
		private var _item2:CJActivityRewardItem;
		private var _item3:CJActivityRewardItem;
		private var _item4:CJActivityRewardItem;
		private var _item5:CJActivityRewardItem;
		
		public function CJActivityLayer()
		{
			super();
		}

		override protected function initialize():void
		{
			super.initialize();
			
			_btnClose.addEventListener(Event.TRIGGERED , function():void
			{
				SApplication.moduleManager.exitModule("CJActivityModule");
			});
			
			_activityBar.minimum = 0;
			_activityBar.maximum = CJDataOfActivityPropertyList.o.getTotalScore();
			
			CJDataManager.o.DataOfActivity.addEventListener(CJDataOfActivity.ACTIVITY_DATA_CHANGE , invalidate);
			
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
		}
		
		override protected function draw():void
		{
			super.draw();
			this._refreshProgressBar();
			this._refreshScore();
			this._refreshAction();
			this._refreshReward();
		}
		
		private function _refreshReward():void
		{
			for(var i:int = 1; i<= 5; i++)
			{
				(this['_item'+i] as CJActivityRewardItem).status = CJDataManager.o.DataOfActivity.getRewardStatus(i);
			}
		}
		
		private function _refreshAction():void
		{
			_turnPage.dataProvider = new ListCollection(CJDataManager.o.DataOfActivity.progressDic);
		}
		
		private function _refreshScore():void
		{
			_activityscore.score = CJDataManager.o.DataOfActivity.userScore;
		}
		
		private function _refreshProgressBar():void
		{
			var score:int = CJDataManager.o.DataOfActivity.userScore;
			var totalScore:int = CJDataOfActivityPropertyList.o.getTotalScore();
			_activityBar.value = score <= totalScore ? score : totalScore;
			
			_progressvalue.text = ""+score+"/"+totalScore;
		}
		
		override public function dispose():void
		{
			super.dispose();
			CJDataManager.o.DataOfActivity.removeEventListener(CJDataOfActivity.ACTIVITY_DATA_CHANGE , invalidate);
		}
		
		public function get btnClose():Button
		{
			return _btnClose;
		}

		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}

		public function get activityBar():ProgressBar
		{
			return _activityBar;
		}

		public function set activityBar(value:ProgressBar):void
		{
			_activityBar = value;
		}

		public function get progressvalue():Label
		{
			return _progressvalue;
		}

		public function set progressvalue(value:Label):void
		{
			_progressvalue = value;
		}

		public function get activityscore():CJActivityScore
		{
			return _activityscore;
		}

		public function set activityscore(value:CJActivityScore):void
		{
			_activityscore = value;
		}

		public function get turnPage():CJActivityActionListLayer
		{
			return _turnPage;
		}

		public function set turnPage(value:CJActivityActionListLayer):void
		{
			_turnPage = value;
		}

		public function get item1():CJActivityRewardItem
		{
			return _item1;
		}

		public function set item1(value:CJActivityRewardItem):void
		{
			_item1 = value;
		}

		public function get item2():CJActivityRewardItem
		{
			return _item2;
		}

		public function set item2(value:CJActivityRewardItem):void
		{
			_item2 = value;
		}

		public function get item3():CJActivityRewardItem
		{
			return _item3;
		}

		public function set item3(value:CJActivityRewardItem):void
		{
			_item3 = value;
		}

		public function get item4():CJActivityRewardItem
		{
			return _item4;
		}

		public function set item4(value:CJActivityRewardItem):void
		{
			_item4 = value;
		}
		
		public function get item5():CJActivityRewardItem
		{
			return _item5;
		}
		
		public function set item5(value:CJActivityRewardItem):void
		{
			_item5 = value;
		}
	}
}