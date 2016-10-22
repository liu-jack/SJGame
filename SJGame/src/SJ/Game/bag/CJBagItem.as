package SJ.Game.bag
{
	
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_setting;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.net.dns.AAAARecord;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.display.Shape;
	import starling.textures.Texture;

	/**
	 * @author sangxu
	 * 创建时间：Apr 3, 2013 11:57:42 AM
	 * 背包物品框单元
	 */
	public class CJBagItem extends SLayer
	{
		/** 物品框图片 */
		private var _imageFrame:Scale9Image;
		/** 物品图片 */
		private var _imageGoods:ImageLoader;
		/** 品质高亮图片 */
//		private var _qualityFrame:SImage;
		/** 道具id */
		private var _itemid:String = "";
		/** 道具数量 */
		private var _labItemCount:Label;
		/** 道具模板ID**/
		private var _itemTemplateId:int
		/** 道具模板数据 */
		private var _tmplData:Json_item_setting;
		
		private var _status:uint;
		
		/** 道具图片相对背景框图片偏移量 */
		private var _spaceXGood:int = ConstBag.BAG_ITEM_CONT_SPACEX;
		private var _spaceYGood:int = ConstBag.BAG_ITEM_CONT_SPACEY;
		/** 道具数量相对于背景框图片偏移量 */
		private var _spaceXCount:int = 33;
		private var _spaceYCount:int = 34;
		/** 框图片宽高 */
		private var _frameImgWidth:int = ConstBag.BAG_ITEM_WIDTH;
		private var _frameImgHeight:int = ConstBag.BAG_ITEM_HEIGHT;
		/** 道具图片宽高 */
		private var _goodImgWidth:int = ConstBag.BAG_ITEM_CONT_WIDTH;
		private var _goodImgHeight:int = ConstBag.BAG_ITEM_CONT_HEIGHT;
		/** 锁图片与未锁背景框纹理 */
		private var _stUnlock:Scale9Textures;
		private var _stLock:Scale9Textures;
		
		/** 索引 */
		private var _index:int = 0;
		/** 品质框 */
		private var _shapeQuality:Shape;
		/** 是否显示品质框 */
//		private var _showQualityShap:Boolean = false;
		
		public function CJBagItem(status:uint = 0)
		{
			super();
			var textureUnlock:Texture = SApplication.assets.getTexture("common_tubiaokuang1");
			var bgScaleRange:Rectangle = new Rectangle(15, 15, 1, 1);
			this._stUnlock = new Scale9Textures(textureUnlock, bgScaleRange);
			
			this._labItemCount = new Label();
			var fontFormatEquip:TextFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xffffff, null, null, null, null, null, TextFormatAlign.RIGHT);
			this._labItemCount.textRendererProperties.textFormat = fontFormatEquip;
			this._labItemCount.text = "";
			this._labItemCount.height = 10;
			this._labItemCount.width = _frameImgWidth - 7;
			this._labItemCount.visible = false;
			this._labItemCount.textRendererFactory = function():ITextRenderer
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
			width = ConstBag.BAG_ITEM_WIDTH;
			height = ConstBag.BAG_ITEM_HEIGHT;
			
			this.addChild(_labItemCount);
			
			_init(status);
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
		public function get imageGoods():ImageLoader
		{
			return _imageGoods;
		}
		
		public function set imageGoods(value:ImageLoader):void
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

		private function _init(status:uint):void
		{
			switch(status)
			{
				case ConstBag.FrameCreateStateUnlock:
					this._imageFrame = new Scale9Image(this._stUnlock);
					break;
				case ConstBag.FrameCreateStateLocked:
					this._initLockTexture();
					this._imageFrame = new Scale9Image(this._stLock);
					this._labItemCount.visible = false;
					break;
				default:
					this._imageFrame = new Scale9Image(this._stUnlock);
			}
			_status = status;
			this._imageFrame.width = _frameImgWidth;
			this._imageFrame.height = _frameImgHeight;
			addChildAt(_imageFrame, 0);
		}
		
		/**
		 * 初始化锁图片纹理
		 * 
		 */		
		private function _initLockTexture():void
		{
			if (this._stLock == null)
			{
				var textureLock:Texture = SApplication.assets.getTexture("common_tubiaokuang2")
				this._stLock = new Scale9Textures(textureLock, new Rectangle(0, 0, 0, 0));
			}
		}
		
		/**
		 *为背包物品框设置物品 
		 * 
		 */		
		public function setBagGoodsItem(imgName : String):void
		{
			var texture:Texture = SApplication.assets.getTexture(imgName);
			if (this._imageGoods == null)
			{
				if (imgName != "" && texture)
				{
					
					this._imageGoods = new ImageLoader();
					this._imageGoods.source = texture;
					this._imageGoods.x = this._imageFrame.x + this._spaceXGood;
					this._imageGoods.y = this._imageFrame.y + this._spaceYGood;
					this._imageGoods.width = this._goodImgWidth;
					this._imageGoods.height = this._goodImgHeight;
					this.addChildAt(this._imageGoods, 1);
				}
				else
				{
//					this.setQualityFrame("");
					this._labItemCount.visible = false;
					this._clearQualityRect();
				}
			}
			else
			{
				if (imgName != "" && texture)
				{
					this._imageGoods.source = texture;
				}
				else
				{
//					this.setQualityFrame("");
					this.removeChild(this._imageGoods);
					this._labItemCount.visible = false;
					this._imageGoods = null;
					this._clearQualityRect();
				}
			}
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
		public function get templData():Json_item_setting
		{
			return this._tmplData;
		}
		public function set tmplData(value:Json_item_setting):void
		{
			this._tmplData = value;
		}
		
		/**
		 * 设置品质，显示框颜色变化
		 * @param quality
		 * 
		 */		
		public function setQuality(quality:int):void
		{
			var imgName:String = "";
			var color:uint = 0;
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
			if (color > 0)
			{
				this._redrawQualityRect(color);
			}
			else
			{
				this._clearQualityRect();
			}
		}
		
//		/**
//		 * 设置品质高亮框
//		 * @param imgName	图片名
//		 * 
//		 */		
//		public function setQualityFrame(imgName:String):void
//		{
//			if (this._qualityFrame == null)
//			{
//				if (imgName != "")
//				{
//					this._qualityFrame = new SImage(SApplication.assets.getTexture(imgName));
//					this._qualityFrame.x = this._imageFrame.x + 0;
//					this._qualityFrame.y = this._imageFrame.y + 0;
//					this._qualityFrame.width = this._frameImgWidth;
//					this._qualityFrame.height = this._frameImgHeight;
//					this.addChild(this._qualityFrame);
//				}
//			}
//			else
//			{
//				if (imgName != "")
//				{
//					this._qualityFrame.texture = SApplication.assets.getTexture(imgName);
//				}
//				else
//				{
//					this.removeChild(this._qualityFrame);
//					this._qualityFrame = null;
//				}
//			}
//		}
		/**
		 * 根据道具模板id设置图片
		 * 调用此方法前需加载道具模板资源：ConstResource.sResItemSetting
		 * @param itemTmplId
		 * 
		 */		
		public function setBagGoodsItemByTmplId(itemTmplId:int, showQuality:Boolean = false):void
		{
			var itemTemplate:Json_item_setting = CJDataOfItemProperty.o.getTemplate(itemTmplId);
			
			Assert(itemTemplate != null, "Item template is null, id is:" + itemTmplId);
			
			setBagGoodsItemByTmpl(itemTemplate, showQuality);
		}
		
		/**
		 * 设置道具模板数据并显示道具图片
		 * @param itemTemplate	道具模板数据(Json_item_setting)
		 * 
		 */		
		public function setBagGoodsItemByTmpl(itemTemplate:Json_item_setting, showQuality:Boolean = false):void
		{
			if (null == itemTemplate)
			{
				return;
			}
			this._tmplData = itemTemplate;
			this._itemTemplateId = itemTemplate.id;
			this.setBagGoodsItem(this._tmplData.picture);
			
			if (true == showQuality)
			{
				this.showQuality();
			}
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
				this._shapeQuality.x = this._imageFrame.x + this._spaceXGood - 1;
				this._shapeQuality.y = this._imageFrame.y + this._spaceYGood - 1;
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
		public function setBagGoodsCount(count : String):void
		{
			this._labItemCount.text = count;
			this._labItemCount.x = _imageFrame.x;
			this._labItemCount.y = _imageFrame.y + _spaceYCount;
			this._labItemCount.visible = true;
			this.setChildIndex(this._labItemCount, this.numChildren - 1);
		}
		/**
		 *改变背包物品框的锁定或者解锁状态 
		 * 
		 */		
		public function updateFrame():void
		{
			switch(_status)
			{
				case ConstBag.FrameCreateStateUnlock:
					this._imageFrame.textures = this._stUnlock;
					break;
				case ConstBag.FrameCreateStateLocked:
					this._initLockTexture();
					this._imageFrame.textures = this._stLock;
					this._labItemCount.visible = false;
					break;
				default:
					this._imageFrame.textures = this._stUnlock;
			}
		}
	}
}