package engine_starling.display
{
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class SAutoSizeImage extends Image
	{
		public static var offset:Number = 0;
		public function SAutoSizeImage(texture:Texture)
		{
			super(texture);
			if(offset>0)
			{
				setPositions();
			}
		}
		private function setPositions():void
		{
			var w:Number = super.width+offset;
			var h:Number = super.height+offset;
			mVertexData.setPosition(0,0-offset,0-offset);
			mVertexData.setPosition(1,w,0-offset);
			mVertexData.setPosition(2,0-offset,h);
			mVertexData.setPosition(3,w,h);
		}
		
		/**@override*/
		override public function readjustSize():void
		{
			super.readjustSize();
			setPositions();
		}
		/**@override*/
		override public function setTexCoords(vertexID:int, coords:Point):void
		{
			super.setTexCoords(vertexID,coords);
			setPositions();
		}
		/**@override*/
		override public function set width(value:Number):void
		{
			super.width = value;
			setTimeout(setPositions,1);
		}
		/**@override*/
		override public function set height(value:Number):void
		{
			super.height = value;
			setTimeout(setPositions,1);
		}

	}
}