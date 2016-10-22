package SJ.Game.task
{
	import SJ.Common.Constants.ConstTask;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfTask;
	import SJ.Game.data.CJDataOfTaskList;
	import SJ.Game.formation.CJTurnPage;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.display.Shape;
	
	/**
	 +------------------------------------------------------------------------------
	 * 任务列表面板
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-2 下午8:43:14  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskDetailPanel extends SLayer
	{
		/*滑动区域宽/高*/
		private const WIDTH:int = 417;
		private const HEIGHT:int = 291;
		/*任务列表数据*/
		private var _taskList:CJDataOfTaskList;
		//背景
		private var _bgWrap:Scale9Image;
		private var _initType:String;
		private var _bg:Scale9Image;
		
		private var _turnPage:CJTurnPage;
		
		public function CJTaskDetailPanel()
		{
			super();
			this._taskList = CJDataManager.o.DataOfTaskList;
			_turnPage = new CJTurnPage(3);
		}
		
		override protected function initialize():void
		{
			this._drawContent();
			this._initData();
			super.initialize();
		}
		
		/**
		 * 更新内容界面
		 * @param type : canaccept | accepted
		 */		
		public function updateContent(type:String):void
		{
			var taskDic:Dictionary = new Dictionary();
			if(type == "canaccept")
			{
				taskDic = this._taskList.getCanAcceptTaskList();
				this._turnPage.dataProvider = this._createDataList(taskDic);
			}
			else if(type == "accepted")
			{
				taskDic = this._getUIAcceptedTaskList();
				this._turnPage.dataProvider = this._createDataList(taskDic);
			}
			else
			{
				Assert(false , "界面更新类型错误")
			}
		}
		
		/**
		 * 获取UI界面需要的已接任务列表数据
		 */		
		private function _getUIAcceptedTaskList():Dictionary
		{
			var taskDic:Dictionary = new Dictionary();
			var allTask:Dictionary = this._taskList.getData(CJDataOfTaskList.DATA_KEY);
			for(var taskid:String in allTask)
			{
				var task:CJDataOfTask = allTask[taskid];
				if(int(task.status) >= ConstTask.TASK_ACCEPTED && int(task.status) < ConstTask.TASK_REWARDED)
				{
					taskDic[taskid] = task;
				}
			}
			return taskDic;
		}
		
		private function _drawContent():void
		{
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(409 , 282);
			bgBall.x = 5;
			bgBall.y = 5;
			this.addChildAt(bgBall , 0 );
			
			//底框
			this._bgWrap = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangnew") , new Rectangle(15 , 15 , 1, 1)));
			this._bgWrap.width = 419;
			this._bgWrap.height = 292;
			this.addChildAt(this._bgWrap , 0);
			
			var mask:Shape = new Shape();
			mask.graphics.beginFill(0x000000 , 0.5);
			mask.graphics.drawRoundRect(0 , 0 , 419 , 292 , 0.1);
			mask.graphics.endFill();
			this.addChildAt(mask , 0 );
			
			//底
			this._bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew") , new Rectangle(1 ,1 , 1, 1)));
			this._bg.width = 419;
			this._bg.height = 292;
			this.addChildAt(this._bg , 0);
			
			this.addChild(_turnPage);
			this._turnPage.setRect(WIDTH , HEIGHT);
			this._turnPage.type = CJTurnPage.SCROLL_V;
		}
		
		override protected function draw():void
		{
			super.draw();
		}
		
		private function _initData():void
		{
			if(this._taskList.dataIsEmpty)
			{
				return;
			}
			else
			{
				this._doInit();
				this.updateContent(this._initType);
			}
		}
		
		private function _createDataList(taskDic:Dictionary):ListCollection
		{
			var taskList:Array = _sortTaskByType(taskDic);
			var listData:Array = new Array();
			for(var i:String in taskList)
			{
				var data:Object = {"taskid":taskList[i].taskId};
				listData.push(data);
			}
			return new ListCollection(listData);
		}
		
		/**
		 * 把任务按照类型排序
		 */		
		private function _sortTaskByType(taskDic:Dictionary):Array
		{
			var allTask:Array = new Array();
			var mainTaskArray:Array = new Array();
			var branchTaskArray:Array = new Array();
			var otherTaskArray:Array = new Array();
			for(var taskid:String in taskDic)
			{
				var task:CJDataOfTask = taskDic[taskid];
				if(task.taskConfig.tasktype == CJTaskType.TASK_MAIN)
				{
					mainTaskArray.unshift(task);
				}
				else if(task.taskConfig.tasktype == CJTaskType.TASK_BRANCH)
				{
					branchTaskArray.unshift(task);
				}
				else
				{
					otherTaskArray.unshift(task);
				}
			}
			allTask = mainTaskArray.concat(branchTaskArray).concat(otherTaskArray);
			return allTask;
		}
		
		private function _doInit():void
		{
			const listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout.gap = 8;
			listLayout.paddingLeft = 15;
			listLayout.paddingTop = 15;
			this._turnPage.layout = listLayout;
			
			var pthis:CJTurnPage = this._turnPage;
			
			this._turnPage.itemRendererFactory = function ():IListItemRenderer
			{
				const render:CJTaskItemDetail = new CJTaskItemDetail();
				render.width = 390;
				render.height = 63;
				render.owner = pthis;
				return render;
			}
		}
		
		override public function dispose():void
		{
			this._turnPage.itemRendererFactory = null;
			_turnPage = null;
			super.dispose();
		}

		public function get initType():String
		{
			return _initType;
		}

		public function set initType(value:String):void
		{
			_initType = value;
		}

	}
}