package SJ.Game.task
{
	import flash.geom.Rectangle;
	
	import SJ.Common.Constants.ConstTask;
	import SJ.Common.global.textRender;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfTask;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.util.CJTaskHtmlUtil;
	import SJ.Game.task.util.CJTaskLabel;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 单个任务面板
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-2 下午7:58:49  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskItemDetail extends CJItemTurnPageBase
	{
		private var _taskid:int;
		private var _task:CJDataOfTask;
		/*状态BUTTON ， 执行，接受，完成等*/
		private var button:Button;

		private var _taskLabelName:CJTaskLabel;

		private var labelProgress:CJTaskLabel;

		private var labelReward:CJTaskLabel;
		
		public function CJTaskItemDetail()
		{
			super("CJTaskItemDetail");
		}
		
		override public function dispose():void
		{
			_task = null;
			super.dispose();
		}
		
		
		override protected function initialize():void
		{
			super.initialize();
			this._drawContent();
		}
		
		private function _drawContent():void
		{
			this._drawRectangBg();
			button = new Button();
			button.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			button.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			button.width = 90;
			button.x = 290;
			button.y = 35;
			this.addChild(button);
			button.addEventListener(Event.TRIGGERED , this._triggerHandler);
			
			//各个label
			_taskLabelName = new CJTaskLabel();
			_taskLabelName.fontFamily = "宋体";
			_taskLabelName.x = 0;
			_taskLabelName.y = 3;
			this.addChild(_taskLabelName);
			
			labelProgress = new CJTaskLabel();
			_taskLabelName.fontFamily = "宋体";
			labelProgress.x = 0;
			labelProgress.y = 25;
			this.addChild(labelProgress);
			
			labelReward = new CJTaskLabel();
			_taskLabelName.fontFamily = "宋体";
			labelReward.x = 0;
			labelReward.y = 45;
			this.addChild(labelReward);
		}
		
		/**
		 * 导航
		 */		
		private function _triggerHandler(e:Event):void
		{
			new CJTaskDirector(this._task).navigate();
			SApplication.moduleManager.exitModule("CJTaskModule");
		}
		
		/**
		 * 名称
		 */		
		private function _updateName():void
		{
			var langType:String = "";
			if(this._task.taskConfig.tasktype == CJTaskType.TASK_MAIN)
			{
				langType = "TASK_TYPE_MAIN";
			}
			else if(this._task.taskConfig.tasktype == CJTaskType.TASK_BRANCH)
			{
				langType = "TASK_TYPE_BRANCH";
			}
			var type:String = CJTaskHtmlUtil.buttonText(CJLang(langType)) ;
			var taskName:String = CJLang(this._task.taskConfig.desckey+"NAME");
			
			//是否完成
			var completeText:String = "";
			//未完成
			if(this._task.status >= ConstTask.TASK_ACCEPTED && this._task.status < ConstTask.TASK_COMPLETE)
			{
				completeText = CJLang("TASK_UNCOMPLETE");
			}
			else if(this._task.isTaskComplete())
			{
				completeText = CJLang("TASK_COMPLETE");
			}
			
			_taskLabelName.text = type+taskName + CJTaskHtmlUtil.space + completeText;
		}
		
		/**
		 * 进度
		 */		
		private function _updateProgress():void
		{
			//可接，简介
			if(this._task.status == ConstTask.TASK_CAN_ACCEPT)
			{
				labelProgress.colorText(CJLang(this._task.taskConfig.desckey+"DETAIL"));
			}
			//已接受 详细
			else
			{
				//任务目标
				var content:String = CJTaskHtmlUtil.wipeHtmlTag(CJLang(this._task.taskConfig.desckey+"TARGET"));
				//进度
				if(_task.progress1 > _task.taskConfig.value1)
				{
					_task.progress1 = _task.taskConfig.value1;
				}
				var progress:String = _task.progress1 +"/"+_task.taskConfig.value1;
				if(_task.taskConfig.value2)
				{
					progress += CJTaskHtmlUtil.tab+ _task.progress2 +"/"+_task.taskConfig.value2;
				}
				if(_task.taskConfig.value3)
				{
					progress += CJTaskHtmlUtil.tab+ _task.progress3 +"/"+_task.taskConfig.value3;
				}
				
				//是否完成
				var completeText:String = "";
				//未完成
				if(this._task.status >= ConstTask.TASK_ACCEPTED && this._task.status < ConstTask.TASK_COMPLETE)
				{
					progress = CJTaskHtmlUtil.colorText(progress , "#FF0000");
				}
				else
				{
					progress = CJTaskHtmlUtil.colorText(progress , "#4AFD2C");
				}
				
				labelProgress.text = content +CJTaskHtmlUtil.space+progress;
			}
		}
		
		/**
		 * 奖励
		 */		
		private function _updateReward():void
		{
			var taskAward:String = CJLang("TASK_ACCEPTED_AWORD");
			var expText:String = CJLang("COMMON_EXP") + CJTaskHtmlUtil.space+CJTaskHtmlUtil.colorText(this._task.taskConfig.expr , "#c1910e");
			var silverText:String = CJLang("COMMON_SILVER") + CJTaskHtmlUtil.space+CJTaskHtmlUtil.colorText(this._task.taskConfig.silver , "#c1910e")+CJTaskHtmlUtil.tab;
			labelReward.text = taskAward +CJTaskHtmlUtil.space+expText+CJTaskHtmlUtil.tab+silverText;
		}
		
		private function _updateButton():void
		{
			button.visible = true;
			button.labelFactory = textRender.htmlTextRender;
			if(this._task.status == ConstTask.TASK_CAN_ACCEPT)
			{
				button.label = CJTaskHtmlUtil.colorText(CJLang("TASK_LABEL_ACCEPT") , "#ffffff");
			}
			//已接
			else if(this._task.status == ConstTask.TASK_ACCEPTED)
			{
				button.label = CJTaskHtmlUtil.colorText(CJLang("TASK_LABEL_IMPLEMENT") ,"#ffffff");
			}
			//完成
			else if(this._task.status == ConstTask.TASK_COMPLETE)
			{
				button.label = CJTaskHtmlUtil.colorText(CJLang("TASK_LABEL_COMPLETE") , "#ffffff");
			}
			else if(this._task.status == ConstTask.TASK_REWARDED)
			{
				button.visible = false;
			}
		}
		
		
		//矩形框
		private function _drawRectangBg():void
		{
			//背景色
			var bg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_renwu_wenzidi") , new Rectangle(8 , 8 , 1, 1)));
			bg.width = 390;
			bg.height = 63;
			this.addChild(bg);
		}
		
		override protected function draw():void
		{
			super.draw();
			const isTotalInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isTotalInvalid)
			{
				this._taskid = data['taskid'];
				this._task = CJDataManager.o.DataOfTaskList.getTaskById(this._taskid);
				this._updateName();
				this._updateProgress();
				this._updateReward();
				this._updateButton();
			}
		}
	}
}