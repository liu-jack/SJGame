package SJ.Game.jewel
{
	
	import SJ.Common.Constants.ConstJewel;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.formation.CJItemTurnPageBase;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import feathers.controls.Label;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.textures.Texture;

	/**
	 * @author sangxu
	 * 2013-05-30
	 * 宝石镶嵌，宝石
	 */
	public class CJJewelItem extends CJItemTurnPageBase
	{
		/** controls */
		/** 物品框图片 */
		private var _imageFrame:SImage;
		/** 物品图片 */
		private var _imageGoods:SImage;
		/** 物品数量 */
		private var _labCount:Label;
		/** 宝石名 */
		private var _labName:Label;
		
		
		/** 道具id */
		private var _itemid:String = "";
		
		private var _status:uint;
		
		/** 道具图片相对背景框图片偏移量 */
		private var _spaceXGood:int = 7;
		private var _spaceYGood:int = 8;
		/** 框图片宽高 */
		private var _frameImgWidth:int = ConstJewel.JEWEL_INLAY_HOLE_WIDTH;
		private var _frameImgHeight:int = ConstJewel.JEWEL_INLAY_HOLE_HEIGHT;
		/** 道具图片宽高 */
		private var _goodImgWidth:int = 44;
		private var _goodImgHeight:int = 44;
		
//		/** 索引 */
//		private var _index:int = 0;
		/** 是否可选中 */
		private var _canSelect:Boolean = true;
		
		public function CJJewelItem()
		{
			super("CJJewelItem", true);
			var textureUnlock:Texture = SApplication.assets.getTexture("common_baoshidi");
			
			_init();
			this.width = _frameImgWidth;
		}
		
		/**
		 * 点击事件
		 * @param selectedIndex
		 * @param item
		 * 
		 */		
		override protected function onSelected():void
		{
			var inlayLayer:CJJewelInlayLayer = this.owner.parent as CJJewelInlayLayer;
			inlayLayer.onSelectJewelItem(this._itemid);
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
			return this._itemid;
		}
		
		public function set itemId(value:String):void
		{
			this._itemid = value;
		}
//		/**
//		 * 索引
//		 * @return 
//		 * 
//		 */		
//		public function get index():int
//		{
//			return _index;
//		}
//		public function set index(value:int):void
//		{
//			_index = value;
//		}
		
		public function set canSelect(value:Boolean):void
		{
			this._canSelect = value;
		}
		
		public function get canSelect():Boolean
		{
			return this._canSelect;
		}
		
		
		/**
		 * 清除道具id
		 * 
		 */		
		public function clearItemId():void
		{
			_itemid = "";
		}

		private function _init():void
		{
//			switch(status)
//			{
//				case ConstBag.FrameCreateStateUnlock:
//					this._imageFrame = new SImage(SApplication.assets.getTexture("baoshi_tubiaodikuang"));
//					break;
//				case ConstBag.FrameCreateStateLocked:
//					this._imageFrame = new SImage(SApplication.assets.getTexture("baoshi_tubiaosuo"));
//					break;
//				default:
//					this._imageFrame = new SImage(SApplication.assets.getTexture("baoshi_tubiaodikuang"));
//			}
			this._imageFrame = new SImage(SApplication.assets.getTexture("common_baoshidi"));
			_status = status;
			this._imageFrame.width = _frameImgWidth;
			this._imageFrame.height = _frameImgHeight;
			addChildAt(_imageFrame, 0);
			
			var tfCount:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 9, 0xffffff, null, null, null, null, null, TextFormatAlign.RIGHT);
			var tfName:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 7, 0xffffff, null, null, null, null, null, TextFormatAlign.CENTER);
			
			_labName = new Label();
			_labName.textRendererProperties.textFormat = tfName;
			_labName.text = "";
			_labName.height = 9;
			_labName.width = _frameImgWidth;
			_labName.x = -2;
			_labName.y = 6;
			_labName.visible = false;
			this.addChild(_labName);
			
			_labCount = new Label();
			_labCount.textRendererProperties.textFormat = tfCount;
			_labCount.text = "";
			_labCount.height = 10;
			_labCount.width = _frameImgWidth - 10;
			_labCount.x = 0;
			_labCount.y = 39;
			_labCount.visible = false;
			this.addChild(_labCount);
		}
		
//		/**
//		 * 改变装备孔的锁定或者解锁状态 
//		 * 
//		 */		
//		public function updateFrame():void
//		{
//			switch(_status)
//			{
//				case ConstBag.FrameCreateStateUnlock:
//					this._imageFrame.texture = SApplication.assets.getTexture("baoshi_tubiaodikuang");
//					break;
//				case ConstBag.FrameCreateStateLocked:
//					this._imageFrame.texture = SApplication.assets.getTexture("baoshi_tubiaosuo");
//					break;
//				default:
//					this._imageFrame.texture = SApplication.assets.getTexture("baoshi_tubiaodikuang");
//			}
//		}
		
		/**
		 * 为装备孔设置物品 
		 * 
		 */		
		public function setHoleGoodsItem(imgName : String):void
		{
			if (this._imageGoods == null)
			{
				if (imgName != "")
				{
					this._imageGoods = new SImage(SApplication.assets.getTexture(imgName));
					this._imageGoods.x = this._imageFrame.x + this._spaceXGood;
					this._imageGoods.y = this._imageFrame.y + this._spaceYGood;
					this._imageGoods.width = this._goodImgWidth;
					this._imageGoods.height = this._goodImgHeight;
					this.addChildAt(this._imageGoods, 1);
					
					_labCount.visible = true;
					_labName.visible = true;
				}
				else
				{
					_labCount.visible = false;
					_labName.visible = false;
				}
			}
			else
			{
				if (imgName != "")
				{
					this._imageGoods.texture = SApplication.assets.getTexture(imgName);
					_labCount.visible = true;
					_labName.visible = true;
				}
				else
				{
					this.removeChild(this._imageGoods);
					this._imageGoods = null;
					_labCount.visible = false;
					_labName.visible = false;
				}
			}
			
			this.setChildIndex(_labCount, this.numChildren - 1);
			this.setChildIndex(_labName, this.numChildren - 1);
		}
		
		/**
		 * 根据道具模板id设置图片
		 * 调用此方法前需加载道具模板资源：ConstResource.sResItemSetting
		 * @param itemTmplId
		 * 
		 */		
		public function setHoleGoodsByTmplId(itemTmplId:int):void
		{
			var tmplData:Json_item_setting = CJDataOfItemProperty.o.getTemplate(itemTmplId);
			
			Assert(tmplData != null, "Item template is null, id is:" + itemTmplId);
			
			this.setHoleGoodsItem(tmplData.picture);
		}

		override protected function draw():void
		{
			const isTotalInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isTotalInvalid)
			{
				this._itemid = this.data["itemid"];
				this._labCount.text = String(this.data["count"]);
				_labName.text = String(this.data["name"]);
				this.setHoleGoodsItem(this.data["picture"]);
			}
			super.draw();
		}
	}
}