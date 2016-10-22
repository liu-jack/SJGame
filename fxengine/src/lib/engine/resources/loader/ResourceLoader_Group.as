package lib.engine.resources.loader
{
	import flash.utils.ByteArray;
	
	import lib.engine.resources.ResourceManager;
	import lib.engine.resources.ResourceType;

	/**
	 * 组文件加载器 
	 * @author caihua
	 * 
	 */
	public class ResourceLoader_Group extends ResourceLoader
	{
		public function ResourceLoader_Group()
		{
			super("group",ResourceType.TYPE_GROUP);
		}
		
		override protected function onLoading(bytes:ByteArray):*
		{
			var objlist:Object = JSON.parse(bytes.toString());
			
			for each (var s:String in objlist.downloadlist)
			{
				ResourceManager.o.getResByPath(s);
			}
			
			return objlist;	
		}
		
		
//		override protected function onBytesComplete(value:*):*
//		{
//			var objlist:Object = JSON.decode(value);
//			
//			for each (var s:String in objlist.downloadlist)
//			{
//				ResourceManager.o.getResByPath(s);
//			}
//			
//			loadComplete(Resource.TYPE_GROUP,objlist,value);
//		}
		
		
	}
}