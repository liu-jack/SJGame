package lib.engine.resources.loader
{
	import flash.utils.ByteArray;
	
	import lib.engine.resources.ResourceType;
	import lib.engine.ui.data.ImagesSet;

	public class ResourceLoader_Images extends ResourceLoader
	{
		public function ResourceLoader_Images()
		{
			super("images",ResourceType.TYPE_IMAGES);
		}
		
		override protected function onLoading(bytes:ByteArray):*
		{
			
			var imageset:ImagesSet = new ImagesSet();
			imageset.UnSerialization(bytes.toString());
			return imageset;
		}
		
		
	}
}