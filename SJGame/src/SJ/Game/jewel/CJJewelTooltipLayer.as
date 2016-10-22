package SJ.Game.jewel
{
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 宝石镶嵌tooltip临时层
	 * @author sangxu
	 * 
	 */	
	public class CJJewelTooltipLayer extends SLayer
	{
		
		public function CJJewelTooltipLayer()
		{
			super();
		}
		
		/** 道具id */
		private var _itemId:String = "";
		
		
		override protected function initialize():void
		{
			super.initialize();
			
//			this._initData();
			
			this._initControls();
			
		}
		
		
		/**
		 * 初始化数据
		 * 
		 */
		private function _initData():void
		{
			
		}
		
		
		private function _initControls():void
		{
//			this.x = 0;
//			this.y = 0;
			this.width = 226;
			this.height = 185;
			
			// 关闭按钮
			this.btnClose = new Button();
			this.btnClose.x = 230;
			this.btnClose.y = -18;
			this.btnClose.width = 28;
			this.btnClose.height = 28;
			this.btnClose.defaultSkin  = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			this.btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			this.addChild(btnClose);
			this.btnClose.addEventListener(starling.events.Event.TRIGGERED, _onBtnCloseClick);
			
			// 背景
			var texture:Texture = SApplication.assets.getTexture("common_tanchukuang");
			var bgScaleRange:Rectangle = new Rectangle(10, 10, 3, 3);
			var bgTexture:Scale9Textures = new Scale9Textures(texture, bgScaleRange);
			this._bgImage = new Scale9Image(bgTexture);
			bgImage.width = 226;
			bgImage.height = 185;
			this.addChildAt(bgImage, 0);
			
			// 
			this._btnDo = new Button();
			this._btnDo.x = 100;
			this._btnDo.y = 100;
			this._btnDo.width = 100;
			this._btnDo.height = 18;
			this._btnDo.defaultSkin  = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			this._btnDo.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			this._btnDo.label  = "镶嵌";
			this.addChild(this._btnDo);
			
			
			
			// 设置关闭按钮深度
			this.setChildIndex(this.btnClose, this.numChildren - 1);
		}
		
		/**
		 * 按钮点击处理 - 关闭按钮
		 * @param event
		 * 
		 */		
		private function _onBtnCloseClick(event:Event) : void
		{
			this.removeFromParent();
		}
		
		public function setDoButtonListener(_funcDo:Function):void
		{
			this._btnDo.addEventListener(Event.TRIGGERED, _funcDo);
		}
		
		/**
		 * 关闭按钮
		 */		
		private var _btnClose : Button;
		private var _btnDo:Button;
		
		/**
		 * 背景图片
		 */		
		private var _bgImage : Scale9Image;

		
		public function get btnClose():Button
		{ 
			return _btnClose;
		}
		public function get bgImage():Scale9Image
		{
			return this._bgImage;
		}
		/**
		 * 控件setter
		 */	
		public function set btnClose (value:Button):void 
		{ 
			_btnClose = value;
		}
	}
}