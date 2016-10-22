package SJ.Game.duobao
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstTextFormat;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	
	import starling.display.DisplayObject;
	import starling.textures.Texture;

	/**
	 * 
	 * @author bianbo
	 * 
	 */	
	public class CJDuoBaoItemLayer extends SLayer
	{
		private var iconBg:ImageLoader;
		private var _labItemTip:Label;
		private var _itemTip:Label;
		
		private var picStr:String;
		
		public function CJDuoBaoItemLayer()
		{
			iconBg = new ImageLoader();
			iconBg.source = SApplication.assets.getTexture("common_baoshidi");
			iconBg.x = 0;
			iconBg.y = 0;
			this.addChild(iconBg);
			
			//显示名字
			this._labItemTip = new Label();
			var fontFormatEquip:TextFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 8, 0xffffff, null, null, null, null, null, TextFormatAlign.RIGHT);
			this._labItemTip.textRendererProperties.textFormat = fontFormatEquip;
			this._labItemTip.text = "";
			this._labItemTip.y = ConstBag.BAG_ITEM_WIDTH-12;
			this._labItemTip.width =  ConstBag.BAG_ITEM_HEIGHT;
			this.addChild(_labItemTip);
			
			//显示提示
			this._itemTip = new Label();
			fontFormatEquip = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFFFF00, null, null, null, null, null, TextFormatAlign.CENTER);
			this._itemTip.textRendererProperties.textFormat = fontFormatEquip;
			this._itemTip.text = "";
			this._itemTip.x = 4;
			this._itemTip.y = 19;
			this._itemTip.width =  ConstBag.BAG_ITEM_HEIGHT;
			this.addChild(_itemTip);
			
			width = ConstBag.BAG_ITEM_WIDTH;
			height = ConstBag.BAG_ITEM_HEIGHT;
		}
		
		/**
		 *为背包物品框设置物品 
		 * 
		 */		
		public function setItem(imgName : String, _name:String):void
		{
			_labItemTip.text = _name;//大于1显示
			_labItemTip.visible = false;
			
			picStr = imgName;
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
				
				_imageGoods.x = (ConstBag.BAG_ITEM_WIDTH - ConstBag.BAG_ITEM_CONT_WIDTH)/2+4;
				_imageGoods.y =(ConstBag.BAG_ITEM_HEIGHT - ConstBag.BAG_ITEM_CONT_HEIGHT)/2+5;
				_imageGoods.visible = false;
				this.addChildAt(_imageGoods, 1);
			}
		}
		
		public function setImgVisible():void
		{
			var dis:DisplayObject = this.getChildByName("item_icon");
			if(dis != null)dis.visible = true;
			_labItemTip.visible = true;
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
			
			_labItemTip.text = "";
			
			_itemTip.text = "";
		}
		
		/**
		 * 设置中间显示提示文字
		 */	
		public function setItemTip(_tip:String):void
		{
			_itemTip.text = _tip;
		}
		
		/**
		 * 获得碎片显示副本
		 * @return SImage
		 */		
		public function getClone():SImage
		{
			_labItemTip.visible = false;
			
			var _imageGoods:SImage;
			
			var dis:DisplayObject = this.getChildByName("item_icon");
			if(dis != null){
				this.removeChild(dis);
				_imageGoods = dis as SImage;
			}
			else
			{
				var texture:Texture = SApplication.assets.getTexture(picStr);
				_imageGoods = new SImage(texture);
			}
				
			_imageGoods.width = ConstBag.BAG_ITEM_CONT_WIDTH;
			_imageGoods.height = ConstBag.BAG_ITEM_CONT_HEIGHT;
			
//			var p:Point = localToGlobal(new Point(this.x, this.y));
			_imageGoods.x = this.parent.x + this.x;
			_imageGoods.y = this.parent.y + this.y;
			
			return _imageGoods;
		}
		
	}
}