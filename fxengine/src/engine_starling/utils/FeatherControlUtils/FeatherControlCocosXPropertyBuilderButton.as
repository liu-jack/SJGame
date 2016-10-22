package engine_starling.utils.FeatherControlUtils
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.utils.AssetManagerUtil;
	
	import feathers.controls.Button;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;

	public class FeatherControlCocosXPropertyBuilderButton extends FeatherControlCocosXPropertyBuilderDefault
	{
		public function FeatherControlCocosXPropertyBuilderButton()
		{
			super();
		}
		
		override public function get fullClassName():String
		{
			return "feathers.controls.Button";
		}
		private var _textformat:TextFormat;
		override protected function _onbeginEdit():void
		{
			super._onbeginEdit();
			_textformat = new TextFormat();
			_textformat.align = TextFormatAlign.CENTER;
			
		}
		
		
		override protected function _onEndEdit():void
		{
			// TODO Auto Generated method stub
			super._onEndEdit();
			(_editControl as Button).defaultLabelProperties.textFormat = _textformat;
			
			if(_scale9Enable)
			{
				_replacescale9tex((_editControl as Button));
			}
			
		}
		private function _replacescale9tex(btn:Button):void
		{
			var simage:SImage = null;
			var tex9:Scale9Textures = null;
			if(btn.defaultSkin != null)
			{
				simage = btn.defaultSkin as SImage;
				tex9 = new Scale9Textures(simage.texture,new Rectangle(_capInsetsX,_capInsetsY,_capInsetsWidth,_capInsetsHeight));
				btn.defaultSkin = new Scale9Image(tex9);
			}
			if(btn.downSkin != null)
			{
				simage = btn.downSkin as SImage;
				tex9 = new Scale9Textures(simage.texture,new Rectangle(_capInsetsX,_capInsetsY,_capInsetsWidth,_capInsetsHeight));
				btn.downSkin = new Scale9Image(tex9);
			}
			if(btn.disabledSkin != null)
			{
				simage = btn.disabledSkin as SImage;
				tex9 = new Scale9Textures(simage.texture,new Rectangle(_capInsetsX,_capInsetsY,_capInsetsWidth,_capInsetsHeight));
				btn.disabledSkin = new Scale9Image(tex9);
			}
		}
		
		
		
		public function set disabled(value:Object):void
		{
			//			"disabled": null,
			//			"disabledData": {
			//				"path": null,
			//				"plistFile": null,
			//				"resourceType": 0
			//			},
		}
		public function set disabledData(value:Object):void
		{
			if(value.path != null)
			{
				var resname:String = AssetManagerUtil.o.getName(value.path);
				(_editControl as Button).disabledSkin = new SImage(SApplication.assets.getTexture(resname));
			}
		}
		public function set normal(value:Object):void
		{
			
		}
		public function set normalData(value:Object):void
		{
			//			"normal": null,
			//			"normalData": {
			//				"path": "closenormal.png",
			//				"plistFile": null,
			//				"resourceType": 0
			//			},
			if(value.path != null)
			{
				var resname:String = AssetManagerUtil.o.getName(value.path);
				(_editControl as Button).defaultSkin = new SImage(SApplication.assets.getTexture(resname));
			}
		}
		public function set pressed(value:Object):void
		{
			
		}
		public function set pressedData(value:Object):void
		{
			//			"pressed": null,
			//			"pressedData": {
			//				"path": "closepress.png",
			//				"plistFile": null,
			//				"resourceType": 0
			//			},
			if(value.path != null)
			{
				var resname:String = AssetManagerUtil.o.getName(value.path);
				(_editControl as Button).downSkin = new SImage(SApplication.assets.getTexture(resname));
			}
		}
		
		
		//textbutton
		
		public function set text(value:String):void
		{
			(_editControl as Button).label = value;
		}
		public function set textColorR(value:int):void
		{
			_textformat.color = ((int(_textformat.color) & 0xFFFF)|(value & 0xFF) <<16);
		}
		public function set textColorG(value:int):void
		{
			_textformat.color = ((int(_textformat.color) & 0xFF00FF)|(value & 0xFF) <<8);
		}
		public function set textColorB(value:int):void
		{
			_textformat.color = ((int(_textformat.color) & 0xFFFF00)|(value & 0xFF));
		}
		public function set fontName(value:String):void
		{
			_textformat.font = value;
		}
		public function set fontSize(value:int):void
		{
			_textformat.size = value/2;
		}
		
		
		
	}
}