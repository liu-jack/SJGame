package engine_starling.display
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import engine_starling.utils.Logger;
	import engine_starling.utils.SObjectUtils;
	
	import luaAlchemy.LuaAlchemy;

	public class SNodeLuaWrapper extends SNode
	{
		public function SNodeLuaWrapper()
		{
			super();
		}
		/**
		 * SLayerlua容器类
		 */
		private static var _luaconsolesdict:Dictionary = new Dictionary();
		
		private var _luaconsolefactory:Function;
		/**
		 * lua工厂构造器  
		 * @return function():ByteArray
		 * 
		 */
		
		public function get luaconsolefactory():Function
		{
			return _luaconsolefactory;
		}
		
		/**
		 * @private
		 */
		public function set luaconsolefactory(value:Function):void
		{
			_luaconsolefactory = value;
		}
		
		private var _luaConsole:LuaAlchemy;
		
		/**
		 * 获取lua控制台 
		 */
		[inline]
		public function get luaConsole():LuaAlchemy
		{
			if(_luaConsole != null)
			{
				return _luaConsole;
			}
			if(_luaconsolefactory != null)
			{
				registerLuaCtrl(_luaconsolefactory());
			}
			return _luaConsole;
		}
		
		
		override protected function draw():void
		{
			doLuaString("draw()");
			super.draw();
		}
		
		override protected function initialize():void
		{
			doLuaString("initialize()");
			super.initialize();
		}
		
		override public function dispose():void
		{
			doLuaString("dispose()");
			unregisertLuaCtrl();
			_luaconsolefactory = null;
			super.dispose();
		}
		
		
		/**
		 * 执行lua 
		 * @param s
		 * @return 
		 * 
		 */
		[inline]
		public function doLuaString(s:String):*
		{
			if(luaConsole != null)
			{
				_luaConsole.setGlobal("this",this);
				return _luaConsole.doString(s);
			}
			return null;
		}
		
		/**
		 * 注册lua控制台 
		 * @param luabytes
		 * 
		 */
		[inline]
		public function registerLuaCtrl(luabytes:ByteArray):void
		{
			if(_luaConsole != null)
			{
				return;
			}
			var luaconsolename:String = SObjectUtils.getClassFullName(this);
			if(_luaconsolesdict[luaconsolename] != null)
			{
				_luaConsole = _luaconsolesdict[luaconsolename];
				return;
			}
			_luaConsole = new LuaAlchemy(null,false);
			_luaConsole.init();
			_luaConsole.setGlobal("print",Logger.getInstance(SObjectUtils.getClassByObject(this)).debug);
			_luaConsole.supplyFile("test.lua",luabytes);
			_luaConsole.doFile("test.lua");
			
			
			_luaconsolesdict[luaconsolename] = _luaConsole;
			
			
		}
		/**
		 * 反注册lua控制台 
		 * 
		 */
		public function unregisertLuaCtrl():void
		{
			if(_luaConsole != null)
			{
				_luaConsole = null;
			}
		}

		
	}
}