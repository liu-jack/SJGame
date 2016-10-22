package SJ.Game.bag
{
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 道具tooltip层
	 * 需预先加载配置文件：
	 * 道具模板配置 : ConstResource.sResItemSetting
	 * 装备道具模板配置 : ConstResource.sResJsonItemEquipConfig
	 * 宝石道具模板配置 : ConstResource.sResJsonItemJewelConfig
	 * 战斗力系数配置 : ConstResource.sResBattleEffectSetting
	 * @author sangxu
	 * 
	 */	
	public class CJItemTooltip extends CJItemTooltipBase
	{
		/** 背景 */
		private var _quad:Quad;
		
		public function CJItemTooltip()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
//			this._initData();
//			
//			this._initControls();
//			
//			this._addListener();
		}
		
		/**
		 * 初始化数据
		 * 
		 */
		override protected function _initData():void
		{
			super._initData();
		}
		
		override protected function _initControls():void
		{
			super._initControls();
			
			// 关闭按钮
			if (btnClose == null)
			{
				this.btnClose = new Button();
				this.btnClose.x = 203;
				this.btnClose.y = -18;
				this.btnClose.defaultSkin  = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
				this.btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new")); 
				
				this._infoLayer.addChild(this.btnClose);
			}
			this.btnClose.addEventListener(Event.TRIGGERED, _onBtnCloseClick);
			// 设置关闭按钮深度
			this._infoLayer.setChildIndex(this.btnClose, this._infoLayer.numChildren - 1);
			
			_quad = new Quad(SApplicationConfig.o.stageWidth, SApplicationConfig.o.stageHeight);
			_quad.alpha = 0;
			_quad.addEventListener(starling.events.TouchEvent.TOUCH, onClickQuad);
			
			this._infoLayer.x = (SApplicationConfig.o.stageWidth - this._infoLayer.width) / 2;
			this._infoLayer.y = (SApplicationConfig.o.stageHeight - this._infoLayer.height) / 2;
//			this.x = 0;
//			this.y = 0;
			this.width = SApplicationConfig.o.stageWidth;
			this.height = SApplicationConfig.o.stageHeight;
			this.addChildAt(_quad, 0);
		}
		
		/**
		 * 点击事件响应 - 背景
		 * @param event
		 * 
		 */		
		private function onClickQuad(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this._quad, TouchPhase.BEGAN);
			if (!touch)
			{
				return;
			}
			this.closeToolTip();
		}
		
		/**
		 * 添加监听事件
		 * 
		 */		
		override protected function _addListener():void
		{
			super._addListener();
		}
		
		/**
		 * 按钮点击处理 - 关闭按钮
		 * @param event
		 * 
		 */
		private function _onBtnCloseClick(event:Event) : void
		{
			this.closeToolTip();
		}
		
		/**
		 * 移除所有事件监听
		 * 
		 */		
		override protected function removeAllEventListener():void
		{
			super.removeAllEventListener();
//			if (btnClose != null)
//			{
//				this.btnClose.removeEventListener(Event.TRIGGERED, _onBtnCloseClick);
//			}
		}
		
		/**
		 * 关闭按钮
		 */		
		private var _btnClose : Button;
		

		/**
		 * 控件 getter
		 */		
		public function get btnClose():Button
		{ 
			return _btnClose;
		}
		
		/**
		 * 控件setter
		 */
		public function set btnClose(value:Button):void 
		{ 
			_btnClose = value;
		}
	}
}