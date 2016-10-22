package fxengine.resource.iface
{
	import flash.utils.ByteArray;
	
	import fxengine.resource.FResource;

	/**
	 * 资源获取接口 
	 * @author caihua
	 * 
	 */
	public interface FResourceInterface
	{
		/**
		 * 获取资源 会触发事件 F_R_LoadComplete
		 * @param URL URL路径
		 * @return 
		 * 
		 */
		function getResource(URL:String):FResource;
		
		/**
		 * 添加资源 
		 * @param URL URL路径
		 * @param buffer 二进制数据
		 * 
		 */
		function addResource(URL:String,buffer:ByteArray):void;
	}
}