package SJ.Game.jewel
{
	
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstItem;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import starling.filters.ColorMatrixFilter;

	/**
	 * @author sangxu
	 * 
	 * 宝石强化 - 装备框
	 */
	public class CJJewelEquip extends SLayer
	{
		/** controls */
		/** 物品框图片 */
		private var _imageFrame:SImage;
		/** 物品图片 */
		private var _imageGoods:SImage;
		/** 选中图片 */
		private var _imageSel:SImage;
		
		/** datas */
		/** 道具id */
//		private var _itemid:String = "";
		/** 是否选中 */
		private var _select:Boolean = false;
		/** 框类型, 参考ConstItem.SCONST_ITEM_SUBTYPE_*** */
		private var _type:int = 0;
		/** 是否可以选中 */
		private var _canSelect:Boolean = true;
		
		/** 道具图片相对背景框图片偏移量 */
		private var _spaceXGood:int = 7;
		private var _spaceYGood:int = 7;
		/** 框图片宽高 */
		private var _frameImgWidth:int = 58;
		private var _frameImgHeight:int = 58;
		
		private var _selKuangName:String;
		
		/** 底图 */
		private var _imgNameSel:String;
		
		private var _filter:ColorMatrixFilter;
		
		/**
		 * 宝石镶嵌中 - 装备框
		 * @param type		装备类型, 参考ConstItem.SCONST_ITEM_SUBTYPE_*** 
		 * @param select 	是否选中, 默认false未选中
		 * 
		 */		
		public function CJJewelEquip(type:int, select:Boolean = false):void
		{
			super();
			
			this._type = type;
			this._select = select;
			
			this._initControls();
		}
		
		private function _initControls():void
		{
			_filter = new ColorMatrixFilter();
			_filter.adjustSaturation(-1);
			
			// 背景
			switch(this._type)
			{
				case ConstItem.SCONST_ITEM_SUBTYPE_WEAPON:
					_imgNameSel = ConstBag.IMG_NAME_SEL_WUQI;
					break;
				case ConstItem.SCONST_ITEM_SUBTYPE_HELMET:
					_imgNameSel = ConstBag.IMG_NAME_SEL_TOUKUI;
					break;
				case ConstItem.SCONST_ITEM_SUBTYPE_CLOAK:
					_imgNameSel = ConstBag.IMG_NAME_SEL_PIFENG;
					break;
				case ConstItem.SCONST_ITEM_SUBTYPE_ARMOUR:
					_imgNameSel = ConstBag.IMG_NAME_SEL_KUIJIA;
					break;
				case ConstItem.SCONST_ITEM_SUBTYPE_SHOES:
					_imgNameSel = ConstBag.IMG_NAME_SEL_XIEZI;
					break;
				case ConstItem.SCONST_ITEM_SUBTYPE_BELT:
					_imgNameSel = ConstBag.IMG_NAME_SEL_YAODAI;
					break;
			}
			
			_imageFrame = new SImage(SApplication.assets.getTexture(_imgNameSel));
			_imageFrame.filter = _filter;
			
			
			this._imageFrame.width = _frameImgWidth;
			this._imageFrame.height = _frameImgHeight;
			this.addChildAt(_imageFrame, 0);
			
			// 选中
			this._imageSel = new SImage(SApplication.assets.getTexture(ConstBag.IMG_NAME_SEL_KUANG));
			this._imageSel.width = _frameImgWidth;
			this._imageSel.height = _frameImgHeight;
			this._imageSel.visible = this._select;
			this.addChild(_imageSel);
		}
		/**
		 * 当前框是否选中
		 */
		public function get select():Boolean
		{
			return this._select;
		}
		/**
		 * 设置当前框选中状态
		 * @param value
		 * 
		 */		
		public function set select(value:Boolean):void
		{
			if (canSelect)
			{
				this._select = value;
				this._imageSel.visible = value;
				if (value)
				{
					this._imageFrame.texture = SApplication.assets.getTexture(this._imgNameSel);
					_imageFrame.filter = null;
				}
				else
				{
					_imageFrame.filter = _filter;
				}
			}
		}
		/**
		 * 当前框是否选中
		 */
		public function get canSelect():Boolean
		{
			return this._canSelect;
		}
		/**
		 * 设置当前框选中状态
		 * @param value
		 * 
		 */		
		public function set canSelect(value:Boolean):void
		{
			this._canSelect = value;
			this._select = false;
			this._imageSel.visible = false;
//			this._itemid = "";
			if (this._imageGoods != null)
			{
				this.removeChild(this._imageGoods);
				this._imageGoods = null;
			}
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
		 * 当前装备位类型
		 * @return 
		 * 
		 */		
		public function get type():int
		{
			return this._type;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_filter.dispose();
		}
	}
}