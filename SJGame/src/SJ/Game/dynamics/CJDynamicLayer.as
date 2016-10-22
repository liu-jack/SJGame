package SJ.Game.dynamics
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 动态层
	 * @author zhengzheng
	 * 
	 */	
	public class CJDynamicLayer extends SLayer
	{
		public function CJDynamicLayer()
		{
			super();
		}
		
		/**
		 * 设置分页类型
		 * @param type
		 * 
		 */		
		public function setPageType(type:int = BTN_TYPE_DYNAMIC_SYSTEM):void
		{
			if (type in BTN_TYPES)
			{
				this._pageType = type;
			}
		}
		/** 按钮类型 */
		/** 动态好友*/
		private static const BTN_TYPE_DYNAMIC_FRIEND:int = 0;
		/** 动态雇佣*/
		private static const BTN_TYPE_DYNAMIC_GUYONG:int = 1;
		/** 动态雇佣*/
		private static const BTN_TYPE_DYNAMIC_DUOBAO:int = 2;
		/** 动态系统*/
		private static const BTN_TYPE_DYNAMIC_SYSTEM:int = 3;
		private static const BTN_TYPES:Array = [BTN_TYPE_DYNAMIC_FRIEND, 
			BTN_TYPE_DYNAMIC_GUYONG, BTN_TYPE_DYNAMIC_DUOBAO, BTN_TYPE_DYNAMIC_SYSTEM];
		
		/** 按钮 */
		private var _btnVec:Vector.<Button>;
		/** 当前按钮类型 */
		private var _currentBtnType:int = 0;
		
		/** 动态系统层 */
		private var _layerDynamicSystem:CJDynamicSystemLayer;
		/** 动态好友层 */
		private var _layerDynamicFriend:CJDynamicFriendLayer;
		/** 动态雇佣层 */
		private var _layerDynamicGuyong:CJDynamicGuyongLayer;
		/** 动态夺宝层 */
		private var _layerDynamicSnatch:CJDynamicSnatchLayer;
		/** 页面类型 */
		private var _pageType:int = 0;
		
		
		override protected function initialize():void
		{
			super.initialize();
			_initData();
			
			// 背景遮罩图
			var imgBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_quanbingdise", 1 ,1 , 1, 1);
			imgBg.width = SApplicationConfig.o.stageWidth;
			imgBg.height = SApplicationConfig.o.stageHeight;
//			imgBg.alpha = 0.7;
			this.addChildAt(imgBg, 0);
			
			// 全屏头部底
			var imgHeadBg:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			imgHeadBg.width = SApplicationConfig.o.stageWidth;
			this.addChildAt(imgHeadBg, 1);
			
			// 边角
			var imgBgcorner:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_quanpingzhuangshi", 14, 13, 1, 1);
			imgBgcorner.width = SApplicationConfig.o.stageWidth;
			imgBgcorner.height = SApplicationConfig.o.stageHeight;
			this.addChildAt(imgBgcorner, 2);
			
			//标题
			var labTitle:CJPanelTitle = new CJPanelTitle(this._getLang("DYNAMIC_DYNAMIC"));
			labTitle.x = 90;
			labTitle.y = 0;
			this.addChildAt(labTitle, 3);
			
			//操作层背景底图
			var imgOperateBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_dinew", 1 ,1 , 1, 1);
			imgOperateBg.width = this.operatLayer.width;
			imgOperateBg.height = this.operatLayer.height;
			this.operatLayer.addChild(imgOperateBg);
			
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(this.operatLayer.width - 8 , this.operatLayer.height - 8);
			bgBall.x = 4;
			bgBall.y = 4;
			this.operatLayer.addChild(bgBall);
			
			//操作层遮罩
			var imgOperateShade:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_dinewzhezhao", 40, 40,1,1);
			imgOperateShade.width = this.operatLayer.width - 20;
			imgOperateShade.height = this.operatLayer.height - 20;
			imgOperateShade.x = 10;
			imgOperateShade.y = 10;
			this.operatLayer.addChild(imgOperateShade);
			
			//操作层 - 外边框图
			var imgOutFrame:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_waikuangnew", 15 , 15 , 1, 1);
			imgOutFrame.width = this.operatLayer.width;
			imgOutFrame.height = this.operatLayer.height;
			this.operatLayer.addChild(imgOutFrame);
			
			
			this.setChildIndex(btnClose, this.numChildren - 1);
			this.setChildIndex(labTitle, this.getChildIndex(btnClose) - 1);
			
			// 页签按钮
			this._btnVec = new Vector.<Button>;
			this._btnVec.push(this.btnFriend, this.btnGuyong, this.btnDuobao, this.btnSystem);
			
			
//			this.btnGuyong.visible = false;
			
			for each (var btnTemp:Button in this._btnVec)
			{
				btnTemp.defaultSelectedSkin = this._getImgBtnSel();
				btnTemp.defaultLabelProperties.textFormat = new TextFormat("Arial", 10, 0xEDDB94);
				
				btnTemp.addEventListener(starling.events.Event.TRIGGERED, _onClickTypeBtn);
			}
			
			this._currentBtnType = _pageType;
			this._onAddOperatLayer(_pageType);
			
			// 为关闭按钮添加监听
			this._btnClose.addEventListener(starling.events.Event.TRIGGERED, function (e:*):void{
				SSoundEffectUtil.playButtonNormalSound();
				// 退出动态模块
				SApplication.moduleManager.exitModule("CJDynamicModule");
			});
			
		}
		private function _initData():void
		{
			this.btnFriend.label = this._getLang("DYNAMIC_FRIEND");
			this.btnGuyong.label = this._getLang("DYNAMIC_GUYONG");
			this.btnDuobao.label = this._getLang("DYNAMIC_SNATCH");
			this.btnSystem.label = this._getLang("DYNAMIC_SYSTEM");
		}
		private function _onClickTypeBtn(event:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			var btnType:int = -1;
			switch(event.target)
			{
				case this.btnFriend:
					btnType = BTN_TYPE_DYNAMIC_FRIEND;
					break;
				case this.btnSystem:
					btnType = BTN_TYPE_DYNAMIC_SYSTEM;
					break;
				case this.btnGuyong:
					btnType = BTN_TYPE_DYNAMIC_GUYONG;
					break;
				case this.btnDuobao:
					btnType = BTN_TYPE_DYNAMIC_DUOBAO;
					break;
			}
			if (-1 == btnType)
			{
				return;
			}
			if (btnType == this._currentBtnType)
			{
				return;
			}
			// 原按钮类型
			var oldBtnType:int = this._currentBtnType;
			// 移除现在显示信息
			this._onRemoveOperatLayer(oldBtnType);
			
			// 将当前按钮类型赋值为当前点击按钮类型
			this._currentBtnType = btnType;
			this._pageType = btnType;
			// 显示选择页签信息
			this._onAddOperatLayer(btnType);
		}
		
		/**
		 * 移除操作层内容
		 * @param type 原按钮类型
		 * 
		 */		
		private function _onRemoveOperatLayer(type:int):void
		{
			switch(type)
			{
				case BTN_TYPE_DYNAMIC_FRIEND:
					// 移除动态好友层
					this.operatLayer.removeChild(_layerDynamicFriend , true);
					break;
				case BTN_TYPE_DYNAMIC_SYSTEM:
					// 移除动态系统层
					this.operatLayer.removeChild(_layerDynamicSystem, true);
					break;
				case BTN_TYPE_DYNAMIC_GUYONG:
					// 移除动态雇佣层
					this.operatLayer.removeChild(_layerDynamicGuyong, true);
					break;
				case BTN_TYPE_DYNAMIC_DUOBAO:
					// 移除动态雇佣层
					this.operatLayer.removeChild(_layerDynamicSnatch, true);
					break;
			}
		}
		
		/**
		 * 根据按钮类型显示相应页面信息
		 * @param type 按钮类型
		 * 
		 */		
		private function _onAddOperatLayer(type:int):void
		{
			// 变更页签按钮显示
			this._changeButton(type);
			
			switch(type)
			{
				case BTN_TYPE_DYNAMIC_FRIEND:
					this._onEnterFriendLayer();
					break;
				case BTN_TYPE_DYNAMIC_SYSTEM:
					this._onEnterSystemLayer();
					break;
				case BTN_TYPE_DYNAMIC_GUYONG:
					this._onEnterGuyongLayer();
					break;
				case BTN_TYPE_DYNAMIC_DUOBAO:
					this._onEnterSnatchLayer();
					break;
			}
		}
		
		/**
		 * 进入动态系统层
		 * 
		 */		
		private function _onEnterSystemLayer():void
		{
			_layerDynamicSystem = new CJDynamicSystemLayer();
			this._addOperation(_layerDynamicSystem);
		}
		
		/**
		 * 进入动态好友层
		 * 
		 */		
		private function _onEnterFriendLayer():void
		{
			_layerDynamicFriend = new CJDynamicFriendLayer();
			this._addOperation(_layerDynamicFriend);
		}
		/**
		 * 进入动态雇佣层
		 * 
		 */		
		private function _onEnterGuyongLayer():void
		{
			_layerDynamicGuyong = new CJDynamicGuyongLayer();
			this._addOperation(_layerDynamicGuyong);
		}
		/**
		 * 进入动态夺宝层
		 * 
		 */		
		private function _onEnterSnatchLayer():void
		{
			_layerDynamicSnatch = new CJDynamicSnatchLayer();
			this._addOperation(_layerDynamicSnatch);
		}
		/**
		 * 向操作层添加layer, 将显示于关闭按钮下方
		 * @param layer
		 * 
		 */		
		private function _addOperation(layer:SLayer):void
		{
			this.operatLayer.addChild(layer);
			this.setChildIndex(this.btnClose, this.numChildren - 1);
		}
		
		/**
		 * 功能按钮显示变更
		 * 
		 */		
		private function _changeButton(buttonType:int):void
		{
			for(var i:uint = 0; i < this._btnVec.length; i++)
			{
				if (buttonType == i)
				{
					// 选中
					this._btnVec[i].isSelected = true;
					this._btnVec[i].width = 62;
					this._btnVec[i].height = 47;
					this._btnVec[i].x = 0;
					this._btnVec[i].defaultLabelProperties.textFormat = new TextFormat("Arial", 12, 0xFDC68B );
				}
				else
				{
					// 未选中
					this._btnVec[i].isSelected = false;
					this._btnVec[i].width = 55;
					this._btnVec[i].height = 42;
					this._btnVec[i].x = 8;
					this._btnVec[i].defaultLabelProperties.textFormat = new TextFormat("Arial", 10, 0xF7E399 );
				}
			}
		}
		
		/**
		 * 获取按钮选中图片
		 * @return 
		 * 
		 */		
		private function _getImgBtnSel():SImage
		{
			return new SImage(SApplication.assets.getTexture("common_xuanxiangka01"))
		}
		
		
		/**
		 * 获取语言表对应语言
		 * @param langKey
		 * @return 
		 * 
		 */		
		private function _getLang(langKey:String) : String
		{
			return CJLang(langKey);
		}
		
		/** 系统按钮 */
		private var _btnSystem:Button;
		/** 好友按钮 */
		private var _btnFriend:Button;
		/** 雇佣按钮 */
		private var _btnGuyong:Button;
		/** 夺宝按钮 */
		private var _btnDuobao:Button;
		/** 关闭按钮 */
		private var _btnClose:Button;
		/** 操作界面层 */
		private var _operatLayer:SLayer;
		
		public function set btnClose(value:Button):void
		{
			this._btnClose = value;
		}
		public function set operatLayer(value:SLayer):void
		{
			this._operatLayer = value;
		}
		
		public function get btnClose():Button
		{
			return this._btnClose;
		}
		public function get operatLayer():SLayer
		{
			return this._operatLayer;
		}

		public function get btnSystem():Button
		{
			return _btnSystem;
		}

		public function set btnSystem(value:Button):void
		{
			_btnSystem = value;
		}

		public function get btnGuyong():Button
		{
			return _btnGuyong;
		}
		
		public function set btnGuyong(value:Button):void
		{
			_btnGuyong = value;
		}
		
		public function get btnDuobao():Button
		{
			return _btnDuobao;
		}
		
		public function set btnDuobao(value:Button):void
		{
			_btnDuobao = value;
		}
		
		public function get btnFriend():Button
		{
			return _btnFriend;
		}

		public function set btnFriend(value:Button):void
		{
			_btnFriend = value;
		}
	}
}