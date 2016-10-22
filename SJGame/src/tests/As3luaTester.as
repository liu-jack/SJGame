package tests
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import cmodule.lua_wrapper.CLibInit;
	
	import engine_starling.utils.SPathUtils;
	
	import luaAlchemy.LuaAlchemy;
	import luaAlchemy.lua_wrapper;
	

	public class As3luaTester
	{
		public function As3luaTester()
		{
		
		}
		public function testAlchemy():void
		{
			var lua:LuaAlchemy = new LuaAlchemy(null,false);
			lua.init();
			//			LuaAssets.init(File.applicationDirectory.nativePath);
			//			trace(LuaAssets.filesystemRoot());
			//			lua.setGlobalLuaValue(
			var b:ByteArray = new ByteArray();
			var filepath:String = File.applicationDirectory.nativePath + "\\appLuaResource\\test.lua";
			SPathUtils.o.readFileToByteArray(filepath,b);
			
			lua.supplyFile("test.lua",b);
			var arr:Array = lua.doFile("test.lua");
			trace(arr);
			
			var script:String = (<![CDATA[
				return
				testluaclass("bb")
			]]>).toString();
			var arr:Array = lua.doString(script);
			trace(arr);
		}
		public function testwrapper():void
		{
			var lua_state:uint = lua_wrapper.luaInitializeState();
			
//			var script:String = (<![CDATA[
//					assert(as3.is_async == false)
//					return 1+5
//					]]>).toString();
			
			var b:ByteArray = new ByteArray();
			var filepath:String = File.applicationDirectory.nativePath + "\\appLuaResource\\test.lua";
			SPathUtils.o.readFileToByteArray(filepath,b);
			
			const libInitaializer:CLibInit = new CLibInit();
			libInitaializer.supplyFile("test.lua",b);
			
			
			trace(lua_wrapper.doFile(lua_state,"test.lua"));
//			trace(lua_wrapper.luaDoString(lua_state,script));
		}
	}
}