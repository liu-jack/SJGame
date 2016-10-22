package SJ.Game.richtext
{
	import SJ.Common.Constants.ConstRichText;
	
	import starling.display.Image;

	public class CJRTElementImage extends CJRTElement
	{
		public function CJRTElementImage()
		{
			super(ConstRichText.CJRT_ELEMENT_TYPE_IMAGE);
		}
		
		override protected function getPropertyJson():String
		{
			var json:String = '"width":"' + this.width + '",';
			json += ',"height":"' + this.height + '",';
			json += ',"textture":"' + this.textture + '"';
			return json;
		}
		
		/** setter */
		public function set width(value:int):void
		{
			this._property.width = value;
		}
//		public function set height(value:int):void
//		{
//			this._property.height = value;
//		}
		public function set textture(value:String):void
		{
			this._property.textture = value;
		}
		
		/** getter */
		public function get width():int
		{
			return this._property.width;
		}
//		public function get height():int
//		{
//			return this._property.height;
//		}
		public function get textture():String
		{
			return this._property.textture;
		}
	}
}