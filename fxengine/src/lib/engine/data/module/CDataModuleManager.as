package lib.engine.data.module
{
	import flash.events.TimerEvent;
	
	import lib.engine.game.module.CModuleSubSystem;
	import lib.engine.game.module.CModuleSubSystemManager;
	import lib.engine.iface.data.IDataModuleRecvier;
	import lib.engine.utils.CTickUtils;
	import lib.engine.utils.CTimerUtils;
	import lib.engine.utils.functions.Assert;

	/**
	 * 数据管理模块 
	 * @author caihua
	 * 
	 */
	
	public class CDataModuleManager extends CModuleSubSystem
	{
		private var _moduleManager:CModuleSubSystemManager;
		private var _modulecontains:Vector.<CDataModuleAbstract>;
		private var _lastticktime:Number;
//		/**
//		 * 模块事件总线 
//		 */

		
		override protected function _onInitBefore(params:Object = null):void
		{
			_moduleManager = new CModuleSubSystemManager();
			_modulecontains = new Vector.<CDataModuleAbstract>();
		}
		
		override protected function _onInit(params:Object = null):void
		{
			_moduleManager.Init();
		}
		
		override protected function _onInitAfter(params:Object = null):void
		{
			CTickUtils.o.addTick("CDataModuleManager",50,int.MAX_VALUE,_onTick);
			_lastticktime = CTimerUtils.getCurrentTime();
		}
		public function CDataModuleManager()
		{
			super("CDataModuleManager");
		}

		
		
		
		/**
		 * 注册数据模块 
		 * @param module
		 * 
		 */
		public function Register(module:CDataModuleAbstract):void
		{
			_moduleManager.registerAndInit(module);
			_moduleManager.enterModule(module.name);
			_modulecontains.push(module);
		}
		
		/**
		 * 获取数据 
		 * @param mRequest
		 * @return 
		 * 
		 */
		public function getData(mRequest:CDataModuleRequestData):CDataModuleAnswerData
		{
			var module:CDataModuleAbstract = CDataModuleAbstract(_moduleManager.getModule(mRequest.moduleName));
			Assert(module != null,"数据获取时,数据模块为空 name[" + mRequest.moduleName + "]");
			if(module == null)
				return null;
			
			//请求远端数据
			//返回当前数据模块中的数据
			return module.getData(mRequest);
			
		}
		/**
		 * 自动获取获取数据 
		 * @param mRequest
		 * @return 
		 * 
		 */
		public function getData_Auto(mRequest:CDataModuleRequestData):CDataModuleAnswerData
		{
//			var module:CDataModuleAbstract = CDataModuleAbstract(_moduleManager.getModule(mRequest.moduleName));
//			Assert(module != null,"数据获取时,数据模块为空 name[" + mRequest.moduleName + "]");
//			if(module == null)
//				return null;
			var rtn:CDataModuleAnswerData;
			for each(var obj:CDataModuleAbstract in  _modulecontains)
			{
				rtn = obj.getData(mRequest);
				if(rtn != null)
					return rtn;
			}
			//请求远端数据
			//			module.remoteDataManager.RequestRemoteData(mRequest);
			//返回当前数据模块中的数据
			return new CDataModuleAnswerData();
			
		}
		
		/**
		 * 自动调用获取本地数据 
		 * 底层调用 getdata
		 * @param event_type 事件ID
		 * @param params 参数
		 * @return 
		 * 
		 */
		public function getDataLocal_Auto(event_type:String,params:Object = null):CDataModuleAnswerData
		{
			return getData_Auto(new CDataModuleRequestData("",event_type,CDataModuleRequestType.TYPE_Local_Request,1000,params));
		}
		/**
		 * 立刻请求网络数据
		 * @param moduleName 模块名称
		 * @param event_type 事件ID
		 * @param params 参数
		 * @return 
		 * 
		 */
		public function getDataRemoteImmediate_Auto(event_type:String,params:Object = null):CDataModuleAnswerData
		{
			return getData_Auto(new CDataModuleRequestData("",event_type,CDataModuleRequestType.TYPE_Immediately_Request,1000,params));
		}
		/**
		 * 定时请求网络数据 
		 * @param moduleName 模块名称
		 * @param event_type 事件ID
		 * @param params 参数
		 * @param requeset_space 事件间隔
		 * @return 
		 * 
		 */
		public function getDataTiming_Auto(event_type:String,params:Object = null,requeset_space:int = 1000):CDataModuleAnswerData
		{
			return getData_Auto(new CDataModuleRequestData("",event_type,CDataModuleRequestType.TYPE_Timing_Request,requeset_space,params));
		}
		/**
		 * 获取本地数据 
		 * 底层调用 getdata
		 * @param moduleName 模块名称
		 * @param event_type 事件ID
		 * @param params 参数
		 * @return 
		 * 
		 */
		public function getDataLocal(moduleName:String,event_type:String,params:Object = null):CDataModuleAnswerData
		{
			return getData(new CDataModuleRequestData(moduleName,event_type,CDataModuleRequestType.TYPE_Local_Request,1000,params));
		}
		
		/**
		 * 立刻请求网络数据
		 * @param moduleName 模块名称
		 * @param event_type 事件ID
		 * @param params 参数
		 * @return 
		 * 
		 */
		public function getDataRemoteImmediate(moduleName:String,event_type:String,params:Object = null):CDataModuleAnswerData
		{
			return getData(new CDataModuleRequestData(moduleName,event_type,CDataModuleRequestType.TYPE_Immediately_Request,1000,params));
		}
		
		/**
		 * 定时请求网络数据 
		 * @param moduleName 模块名称
		 * @param event_type 事件ID
		 * @param params 参数
		 * @param requeset_space 事件间隔
		 * @return 
		 * 
		 */
		public function getDataTiming(moduleName:String,event_type:String,params:Object = null,requeset_space:int = 1000):CDataModuleAnswerData
		{
			return getData(new CDataModuleRequestData(moduleName,event_type,CDataModuleRequestType.TYPE_Timing_Request,requeset_space,params));
		}
		

		/**
		 * 设置数据,主要用于本地缓存,也可以用户主控模块的设置数据 
		 * @param modulename 模块名称
		 * @param eventType 数据事件ID
		 * @param value 数据
		 * 
		 */
		public function setData(modulename:String,eventType:String,value:Object):void
		{
			var module:CDataModuleAbstract = CDataModuleAbstract(_moduleManager.getModule(modulename));
			Assert(module != null,"数据设置,数据模块为空 name[" + modulename + "]");
			if(module == null)
				return;
			module.setData(eventType,value);
		}
		/**
		 * 设置数据,主要用于本地缓存,也可以用户主控模块的设置数据 
		 * @param eventType 数据事件ID
		 * @param value 数据
		 * 
		 */
		public function setData_Auto(eventType:String,value:Object):void
		{
			for each(var obj:CDataModuleAbstract in  _modulecontains)
			{
				obj.setData(eventType,value);
			}
		}
		
		/**
		 * 删除数据 
		 * @param modulename 模块名称
		 * @param eventType 数据事件ID
		 * @param value 数据
		 * 
		 */
		public function delData(modulename:String,eventType:String,value:Object):void
		{
			var module:CDataModuleAbstract = CDataModuleAbstract(_moduleManager.getModule(modulename));
			Assert(module != null,"数据删除,数据模块为空 name[" + modulename + "]");
			if(module == null)
				return;
			module.delData(eventType,value);
		}

		/**
		 * 删除数据 
		 * @param eventType 数据事件ID
		 * @param value 数据
		 * 
		 */
		public function delData_Auto(eventType:String,value:Object):void
		{
			for each(var obj:CDataModuleAbstract in  _modulecontains)
			{
				obj.delData(eventType,value);
			}
		}
		
		public function addEventListener_Auto(EventType:String,listener:IDataModuleRecvier):void
		{
			for each(var obj:CDataModuleAbstract in  _modulecontains)
			{
				obj.addEventListener(EventType,listener.onDataRecv);
			}
		}
		public function removeEventListener_Auto(EventType:String,listener:IDataModuleRecvier):void
		{
			for each(var obj:CDataModuleAbstract in  _modulecontains)
			{
				obj.removeEventListener(EventType,listener.onDataRecv);
			}
		}
		public function addEventListener(ModuleName:String,EventType:String,listener:IDataModuleRecvier):void
		{
			var module:CDataModuleAbstract = CDataModuleAbstract(_moduleManager.getModule(ModuleName));
			Assert(module != null,"数据模块注册时,数据模块为空 name[" + ModuleName + "]");
			if(module == null)
				return;
			module.addEventListener(EventType,listener.onDataRecv);
		}
		
		public function removeEventListener(ModuleName:String,EventType:String,listener:IDataModuleRecvier):void
		{
			var module:CDataModuleAbstract = CDataModuleAbstract(_moduleManager.getModule(ModuleName));
			Assert(module != null,"数据模块removeEventListener时,数据模块为空 name[" + ModuleName + "]");
			if(module == null)
				return;
			module.removeEventListener(EventType,listener.onDataRecv);
		}
		
		protected function _onTick(e:TimerEvent,params:Object):void
		{
			var currentTime:Number = CTimerUtils.getCurrentTime();
			var escapetime:Number = currentTime - _lastticktime;
			_lastticktime = currentTime;
			for each(var mdata:CDataModuleAbstract in _modulecontains)
			{
				mdata.remoteDataManager.update(currentTime,escapetime);
			}
		}
		

	}
}