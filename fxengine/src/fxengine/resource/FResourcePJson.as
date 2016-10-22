package fxengine.resource
{
	import flash.utils.ByteArray;
	
	import fxengine.utils.FPathUtils;

	public class FResourcePJson extends FResource
	{
		public function FResourcePJson()
		{
			super();
		}
		
		override public function get resType():int
		{
			return FResType_PJson;
		}
		
		override protected function _build():void
		{
			_resource = JSON.parse((loadInfo.data as ByteArray).toString());
			_buildComplete();
		}
		
		override protected function _canBuild():Boolean
		{
			
			var ext:String = FPathUtils.o.getPathExt(loadInfo.fullPath).toLowerCase();
			if(ext == "pjson")
			{
				return true;
			}
			return false;
		}
		

	}
}