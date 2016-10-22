package engine_starling.display
{
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SStringUtils;
	
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.textures.Texture;

	public class SScale3Plane extends SLayer
	{
		private var _scale3Image:Scale3Image;
		public function SScale3Plane()
		{
			super();
		}
		
		private var _texturename:String = null;
		private var _firstRegionSize:Number = 0;
		private var _secondRegionSize:Number = 0;
		private var _direction:String = Scale3Textures.DIRECTION_HORIZONTAL;
		
		override protected function draw():void
		{
			_scale3Image.width = width;
			_scale3Image.height = height;
			super.draw();
		}
		
		override protected function initialize():void
		{
			if (SStringUtils.isEmpty(_texturename))
			{
				Assert(false,"SScale3Plane need texturename!");
				return;
			}
			var texture:Texture = AssetManagerUtil.o.getTexture(_texturename);
			
			var scale3Texture:Scale3Textures = new Scale3Textures(texture,_firstRegionSize,_secondRegionSize,_direction);
			_scale3Image = new Scale3Image(scale3Texture);			
			addChild(_scale3Image);
			super.initialize();
		}

		/**
		 * 贴图名称 
		 */
		public function get texturename():String
		{
			return _texturename;
		}

		/**
		 * @private
		 */
		public function set texturename(value:String):void
		{
			_texturename = value;
		}

		public function get firstRegionSize():Number
		{
			return _firstRegionSize;
		}

		public function set firstRegionSize(value:Number):void
		{
			_firstRegionSize = value;
		}

		public function get secondRegionSize():Number
		{
			return _secondRegionSize;
		}

		public function set secondRegionSize(value:Number):void
		{
			_secondRegionSize = value;
		}

		public function get direction():String
		{
			return _direction;
		}

		public function set direction(value:String):void
		{
			_direction = value;
		}
		
		
		
		
	}
}