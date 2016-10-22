package engine_starling.display
{
	import flash.geom.Rectangle;
	
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SStringUtils;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.textures.Texture;

	public class SScale9Plane extends SLayer
	{
		private var _scaleImage9:Scale9Image;
		private var _texturename:String = null;
		private var _gridx:int;
		private var _gridy:int;
		private var _gridwidth:int;
		private var _gridheight:int;
		public function SScale9Plane()
		{
			super();
		}
		
		override protected function draw():void
		{
			this.removeChildren();
			var texture:Texture = AssetManagerUtil.o.getTexture(_texturename);
			var tex9:Scale9Textures = new Scale9Textures(texture,new Rectangle(_gridx,_gridy,_gridwidth,_gridheight));
			_scaleImage9 = new Scale9Image(tex9);
			addChild(_scaleImage9);
			_scaleImage9.width = width;
			_scaleImage9.height = height;
			super.draw();
		}
		
		override protected function initialize():void
		{
			if (SStringUtils.isEmpty(_texturename))
			{
				Assert(false,"SScale9Plane need texturename!");
				return;
			}
			super.initialize();
		}
		
		public function get gridx():int
		{
			return _gridx;
		}

		public function set gridx(value:int):void
		{
			_gridx = value;
		}

		public function get gridy():int
		{
			return _gridy;
		}

		public function set gridy(value:int):void
		{
			_gridy = value;
		}

		public function get gridwidth():int
		{
			return _gridwidth;
		}

		public function set gridwidth(value:int):void
		{
			_gridwidth = value;
		}

		public function get gridheight():int
		{
			return _gridheight;
		}

		public function set gridheight(value:int):void
		{
			_gridheight = value;
		}

		public function get texturename():String
		{
			return _texturename;
		}

		public function set texturename(value:String):void
		{
			_texturename = value;
			this.invalidate();
		}
		
		
	}
}