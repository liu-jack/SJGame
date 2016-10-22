package fxengine.resource
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.LoaderContext;
	
	import fxengine.game.texture.FTexture;
	import fxengine.utils.FPathUtils;

	/**
	 * 位图资源 
	 * @author caihua
	 * 
	 */
	public class FResourceBitmapData extends FResource
	{
		public function FResourceBitmapData()
		{
			super();
		}
		
		override public function get resType():int
		{
			return FResType_Bitmap;
		}
		
		override protected function _build():void
		{
			//异步加载图片资源
			var pictureloader:Loader = new Loader();
			var context:LoaderContext = new LoaderContext();
			if(context.hasOwnProperty("allowCodeImport"))
			{
				context.allowCodeImport = true;
			}
			pictureloader.contentLoaderInfo.addEventListener(Event.COMPLETE,function loadComplete(e:Event):void
			{
				var resourceLoaderInfo:LoaderInfo = e.target as LoaderInfo;
				
				_resource = new FTexture((resourceLoaderInfo.content as Bitmap).bitmapData);
				_buildComplete();
			});
			pictureloader.loadBytes(loadInfo.data,context);
			
		}
		
		
		
		
		
		override protected function _canBuild():Boolean
		{

			var ext:String = FPathUtils.o.getPathExt(loadInfo.fullPath).toLowerCase();
			if(ext == "png" || ext == "jpg" || ext == "jpeg")
			{
				return true;
			}
			return false;
//			return super._canBuild(resource, fullPath);
		}
		
	}
}