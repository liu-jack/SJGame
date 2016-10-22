package lib.engine.game.module
{
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	
	import engine_starling.utils.SObjectUtils;
	
	import lib.engine.iface.IFacadeModule;
	import lib.engine.iface.modules.IModuleManager;
	import lib.engine.utils.functions.Assert;

	/**
	 * 子系统管理器 
	 * @author caihua
	 * 
	 */
	public class CModuleSubSystemManager extends CModuleBase implements IModuleManager
	{
		public function CModuleSubSystemManager()
		{
		}
		/**
		 * 系统集合 
		 */
		private var _SystemContains:Dictionary = new Dictionary();
		private var _regClassContains:Dictionary = new Dictionary();
		
		/**
		 * 注册类 
		 * @param regclass
		 * @return 
		 * 
		 */
		public function registerClass(regclass:Class):Boolean
		{
			var classShortName:String = SObjectUtils.getClassName(regclass);
			_regClassContains[classShortName] = regclass;
			return true;
		}
		
		public function unregisterClass(regName:String):Boolean
		{
//			var classShortName:String = SObjectUtils.getClassName(regclass);
			exitModByClass(regName);
			delete _regClassContains[regName];
			return true;
		}
		
		/**
		 * 注册并初始化 
		 * @param regclass
		 * @param params
		 * @return 
		 * 
		 */
		protected function registerAndInitByClass(regclass:Class,params:Object = null):Boolean
		{
			var classShortName:String = SObjectUtils.getClassName(regclass);
			registerClass(regclass);
			var module:CModuleSubSystem = _SystemContains[classShortName] as CModuleSubSystem;
			if(module == null)
			{
				var moduleClass:Class = _regClassContains[classShortName];
				if(moduleClass != null)
				{
					module = new moduleClass()
					_SystemContains[classShortName] = module;
				}
			}
			if(module == null)
			{
				trace("module registerAndInitByClass error! module is not found! " + classShortName);
				return false;
			}
			
			if(!module.isInit)
			{
				module.Init();
			}
			return true
		}
		
		/**
		 * 通过类名进入类 
		 * @param modulename 短名称。例如 xxx
		 * @param params
		 * @return 
		 * 
		 */
		protected function enterModByClass(modulename:String,params:Object = null):Boolean
		{
			var module:CModuleSubSystem = _SystemContains[modulename] as CModuleSubSystem;
			if(module == null)
			{
				var moduleClass:Class = _regClassContains[modulename];
				if(moduleClass != null)
				{
					module = new moduleClass();
					_SystemContains[modulename] = module;
				}
			}
			if(module == null)
			{
				trace("module enter error! module is not found! " + modulename);
				return false;
			}
			
			if(!module.isInit)
			{
				module.Init();
			}
			module.Enter(params);
			return true;
		}
		
		/**
		 * 通过类名退出 
		 * @param modulename
		 * @param params
		 * @return 
		 * 
		 */
		protected function exitModByClass(modulename:String,params:Object = null):Boolean
		{
			var module:CModuleSubSystem = _SystemContains[modulename] as CModuleSubSystem;
			if(module == null)
			{
				return false;
			}
			
			module.Exit(params);
			
			
			return true;
		}
		
		protected function destroyModByClass(modulename:String,params:Object = null):Boolean
		{
			var module:CModuleSubSystem = _SystemContains[modulename] as CModuleSubSystem;
			if(module == null)
			{
				return false;
			}
			
			module.Destroy(params);
			
			delete _SystemContains[modulename];
			
			return true;
		}
		
		/**
		 * 注册模块 
		 * @param reg 模块实例 CModuleSubSystem
		 * @return 
		 * 
		 */
		public function register(reg:CModuleSubSystem):Boolean
		{
			var modclass:Class = SObjectUtils.getClassByObject(reg);
			return registerClass(modclass);
			
//			Assert(_isInit,"CModuleSubSystemManager 没有初始化了");
//			Assert(reg is CModuleSubSystem,"注册类型不正确");
//			var _reg:CModuleSubSystem = reg as CModuleSubSystem;
//			Assert(_reg.name != null && _reg.name != "","模块名称无效");
//			
//			if(_SystemContains[_reg.name] != null)
//			{
//				Assert(false,"模块[" + _reg.name + "]已经被注册!");
//				return false;
//			}
//			_SystemContains[_reg.name] = reg;
			
//			return true;
		}
		
		/**
		 * 注册并且初始化 
		 * @param reg
		 * @return 
		 * 
		 */
		public function registerAndInit(reg:CModuleSubSystem,params:Object = null):Boolean
		{
			var modclass:Class = SObjectUtils.getClassByObject(reg);
			return registerAndInitByClass(modclass,params);
//			if(register(reg) == false)
//				return false;
//			var _reg:CModuleSubSystem = reg as CModuleSubSystem;
//			if(!_SystemContains[_reg.name].isInit)
//				_SystemContains[_reg.name].Init(params);
//			return true;
		}
		
		/**
		 * 取消注册 
		 * @param reg 模块实例名称
		 * @return 
		 * 
		 */
		public function unregister(regName:String):Boolean
		{
			return unregisterClass(regName);
//			Assert(regName is String,"模块名称类型不正确");
//			var modulename:String = regName as String;
//			Assert(modulename != null && modulename != "","模块名称无效");
//			if(_SystemContains[modulename] == null)
//			{
//				Assert(false,"模块[" + modulename + "]取消注册失败,模块不存在!");
//				return false;
//			}
//			delete _SystemContains[modulename];
//			return true;
		}
		
		
		/**
		 * 进入模块 
		 * @param modulename 模块名称
		 * @return 
		 * 
		 */
		public function enterModule(modulename:String,params:Object = null):Boolean
		{
			return enterModByClass(modulename,params);
//			var module:CModuleSubSystem = _SystemContains[modulename] as CModuleSubSystem;
//			if(module == null)
//			{
//				Assert(false,"没有找到对应的模块[{0}]",modulename);
//				return false;
//			}
//			
//			if(!module.isInit)
//			{
//				module.Init();
//			}
//			module.Enter(params);
//			return true;
			
		}
		
		/**
		 * 退出模块 并销毁
		 * @param modulename 模块名称
		 * @return 
		 * 
		 */
		public function exitModule(modulename:String,params:Object = null):Boolean
		{
			return exitModByClass(modulename,params);
//			var module:CModuleSubSystem = _SystemContains[modulename] as CModuleSubSystem;
//			if(module == null)
//			{
//				return false;
//			}
//			module.Exit(params);
//			return true;
		}
		
		/**
		 * 销毁模块,并取消注册
		 * @param modulename
		 * 
		 */
		public function DestroyModule(modulename:String,params:Object = null):Boolean
		{
			return destroyModByClass(modulename,params);
//			var module:CModuleSubSystem = _SystemContains[modulename] as CModuleSubSystem;
//			if(module == null)
//			{
//				return false;
//			}
//			module.Destroy(params);
//			
//			//需要注册
//			unregister(modulename);
		}
		
		/**
		 * 获得模块,通过模块名称 
		 * @param modulename
		 * @return 如果没有 返回null
		 * 
		 */
		public function getModule(modulename:String):IFacadeModule
		{
			return _SystemContains[modulename];
		}
		
		public function getModules():Dictionary
		{
			return _SystemContains;
		}
	}
}