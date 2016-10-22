package engine_starling.display
{
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class SImage extends Image
	{
		/**
		 * 是否销毁的时候释放texture资源 
		 */
		private var _disposeTexture:Boolean = false;
		
		
		public function SImage(texture:Texture,disposeTexture:Boolean = false)
		{
			super(texture);
			_disposeTexture = disposeTexture;
		}
		
		override public function set texture(value:Texture):void
		{
			if(_disposeTexture)
			{
				if(super.texture != null && super.texture != value)
				{
					super.texture.dispose();
				}
			}
			super.texture = value;
		}
		
		
		override public function dispose():void
		{
			if(_disposeTexture)
				texture.dispose();
			super.dispose();
		}
		
		
	}
}