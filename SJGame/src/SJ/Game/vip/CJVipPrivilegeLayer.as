package SJ.Game.vip
{
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	
	import starling.events.Event;
	
	public class CJVipPrivilegeLayer extends SLayer
	{
		private var _labelTitle:Label;
		private var _bg:ImageLoader;
		/**  标题 **/
		public function get labelTitle():Label
		{
			return _labelTitle;
		}
		/** @private **/
		public function set labelTitle(value:Label):void
		{
			_labelTitle = value;
		}
		public function set bg(value:ImageLoader):void
		{
			_bg = value;
		}
		
		private var _btnClose:Button;
		/**  关闭按钮 **/
		public function get btnClose():Button
		{
			return _btnClose;
		}
		/** @private **/
		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}

		
		private var _title:CJPanelTitle;
		
		private var _panel:CJVipHPanel;
		
		
		public function CJVipPrivilegeLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			width = SApplicationConfig.o.stageWidth;
			height = SApplicationConfig.o.stageHeight;

			
			// 水平显示面板
			_panel = new CJVipHPanel;
			addChild(_panel);
			_panel.x = 0;
			_panel.y = 20;
			
			
			
			// 标题
			_title = new CJPanelTitle(CJLang("vip_title"));
			addChild(_title);
			_title.x = labelTitle.x;
			_title.y = labelTitle.y;
			
			_bg.scaleX = 1.125;
			_bg.x = -24;
			
			// 关闭按钮
			btnClose.addEventListener(Event.TRIGGERED, function(e:Event):void{
				SApplication.moduleManager.exitModule("CJVipPrivilegeModule");
			});
			addChild(btnClose);
		}
		
	}
}