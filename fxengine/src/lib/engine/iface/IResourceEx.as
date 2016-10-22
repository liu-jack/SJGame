package lib.engine.iface
{
	import lib.engine.resources.Resource;

	public interface IResourceEx
	{
		/**
		 * 获取 Layout 资源 
		 * @param name Layout 名称
		 * @return 可能返回null
		 * 
		 */
		function getLayout(name:String):Resource;
		
		
		/**
		 * 获取imageset 资源 
		 * @param name ImageSet名称
		 * @return 可能返回null
		 * 
		 */
		function getImageset(name:String):Resource;
	}
}