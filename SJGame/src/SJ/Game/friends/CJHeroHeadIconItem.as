package SJ.Game.friends
{
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import starling.textures.Texture;

	/**
	 * 武将头像单元
	 * @author zhengzheng
	 * 
	 */	
	public class CJHeroHeadIconItem extends SLayer
	{
		/** 武将头像框图片 */
		private var _imageFrame:Scale9Image;
		/** 武将头像图片 */
		private var _imageHead:ImageLoader;
		
		public function CJHeroHeadIconItem()
		{
			super();
			var texture:Texture = SApplication.assets.getTexture("common_tubiaokuang1");
			var bgScaleRange:Rectangle = new Rectangle(15, 15, 1, 1);
			this.imageFrame = new Scale9Image(new Scale9Textures(texture, bgScaleRange));
			this.imageFrame.width = 51;
			this.imageFrame.height = 51;
			addChild(this.imageFrame);
			
			this.imageHead = new ImageLoader();
			this.imageHead.x = -8;
			this.imageHead.y = -8;
			this.imageHead.width = 65;
			this.imageHead.height = 65;
			this.addChild(this.imageHead);
		}
		
		/**
		 *为武将头像框设置头像图片
		 * 
		 */		
		public function setHeadImg(imgName : String):void
		{
			if (imgName != null)
			{
				this.imageHead.source = SApplication.assets.getTexture(imgName);
			}
		}
		
		/** 武将头像框图片 */
		public function get imageFrame():Scale9Image
		{
			return _imageFrame;
		}

		public function set imageFrame(value:Scale9Image):void
		{
			_imageFrame = value;
		}

		/** 武将头像图片 */
		public function get imageHead():ImageLoader
		{
			return _imageHead
		}

		public function set imageHead(value:ImageLoader):void
		{
			_imageHead = value;
		}


	}
}