package SJ.Game.dailytask
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfDailyTask;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 活跃度主界面
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-10-2 上午10:46:06    
	 +------------------------------------------------------------------------------
	 */
	public class CJDailyTaskLayer extends SLayer
	{
		private var _btnClose:Button;
		private var _item1:CJDailyTaskItem;
		private var _item2:CJDailyTaskItem;
		private var _item3:CJDailyTaskItem;
		private var _statusItem:CJDailyTaskStatusItem;
		
		public function CJDailyTaskLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			_btnClose.addEventListener(Event.TRIGGERED , function():void
			{
				SApplication.moduleManager.exitModule("CJDailyTaskModule");
			});
			
			CJDataManager.o.DataOfDailyTask.addEventListener(CJDataOfDailyTask.DAILYTASK_DATA_CHANGE , invalidate);
			
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
		}
		
		override protected function draw():void
		{
			super.draw();
			var taskData:Array = CJDataManager.o.DataOfDailyTask.taskDic;
			if(!taskData || taskData.length == 0)
			{
				return;
			}
			for(var i:int = 0 ; i < 3 ; i++)
			{
				this["_item"+(i+1)].taskData = taskData[i];
			}
			_statusItem.invalidate();
		}
		
		override public function dispose():void
		{
			super.dispose();
			CJDataManager.o.DataOfDailyTask.removeEventListener(CJDataOfDailyTask.DAILYTASK_DATA_CHANGE , invalidate);
		}
		
		public function get btnClose():Button
		{
			return _btnClose;
		}
		
		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}

		public function get item1():CJDailyTaskItem
		{
			return _item1;
		}

		public function set item1(value:CJDailyTaskItem):void
		{
			_item1 = value;
		}

		public function get item2():CJDailyTaskItem
		{
			return _item2;
		}

		public function set item2(value:CJDailyTaskItem):void
		{
			_item2 = value;
		}

		public function get item3():CJDailyTaskItem
		{
			return _item3;
		}

		public function set item3(value:CJDailyTaskItem):void
		{
			_item3 = value;
		}

		public function get statusItem():CJDailyTaskStatusItem
		{
			return _statusItem;
		}

		public function set statusItem(value:CJDailyTaskStatusItem):void
		{
			_statusItem = value;
		}
	}
}