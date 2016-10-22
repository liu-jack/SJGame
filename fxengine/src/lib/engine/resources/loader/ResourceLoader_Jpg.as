package lib.engine.resources.loader
{
	import lib.engine.resources.ResourceType;

	public class ResourceLoader_Jpg extends ResourceLoader_Swf
	{
		public function ResourceLoader_Jpg()
		{
			super();
			_resourceType = ResourceType.TYPE_JPG;
			_resource_ext = "jpg";
		}
	}
}