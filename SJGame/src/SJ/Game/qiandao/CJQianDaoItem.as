package SJ.Game.qiandao
{
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.config.CJDataOfItemProperty;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.core.ITextRenderer;
	
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.display.DisplayObject;
	import starling.textures.Texture;

	public class CJQianDaoItem extends SLayer
	{
		private var iconBg:ImageLoader;
		private var _labItemCount:Label;
		
		public var itemId:int=0;//存储当前道具的id，默认0
		
		public function CJQianDaoItem()
		{
			iconBg = new ImageLoader();
			iconBg.source = SApplication.assets.getTexture("qiandao_jiangpinkuang");
			iconBg.x = 0;
			iconBg.y = 0;
			this.addChild(iconBg);
			
			
			this._labItemCount = new Label();
			var fontFormatEquip:TextFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xffffff, null, null, null, null, null, TextFormatAlign.RIGHT);
			this._labItemCount.textRendererProperties.textFormat = fontFormatEquip;
			this._labItemCount.text = "";
			this._labItemCount.y = ConstBag.BAG_ITEM_WIDTH-12;
			this._labItemCount.width =  ConstBag.BAG_ITEM_HEIGHT;
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
			
			this.addChild(_labItemCount);
			
			width = ConstBag.BAG_ITEM_WIDTH;
			height = ConstBag.BAG_ITEM_HEIGHT;
		}
		
		/**
		 * 设置道具显示数量
		 * @param _num
		 */		
		public function setNum(_num:int):void
		{
			_labItemCount.text = ""+_num;
			_labItemCount.visible = true;
		}
		
		/**
		 *为背包物品框设置物品 
		 * 
		 */		
		public function setBagGoodsItem(imgName : String=""):void
		{
			var texture:Texture = SApplication.assets.getTexture(imgName);
			
			if (imgName != "" && texture)
			{
				var dis:DisplayObject = this.getChildByName("item_icon");
				if(dis != null)
				{
					this.contains(dis) && this.removeChild(dis);
				}
				
				var _imageGoods:SImage = new SImage(texture);
				_imageGoods.name = "item_icon";
				_imageGoods.width = ConstBag.BAG_ITEM_CONT_WIDTH;
				_imageGoods.height = ConstBag.BAG_ITEM_CONT_HEIGHT;
				
				_imageGoods.x = (ConstBag.BAG_ITEM_WIDTH - ConstBag.BAG_ITEM_CONT_WIDTH)/2+2;
				_imageGoods.y =(ConstBag.BAG_ITEM_HEIGHT - ConstBag.BAG_ITEM_CONT_HEIGHT)/2+3;
				this.addChildAt(_imageGoods, 1);
			}
		}
		
		/**
		 * 尝试移除旧的道具内容
		 */		
		public function removeOldItem():void
		{
			var dis:DisplayObject = this.getChildByName("item_icon");
			if(dis != null)
			{
				this.contains(dis) && this.removeChild(dis);
			}
			
			_labItemCount.text = "";
			_labItemCount.visible = false;
		}
	}
}