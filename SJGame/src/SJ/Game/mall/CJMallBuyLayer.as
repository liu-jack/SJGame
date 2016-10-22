package SJ.Game.mall
{
	import SJ.Common.Constants.ConstCurrency;
	import SJ.Common.Constants.ConstMall;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_mall;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.bag.CJBagItem;
	import SJ.Game.controls.CJButtonUtil;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfMall;
	import SJ.Game.data.CJDataOfMallItem;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.utils.SCompileUtils;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	import engine_starling.utils.STween;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	/**
	 * 商城layer
	 * @author sangxu
	 * @date:2013-06-28
	 */	
	public class CJMallBuyLayer extends SLayer
	{
		public function CJMallBuyLayer(dataMallItem:CJDataOfMallItem)
		{
			super();
			_dataMallItem = dataMallItem;
		}
		
		/** datas */
		/** 数据 - 角色数据 */
		private var _dataRole:CJDataOfRole;
		/** 数据 - 商城数据 */
		private var _dataMall:CJDataOfMall;
		/** 数据 - 单独商城数据 */
		private var _dataMallItem:CJDataOfMallItem;
		
		/** 配置数据 - 道具配置表 */
		private var _itemProperty:CJDataOfItemProperty;
		/** 道具模板数据 */
		private var _itemTemplate:Json_item_setting;
		
		/** 数据 - 背包 */
		private var _dataBag:CJDataOfBag;
		
		/** 图标按钮组 */
		private var _btnVec:Vector.<Button>;
		
		/** 物品显示层宽高 */
		private const _operatLayerWidth:int = 208;
		private const _operatLayerHeight:int = 184;
		
		private const _maxCount:int = 99;
		
		/** 关闭回调 */
		private var _funcClose:Function;
		
		/** 警告信息弹框 */
		private var _alertLayer:CJMallNotEnoughPriceLayer;
		private var _btnSure:Button;
		private var _btnCancel:Button;
		private var _labCount:Label;
		private var _labSum:Label;
		private var _btnSub:Button;
		private var _btnAdd:Button;
		private var _btnMax:Button;
		private var _btnBuy:Button;
		private var _infoLayer:SLayer;
//		private var _btnClose:Button;
		
		/** 背景 */
		private var _quad:Quad;
		
		override protected function initialize():void
		{
			super.initialize();
			
			this._initData();
			
			this._initControls();
			
			this._addDataLiteners();
			
			this._initDraw();
		}
		
		/**
		 * 添加事件监听
		 * 
		 */		
		private function _addDataLiteners():void
		{
			// 监听RPC结果
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
		}
		
		/**
		 * 初始绘制
		 * 
		 */		
		private function _initDraw():void
		{
			
		}
		
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{	
			width = SApplicationConfig.o.stageWidth;;
			height = SApplicationConfig.o.stageHeight;
			
			_quad = new Quad(SApplicationConfig.o.stageWidth, SApplicationConfig.o.stageHeight);
			_quad.alpha = 0;
			_quad.width = width;
			_quad.height = height;
			_quad.addEventListener(starling.events.TouchEvent.TOUCH, _onClickQuad);
			this.addChild(_quad);
			
			_infoLayer = new SLayer();
			_infoLayer.width = _operatLayerWidth;
			_infoLayer.height = _operatLayerHeight;
			_infoLayer.x = (width - _infoLayer.width) / 2;
			_infoLayer.y = (height - _infoLayer.height) / 2;
			this.addChild(_infoLayer);
			
			var texture:Texture;
			var optIdx:int = 0;
			
			// 背景遮罩图
			var imgOptBgKuang:Scale9Image;
			texture = SApplication.assets.getTexture("common_tankuangdi");
			imgOptBgKuang = new Scale9Image(new Scale9Textures(texture, new Rectangle(19,19,1,1)));
			imgOptBgKuang.x = 0;
			imgOptBgKuang.y = 0;
			imgOptBgKuang.width = _operatLayerWidth;
			imgOptBgKuang.height = _operatLayerHeight;
			this._infoLayer.addChildAt(imgOptBgKuang, optIdx++);
			
			var imgKuangNei:Scale9Image;
			texture = SApplication.assets.getTexture("common_tankuangwenzidi");
			imgKuangNei = new Scale9Image(new Scale9Textures(texture, new Rectangle(11, 11, 1, 1)));
			imgKuangNei.x = 5;
			imgKuangNei.y = 25;
			imgKuangNei.width = 197;
			imgKuangNei.height = 155;
			this._infoLayer.addChildAt(imgKuangNei, optIdx++);
			
			// 关闭按钮
//			this.btnClose = new Button();
//			this.btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
//			this.btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
//			this.btnClose.width = 35;
//			this.btnClose.height = 35;
//			this.btnClose.x = 190;
//			this.btnClose.y = -14;
//			this.btnClose.addEventListener(starling.events.Event.TRIGGERED, _onBtnClickClose);
//			this._infoLayer.addChild(this.btnClose);
			
			// 图标
			var bagItem:CJBagItem = new CJBagItem();
			bagItem.x = 11;
			bagItem.y = 32;
			bagItem.width = 100;
			bagItem.height = 100;
			bagItem.setBagGoodsItem(_itemTemplate.picture);
			this._infoLayer.addChild(bagItem);
			
			// 文字 - 标题
			var labTitle:Label = new Label();
			labTitle.x = 79;
			labTitle.y = 5;
			labTitle.width = 52;
			labTitle.height = 16;
			labTitle.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xFFf960, null, null, null, null, null, TextFormatAlign.CENTER);
			labTitle.textRendererFactory = this._getTextRender;
			labTitle.text = CJLang("MALL_BUY_TITLE");
			this._infoLayer.addChild(labTitle);
			
			// 道具名称
			var labItemName:Label = new Label();
			labItemName.x = 73;
			labItemName.y = 35;
			labItemName.width = 100;
			labItemName.height = 13;
			labItemName.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 11, 0xFFF99E, null, null, null, null, null, TextFormatAlign.LEFT);
			labItemName.text = CJLang(_itemTemplate.itemname);
			this._infoLayer.addChild(labItemName);
			
			// 道具描述
			var labDesc:Label = new Label();
			labDesc.x = 73;
			labDesc.y = 53;
			labDesc.height = 35;
			labDesc.width = 124;
			labDesc.textRendererProperties.wordWrap = true;
			labDesc.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.LEFT);
			labDesc.text = CJLang(this._itemTemplate.description);
			this._infoLayer.addChild(labDesc);
			
			var tfText:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xBAFF69, null, null, null, null, null, TextFormatAlign.LEFT);
			// 文字 - 购买数量
			var labBuyCount:Label = new Label();
			labBuyCount.x = 22;
			labBuyCount.y = 95;
			labBuyCount.width = 45;
			labBuyCount.height = 13;
			labBuyCount.textRendererProperties.textFormat = tfText;
			labBuyCount.text = CJLang("MALL_BUY_COUNT");
			this._infoLayer.addChild(labBuyCount);
			
			// 购买数量背景
			texture = SApplication.assets.getTexture("common_fanyeyemawenzidi");
			var imgCountBg:Scale9Image = new Scale9Image(new Scale9Textures(texture, new Rectangle(5, 5, 1, 1)));
			imgCountBg.x = 72;
			imgCountBg.y = 93;
			imgCountBg.width = 58;
			imgCountBg.height = 19;
			this._infoLayer.addChild(imgCountBg);
			
			// 购买数量
			_labCount = new Label();
			_labCount.x = 72;
			_labCount.y = 95;
			_labCount.width = 58;
			_labCount.height = 19;
			_labCount.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
			_labCount.text = "1";
			this._infoLayer.addChild(_labCount);
			
			// 按钮 - 减号
			_btnSub = new Button();
			_btnSub.x = 138;
			_btnSub.y = 89;
			_btnSub.width = 24;
			_btnSub.height = 24;
			_btnSub.defaultSkin = new SImage(SApplication.assets.getTexture("common_jiananniu"));
			_btnSub.addEventListener(Event.TRIGGERED, _onBtnCllickSub);
			this._infoLayer.addChild(_btnSub);
			
			// 按钮 - 加号
			_btnSub = new Button();
			_btnSub.x = 170;
			_btnSub.y = 89;
			_btnSub.width = 24;
			_btnSub.height = 24;
			_btnSub.defaultSkin = new SImage(SApplication.assets.getTexture("common_jiaanniu"));
			_btnSub.addEventListener(Event.TRIGGERED, _onBtnCllickAdd);
			this._infoLayer.addChild(_btnSub);
			
			// 文字 - 购买总价
			var labBuySum:Label = new Label();
			labBuySum.x = 22;
			labBuySum.y = 129;
			labBuySum.width = 45;
			labBuySum.height = 13;
			labBuySum.textRendererProperties.textFormat = tfText;
			labBuySum.text = CJLang("MALL_BUY_PRICE");
			this._infoLayer.addChild(labBuySum);
			
			// 购买总价
			_labSum = new Label();
			_labSum.x = 72;
			_labSum.y = 129;
			_labSum.width = 58;
			_labSum.height = 19;
			_labSum.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFF264, null, null, null, null, null, TextFormatAlign.CENTER);
			_labSum.text = String(_dataMallItem.price);
			this._infoLayer.addChild(_labSum);
			
			// 图片 - 元宝
			if (_dataMallItem.pricetype == ConstCurrency.CURRENCY_TYPE_GOLD)
			{
				var imgGold:SImage = new SImage(SApplication.assets.getTexture("common_yuanbao"));
				imgGold.x = 122;
				imgGold.y = 128;
				imgGold.width = 15;
				imgGold.height = 11;
				this._infoLayer.addChild(imgGold);
			}
			// 分割线
			
			_btnMax = new Button();
			_btnMax.x = 143;
			_btnMax.y = 125;
			_btnMax.width = 46;
			_btnMax.height = 18;
			_btnMax.defaultSkin = new SImage(SApplication.assets.getTexture("zq_zuidahua"));
			_btnMax.addEventListener(Event.TRIGGERED, _onBtnClickMax);
			this._infoLayer.addChild(_btnMax);
			
			// 按钮 - 购买
			_btnBuy = new Button();
			_btnBuy.width = 80;
			_btnBuy.height = 28;
			_btnBuy.x = (_infoLayer.width - _btnBuy.width) / 2;
			_btnBuy.y = 148;
			_btnBuy.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_btnBuy.defaultSelectedSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_btnBuy.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xD5CDA1, null, null, null, null, null, TextFormatAlign.CENTER);
			_btnBuy.label = CJLang("MALL_BTN_BUY");
			_btnBuy.addEventListener(Event.TRIGGERED, _onBtnClickBuy);
			this._infoLayer.addChild(_btnBuy);
			
			_btnClose = new Button();
			_btnClose.defaultSkin  = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			_btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			_btnClose.width = 46;
			_btnClose.height = 45;
			_btnClose.x = _infoLayer.width - 23;
			_btnClose.y = - 18;
			_btnClose.addEventListener(Event.TRIGGERED, _onClickClose);
			this._infoLayer.addChild(_btnClose);
		}
		/**
		 * 点击关闭按钮
		 * @param e
		 * 
		 */		
		private function _onClickClose(e:Event):void
		{
			this._closeLayer();
		}
		
		/**
		 * 点击事件响应 - 背景
		 * @param event
		 * 
		 */		
		private function _onClickQuad(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this._quad, TouchPhase.BEGAN);
			if (!touch)
			{
				return;
			}
			this._closeLayer();
		}
		
		/**
		 * 按钮点击处理 - MAX
		 * @param event
		 * 
		 */
		private function _onBtnClickMax(event:Event):void
		{
			var canBuyCount:int = 0;
			var showMaxCount:int = _maxCount;
			if (_dataMallItem.pricetype == ConstCurrency.CURRENCY_TYPE_GOLD)
			{
				canBuyCount = int(_dataRole.gold / _dataMallItem.price);
			}
			else if (_dataMallItem.pricetype == ConstCurrency.CURRENCY_TYPE_CREDIT)
			{
				canBuyCount = int(_dataRole.credit / _dataMallItem.price);
			}
			if (canBuyCount <= 0)
			{
				canBuyCount = 1;
			}
			
			if (canBuyCount < _maxCount)
			{
				showMaxCount = canBuyCount;
			}
			_labCount.text = String(showMaxCount);
			_redrawPrice();
		}
		/**
		 * 按钮点击处理 - 减
		 * @param event
		 * 
		 */
		private function _onBtnCllickSub(event:Event):void
		{
			var count:int = int(_labCount.text);
			if (count <= 1)
			{
				return;
			}
			count -= 1;
			_labCount.text = String(count);
			_redrawPrice();
		}
		/**
		 * 按钮点击处理 - 加
		 * @param event
		 * 
		 */
		private function _onBtnCllickAdd(event:Event):void
		{
			var count:int = int(_labCount.text);
			if (count >= _maxCount)
			{
				return;
			}
			count += 1;
			_labCount.text = String(count);
			_redrawPrice();
		}
		/**
		 * 按钮点击处理 - 购买
		 * @param event
		 * 
		 */
		private function _onBtnClickBuy(event:Event):void
		{
			var count:int = int(_labCount.text);
			this._buyMallItem(_dataMallItem, count);
		}
		
		/**
		 * 重绘价格
		 * 
		 */		
		private function _redrawPrice():void
		{
			_labSum.text = String(_dataMallItem.price * int(_labCount.text));
		}
		
		/**
		 * 购买商城道具
		 * @param mallItem	商城道具数据CJDataOfMallItem
		 * @param count	购买数量
		 * 
		 */		
		private function _buyMallItem(mallItem:CJDataOfMallItem, count:int = 1):void
		{
			if (mallItem.pricetype == ConstCurrency.CURRENCY_TYPE_GOLD)
			{
				// 元宝
				if (this._dataRole.gold < (mallItem.price * count))
				{
					// 弹出元宝不足提示框
					this._showGoldNotEnough();
					return;
				}
			}
			else if (mallItem.pricetype == ConstCurrency.CURRENCY_TYPE_CREDIT)
			{
				// 声望
				if (this._dataRole.credit < mallItem.price)
				{
					// 弹出声望不足提示框
					this._showCreditNotEnough();
					return;
				}
			}
			else
			{
				Assert(false, "Mall item price error!!! Price type is " + mallItem.pricetype);
				return;
			}
			
			var canPutInBag:Boolean = CJItemUtil.canPutItemInBag(this._dataBag, mallItem.itemid, count);
			if (false == canPutInBag)
			{
				// 提示背包空间不足
				CJMessageBox(CJLang("MALL_ALERT_BAGNOTGRID"));
				return;
			}
			// 向服务端发送购买商城道具申请
			SocketCommand_mall.buyitem(mallItem.id, count);
		}
		
		/**
		 * 提示元宝不足
		 * 
		 */		
		private function _showGoldNotEnough():void
		{
			// 元宝不足
			// 字体 - 按钮
//			var tfBtn:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xFFEFBD, null, null, null, null, null, TextFormatAlign.CENTER);
			
			_alertLayer = new CJMallNotEnoughPriceLayer();
			_alertLayer.text = CJLang("MALL_ALERT_YUANBAO");
			CJLayerManager.o.addModuleLayer(_alertLayer);
			
			// 充值
			_btnSure = CJButtonUtil.createCommonButton(CJLang("MALL_ALERT_BTN_RECHARGE"));
			_btnSure.addEventListener(Event.TRIGGERED, _onBtnClickAlertSure);
			_btnSure.x = 20;
			_btnSure.y = 80;
			_btnSure.labelOffsetY = -2;
//			_btnSure.visible = !SCompileUtils.o.isOnVerify();
//			btnSure.defaultLabelProperties.textForma = tfBtn;
			_alertLayer.addButton(_btnSure);
			
			
			// 取消
			_btnCancel = CJButtonUtil.createCommonButton(CJLang("COMMON_CANCEL"));
			_btnCancel.addEventListener(Event.TRIGGERED, _onBtnClickAlertCancel);
//			_btnCancel.x = SCompileUtils.o.isOnVerify() ? 70 : 120;
			_btnCancel.x = 120;
			_btnCancel.y = 80;
			_btnCancel.labelOffsetY = -2;
//			btnCancel.defaultLabelProperties.textForma = tfBtn;
			_alertLayer.addButton(_btnCancel);
			
		}
		
		/**
		 * 提示声望不足 
		 * 
		 */		
		private function _showCreditNotEnough():void
		{
			// 声望不足
			_alertLayer = new CJMallNotEnoughPriceLayer();
			_alertLayer.text = CJLang("MALL_ALERT_SHENGWANG");
			
			CJLayerManager.o.addModuleLayer(_alertLayer);
			
			_btnSure = CJButtonUtil.createCommonButton(CJLang("COMMON_TRUE"));
			_btnSure.addEventListener(Event.TRIGGERED, _onBtnClickAlertCancel);
			_btnSure.x = 76;
			_btnSure.y = 80;
			_btnSure.labelOffsetY = -2;
			_alertLayer.addButton(_btnSure);
			
		}
		
		/**
		 * 按钮点击事件响应 - 货币不足提示框充值按钮
		 * 
		 */		
		private function _onBtnClickAlertSure(event:Event):void
		{
			_alertLayer.removeFromParent(true);
			// 退出商城模块
			SApplication.moduleManager.exitModule("CJMallModule");
			// 进入充值模块
			SApplication.moduleManager.enterModule("CJRechargeModule");
		}
		
		/**
		 * 按钮点击事件响应 - 货币不足提示框取消按钮
		 * 
		 */		
		private function _onBtnClickAlertCancel(event:Event):void
		{
			_alertLayer.removeFromParent(true);
		}
		
		override public function dispose():void
		{
			_removeAllEventListener();
			
			super.dispose();
		}
		
		/**
		 * 移除所有监听
		 * 
		 */		
		private function _removeAllEventListener():void
		{
			if (_btnSure != null)
			{
				_btnSure.removeEventListener(Event.TRIGGERED, _onBtnClickAlertSure);
				_btnSure = null;
			}
			
			if (_btnCancel != null)
			{
				_btnCancel.removeEventListener(Event.TRIGGERED, _onBtnClickAlertCancel);
				_btnCancel = null;
			}
			
			if (_alertLayer != null)
			{
				_alertLayer = null;
			}
		}
		/**
		 * 按钮点击 - 关闭
		 * @param event
		 * 
		 */		
		private function _onBtnClickClose(event:Event):void
		{
			//退出模块
//			this.removeFromParent(true);
			_closeLayer();
		}
		
		/**
		 * 初始化数据
		 * 
		 */		
		private function _initData():void
		{
			// 角色数据
			_dataRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole;
			// 商城数据
			this._dataMall = CJDataManager.o.getData("CJDataOfMall") as CJDataOfMall;
			
			// 背包数据
			this._dataBag = CJDataManager.o.getData("CJDataOfBag") as CJDataOfBag;
			// 所有道具配置数据
			_itemProperty = CJDataOfItemProperty.o;
			// 当前道具配置数据
			_itemTemplate = _itemProperty.getTemplate(_dataMallItem.itemid);
		}
		
		/**
		 * RPC返回响应
		 * @param e
		 * 
		 */		
		private function _onRpcReturn(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage;
			if (msg.getCommand() == ConstNetCommand.CS_MALL_BUYITEM)
			{
				// 购买商城道具
//				this.removeFromParent(true);
				_closeLayer();
			}
		}
		
		
		/**
		 * 飘字
		 * @param str 飘字内容
		 * 
		 */		
		private function _showPiaozi(str:String):void
		{
			var seccessLabel:Label = new Label();
			seccessLabel.text = str;
			seccessLabel.textRendererProperties.textFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
			seccessLabel.x = 0;
			seccessLabel.y = (SApplicationConfig.o.stageHeight - seccessLabel.height) / 2 - this.y;
			seccessLabel.width = SApplicationConfig.o.stageWidth;
			var textTween:STween = new STween(seccessLabel, 2, Transitions.LINEAR);
			textTween.moveTo(seccessLabel.x, seccessLabel.y- 50);
			
			textTween.onComplete = function():void
			{
				Starling.juggler.remove(textTween);
				seccessLabel.removeFromParent(true);
			}
			this.addChild(seccessLabel);
			Starling.juggler.add(textTween);
		}
		
		/**
		 * 描边 - 卷积，发光
		 */
		private function _getTextRender():ITextRenderer
		{
			var _htmltextRender:TextFieldTextRendererEx;
			_htmltextRender = new TextFieldTextRendererEx()
			_htmltextRender.isHTML = true;
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			
			_htmltextRender.nativeFilters = [new ConvolutionFilter(3,3,matrix,3) , new GlowFilter(0x000000,1.0,2.0,2.0,5,2)];
			return _htmltextRender;
		}
		
		/**
		 * 移除所有事件监听
		 * 
		 */		
		public function removeAllEventListener():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);

		}
		
		/**
		 * 关闭
		 * 
		 */		
		private function _closeLayer():void
		{
			this.removeFromParent(true);
			if (_funcClose != null)
			{
				_funcClose();
			}
		}
		
		/**
		 * 设置关闭回调方法
		 * @param func
		 * 
		 */		
		public function setCloseFunction(func:Function):void
		{
			_funcClose = func;
		}
		
		/** controls */
		/** 按钮 - 关闭 */
		private var _btnClose:Button;
		
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