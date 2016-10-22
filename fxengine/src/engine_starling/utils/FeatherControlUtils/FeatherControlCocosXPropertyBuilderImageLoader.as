package engine_starling.utils.FeatherControlUtils
{
	import flash.geom.Rectangle;
	
	import engine_starling.SApplication;
	import engine_starling.utils.AssetManagerUtil;
	
	import feathers.controls.ImageLoader;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.textures.Texture;

	public class FeatherControlCocosXPropertyBuilderImageLoader extends FeatherControlCocosXPropertyBuilderDefault
	{
		public function FeatherControlCocosXPropertyBuilderImageLoader()
		{
			super();
		}
		override public function get fullClassName():String
		{
			return "feathers.controls.ImageLoader";
		}
		
		override protected function _onEndEdit():void
		{
			super._onEndEdit();
			
			//因为imageloader不支持scale9 所以删除原空间，增加新的scale9
			if(_scale9Enable)
			{
				var simagetex:Texture = (_editControl as ImageLoader).source as Texture;
				if(simagetex != null)
				{
					var tex9:Scale9Textures = new Scale9Textures(simagetex,new Rectangle(_capInsetsX,_capInsetsY,_capInsetsWidth,_capInsetsHeight));
					var _scaleImage9:Scale9Image = new Scale9Image(tex9);
					_scaleImage9.width = _editControl.width;
					_scaleImage9.height = _editControl.height;
					(_editControl as ImageLoader).source = null;
					(_editControl as ImageLoader).addChild(_scaleImage9);
				}
			}
			
		}
		
		public function set fileName(value:Object):void
		{
//			"fileName": null,
//			"fileNameData": {
//				"path": "chuangong_wenzi.png",
//				"plistFile": null,
//				"resourceType": 0
//			},
		}
		public function set fileNameData(value:Object):void
		{
			if(value.path != null)
			{
				var resname:String = AssetManagerUtil.o.getName(value.path);
				(_editControl as ImageLoader).source = SApplication.assets.getTexture(resname);
			}
		}
		
		
	}
}