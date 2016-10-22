package lib.engine.resources
{
	public class ResourceLoadState
	{
		public function ResourceLoadState()
		{
		}
		
		/**
		 * 没有进行加载 
		 */		
		public static const LOADSTATE_NOLOAD:String = "LOADSTATE_NOLOAD";
		/**
		 * 资源加载中 
		 */		
		public static const LOADSTATE_LOADING:String = "LOADSTATE_LOADING";
		/**
		 * 加载完成 
		 */
		public static const LOADSTATE_LOADED:String = "LOADSTATE_LOADED";
	}
}