package lib.engine.game.module
{
	import lib.engine.iface.IFacadeModule;
	import lib.engine.utils.functions.Assert;
	
	/**
	 * 模块基类
	 * 所有子系统继承 CModuleSubSystem
	 * @author caihua
	 * 
	 */
	internal class CModuleBase implements IFacadeModule
	{
		protected var _isInit:Boolean = false;
		
		/**
		 * 是否只可以进入一次,
		 * true 只可以同时运行一个Module实例的 onEnter
		 * false 可以多次反复进入 onEnter  onEnter onEnter..... 
		 */
		protected var _onEnterOnce:Boolean = true;
		
		
		private var _onEntered:Boolean = false;
		
		private var _bDisposed:Boolean = false;

		/**
		 * 是否已经被销毁 
		 */
		public function get bDisposed():Boolean
		{
			return _bDisposed;
		}


		/**
		 * 是否已经进入了,如果_onEnterOnce 为False的时候,改属性一直为False 
		 */
		public function get onEntered():Boolean
		{
			if(_onEnterOnce == false)
				return false;
			return _onEntered;
		}
		private var _name:String;
		
		/**
		 * 系统名称,唯一索引 
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			_name = value;
		}

		/**
		 * 是否已经初始化了 
		 * @return T 初始化了 F 还没有
		 * 
		 */
		public function get isInit():Boolean
		{
			return _isInit;
		}

		public function CModuleBase()
		{
		}
		
		
		public final function Init(params:Object = null):void
		{
			if(_isInit)
				return;
			_isInit = true;
			
			_onInitBefore(params);
			_onInit(params);
			_onInitAfter(params);
		}
		
		public final function Enter(params:Object = null):void
		{
			if(_onEnterOnce == true)
			{
				if(onEntered)//已经进入了
				{
					Assert(false,"重复进入模块!" + name);
					return;
				}
			}
			
			_onEntered = true;
			
			
			_onEnter(params);
		}
		
		public final function Exit(params:Object = null):void
		{
			//不可以反复进入,自然不可以反复退出,
			//
			if(_onEnterOnce == true && !onEntered)
			{
				return
			}
			_onEntered = false;
			
			
			_onExit(params);
		}
		
		public final function Destroy(params:Object = null):void
		{
			if(_bDisposed == true)
				return;
			_bDisposed = true;
			
			_onDestroy(params);
		}
		
		/**
		 * 初始化之前 
		 * 
		 */
		protected function _onInitBefore(params:Object = null):void{};
		/**
		 * 初始化过程中 
		 * 
		 */
		protected function _onInit(params:Object = null):void{};
		/**
		 * 初始化之后 
		 * 
		 */
		protected function _onInitAfter(params:Object = null):void{};
		
		/**
		 * 进入系统 
		 * 
		 */
		protected function _onEnter(params:Object = null):void{};
		
		/**
		 * 退出系统 
		 * 
		 */
		protected function _onExit(params:Object = null):void{};
		
		/**
		 * 系统销毁 
		 * 
		 */
		protected function _onDestroy(params:Object = null):void{};
		
		
		
	}
}