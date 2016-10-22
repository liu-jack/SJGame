package SJ.Game.controls
{
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.display.TiledImage;
	
	import starling.textures.Texture;
	
	public class CJPanelFrame extends SLayer
	{
		private var _fwidth:Number
		private var _fheight:Number

		private var topImage:TiledImage;

		private var leftImage:TiledImage;

		private var rightIamge:TiledImage;

		private var bottomImage:TiledImage;

		private var texture:Texture;
		
		public function CJPanelFrame(w:Number = 0,h:Number = 0)
		{
			super();
			_fwidth = w;
			_fheight = h;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			var textname:String = "common_biankuanghuawen";
			texture = SApplication.assets.getTexture(textname);
			topImage = new TiledImage(texture);
			this.addChild(topImage);
			
			leftImage = new TiledImage(texture);
			leftImage.pivotX = texture.width>>1;
			leftImage.pivotY = texture.height>>1;
			leftImage.scaleY = -1
			leftImage.rotation = Math.PI/2;
			this.addChild(leftImage);
			
			rightIamge = new TiledImage(texture)
			rightIamge.rotation = Math.PI/2;
			this.addChild(rightIamge);
			
			bottomImage = new TiledImage(texture);
			bottomImage.scaleY = -1;
			this.addChild(bottomImage);
		}
		
		override protected function draw():void
		{
			super.draw();
			
			topImage.width = this._fwidth;
			
			leftImage.width = this._fheight - texture.height;
			leftImage.y = topImage.y + texture.height;
			leftImage.x = texture.height/2;
			
			rightIamge.width = this._fheight - texture.height;
			rightIamge.x = this._fwidth;
			rightIamge.y = leftImage.y;
			
			bottomImage.width = this._fwidth;
			bottomImage.y = this._fheight
		}
		
		override public function dispose():void
		{
			super.dispose();
		}

		public function get fwidth():Number
		{
			return _fwidth;
		}

		public function set fwidth(value:Number):void
		{
			_fwidth = value;
			this.invalidate();
		}

		public function get fheight():Number
		{
			return _fheight;
		}

		public function set fheight(value:Number):void
		{
			_fheight = value;
			this.invalidate();
		}
	}
}