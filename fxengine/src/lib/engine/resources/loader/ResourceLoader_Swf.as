package lib.engine.resources.loader
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import lib.engine.resources.ResourceType;
	
	public class ResourceLoader_Swf extends ResourceLoader
	{

		public function ResourceLoader_Swf()
		{
			super("swf",ResourceType.TYPE_SWF);
		}
		
		override protected function onLoading(bytes:ByteArray):*
		{
			bytes.position = 0;			
			var loader:Loader = new Loader();
			var context:LoaderContext = new LoaderContext();
			if(context.hasOwnProperty("allowCodeImport"))
			{
				context.allowCodeImport = true;
			}
			//context.allowCodeImport = true;
			loader.loadBytes(bytes,context);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,_loadswfResComplete);
			return null;
		}
		
		private function _loadswfResComplete(e:Event):void
		{	
			var loader:LoaderInfo = e.target as LoaderInfo;
			loadComplete(loader);
		}
		
	}
}