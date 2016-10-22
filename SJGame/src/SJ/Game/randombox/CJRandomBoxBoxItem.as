package SJ.Game.randombox
{
	
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_setting;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Label;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.display.Shape;
	import starling.textures.Texture;

	/**
	 * @author sangxu
	 * @date   2013-09-10
	 * 随机宝箱 - 宝箱中道具
	 */
	public class CJRandomBoxBoxItem extends SLayer
	{
		/** 道具id */
		private var _itemid:String = "";
		/** 道具模板ID**/
		private var _itemTemplateId:int
		/** 道具模板数据 */
		private var _tmplData:Json_item_setting;
		
		/** 道具图片相对背景框图片偏移量 */
//		private static var _spaceXGood:int = 25;
//		private static var _spaceYGood:int = 25;
		/** 道具数量相对于背景框图片偏移量 */
//		private static var _spaceXCount:int = 37;
		private static var _spaceYCount:int = 31;
		/** 框图片宽高 */
		private static var _frameImgWidth:int = 44;
		private static var _frameImgHeight:int = 44;
		/** 道具图片宽高 */
//		private static var _goodImgWidth:int = 44;
//		private static var _goodImgHeight:int = 44;
		
		/** Controls */
		/** 图片 - 物品 */
		private var _imageGoods:SImage;
		/** 道具数量 */
		private var _labItemCount:Label;
		
		/** 索引 */
		private var _index:int = 0;
		/** 品质框 */
		private var _shapeQuality:Shape;
		
		public function CJRandomBoxBoxItem(itemTmplId:int)
		{
			super();
			width = _frameImgWidth;
			height = _frameImgHeight;
			
			// 图标
//			this._imageGoods = new SImage(SApplication.assets.getTexture(_ttLockName));
//			this._imageGoods.x = 0;
//			this._imageGoods.y = 0;
//			this._imageGoods.width = width;
//			this._imageGoods.height = width;
//			this.addChildAt(this._imageGoods, 1);
			setBagGoodsItemByTmplId(itemTmplId, true);
			
			this._labItemCount = new Label();
			var fontFormatEquip:TextFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 9, 0xffffff, null, null, null, null, null, TextFormatAlign.RIGHT);
			this._labItemCount.textRendererProperties.textFormat = fontFormatEquip;
			this._labItemCount.text = "";
			this._labItemCount.height = 10;
			this._labItemCount.width = _frameImgWidth - 5;
			this._labItemCount.visible = true;
			
			this.addChild(_labItemCount);
			
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
				if (this._imageGoods == null)
				{
					// 图标
					this._imageGoods = new SImage(texture);
					this._imageGoods.x = 0;
					this._imageGoods.y = 0;
					this._imageGoods.width = width;
					this._imageGoods.height = width;
					this.addChildAt(this._imageGoods, 0);
				}
				else
				{
					this._imageGoods.texture = texture;
					this._imageGoods.visible = true;
				}
			}
			else
			{
				this._imageGoods.visible = false;
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
		 * 设置品质，显示框颜色变化
		 * @param quality
		 * 
		 */		
		public function setQuality(quality:int):void
		{
			var imgName:String = "";
			var color:int = 0;
			color = _getQualityColor(quality);
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
				this._shapeQuality.x = -1;
				this._shapeQuality.y = -1;
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
			this._labItemCount.x = _imageGoods.x;
			this._labItemCount.y = _imageGoods.y + _spaceYCount;
			this._labItemCount.visible = true;
			this.setChildIndex(this._labItemCount, this.numChildren - 1);
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