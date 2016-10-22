package engine_starling.utils.FeatherControlUtils
{
	import engine_starling.SApplication;
	import engine_starling.utils.AssetManagerUtil;
	
	import feathers.controls.ProgressBar;
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;
	
	import starling.textures.Texture;

	public class FeatherControlCocosXPropertyBuilderProgressBar extends FeatherControlCocosXPropertyBuilderDefault
	{
		public function FeatherControlCocosXPropertyBuilderProgressBar()
		{
			super();
		}
		override public function get fullClassName():String
		{
			return "feathers.controls.ProgressBar";
		}
		
		override protected function _onEndEdit():void
		{
			// TODO Auto Generated method stub
			super._onEndEdit();
			if(_scale9Enable)
			{
				var fillSkin:Scale3Image = (_editControl as ProgressBar).fillSkin as Scale3Image;
				var tex:Texture = fillSkin.textures.texture;
				var scale3texture:Scale3Textures = new Scale3Textures(tex,_capInsetsX,_capInsetsWidth);
				
				fillSkin = new Scale3Image(scale3texture);
				(_editControl as ProgressBar).fillSkin = fillSkin;
			}
		}
		
		override protected function _onbeginEdit():void
		{
			// TODO Auto Generated method stub
			super._onbeginEdit();
		}
		

		
		public function set percent(value:Number):void
		{
			(_editControl as ProgressBar).value = value/100;
		}
		public function set textureData(value:Object):void
		{
//			"percent": 100,
//			"scale9Enable": false,
//			"texture": null,
//			"textureData": {
//				"path": "herostar_jindutiaokuang.png",
//				"plistFile": null,
//				"resourceType": 0
//			}
			if(value.path != null)
			{
				var resname:String = AssetManagerUtil.o.getName(value.path);
				var t:Texture = SApplication.assets.getTexture(resname);
				var autowidth:Number = 1;
				var autoleft:Number = (t.width - autowidth)/2.0;
				var scale3texture:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture(resname),autoleft,autowidth);
				var fillSkin:Scale3Image = new Scale3Image(scale3texture);
				(_editControl as ProgressBar).fillSkin = fillSkin;
//				(_editControl as ProgressBar).fillSkin = new SImage(SApplication.assets.getTexture(resname));
			}
		}
	}
}