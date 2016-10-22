package lib.engine.resources.loader
{
	import lib.engine.resources.ResourceType;

	public class ResourceLoader_Jpeg extends ResourceLoader_Swf
	{
		public function ResourceLoader_Jpeg()
		{
			super();
			_resourceType = ResourceType.TYPE_JPEG;
			_resource_ext = "jpeg";
		}
	}
}