package SJ.Game.task
{
	import flash.utils.Dictionary;
	
	import SJ.Common.global.textRender;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.util.CJTaskHtmlUtil;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 任务主面板
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-2 下午8:04:12  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskLayer extends SLayer
	{
		//可接按钮
		private var _btnCanaccept:Button;
		//已接按钮
		private var _btnAccepted:Button;
		//关闭按钮
		private var _btnClose:Button;
		//任务详细滑动面板
		private var _taskDetailPanel:CJTaskDetailPanel;
		
		private const BWIDTH:int = 62;
		private const SWIDTH:int = 54;
		
		private const BHEIGHT:int = 51;
		private const SHEIGHT:int = 47;
		
		public function CJTaskLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this.width = SApplicationConfig.o.stageWidth;
			this.height = SApplicationConfig.o.stageHeight;
			this._addEventListeners();
			this._drawContent();
		}
		
		override public function dispose():void
		{
			_taskDetailPanel = null;
			super.dispose();
		}
		
		
		private function _drawContent():void
		{
			var title:CJPanelTitle = new CJPanelTitle(CJLang("CHAT_RENWU"));
			this.addChild(title);
			title.x = 120;
			title.y = 5;
			
			_btnCanaccept.labelFactory = textRender.htmlTextRender;
			_btnCanaccept.label = CJLang("TASK_LABEL_ACCESS");
			_btnCanaccept.defaultSelectedSkin = new SImage( SApplication.assets.getTexture("common_xuanxiangka01"));
			_btnCanaccept.defaultSkin = new SImage( SApplication.assets.getTexture("common_xuanxiangka02"));
			
			_btnAccepted.labelFactory = textRender.htmlTextRender;
			_btnAccepted.label = CJLang("TASK_LABEL_RECEIVE");
			_btnAccepted.label = CJTaskHtmlUtil.buttonText(CJLang("TASK_LABEL_RECEIVE"));
			_btnAccepted.defaultSelectedSkin = new SImage( SApplication.assets.getTexture("common_xuanxiangka01"));
			_btnAccepted.defaultSkin = new SImage( SApplication.assets.getTexture("common_xuanxiangka02"));
			_btnCanaccept.addEventListener(Event.TRIGGERED , this._handler);
			_btnAccepted.addEventListener(Event.TRIGGERED , this._handler);
			
			this._setInitSeletedButton();
			
		}
		
		private function _setInitSeletedButton():void
		{
			var acceptedList:Dictionary = CJDataManager.o.DataOfTaskList.getUnCompleteTaskList();
			var num:int = 0;
			for(var key:String in acceptedList)
			{
				num++;
			}
			if(num == 0)
			{
				_btnCanaccept.isSelected = true;
				_recoloreButton(_btnCanaccept);
				this._taskDetailPanel.initType = _btnCanaccept.name;
			}
			else
			{
				_btnAccepted.isSelected = true;
				_recoloreButton(_btnAccepted);
				this._taskDetailPanel.initType = _btnAccepted.name;
			}
		}
		
		private function _handler(e:Event):void
		{
			if(e.target is Button)
			{
				var btn:Button = e.target as Button;
				if(btn.isSelected)
				{
					return;
				}
				
				this._recoloreButton(btn);
			}
		}
		
		private function _recoloreButton(btn:Button):void
		{
			if(btn.name == "canaccept")
			{
				_btnCanaccept.label = CJTaskHtmlUtil.buttonText(CJLang("TASK_LABEL_ACCESS"));
				_btnAccepted.label = CJLang("TASK_LABEL_RECEIVE");
				_btnCanaccept.isSelected = true;
				_btnAccepted.isSelected = false;
			}
			else if(btn.name == "accepted")
			{
				_btnCanaccept.label = CJLang("TASK_LABEL_ACCESS");
				_btnAccepted.label = CJTaskHtmlUtil.buttonText(CJLang("TASK_LABEL_RECEIVE"));
				_btnCanaccept.isSelected = false;
				_btnAccepted.isSelected = true;
			}
			_resize(_btnCanaccept);
			_resize(_btnAccepted);
			this._taskDetailPanel.updateContent(btn.name);
		}
		
		private function _resize(button:Button):void
		{
			if(button.isSelected)
			{
				button.x = 0;
				button.width = BWIDTH;
				button.height = BHEIGHT;
			}
			else
			{
				button.x = 8;
				button.width = SWIDTH;
				button.height = SHEIGHT;
			}
		}
		
		private function _addEventListeners():void
		{
			this._btnClose.addEventListener(Event.TRIGGERED , this._closePanel);
		}
		
		private function _closePanel(e:Event):void
		{
			SApplication.moduleManager.exitModule("CJTaskModule");
		}
		
		public function get btnCanaccept():Button
		{
			return _btnCanaccept;
		}

		public function set btnCanaccept(value:Button):void
		{
			_btnCanaccept = value;
		}

		public function get btnAccepted():Button
		{
			return _btnAccepted;
		}

		public function set btnAccepted(value:Button):void
		{
			_btnAccepted = value;
		}

		public function get btnClose():Button
		{
			return _btnClose;
		}

		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}

		public function get taskDetailPanel():CJTaskDetailPanel
		{
			return _taskDetailPanel;
		}

		public function set taskDetailPanel(value:CJTaskDetailPanel):void
		{
			_taskDetailPanel = value;
		}
	}
}