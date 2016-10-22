package SJ.Game.mainUI
{
	import SJ.Common.Constants.ConstTask;
	import SJ.Common.global.textRender;
	import SJ.Game.controls.CJTextFormatUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfTask;
	import SJ.Game.data.CJDataOfTaskList;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.json.Json_hero_battle_propertys;
	import SJ.Game.data.json.Json_task_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.CJTaskChecker;
	import SJ.Game.task.CJTaskDirector;
	import SJ.Game.task.CJTaskEvent;
	import SJ.Game.task.CJTaskType;
	import SJ.Game.task.npcdialogdata.CJTaskActionType;
	import SJ.Game.utils.SWordsUtil;
	
	import engine_starling.Events.MouseEvent;
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	
	import flash.text.TextFormat;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	
	/**
	 +------------------------------------------------------------------------------
	 * 主场景导航组件
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-17 下午2:57:11  
	 +------------------------------------------------------------------------------
	 */
	public class CJMainNavigator extends SLayer
	{
		//当前主线任务
		private var _currentTask:CJDataOfTask;
		//NPC的头像
		private var _npcLogo:ImageLoader;
		//任务状态标志
		private var _signal:ImageLoader;
		private var _taskList:CJDataOfTaskList;
		private var _taskDesc:Label;
		private var _taskStatus:Label;
		
		public function CJMainNavigator()
		{
			super();
			_taskList = CJDataManager.o.DataOfTaskList;
			this._drawContent();
			this._addListeners();
		}
		
		private function _addListeners():void
		{
			this.mouseQuickEventEnable = true;
			this.addEventListener(MouseEvent.Event_MouseClick , this._clickHandler);
			_taskList.addEventListener(CJEvent.EVENT_TASK_DATA_CHANGE , this._setMainTask);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_SELF_PLAYER_UPLEVEL , this.invalidate);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this.currentTask = CJDataManager.o.DataOfTaskList.getCurrentMainTask();
		}
		
		override public function dispose():void
		{
			
			_taskList.removeEventListener(CJEvent.EVENT_TASK_DATA_CHANGE , this._setMainTask);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_SELF_PLAYER_UPLEVEL , this.invalidate);
			super.dispose();
		}
		
		
		private function _touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch)
			{
				new CJTaskDirector(_currentTask).navigate();
			}
		}
		
		private function _setMainTask(e:Event):void
		{
			this.currentTask = CJDataManager.o.DataOfTaskList.getCurrentMainTask();
		}
		
		private function _drawContent():void
		{
			var bg:SImage = new SImage(SApplication.assets.getTexture("zhujiemian_jiaodiankuang"));
			this.addChild(bg);
			_npcLogo = new ImageLoader();
			_npcLogo.x =  -19;
			_npcLogo.y =  -25;
			this.addChild(_npcLogo);
			_signal = new ImageLoader();
			this.addChild(_signal);
			
			_taskDesc = new Label();
			_taskDesc.textRendererFactory = textRender.htmlTextRender;
			_taskDesc.textRendererProperties.textFormat = new TextFormat("黑体" , 10 , 0x00FF00);
			_taskDesc.x = -35;
			_taskDesc.y = 58;
			this.addChild(_taskDesc);
			
			_taskStatus = new Label();
			_taskStatus.textRendererFactory = textRender.htmlTextRender;
			_taskStatus.textRendererProperties.textFormat = new TextFormat("黑体" , 10 , 0x00FF00);
			_taskStatus.x = -35;
			_taskStatus.y = 58;
			this.addChild(_taskStatus);
		}
		
		override protected function draw():void
		{
			super.draw();
			if(!_currentTask)
			{
				this._npcLogo.source = null;
				_signal.source = null;
				return;
			}
			
			//刷新任务进度
			var config:Json_task_setting = _currentTask.taskConfig;
			if(config.action1 == ConstTask.TASK_ACTION_HUNT || config.action1 == ConstTask.TASK_ACTION_TALK)
			{
				if(config.key1)
				{
					_taskDesc.text = CJLang(CJDataOfHeroPropertyList.o.getProperty(config.key1).name) + ":";
				}
			}
			_taskStatus.text = _currentTask.progress1 +"/"+_currentTask.taskConfig.value1;
			
			var width:int = SWordsUtil.getStandardTextWidth(_taskDesc.text ,new  TextFormat("黑体" , 10 , 0x00FF00));
			
			_taskDesc.x = 20 - width;
			_taskStatus.x = 20;
				
			var status:int = _currentTask.status;
			var npcid:int = 0;
			var propertys:CJDataHeroProperty;
			var resproperty:Json_hero_battle_propertys;
			//没领取
			if(status == ConstTask.TASK_CAN_ACCEPT)
			{
				if(!CJTaskChecker.isTaskCanAccept(_currentTask))
				{
					_signal.source = SApplication.assets.getTexture("common_tanhaohui");
				}
				else
				{
					_signal.source = SApplication.assets.getTexture("common_tanhao");
				}
				npcid = _currentTask.taskConfig.npcbegin;
				_signal.x = 36;
				_signal.y = 18;
				propertys = CJDataOfHeroPropertyList.o.getProperty(npcid);
				resproperty = CJDataOfHeroPropertyList.o.getBattlePropertyWithTemplateId(npcid);
				this._npcLogo.source = SApplication.assets.getTexture("touxiang_"+resproperty.texturename);
			}
			//执行中，分情况显示不同的图标
			else if(status == ConstTask.TASK_ACCEPTED)
			{
				this._setExecutingSignal();
				npcid = _currentTask.taskConfig.npcend;
				this._npcLogo.source = null;
			}
			else if(status == ConstTask.TASK_COMPLETE)
			{
				npcid = _currentTask.taskConfig.npcend;
				_signal.source = SApplication.assets.getTexture("common_wenhao");
				_signal.x = 36;
				_signal.y = 18;
				propertys = CJDataOfHeroPropertyList.o.getProperty(npcid);
				resproperty = CJDataOfHeroPropertyList.o.getBattlePropertyWithTemplateId(npcid);
				this._npcLogo.source = SApplication.assets.getTexture("touxiang_"+resproperty.texturename);
			}
		}
		
		//todo: 是否三个action都需要查 ,增加其他类型的图案
		private function _setExecutingSignal():void
		{
			var action:int = int(_currentTask.taskConfig.action1);
			_signal.x = 3;
			_signal.y = 0;
			switch (action)
			{
				case ConstTask.TASK_ACTION_ITEM_TALK:
				case ConstTask.TASK_ACTION_TALK:
					_signal.source = SApplication.assets.getTexture("common_wenhao");break;
				
				case ConstTask.TASK_ACTION_EQUIPMENT:
					_signal.source = SApplication.assets.getTexture("daohang_wujiang");break;
				
				case ConstTask.TASK_ACTION_USE_TOOL:
				case ConstTask.TASK_ACTION_COLLECTNORMAL:
				case ConstTask.TASK_ACTION_COLLECTTASK:
					_signal.source = SApplication.assets.getTexture("daohang_beibao");break;
				
				case ConstTask.TASK_ACTION_HUNT:
				case ConstTask.TASK_ACTION_PK:
					_signal.source = SApplication.assets.getTexture("daohang_zhandou");break;
				
				case ConstTask.TASK_ACTION_JOIN_CAMP:
					_signal.source = SApplication.assets.getTexture("daohang_zhenying");break;
				default : _signal.source = null;
			}
		}
		
		private function _wipeAll():void
		{
			_npcLogo.source = new Texture();
			_signal.source = new Texture();
		}
		
		public function hideStatus():void
		{
			this._taskStatus.visible = false;
			this._taskDesc.visible = false;
		}
		
		public function showStatus():void
		{
			this._taskStatus.visible = true;
			this._taskDesc.visible = true;
		}
		
		private function _clickHandler(e:Event):void
		{
			new CJTaskDirector(_currentTask).navigate();
		}
		
		public function set currentTask(value:CJDataOfTask):void
		{
			_currentTask = value;
			this.invalidate();
		}
	}
}