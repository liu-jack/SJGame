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
	 * 装备强化layer
	 * @author sangxu
	 * 
	 */	
	public class CJMoneyTreeHarvestLayer extends SLayer
	{
		public function CJMoneyTreeHarvestLayer()
		{
			super();
		}
		
		/** datas */
		/** 数据 - 摇钱树配置数据 */
		private var _moneyTreeConfig:CJDataOfMoneyTreeProperty;
		/** 数据 - 玩家数据 */
		private var _dataRole:CJDataOfRole;
		
		private var _operateLayer:CJMoneyTreeHarvestOperate;
		
		/** 是否是VIP */
		private var _isVip:Boolean;
		
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
			this._dataRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole;
			if (this._dataRole.vipLevel > 0)
			{
				this._isVip = true;
			}
			else
			{
				this._isVip = false;
			}
		}
		
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
			this.width = 233;
			this.height = 223;
			
			var texture:Texture;
			// 边框
			var imgBiankuang:Scale9Image;
			texture = SApplication.assets.getTexture("common_tankuangdi");
			var bkScaleRange:Rectangle = new Rectangle(19,19,1,1);
			var bkTexture:Scale9Textures = new Scale9Textures(texture, bkScaleRange);
			imgBiankuang = new Scale9Image(bkTexture);
			imgBiankuang.x = 17;
			imgBiankuang.y = 15;
			imgBiankuang.width = 202;
			imgBiankuang.height = this._isVip ? 160 : 196;
			this.addChild(imgBiankuang);
			
			// 关闭按钮
			this.btnClose = new Button();
			this.btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			this.btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			this.btnClose.width = 35;
			this.btnClose.height = 35;
			this.btnClose.x = 200;
			this.btnClose.y = 2;
			//为关闭按钮添加监听
			this.btnClose.addEventListener(starling.events.Event.TRIGGERED, _onBtnClickClose);
			this.addChild(this.btnClose);
			
			// 操作层
			this._operateLayer = new CJMoneyTreeHarvestOperate();
			this._operateLayer.x = 17;
			this._operateLayer.y = 15;
			this._operateLayer.width = 200;
			this._operateLayer.height = this._isVip ? 158 : 193;
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
		
		
		
		
		
		/**
		 * 接收到服务器端数据
		 * @param e
		 * 
		 */		
		private function _onDataLoaded(e:Event):void
		{
//			if (e.target is CJDataOfHeroList)
//			{
//				this._dataHeroListInit = true;
//				this._onDataLoadedHeroList();
//			}
//			this._redraw();
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