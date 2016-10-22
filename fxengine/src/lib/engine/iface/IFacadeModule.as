package lib.engine.iface
{
	/**
	 * 模块外观 
	 * @author caihua
	 * 
	 */
	public interface IFacadeModule
	{
		/**
		 * 初始化 
		 * 
		 */
		function Init(params:Object = null):void;
		/**
		 * 进入 
		 * 
		 */
		function Enter(params:Object = null):void;
		/**
		 * 退出 
		 * 
		 */
		function Exit(params:Object = null):void;
		
		/**
		 * 销毁 
		 * 
		 */
		function Destroy(params:Object = null):void;
	}
}