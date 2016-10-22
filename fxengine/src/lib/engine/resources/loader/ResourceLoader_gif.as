package lib.engine.resources.loader
{
	import lib.engine.resources.ResourceType;

	public class ResourceLoader_gif extends ResourceLoader_Swf
	{
		public function ResourceLoader_gif()
		{
			super();
			_resourceType = ResourceType.TYPE_GIF;
			_resource_ext = "gif";
		}
		
	}
}