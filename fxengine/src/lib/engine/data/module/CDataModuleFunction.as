package lib.engine.data.module
{
	import lib.engine.game.module.CModuleSubSystem;
	
	/**
	 * 数据模块操作函数类 
	 * @author caihua
	 * 
	 */
	public class CDataModuleFunction extends CModuleSubSystem
	{
		/**
		 * 远端数据获取函数列表
		 * Function(args:CDataModuleRequestData):void 
		 */
		private var _remoteDataGetFunction:Object;
		
		/**
		 * 设置数据函数列表 
		 */
		private var _onSetDataFunction:Object;
		
		/**
		 * 获取数据函数列表 
		 */
		protected var _onGetDataFunction:Object;
		
		/**
		 * 删除数据函数列表 
		 */
		private var _onDelDataFunction:Object;
		
		public function CDataModuleFunction(name:String)
		{
			super(name);
		}
		
		/**
		 * 注册本地删除数据函数 
		 * @param eventType
		 * @param func Function(value:Object):void
		 * 
		 */
		protected function _registeDelDataFunction(eventType:String,func:Function):void
		{
			_onDelDataFunction[eventType] = func;
		}
		/**
		 * 取消注册本地删除数据函数
		 * @param eventType
		 *
		 * 
		 */
		protected function  _unregisteDelDataFunction(eventType:String):void
		{
			_onDelDataFunction[eventType] = null;
		}
		
		/**
		 * 本地删除数据函数
		 * @param mRequest
		 * 
		 */
		protected function _executeDelDataFunction(eventType:String,value:Object):void
		{
			if(_onDelDataFunction[eventType]!= null)
			{
				_onDelDataFunction[eventType](value);
			}
		}
		/**
		 * 注册本地获取数据函数 
		 * @param eventType
		 * @param func Function(mRequest:CDataModuleRequestData):CDataModuleAnswerData
		 * 
		 */
		protected function _registeGetDataFunction(eventType:String,func:Function):void
		{
			_onGetDataFunction[eventType] = func;
		}
		/**
		 * 取消注册本地获取数据函数 
		 * @param eventType
		 *
		 * 
		 */
		protected function  _unregisteGetDataFunction(eventType:String):void
		{
			_onGetDataFunction[eventType] = null;
		}
		
		/**
		/**
		 * 注册本地设置数据函数 
		 * @param eventType
		 * @param func Function(value:Object):void
		 * 
		 */
		protected function _registeSetDataFunction(eventType:String,func:Function):void
		{
			_onSetDataFunction[eventType] = func;
		}
		/**
		 * 取消注册本地设置数据函数 
		 * @param eventType
		 *
		 * 
		 */
		protected function  _unregisteSetDataFunction(eventType:String):void
		{
			_onSetDataFunction[eventType] = null;
		}
		/**
		 * 自动执行数据设置函数 
		 * @param mRequest
		 * 
		 */
		protected function _executeSetDataFunction(eventType:String,value:Object):void
		{
			if(_onSetDataFunction[eventType]!= null)
			{
				_onSetDataFunction[eventType](value);
			}
		}
		/**
		 * 注册远程数据获取函数 
		 * @param eventType
		 * @param func Function(args:CDataModuleRequestData):void 
		 * 
		 */
		protected function _registeRemoteDataGetFunction(eventType:String,func:Function):void
		{
			_remoteDataGetFunction[eventType] = func;
		}
		/**
		 * 取消书册远程数据获取函数 
		 * @param eventType
		 * 
		 * 
		 */
		protected function _unregisterRemoteDataGetFunction(eventType:String):void
		{
			_remoteDataGetFunction[eventType] = null;
		}
		
		/**
		 * 自动执行远端访问函数 
		 * @param mRequest
		 * 
		 */
		protected function _executeRemoteDataGetFunction(mRequest:CDataModuleRequestData):void
		{
			if(_remoteDataGetFunction[mRequest.event_type]!= null)
			{
				_remoteDataGetFunction[mRequest.event_type](mRequest);
			}
		}
		
		override protected function _onInitBefore(params:Object=null):void
		{
			super._onInitBefore(params);
			_remoteDataGetFunction = new Object();
			_onSetDataFunction = new Object();
			_onGetDataFunction = new Object();
			_onDelDataFunction = new Object();
		}
		
		
		
		
		
	}
}