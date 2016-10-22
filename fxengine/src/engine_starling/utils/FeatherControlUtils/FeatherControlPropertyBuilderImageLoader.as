package engine_starling.utils.FeatherControlUtils
{
	import engine_starling.SApplication;
	
	import feathers.controls.ImageLoader;
	

	public class FeatherControlPropertyBuilderImageLoader extends FeatherControlPropertyBuilderDefault
	{
		public function FeatherControlPropertyBuilderImageLoader()
		{
			super();
		}
		
		override public function get fullClassName():String
		{
			return "feathers.controls.ImageLoader";
		}
		
		public function set localTexture(value:*):void
		{
			(_editControl as ImageLoader).source = SApplication.assets.getTexture(value);
		}
		
		
	}
}