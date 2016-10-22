package SJ.Game.randombox
{
	
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	import engine_starling.utils.AssetManagerUtil;
	
	import feathers.controls.Label;
	import feathers.core.ITextRenderer;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.core.Starling;
	import starling.display.Shape;
	import starling.textures.Texture;

	/**
	 * @author sangxu
	 * @date   2013-09-10
	 * 随机宝箱 - 宝箱中道具
	 */
	public class CJRandomBoxItem extends SLayer
	{
		/** 道具id */
		private var _itemid:String = "";
		/** 道具模板ID**/
		private var _itemTemplateId:int
		/** 道具模板数据 */
		private var _tmplData:Json_item_setting;
		
		private var _status:uint;
		
		/** 图片名 - 锁 */
		private static var _ttLockName:String = "kaibaoxiang_tubiaosuo"
		
		/** 道具图片相对背景框图片偏移量 */
		private static var _spaceXGood:int = 13;
		private static var _spaceYGood:int = 13;
		/** 道具数量相对于背景框图片偏移量 */
//		private static var _spaceXCount:int = 33;
		private static var _spaceYCount:int = 45;
		/** 框图片宽高 */
		private static var _frameImgWidth:int = 69;
		private static var _frameImgHeight:int = 69;
		/** 道具图片宽高 */
		private static var _goodImgWidth:int = 44;
		private static var _goodImgHeight:int = 44;
		/** 锁图片宽高 */
		private static var _imgLockWidth:int = 34;
		private static var _imgLockHeight:int = 40;
		
		/** Controls */
		/** 图片 - 背景框 */
		private var _imgBg:SImage;
		/** 图片 - 物品 */
		private var _imageGoods:SImage;
		/** 道具数量 */
		private var _labItemCount:Label;
		/** 道具名 */
		private var _labItemName:Label;
		
		/** 索引 */
		private var _index:int = 0;
		/** 品质框 */
		private var _shapeQuality:Shape;
		
		private var _animStar:SAnimate;
		
		public function CJRandomBoxItem()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			width = _frameImgWidth;
			height = _frameImgHeight;
			
			// 背景
			var ttBg:Texture = SApplication.assets.getTexture("kaibaoxiang_tubiaodi");
			_imgBg = new SImage(ttBg);
			_imgBg.width = width;
			_imgBg.height = height;
			this.addChild(_imgBg);
			
			// 图标
			this._imageGoods = new SImage(SApplication.assets.getTexture(_ttLockName));
//			this._imageGoods.x = this._imgBg.x + _spaceXGood;
//			this._imageGoods.y = this._imgBg.y + _spaceYGood;
//			this._imageGoods.width = _goodImgWidth;
//			this._imageGoods.height = _goodImgHeight;
			this.addChildAt(this._imageGoods, 1);
			this.setLock();
			
			this._labItemCount = new Label();
			var fontFormatEquip:TextFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 9, 0xffffff, null, null, null, null, null, TextFormatAlign.RIGHT);
			this._labItemCount.textRendererProperties.textFormat = fontFormatEquip;
			this._labItemCount.text = "";
			this._labItemCount.height = 10;
			this._labItemCount.width = _frameImgWidth - 15;
			this._labItemCount.visible = false;
			
			this.addChild(_labItemCount);
			
			var animObject:Object = AssetManagerUtil.o.getObject("anim_xiangqiankaikong");
			this._animStar = SAnimate.SAnimateFromAnimJsonObject(animObject);
			this._animStar.x = 0;
			this._animStar.y = 0;
			this._animStar.loop = true;
			this._animStar.width = this.width;
			this._animStar.height = this.height;
			this._animStar.touchable = false;
			this.addChild(this._animStar);
			Starling.juggler.add(_animStar);
			this._animStar.gotoAndPlay();
			this._animStar.currentFrame = int(Math.random() * 9);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			Starling.juggler.remove(_animStar);
		}
		
		
		
		/**
		 *为背包物品框设置物品 
		 * 
		 */		
		public function setBagGoodsItem(imgName : String):void
		{
			var texture:Texture = SApplication.assets.getTexture(imgName);
			
			
			if (texture != null)
			{
				this._imageGoods.texture = texture;
				this._imageGoods.visible = true;
				this._imageGoods.readjustSize();
			}
			else
			{
				this._imageGoods.visible = false;
			}
			
			this._imageGoods.x = this._imgBg.x + _spaceXGood;
			this._imageGoods.y = this._imgBg.y + _spaceYGood;
			this._imageGoods.width = _goodImgWidth;
			this._imageGoods.height = _goodImgHeight;
			
			this._status = ConstBag.FrameCreateStateUnlock;
		}
		
		/**
		 * 锁
		 * 
		 */		
		public function setLock():void
		{
			this._imageGoods.texture = SApplication.assets.getTexture(_ttLockName);
			this._imageGoods.visible = true;
			
			this._imageGoods.x = (this._imgBg.width - _imgLockWidth) / 2 + 2;
			this._imageGoods.y = (this._imgBg.height - _imgLockHeight) / 2;
			this._imageGoods.width = _imgLockWidth;
			this._imageGoods.height = _imgLockHeight;
			
			this._status = ConstBag.FrameCreateStateLocked;
		}
		
		/**
		 * 显示品质框，根据道具模板信息
		 * 
		 */		
		public function showQuality():void
		{
			if (this._tmplData != null)
			{
				this.setQuality(this._tmplData.quality);
			}
		}
		
		/**
		 * 设置品质，显示框颜色变化
		 * @param quality
		 * 
		 */		
		public function setQuality(quality:int):void
		{
			var imgName:String = "";
			var color:int = this._getQualityColor(quality);
			if (color > 0)
			{
				this._redrawQualityRect(color);
			}
			else
			{
				this._clearQualityRect();
			}
		}
		
		/**
		 * 根据道具模板id设置图片
		 * 调用此方法前需加载道具模板资源：ConstResource.sResItemSetting
		 * @param itemTmplId
		 * 
		 */		
		public function setItemByTmplId(itemTmplId:int, showQuality:Boolean = false):void
		{
			var itemTemplate:Json_item_setting = CJDataOfItemProperty.o.getTemplate(itemTmplId);
			
			Assert(itemTemplate != null, "Item template is null, id is:" + itemTmplId);
			
			setItemByTmpl(itemTemplate, showQuality);
		}
		
		/**
		 * 设置道具模板数据并显示道具图片
		 * @param itemTemplate	道具模板数据(Json_item_setting)
		 * 
		 */		
		public function setItemByTmpl(itemTemplate:Json_item_setting, showQuality:Boolean = false):void
		{
			this._tmplData = itemTemplate;
			this._itemTemplateId = itemTemplate.id;
			this.setBagGoodsItem(this._tmplData.picture);
			this.setBagGoodsName(itemTemplate);
			if (true == showQuality)
			{
				this.showQuality();
			}
		}
		
		/**
		 * 设置道具名
		 * @param itemTemplate
		 * 
		 */		
		public function setBagGoodsName(itemTemplate:Json_item_setting):void
		{
			if (null == this._labItemName)
			{
				this._labItemName = new Label();
				this._labItemName.textRendererProperties.textFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x000000, null, null, null, null, null, TextFormatAlign.CENTER);
				this._labItemName.height = 10;
				this._labItemName.width = _frameImgWidth;
				this._labItemName.x = 0;
				this._labItemName.y = 60;
				this.addChild(this._labItemName);
			}
			this._labItemName.visible = true;
			this._labItemName.text = CJLang(itemTemplate.itemname);
			var color:int = _getQualityColor(itemTemplate.quality);
			this._labItemName.textRendererProperties.textFormat.color = color;
			this._labItemName.textRendererFactory = function():ITextRenderer
			{
				var _htmltextRender:TextFieldTextRendererEx;
				_htmltextRender = new TextFieldTextRendererEx()
				_htmltextRender.isHTML = true;
				var matrix:Array = [0,1,0,
					1,1,1,
					0,1,0];
				
				_htmltextRender.nativeFilters = [new ConvolutionFilter(3,3,matrix,3) , new GlowFilter(0x000000,1.0,2.0,2.0,5,2)];
				return _htmltextRender;
			};
		}
		
		private function _getQualityColor(quality:int):int
		{
			var color:int = 0;
			switch(quality)
			{
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_GREEN:
					color = ConstTextFormat.TEXT_COLOR_GREEN;
					break;
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_BLUE:
					color = ConstTextFormat.TEXT_COLOR_BLUE;
					break;
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_PURPLE:
					color = ConstTextFormat.TEXT_COLOR_PURPLE;
					break;
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_ORANGE:
					color = ConstTextFormat.TEXT_COLOR_ORANGE;
					break;
				case ConstItem.SCONST_ITEM_QUALITY_TYPE_RED:
					color = ConstTextFormat.TEXT_COLOR_RED;
					break;
			}
			return color;
		}
		
		/**
		 * 绘制品质框
		 * 
		 */		
		private function _redrawQualityRect(color:uint):void
		{
			if (_shapeQuality == null)
			{
				this._shapeQuality = new Shape();
				this._shapeQuality.x = this._imgBg.x + _spaceXGood - 1;
				this._shapeQuality.y = this._imgBg.y + _spaceYGood - 1;
				this.addChild(this._shapeQuality);
			}
			this._shapeQuality.graphics.beginFill(color , 0);
			this._shapeQuality.graphics.lineStyle(1 , color);
			this._shapeQuality.graphics.drawRoundRect(0 , 0 , 45 , 45 , 1);
			this._shapeQuality.graphics.endFill();
		}
		
		/**
		 * 清除道具品质框
		 * 
		 */		
		private function _clearQualityRect():void
		{
			if (_shapeQuality != null)
			{
				this.removeChild(this._shapeQuality);
				this._shapeQuality = null;
			}
		}
		
		/**
		 *  模板ID
		 * @return 
		 * 
		 */
		public function get templateId():int
		{
			return this._itemTemplateId
		}
		/**
		 * 设置道具数量
		 * 不显示数量，不要调用此方法
		 * @param count
		 * 
		 */		
		public function setCount(count : int):void
		{
			this._labItemCount.text = String(count);
			this._labItemCount.x = _imgBg.x;
			this._labItemCount.y = _imgBg.y + _spaceYCount;
			this._labItemCount.visible = true;
			this.setChildIndex(this._labItemCount, this.numChildren - 1);
		}
		
		/**
		 * _status为ConstBag.FrameCreateStateUnlock时，创建解锁物品框，否则创建加锁物品框
		 */
		public function get status():uint
		{
			return _status;
		}
		
		public function set status(value:uint):void
		{
			_status = value;
		}
		/**
		 * 物品图片
		 * 
		 */		
		public function get imageGoods():SImage
		{
			return _imageGoods;
		}
		
		public function set imageGoods(value:SImage):void
		{
			_imageGoods = value;
		}
		
		/**
		 * 道具id
		 * @return 
		 * 
		 */		
		public function get itemId():String
		{
			return _itemid;
		}
		
		public function set itemId(value:String):void
		{
			_itemid = value;
		}
		/**
		 * 索引
		 * @return 
		 * 
		 */		
		public function get index():int
		{
			return _index;
		}
		public function set index(value:int):void
		{
			_index = value;
		}
		
		/**
		 * 清除道具id
		 * 
		 */		
		public function clearItemId():void
		{
			_itemid = "";
		}
	}
}