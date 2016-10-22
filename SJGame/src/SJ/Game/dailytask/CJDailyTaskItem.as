package SJ.Game.dailytask
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_dailyTask;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfDailyTaskPropertyList;
	import SJ.Game.data.config.CJDataOfFubenProperty;
	import SJ.Game.data.config.CJDataOfGuankaProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_daily_task_setting;
	import SJ.Game.data.json.Json_fuben_config;
	import SJ.Game.data.json.Json_fuben_guanka_config;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJPanelMessageBox;
	import SJ.Game.task.util.CJTaskHtmlUtil;
	import SJ.Game.task.util.CJTaskLabel;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 每日任务单个item
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-10-16 下午5:58:49  
	 +------------------------------------------------------------------------------
	 */
	public class CJDailyTaskItem extends SLayer
	{
		private var _dailyTaskid:int;
		private var _taskData:Object;
		/*状态BUTTON ，接受 ， 立即完成 ， 领取奖励*/
		private var button:Button;
		private var _navigateButton:Button;
		private var _config:Json_daily_task_setting;
		private var _taskLabelName:CJTaskLabel;
		private var labelProgress:CJTaskLabel;
		private var labelReward:CJTaskLabel;
		private var _star:CJDailyTaskStar;
		
		public function CJDailyTaskItem()
		{
			super();
		}
		
		override public function dispose():void
		{
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
			button.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniu03new"));
			button.width = 80;
			button.height = 25;
			button.x = 365;
			button.y = 31;
			button.labelOffsetY = 0;
			this.addChild(button);
			var fontFormat:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xffffff);
			button.defaultLabelProperties.textFormat = fontFormat;
			button.addEventListener(Event.TRIGGERED , this._triggerHandler);
			
			//各个label
			_taskLabelName = new CJTaskLabel();
			_taskLabelName.fontFamily = "黑体";
			_taskLabelName.fontSize = 10;
			_taskLabelName.x = 13;
			_taskLabelName.y = 7;
			this.addChild(_taskLabelName);
			
			labelProgress = new CJTaskLabel();
			labelProgress.fontFamily = "黑体";
			labelProgress.fontSize = 10;
			labelProgress.x = 13;
			labelProgress.y = 24;
			this.addChild(labelProgress);
			
			labelReward = new CJTaskLabel();
			labelReward.fontFamily = "黑体";
			labelReward.fontSize = 10;
			labelReward.x = 13;
			labelReward.y = 40;
			this.addChild(labelReward);
			
			_star = new CJDailyTaskStar();
			_star.x = 240;
			_star.y = 7;
			this.addChild(_star);
			
			_navigateButton = new Button();
			_navigateButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_navigateButton.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_navigateButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniu03new"));
			_navigateButton.width = 80;
			_navigateButton.height = 25;
			_navigateButton.x = 365;
			_navigateButton.y = 0;
			_navigateButton.labelOffsetY = 0;
			_navigateButton.label = CJLang('DAILYTASK_CLICK_NAVIGATE');
			this.addChild(_navigateButton);
			_navigateButton.defaultLabelProperties.textFormat = fontFormat;
			_navigateButton.addEventListener(Event.TRIGGERED , this._onNaviagte);
			_navigateButton.visible = false;
		}
		
		private function _onNaviagte(e:Event):void
		{
			SApplication.moduleManager.exitModule('CJDailyTaskModule');
			CJEventDispatcher.o.dispatchEventWith(CJEvent.Event_Task_GuideNpc , false , {"npcid":_config.conditionkey , 'gid':_config.extkey});
		}
		
		/**
		 * 点击按钮
		 */		
		private function _triggerHandler(e:Event):void
		{
			var status:int = this._taskData['status'];
			if(status == CJDailyTaskEventKey.DAILYTASK_CAN_ACCEPT)
			{
				SocketCommand_dailyTask.accept(this._dailyTaskid);
				
//				如果是打怪，需要导航
				if(_config.dailytaskkey == 'hunt')
				{
					SApplication.moduleManager.exitModule('CJDailyTaskModule');
					CJEventDispatcher.o.dispatchEventWith(CJEvent.Event_Task_GuideNpc , false , {"npcid":_config.conditionkey , 'gid':_config.extkey});
				}
			}
			//已接
			else if(status == CJDailyTaskEventKey.DAILYTASK_ACCEPTED)
			{
				//已经完成领取奖励
				if(CJDataManager.o.DataOfDailyTask.isDailyTaskCompleted(this._taskData['dailytaskid']))
				{
					//判断背包是否已满
//					if(!CJItemUtil.canPutItemInBag(CJDataManager.o.DataOfBag , _config.additem , 1))
//					{
//						CJMessageBox(CJLang("BAG_HAS_NOT_ENOUGH_GRID"));
//						return;
//					}
					SocketCommand_dailyTask.reward(this._dailyTaskid);
				}
				//没有完成，立即完成
				else
				{
					var needGold:Number = _config.imdcompletegold;
					var gold:Number = CJDataOfRole(CJDataManager.o.getData("CJDataOfRole")).gold;
					if(gold < needGold)
					{
						CJPanelMessageBox(CJLang("ITEM_MAKE_RESULT_STATE_LACK_GOLD"));
					}
					else
					{
						CJConfirmMessageBox(CJLang('DAILYTASK_IMDCOMPLETEGOLD' , {'value':needGold}) , function():void
						{
							SocketCommand_dailyTask.imdComplete(_dailyTaskid);
						});
					}
				}
			}
		}
		
		/**
		 * 名称
		 */		
		private function _updateName():void
		{
			var type:String = "<font color='#F1C74A'>"+CJLang('DAILYTASK_RI')+"</font>" ;
			_taskLabelName.text = type+ CJLang(_config.dailytasktitle);
			
			//星星
			_star.starNum = _config.star;
		}
		
		/**
		 * 任务目标
		 */		
		private function _updateProgress():void
		{
			var content:String = CJTaskHtmlUtil.wipeHtmlTag(this.getTaskreplaceContent(_config));
			
			var progress:String = "";
			var total:int = _config.conditionvalue;
			var current:int = _taskData['progress'] > total ? total : _taskData['progress'];
			progress = CJTaskHtmlUtil.colorText("("+current+"/"+total+")" , "#4AFD2C");
			labelProgress.text = content +CJTaskHtmlUtil.space+progress;
		}
		
		/**
		 * 奖励
		 */		
		private function _updateReward():void
		{
			var taskAward:String = CJLang("TASK_ACCEPTED_AWORD");
			var expText:String = CJLang("COMMON_EXP") + CJTaskHtmlUtil.space+CJTaskHtmlUtil.colorText(_config.addexp , "#c1910e");
			var silverText:String = CJLang("COMMON_SILVER") + CJTaskHtmlUtil.space+CJTaskHtmlUtil.colorText(_config.addsilver , "#c1910e")+CJTaskHtmlUtil.tab;
			labelReward.text = taskAward +CJTaskHtmlUtil.space+expText+CJTaskHtmlUtil.tab+silverText;
		}
		
		/**
		 * 按钮状态
		 */ 
		private function _updateButton():void
		{
			if(!CJDataManager.o.DataOfDailyTask.isDailyTaskHasMoreChance())
			{
				_navigateButton.visible = false;
				button.visible = false;
				return;
			}
			
			button.label = "";
			var status:int = this._taskData['status'];
			if(status == CJDailyTaskEventKey.DAILYTASK_CAN_ACCEPT)
			{
				button.label = CJTaskHtmlUtil.wipeHtmlTag(CJLang("TASK_LABEL_ACCEPT"));
				button.isEnabled = true;
				_navigateButton.visible = false;
			}
			//已接
			else if(status == CJDailyTaskEventKey.DAILYTASK_ACCEPTED)
			{
				//已经完成
				if(CJDataManager.o.DataOfDailyTask.isDailyTaskCompleted(this._taskData['dailytaskid']))
				{
					button.label = CJTaskHtmlUtil.wipeHtmlTag(CJLang("TASK_REWARD"));
					_navigateButton.visible = false;
				}
				else
				{
					button.label = CJTaskHtmlUtil.wipeHtmlTag(CJLang("DAILYTASK_IMDCOMPLETE"));
				}
				button.isEnabled = true;
				
//				导航按钮
				if(_config.dailytaskkey == 'hunt')
				{
					_navigateButton.visible = true;
				}
				else
				{
					_navigateButton.visible = false;
				}
			}
			//完成
			else if(status == CJDailyTaskEventKey.DAILYTASK_REWARDED)
			{
				button.label = CJLang("activity_fail");
				button.isEnabled = false;
				_navigateButton.visible = false;
			}
		}
		
		
		//矩形框
		private function _drawRectangBg():void
		{
			//背景色
			var bg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_renwu_wenzidi") , new Rectangle(8 , 8 , 1, 1)));
			bg.width = 450;
			bg.height = 57;
			this.addChild(bg);
		}
		
		override protected function draw():void
		{
			super.draw();
			if(_config == null)
			{
				return;
			}
			const isTotalInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isTotalInvalid)
			{
				this._dailyTaskid = _taskData['dailytaskid'];
				this._updateName();
				this._updateProgress();
				this._updateReward();
				this._updateButton();
			}
		}

		public function get taskData():Object
		{
			return _taskData;
		}

		public function set taskData(value:Object):void
		{
			if(value == _taskData)
			{
				return;
			}
			_taskData = value;
			_config = CJDataOfDailyTaskPropertyList.o.getConfigById(_taskData['dailytaskid']);
			this.invalidate();
		}
		
		private function getTaskreplaceContent(taskConfig:Json_daily_task_setting):String
		{
			var content:String = CJLang(taskConfig.dailytaskdesc);
			switch(taskConfig.dailytaskkey)
			{
				case "mallbuygoods":
					var itemname:Json_item_setting = CJDataOfItemProperty.o.getTemplate(taskConfig.conditionkey);
					content = content.replace("{itemname}",CJLang(itemname.itemname));
					content = content.replace("{num}",taskConfig.conditionvalue);
					break;
				case "hunt":
					var npcid:int = taskConfig.conditionkey;
					var gid:int = taskConfig.extkey;
					//关卡ID
					var fid:int = CJDataOfFubenProperty.o.getFidByGid(gid);
					var fbConfig:Json_fuben_config = CJDataOfFubenProperty.o.getPropertyById(fid);
					var gkConfig:Json_fuben_guanka_config = CJDataOfGuankaProperty.o.getPropertyById(gid);
					var npcConfig:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(npcid);
					var fbname:String = CJLang(fbConfig.name);
					content = content.replace("{fubenname}",fbname);
					content = content.replace("{guankaname}",CJLang(gkConfig.name));
					content = content.replace("{bossname}",CJLang(npcConfig.name));
					content = content.replace("{num}",taskConfig.conditionvalue);
					break;
			}
			return content;
		}
	}
}