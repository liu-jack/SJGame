package SJ.Game.moneytree
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfMoneyTreeProperty;
	
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
	 * 摇钱树成长内容layer
	 * @author sangxu
	 * 
	 */	
	public class CJMoneyTreeChengZhangLayer extends SLayer
	{
		public function CJMoneyTreeChengZhangLayer()
		{
			super();
		}
		
		/** datas */
		/** 数据 - 摇钱树配置数据 */
		private var _moneyTreeConfig:CJDataOfMoneyTreeProperty;
		/** 数据 - 玩家数据 */
//		private var _dataRole:CJDataOfRole;
		
		private var _operateLayer:CJMoneyTreeChengZhangOperate;
		
		
		override protected function initialize():void
		{
			super.initialize();
			
			this._initData();
			
			this._initControls();
			
		}
		
		/**
		 * 初始化数据
		 * 
		 */		
		private function _initData():void
		{

		}
		
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
			this.width = 410;
			this.height = 212;
			
			var texture:Texture;
			// 边框
			var imgBiankuang:Scale9Image;
			texture = SApplication.assets.getTexture("common_tiptankuang");
			var bkScaleRange:Rectangle = new Rectangle(4, 4, 1, 1);
			var bkTexture:Scale9Textures = new Scale9Textures(texture, bkScaleRange);
			imgBiankuang = new Scale9Image(bkTexture);
			imgBiankuang.x = 0;
			imgBiankuang.y = 0;
			imgBiankuang.width = 410;
			imgBiankuang.height = 212;
			this.addChild(imgBiankuang);
			
			// 关闭按钮
			this.btnClose = new Button();
			this.btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			this.btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			this.btnClose.width = 35;
			this.btnClose.height = 35;
			this.btnClose.x = 392;
			this.btnClose.y = -14;
			//为关闭按钮添加监听
			this.btnClose.addEventListener(starling.events.Event.TRIGGERED, _onBtnClickClose);
			this.addChild(this.btnClose);
			
			// 操作层
			this._operateLayer = new CJMoneyTreeChengZhangOperate();
			this._operateLayer.x = 0;
			this._operateLayer.y = 0;
			this._operateLayer.width = 200;
			this._operateLayer.height = 186;
			this.addChild(this._operateLayer);
			
			this.setChildIndex(btnClose, this.numChildren - 1);
		}
		
		/**
		 * 按钮点击 - 关闭
		 * @param event
		 * 
		 */		
		private function _onBtnClickClose(event:Event):void
		{
			this._removeAllEventListener();
			this.removeFromParent();
		}
		
		/**
		 * 移除所有监听事件
		 * 
		 */		
		private function _removeAllEventListener():void
		{
			this._operateLayer.removeAllEventListener();
			this.btnClose.removeEventListener(starling.events.Event.TRIGGERED, _onBtnClickClose);
		}
		
		/** controls */
		/** 按钮 - 关闭 */
		private var _btnClose:Button
		
		/** setter */
		public function set btnClose(value:Button):void
		{
			this._btnClose = value;
		}
		
		/** getter */
		public function get btnClose():Button
		{
			return this._btnClose;
		}
	}
}