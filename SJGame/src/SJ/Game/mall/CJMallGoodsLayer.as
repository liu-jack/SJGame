package SJ.Game.mall
{
	import SJ.Common.Constants.ConstCurrency;
	import SJ.Common.Constants.ConstMall;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.bag.CJBagItem;
	import SJ.Game.data.CJDataOfMallItem;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	
	import feathers.controls.Button;
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
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	/**
	 * 商城商品layer
	 * @author sangxu
	 * @date:2013-06-29
	 */	
	public class CJMallGoodsLayer extends SLayer
	{
		public function CJMallGoodsLayer()
		{
			super();
		}
		
		/** datas */
		/** 数据 - 商城道具 */
		private var _dataMallItem:CJDataOfMallItem;
		
		/** 道具模板管理器 */
		private var _itemTemplateProperty:CJDataOfItemProperty;
		/** 道具模板 */
		private var _itemTemplate:Json_item_setting;
		
		private var _select:Boolean;

		
		override protected function initialize():void
		{
			super.initialize();
			
			this._initData();
			
			this._initControls();
//			
//			this._addDataLiteners();
			
//			this._initDraw();
		}
		
		/**
		 * 按钮点击 - 购买
		 * @param event
		 * 
		 */		
		private function _onBtnClickBuy(event:Event):void
		{
			_showBuy();
		}
		
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
			// 背景
			var textureBg:Texture = SApplication.assets.getTexture("shangcheng_kuang");
			var bgScaleRange:Rectangle = new Rectangle(10, 10, 1, 1);
			var bgTexture:Scale9Textures = new Scale9Textures(textureBg, bgScaleRange);
			imgBg = new Scale9Image(bgTexture);
			imgBg.x = 0;
			imgBg.y = 0;
			imgBg.width = 126;
			imgBg.height = 62;
			imgBg.addEventListener(TouchEvent.TOUCH, _onTouchToBuy);
			this.addChild(imgBg);
			
			// 道具图片
			this.showItem = new CJBagItem();
			this.showItem.x = 7;
			this.showItem.y = 6;
			this.addChild(this.showItem);
			showItem.addEventListener(TouchEvent.TOUCH, _onTouchItem);
			
			// 字体 - 道具名
			var fontFormatName:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x000000, true);
			// 字体 - 价格
			var ffPrice:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 8, 0xCED459, null, null, null, null, null, TextFormatAlign.CENTER);
			// 字体 - 声望
			var fontFormatShengwang:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 9, 0x000000);
			// 字体 - 按钮
			var ffBtn:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 9, 0xFFFE82, true, null, null, null, null, TextFormatAlign.CENTER);
			var tfBuy:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 11, 0xFFFD52, true, null, null, null, null, TextFormatAlign.CENTER);
			// 文字 - 道具名
			this.labName = new Label();
			this.labName.x = 61;
			this.labName.y = 7;
			this.labName.width = 60;
			this.labName.height = 13;
			this.labName.textRendererProperties.textFormat = fontFormatName;
			this.labName.textRendererFactory = function():ITextRenderer
			{
				var _htmltextRender:TextFieldTextRendererEx;
				_htmltextRender = new TextFieldTextRendererEx()
				_htmltextRender.isHTML = true;
				var matrix:Array = [0,1,0,
					1,1,1,
					0,1,0];
				
				_htmltextRender.nativeFilters = [new ConvolutionFilter(3,3,matrix,3) , new GlowFilter(0xFFF0B4,1.0,2.0,2.0,5,2)];
				return _htmltextRender;
			};
			this.labName.touchable = false;
			this.addChild(this.labName);
			
			// 图片 - 道具价格背景
			var texturePrice:Texture = SApplication.assets.getTexture("shangcheng_shuzidi");
			var recPrice:Rectangle = new Rectangle(2, 2, 3, 3);
			var ttPrice:Scale9Textures = new Scale9Textures(texturePrice, recPrice);
			this.imgBgPrice = new Scale9Image(ttPrice);
			this.imgBgPrice.width = 33;
			this.imgBgPrice.height = 11;
			this.imgBgPrice.x = 64;
			this.imgBgPrice.y = 26;
			this.imgBgPrice.width = 33;
			this.imgBgPrice.height = 11;
			this.imgBgPrice.touchable = false;
			this.addChild(this.imgBgPrice);
			
			// 文字 - 道具价格
			this.labPrice = new Label();
			this.labPrice.x = 64;
			this.labPrice.y = 25;
			this.labPrice.width = 33;
			this.labPrice.height = 11;
			this.labPrice.textRendererProperties.textFormat = ffPrice;
			this.labPrice.touchable = false;
			this.addChild(this.labPrice);
			
			// 图片 - 元宝
			this.imgGold = new SImage(SApplication.assets.getTexture("common_yuanbao"));
			this.imgGold.x = 100;
			this.imgGold.y = 26;
			this.imgGold.width = 15;
			this.imgGold.height = 11;
			this.imgGold.touchable = false;
			this.addChild(this.imgGold);
			
			// 文字 - 声望
			this.labShengwang = new Label();
			this.labShengwang.x = 61;
			this.labShengwang.y = 23;
			this.labShengwang.width = 22;
			this.labShengwang.height = 11;
			this.labShengwang.textRendererProperties.textFormat = fontFormatShengwang;
			this.labShengwang.text = CJLang("MALL_SHENGWANG");
			this.labShengwang.visible = false;
			this.labShengwang.touchable = false;
			this.addChild(this.labShengwang);
			
			// 图片 - 分割线
			this.imgFenge = new SImage(SApplication.assets.getTexture("shangcheng_xian"));
			this.imgFenge.x = 60;
			this.imgFenge.y = 40;
			this.imgFenge.width = 61;
			this.imgFenge.height = 1;
			this.imgFenge.touchable = false;
			this.addChild(this.imgFenge);
			
			// 按钮 - 购买
//			this.btnBuy = new Button();
//			this.btnBuy.x = 70;
//			this.btnBuy.y = 42;
//			this.btnBuy.width = 43;
//			this.btnBuy.height = 15;
//			this.btnBuy.defaultSkin = new SImage(SApplication.assets.getTexture("shangcheng_goumaianniu01"));
//			this.btnBuy.downSkin = new SImage(SApplication.assets.getTexture("shangcheng_goumaianniu02"));
//			this.btnBuy.defaultLabelProperties.textFormat = ffBtn;
//			this.btnBuy.labelFactory = textRender.standardTextRender;
//			this.addChild(this.btnBuy);
//			this.btnBuy.addEventListener(Event.TRIGGERED, _onBtnClickBuy);
			
			this.labBuy = new Label();
			labBuy.x = 64;
			labBuy.y = 41;
			labBuy.width = 55;
			labBuy.height = 16;
			labBuy.textRendererProperties.textFormat = tfBuy;
			labBuy.textRendererFactory = function():ITextRenderer
			{
				var _htmltextRender:TextFieldTextRendererEx;
				_htmltextRender = new TextFieldTextRendererEx()
				_htmltextRender.isHTML = true;
				var matrix:Array = [0,1,0,
					1,1,1,
					0,1,0];
				
				_htmltextRender.nativeFilters = [new ConvolutionFilter(3,3,matrix,3) , new GlowFilter(0x4B2C0F,1.0,2.0,2.0,5,2)];
				return _htmltextRender;
			};
			labBuy.text = CJLang("MALL_BUY_LAB");
			labBuy.touchable = false;
			this.addChild(labBuy);
			
			// 图片 - 推荐
			this.imgTuijian = new SImage(SApplication.assets.getTexture("shangcheng_tuijian"));
			this.imgTuijian.x = 32;
			this.imgTuijian.y = 0;
			this.imgTuijian.width = 32;
			this.imgTuijian.height = 32;
			this.imgTuijian.touchable = false;
			this.addChild(this.imgTuijian);
		}
		
		/**
		 * 移除所有事件监听
		 * 
		 */		
		public function removeAllEventListener():void
		{
			this.showItem.removeEventListener(TouchEvent.TOUCH, _onTouchItem);
//			this.btnBuy.removeEventListener(Event.TRIGGERED, _onBtnClickBuy);
			labBuy.removeEventListener(TouchEvent.TOUCH, _onTouchToBuy);
		}
		
		/**
		 * 点击道具图标处理
		 * @param event
		 * 
		 */		
		private function _onTouchItem(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this.showItem, TouchPhase.BEGAN);
			if (!touch)
			{
				return;
				
			}
			// 重绘商城界面道具选中效果
			((this.parent) as CJMallOperateLayer).redrawItemSelect(_dataMallItem.id);
			// 显示道具tooltip
			this._showTooltip();
		}
		
		/**
		 * 点击当前物品
		 * @param event
		 * 
		 */		
		private function _onTouchToBuy(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this.imgBg, TouchPhase.BEGAN);
			if (!touch)
			{
				return;
				
			}
			// 重绘商城界面道具选中效果
			((this.parent) as CJMallOperateLayer).redrawItemSelect(_dataMallItem.id);
			// 显示购买弹出框
			this._showBuy();
		}
		
		/**
		 * 显示购买框
		 * 
		 */		
		private function _showBuy():void
		{
			if (this._dataMallItem != null)
			{
				((this.parent) as CJMallOperateLayer).buyMallItem(this._dataMallItem);
			}
		}
		
		/**
		 * 显示道具tooltip
		 * 
		 */		
		private function _showTooltip():void
		{
			((this.parent) as CJMallOperateLayer).showTooltip(this._itemTemplate.id);
		}
		
		/**
		 * 初始化数据
		 * 
		 */		
		private function _initData():void
		{
			// 道具模板管理器
			this._itemTemplateProperty = CJDataOfItemProperty.o;
			
		}
		
		/**
		 * 根据数据重新绘制商城道具
		 * @param data 商城道具数据CJDataOfMallItem
		 * 
		 */		
		public function redrawWithData(data:CJDataOfMallItem, vipJewelDiscount:int = 0):void
		{
			this._dataMallItem = data;
			select = false;
			if (data == null)
			{
				this.visible = false;
			}
			else
			{
				this.visible = true;
				if (this._dataMallItem.pricetype == ConstCurrency.CURRENCY_TYPE_GOLD)
				{
					// 元宝
					this.labShengwang.visible = false;
					this.imgGold.visible = true;
					this.imgBgPrice.x = 64;
					this.labPrice.x = 64;
//					this.btnBuy.label = CJLang("MALL_BTN_BUY");
					labBuy.text = CJLang("MALL_BUY_LAB");
				}
				else if (this._dataMallItem.pricetype == ConstCurrency.CURRENCY_TYPE_CREDIT)
				{
					// 声望
					this.labShengwang.visible = true;
					this.imgGold.visible = false;
					this.imgBgPrice.x = 86;
					this.labPrice.x = 86;
//					this.btnBuy.label = CJLang("MALL_BTN_EXCHANGE");
					labBuy.text = CJLang("MALL_EXCHANGE_LAB");
				}
				this._itemTemplate = this._itemTemplateProperty.getTemplate(this._dataMallItem.itemid);
				
				Assert(this._itemTemplate != null, "Item template is null, item template id is:" + this._dataMallItem.itemid);
				
				this.showItem.setBagGoodsItemByTmpl(this._itemTemplate, true);
				this.showItem.showQuality();
				this.labName.text = CJLang(this._itemTemplate.itemname);
				
				var intPrice:int = int(this._dataMallItem.price);
				if (vipJewelDiscount > 0)
				{
					if (this._dataMallItem.type == ConstMall.MALL_ITEM_TYPE_JEWEL)
					{
						intPrice = int(intPrice * ((100 - vipJewelDiscount) / 100.0));
					}
				}
				this.labPrice.text = String(intPrice);
				if (this._dataMallItem.isrecommend)
				{
					this.imgTuijian.visible = true;
				}
				else
				{
					this.imgTuijian.visible = false;
				}
			}
		}
		
		/**
		 * 卷积，发光
		 */		
		private function _getTextRender():ITextRenderer
		{
			var _htmltextRender:TextFieldTextRendererEx;
			_htmltextRender = new TextFieldTextRendererEx()
			_htmltextRender.isHTML = true;
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			
			_htmltextRender.nativeFilters = [new ConvolutionFilter(3,3,matrix,3) , new GlowFilter(0xFFF0B4,1.0,2.0,2.0,5,2)];
			return _htmltextRender;
		}
		
		/**
		 * 描边 - 卷积，发光
		 */		
		private function _getTextRenderBuy():ITextRenderer
		{
			var _htmltextRender:TextFieldTextRendererEx;
			_htmltextRender = new TextFieldTextRendererEx()
			_htmltextRender.isHTML = true;
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			
			_htmltextRender.nativeFilters = [new ConvolutionFilter(3,3,matrix,3) , new GlowFilter(0x4B2C0F,1.0,2.0,2.0,5,2)];
			return _htmltextRender;
		}
		
		
		public function set select(value:Boolean):void
		{
			this._select = value;
			_onSelect(value);
		}
		
		public function get select():Boolean
		{
			return this._select;
		}
		
		private function _onSelect(selType:Boolean):void
		{
			if (_imgSel == null)
			{
				var textureSel:Texture = SApplication.assets.getTexture("shangcheng_xuanzhong");
				var bgScaleRange:Rectangle = new Rectangle(12, 12, 1, 1);
				var bgTexture:Scale9Textures = new Scale9Textures(textureSel, bgScaleRange);
				_imgSel = new Scale9Image(bgTexture);
				_imgSel.x = 0;
				_imgSel.y = 0;
				_imgSel.width = 126;
				_imgSel.height = 62;
				_imgSel.touchable = false;
				this.addChild(_imgSel);
			}
			if (selType)
			{
				_imgSel.visible = true;
			}
			else
			{
				_imgSel.visible = false;
			}
		}
		
		public function get dataMallItem():CJDataOfMallItem
		{
			return _dataMallItem;
		}
		
		/** controls */
		/** 按钮 - 购买 */
		private var _btnBuy:Button;
		/** 道具图片 */
		private var _showItem:CJBagItem;
		/** 文字 - 道具名 */
		private var _labName:Label;
		/** 按钮 - 价格 */
		private var _btnPrice:Button;
		/** 图片 - 价格背景 */
		private var _imgBgPrice:Scale9Image;
		/** 图片 - 价格 */
		private var _labPrice:Label;
		/** 图片 - 元宝 */
		private var _imgGold:SImage;
		/** 图片 - 分割线 */
		private var _imgFenge:SImage;
		/** 文字 - 声望 */
		private var _labShengwang:Label;
		/** 图片 - 推荐 */
		private var _imgTuijian:SImage;
		/** 文字 - 购买 */
		private var _labBuy:Label;
		/** 图片 - 背景 */
		private var _imgBg:Scale9Image;
		/** 图片 - 选中 */
		private var _imgSel:Scale9Image;
		
		/** setter */
		public function set btnBuy(value:Button):void
		{
			this._btnBuy = value;
		}
		public function set showItem(value:CJBagItem):void
		{
			this._showItem = value;
		}
		public function set labName(value:Label):void
		{
			this._labName = value;
		}
		public function set imgBgPrice(value:Scale9Image):void
		{
			this._imgBgPrice = value;
		}
		public function set labPrice(value:Label):void
		{
			this._labPrice = value;
		}
		public function set imgGold(value:SImage):void
		{
			this._imgGold = value;
		}
		public function set imgFenge(value:SImage):void
		{
			this._imgFenge = value;
		}
		public function set labShengwang(value:Label):void
		{
			this._labShengwang = value;
		}
		public function set imgTuijian(value:SImage):void
		{
			this._imgTuijian = value;
		}
		public function set labBuy(value:Label):void
		{
			this._labBuy = value;
		}
		public function set imgBg(value:Scale9Image):void
		{
			this._imgBg = value;
		}
		
		/** getter */
		public function get btnBuy():Button
		{
			return this._btnBuy;
		}
		public function get showItem():CJBagItem
		{
			return this._showItem;
		}
		public function get labName():Label
		{
			return this._labName;
		}
		public function get imgBgPrice():Scale9Image
		{
			return this._imgBgPrice;
		}
		public function get labPrice():Label
		{
			return this._labPrice;
		}
		public function get imgGold():SImage
		{
			return this._imgGold;
		}
		public function get imgFenge():SImage
		{
			return this._imgFenge;
		}
		public function get labShengwang():Label
		{
			return this._labShengwang;
		}
		public function get imgTuijian():SImage
		{
			return this._imgTuijian;
		}
		public function get labBuy():Label
		{
			return this._labBuy;
		}
		public function get imgBg():Scale9Image
		{
			return this._imgBg;
		}
	}
}