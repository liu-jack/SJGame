package engine_starling.utils.FeatherControlUtils
{
	import flash.geom.Rectangle;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SStringUtils;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;

	public class FeatherControlCocosXPropertyBuilderSLayer extends FeatherControlCocosXPropertyBuilderDefault
	{
		public function FeatherControlCocosXPropertyBuilderSLayer()
		{
		}
		
		private var _resname:String;
		
		override public function get fullClassName():String
		{
			return "engine_starling.display.SLayer";
		}
		
		override protected function _onbeginEdit():void
		{
			// TODO Auto Generated method stub
			super._onbeginEdit();
			_resname = null;
		}
		
		
		override protected function _onEndEdit():void
		{
			// TODO Auto Generated method stub
			super._onEndEdit();
			if(SStringUtils.isEmpty(_resname))
			{
				return;
			}
			if(_scale9Enable)
			{
				var scale9i:Scale9Image;
				var tex9:Scale9Textures = new Scale9Textures(SApplication.assets.getTexture(_resname),new Rectangle(_capInsetsX,_capInsetsY,_capInsetsWidth,_capInsetsHeight));
				scale9i = new Scale9Image(tex9);
				scale9i.width = _editControl.width;
				scale9i.height = _editControl.height;
				scale9i.touchable = false;
				_editControl.addChild(scale9i);
			}
			else
			{
				var bgimage:SImage = new SImage(SApplication.assets.getTexture(_resname));
				bgimage.pivotX = bgimage.width / 2;
				bgimage.pivotY = bgimage.height / 2;
				bgimage.x = _editControl.width / 2;
				bgimage.y = _editControl.height / 2;
				bgimage.touchable = false;
				_editControl.addChild(bgimage);
				
			}
		}
		
		
		
		//				options	Object (@170510a1)	
		//				backGroundImage	null	
		//				backGroundImageData	null	
		//				backGroundScale9Enable	false	
		//				bgColorB	255 [0xff]	
		//				bgColorG	200 [0xc8]	
		//				bgColorOpacity	0	
		//				bgColorR	150 [0x96]	
		//				bgEndColorB	255 [0xff]	
		//				bgEndColorG	0	
		//				bgEndColorR	0	
		//				bgStartColorB	255 [0xff]	
		//				bgStartColorG	255 [0xff]	
		//				bgStartColorR	255 [0xff]	
		//				classname	"Panel"	
		//				classType	null	
		//				clipAble	false	
		//				colorType	1	
		//				__type	"ComGUIPanelSurrogate:#EditorCommon.JsonModel.Component.GUI"	
		//				vectorX	0	
		//				vectorY	-0.5
		
		public function set backGroundScale9Enable(value:Boolean):void
		{
			_scale9Enable = value;	
		}
		public function set backGroundImage(value:Object):void
		{
			//		"backGroundImage": null,
			//		"backGroundImageData": {
			//			"path": "common_jindutiao.png",
			//			"plistFile": null,
			//			"resourceType": 0
			//		},
			//		"backGroundScale9Enable": true,
		}
		public function set backGroundImageData(value:Object):void
		{
			if(value != null)
			{
				_resname = AssetManagerUtil.o.getName(value.path);
				
			}
		}
	}
}