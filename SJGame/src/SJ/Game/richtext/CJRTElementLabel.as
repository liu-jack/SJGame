package SJ.Game.richtext
{
	import SJ.Common.Constants.ConstRichText;
	
	import feathers.controls.Label;

	public class CJRTElementLabel extends CJRTElement
	{
		public function CJRTElementLabel(text:String = "")
		{
			super(ConstRichText.CJRT_ELEMENT_TYPE_LABEL);
			this._text = text;
		}
		
		override protected function getPropertyJson():String
		{
			var json:String = '"font":"' + this.font + '",';
			json += ',"size":"' + this.size + '",';
			json += ',"color":"' + this.color + '",';
			json += ',"bold":"' + this.bold + '"';
			return json;
		}
		
		/** setter */
		public function set font(value:String):void
		{
			this._property.font = value;
		}
		public function set size(value:int):void
		{
			this._property.size = value;
		}
		public function set color(value:Object):void
		{
			this._property.color = value;
		}
		public function set bold(value:Object):void
		{
			this._property.bold = value;
		}
		public function set underline(value:Object):void
		{
			this._property.underline = value;
		}
		
		/** getter */
		public function get font():String
		{
			return this._property.font;
		}
		public function get size():int
		{
			return this._property.size;
		}
		public function get color():Object
		{
			return this._property.color;
		}
		public function get bold():Object
		{
			return this._property.bold;
		}
		public function get underline():Object
		{
			return this._property.underline;
		}
	}
}