package engine_starling.utils.FeatherControlUtils
{
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.utils.AssetManagerUtil;
	
	import feathers.controls.Button;
	import feathers.controls.Check;

	public class FeatherControlCocosXPropertyBuilderCheckBox extends FeatherControlCocosXPropertyBuilderDefault
	{
		public function FeatherControlCocosXPropertyBuilderCheckBox()
		{
			super();
		}
		override public function get fullClassName():String
		{
			
			return "feathers.controls.Check";
		}
		override protected function _onEndEdit():void
		{
			// TODO Auto Generated method stub
			super._onEndEdit();
		}
		
		override protected function _onbeginEdit():void
		{
			// TODO Auto Generated method stub
			super._onbeginEdit();
		}

//		"backGroundBox": null,
//		"backGroundBoxData": {
//			"path": "gongnengzhenghe_shenxinganxia.png",
//			"plistFile": null,
//			"resourceType": 0
//		},
//		"backGroundBoxDisabled": null,
//		"backGroundBoxDisabledData": {
//			"path": "gongnengzhenghe_zhenxinganxia.png",
//			"plistFile": null,
//			"resourceType": 0
//		},
//		"backGroundBoxSelected": null,
//		"backGroundBoxSelectedData": {
//			"path": "gongnengzhenghe_zhenxing.png",
//			"plistFile": null,
//			"resourceType": 0
//		},
//		"frontCross": null,
//		"frontCrossData": {
//			"path": "gongnengzhenghe_zhuzao.png",
//			"plistFile": null,
//			"resourceType": 0
//		},
//		"frontCrossDisabled": null,
//		"frontCrossDisabledData": {
//			"path": "gongnengzhenghe_zhuzaoanxia.png",
//			"plistFile": null,
//			"resourceType": 0
//		},
//		"selectedState": true
		
		public function set backGroundBoxData(value:Object):void
		{
			if(value.path != null)
			{
				var resname:String = AssetManagerUtil.o.getName(value.path);
				(_editControl as Check).defaultSelectedSkin = new SImage(SApplication.assets.getTexture(resname));
			}
		}
		public function set backGroundBoxDisabledData(value:Object):void
		{
			if(value.path != null)
			{
				var resname:String = AssetManagerUtil.o.getName(value.path);
				(_editControl as Check).selectedDisabledSkin = new SImage(SApplication.assets.getTexture(resname));
			}
		}
		
		public function set backGroundBoxSelectedData(value:Object):void
		{
			if(value.path != null)
			{
				var resname:String = AssetManagerUtil.o.getName(value.path);
				(_editControl as Check).selectedDownSkin = new SImage(SApplication.assets.getTexture(resname));
			}
		}
		//选中
		public function set frontCrossData(value:Object):void
		{
			if(value.path != null)
			{
				var resname:String = AssetManagerUtil.o.getName(value.path);
				(_editControl as Check).selectedUpSkin = new SImage(SApplication.assets.getTexture(resname));
			}
		}
		//未选中,就不显示了
		public function set frontCrossDisabledData(value:Object):void
		{
//			if(value.path != null)
//			{
//				var resname:String = AssetManagerUtil.o.getName(value.path);
//				(_editControl as Check).selectedDisabledSkin = new SImage(SApplication.assets.getTexture(resname));
//			}
		}
//		"selectedState": true
		public function set selectedState(value:Boolean):void
		{
			(_editControl as Check).isSelected = value;	
		}
	}
}