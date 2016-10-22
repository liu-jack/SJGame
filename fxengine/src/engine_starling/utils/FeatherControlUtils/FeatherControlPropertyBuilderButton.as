package engine_starling.utils.FeatherControlUtils
{
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;

	public class FeatherControlPropertyBuilderButton extends FeatherControlPropertyBuilderDefault
	{
		public function FeatherControlPropertyBuilderButton()
		{
			super();
		}
		
		override public function get fullClassName():String
		{
			return "feathers.controls.Button";
		}
		

		public function set x(value:Number):void
		{
			_editControl.x = value ;
		}
		
		/**
		 * addby caihua 
		 * 实现按钮皮肤配置功能
		 */		
		public function set defaultSkin(featureName:String):void
		{
			(_editControl as Button).defaultSkin = new SImage(SApplication.assets.getTexture(featureName));
		}
		
		/**
		 * 按钮按下状态
		 */		
		public function set downSkin(featureName:String):void
		{
			(_editControl as Button).downSkin = new SImage(SApplication.assets.getTexture(featureName));
		}
		
		/**
		 * 按钮不可用状态
		 */		
		public function set disabledSkin(featureName:String):void
		{
			(_editControl as Button).disabledSkin = new SImage(SApplication.assets.getTexture(featureName));
		}
		
	}
}