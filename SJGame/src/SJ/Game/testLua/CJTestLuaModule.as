package SJ.Game.testLua
{
	import flash.utils.ByteArray;
	
	import SJ.Game.core.CJModuleSubSystem;
	import SJ.Game.utils.LuaResource;
	
	public class CJTestLuaModule extends CJModuleSubSystem
	{
		public function CJTestLuaModule()
		{
			super();
		}
		
		override protected function _onInit(params:Object=null):void
		{
			var b:ByteArray = LuaResource.getLua("Mod_TestLua.lua");
			genLuaConsole(b);
			super._onInit(params);
		}
		
		
	}
}