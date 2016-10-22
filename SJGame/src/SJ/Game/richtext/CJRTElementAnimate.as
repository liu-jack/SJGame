package SJ.Game.richtext
{
	import SJ.Common.Constants.ConstRichText;
	
	import engine_starling.display.SAnimate;
	
	import starling.display.Image;

	public class CJRTElementAnimate extends CJRTElement
	{
		public function CJRTElementAnimate()
		{
			super(ConstRichText.CJRT_ELEMENT_TYPE_ANIMATE);
		}
		
		override protected function getPropertyJson():String
		{
			var json:String = '"width":"' + this.width + '",';
			json += ',"height":"' + this.height + '",';
			json += ',"animateTextture":"' + this.animateTextture + '"';
			return json;
		}
		
		/** setter */
		public function set animateTextture(value:String):void
		{
			this._property.animateTextture = value;
		}
		public function set width(value:int):void
		{
			this._property.width = value;
		}
//		public function set height(value:int):void
//		{
//			this._property.height = value;
//		}
		
		/** getter */
		public function get animateTextture():String
		{
			return this._property.animateTextture;
		}
		public function get width():int
		{
			return this._property.width;
		}
//		public function get height():int
//		{
//			return this._property.height;
//		}
	}
}