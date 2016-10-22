package SJ.Game.richtext
{
	import SJ.Common.Constants.ConstRichText;
	
	import feathers.controls.Button;
	import feathers.controls.Label;

	public class CJRTElementButton extends CJRTElement
	{
		public function CJRTElementButton(text:String = "")
		{
			super(ConstRichText.CJRT_ELEMENT_TYPE_BUTTON);
			this._text = text;
		}
		
		override protected function getPropertyJson():String
		{
			var json:String = '"width":"' + this.width + '",';
			json += ',"height":"' + this.height + '",';
			json += ',"defaultskin":"' + this.defaultskin + '",';
			json += ',"downskin":"' + this.downskin + '"';
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
		public function set defaultskin(value:String):void
		{
			this._property.defaultskin = value;
		}
		public function set downskin(value:String):void
		{
			this._property.downskin = value;
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
		public function get defaultskin():String
		{
			return this._property.defaultskin;
		}
		public function get downskin():String
		{
			return this._property.downskin;
		}
	}
}