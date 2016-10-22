package lib.engine.game.module
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import engine_starling.utils.Logger;
	import engine_starling.utils.SObjectUtils;
	
	import luaAlchemy.LuaAlchemy;

	public class CModuleLuaWrapper extends CModuleBase
	{
		public function CModuleLuaWrapper()
		{
			super();
		}
		
		
		/**
		 * lua控制台 
		 */
		private static var _luaconsoles:Dictionary = new Dictionary();
		/**
		 * 本地lua控制台映射 
		 */		
		private var _luaconsole:LuaAlchemy = null;
		
		/**
		 * 注册lua控制台 
		 * @param luaconsole
		 * 
		 */
		public final function genLuaConsole(luabytes:ByteArray):void
		{
			var luaconsole:LuaAlchemy = _luaconsoles[name];
			if(luaconsole == null)
			{
				luaconsole = new LuaAlchemy(null,false);
				luaconsole.init();
				luaconsole.setGlobal("print",Logger.getInstance(SObjectUtils.getClassByObject(this)).debug);
				_luaconsoles[name] = luaconsole;
				luaconsole.supplyFile(name,luabytes);
				luaconsole.doFile(name);
				
			}
			_luaconsole = luaconsole;
			
		}
		
		/**
		 * 反注册lua控制台 
		 * 
		 */
		public final function unregisterLuaConsole():void
		{
			var oldluaconsole:LuaAlchemy = _luaconsoles[name];
			if(oldluaconsole != null)
			{
				oldluaconsole.close();
				delete _luaconsoles[name]
				_luaconsole = null;
			}
		}
		/**
		 * 获取lua控制台 
		 * @return 
		 * 
		 */
		public function get LuaConsole():LuaAlchemy
		{
			if(_luaconsoles == null)
			{
				_luaconsole = _luaconsoles[name]
			}
			return _luaconsole;
		}
		
		/**
		 * 执行lua String 
		 * @param script
		 * @return 
		 * 
		 */
		[inline]
		protected function _doLuaString(script:String):*
		{
			var luaconsole:LuaAlchemy = LuaConsole;
			
			
			if(luaconsole != null)
			{
				luaconsole.setGlobal("this",this);
				return luaconsole.doString(script);		
			}
			return null;
		}
		
		override protected function _onDestroy(params:Object=null):void
		{
			if(LuaConsole != null)
			{
				LuaConsole.setGlobal("params",params);
			}
			_doLuaString("onDestory()");
			super._onDestroy(params);
		}
		
		override protected function _onEnter(params:Object=null):void
		{
			if(LuaConsole != null)
			{
				LuaConsole.setGlobal("params",params);
			}
			_doLuaString("onEnter()");
			super._onEnter(params);
		}
		
		override protected function _onExit(params:Object=null):void
		{
			if(LuaConsole != null)
			{
				LuaConsole.setGlobal("params",params);
			}
			_doLuaString("onExit()");
			super._onExit(params);
		}
		
		override protected function _onInit(params:Object=null):void
		{
			if(LuaConsole != null)
			{
				LuaConsole.setGlobal("params",params);
			}
			_doLuaString("onInit()");
			super._onInit(params);
		}
		
		override protected function _onInitAfter(params:Object=null):void
		{
			if(LuaConsole != null)
			{
				LuaConsole.setGlobal("params",params);
			}
			_doLuaString("onInitAfter()");
			super._onInitAfter(params);
		}
		
		override protected function _onInitBefore(params:Object=null):void
		{
			if(LuaConsole != null)
			{
				LuaConsole.setGlobal("params",params);
			}
			_doLuaString("onInitBefore()");
			super._onInitBefore(params);
		}
	}
}