package lib.engine.resources.loader
{
	import lib.engine.resources.ResourceType;

	public class ResourceLoader_Png extends ResourceLoader_Swf
	{
		public function ResourceLoader_Png()
		{
			super();
			_resourceType = ResourceType.TYPE_PNG;
			_resource_ext = "png";
		}
	}
}