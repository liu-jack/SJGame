package SJ.Game.core
{
	import lib.engine.game.module.CModuleSubSystem;
	
	/**
	 * 子系统 
	 * @author caihua
	 * 
	 */
	public class CJModuleSubSystem extends CModuleSubSystem
	{
		public function CJModuleSubSystem()
		{
			super();
		}
		
		/**
		 * 获得需要预加载的资源 
		 * @return 
		 * 
		 */
		public function getPreloadResource():Array
		{
			//Vector.<String>(["xxxxx","bbbbb"])
			var retArr:Array = [];
			if(LuaConsole != null)
			{
				var luaArr:Array = _doLuaString("getPreloadResource()");
				
			}
			
			return retArr;
		}
	}
}