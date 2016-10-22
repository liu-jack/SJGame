package com.lua
{
	import cmodule.lua_wrapper.*;
	
	import luaAlchemy.*;

	public class LuaImports
	{
		public function LuaImports()
		{
			lua_wrapper;
			CLibInit;
			LuaAlchemy;
		}
	}
}