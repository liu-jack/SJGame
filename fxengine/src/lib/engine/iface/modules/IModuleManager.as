package lib.engine.iface.modules
{
	import flash.utils.Dictionary;
	
	import lib.engine.game.module.CModuleSubSystem;
	import lib.engine.iface.IFacadeModule;
	import lib.engine.iface.IRegister;

	/**
	 * 模块管理器接口 
	 * @author caihua
	 * 
	 */
	public interface IModuleManager
	{
		/**
		 * 注册并且初始化 
		 * @param reg
		 * @return 
		 * 
		 */
		function registerAndInit(reg:CModuleSubSystem,params:Object = null):Boolean;
		/**
		 * 进入模块 
		 * @param modulename 模块名称
		 * @return 
		 * 
		 */
		function enterModule(modulename:String,params:Object = null):Boolean;
		/**
		 * 退出模块 
		 * @param modulename 模块名称
		 * @return 
		 * 
		 */
		function exitModule(modulename:String,params:Object = null):Boolean;
		/**
		 * 销毁模块,并取消注册
		 * @param modulename
		 * 
		 */
		function DestroyModule(modulename:String,params:Object = null):Boolean;
		/**
		 * 获得模块,通过模块名称 
		 * @param modulename
		 * @return 如果没有 返回null
		 * 
		 */
		function getModule(modulename:String):IFacadeModule;
		function getModules():Dictionary;
		
	}
}