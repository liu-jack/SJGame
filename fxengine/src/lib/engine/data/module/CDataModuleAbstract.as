package lib.engine.data.module
{
	import lib.engine.event.CEvent;
	import lib.engine.event.CEventSubject;
	import lib.engine.utils.CObjectUtils;

	/**
	 * 数据模块基类 
	 * @author caihua
	 * 
	 */
	public class CDataModuleAbstract extends  CDataModuleFunction //implements IEventSubject
	{
		
		private var _eventbus:CEventSubject;
		/**
		 * 远端数据管理器 
		 */
		private var _remoteDataManager:CDataModuleRemote;

		public function CDataModuleAbstract(name:String)
		{
			super(name);
		}
	
		/**
		 * 请求远端数据 
		 * 
		 */
		public final function getRemoteData(mRequest:CDataModuleRequestData):void
		{
			//自动执行远程函数
			_executeRemoteDataGetFunction(mRequest);
		}
		/**
		 * 请求本地数据
		 * @param e
		 * 
		 */
		public final function getData(mRequest:CDataModuleRequestData):CDataModuleAnswerData
		{
			
			var func:Function = _onGetDataFunction[mRequest.event_type];
			if(func != null)
			{
				
				//请求远端数据
				_remoteDataManager.RequestRemoteData(mRequest);
				//返回本地数据
				return func(mRequest);
			}
			return null;
		
		}
		/**
		 * 设置数据 
		 * @param mData
		 * 
		 */
		public final function setData(eventType:String,value:Object):void
		{
			_executeSetDataFunction(eventType,value);
		}

		/**
		 * 删除数据 
		 * @param eventType 数据类型	
		 * @param value 值
		 * 
		 */
		public final function delData(eventType:String,value:Object):void
		{
			_executeDelDataFunction(eventType,value);
		}
		override protected function _onInitBefore(params:Object = null):void
		{
			
			super._onInitBefore(params);
			_eventbus = new CEventSubject();
			_remoteDataManager = new CDataModuleRemote(this);

		}
		
		/**
		 * 通知数据变化 
		 * @param EventType 数据类型
		 * @param data 数据结构体
		 * 
		 */
		protected final function notifyDataChange(EventType:String,data:CDataModuleAnswerData):void
		{
			_eventbus.dispatchEvent(new CEvent(EventType,{'data':data}));
		}
		/**
		 * 通知数据变化
		 * @param EventType 数据类型
		 * @param value 数据,是clone的方式 不是引用
		 * @param hasValue 是否有数据
		 * @param RequestData 原始请求数据
		 * 
		 */
		protected final function notifyDataChangeByValue(EventType:String,value:Object,hasValue:Boolean = true,RequestData:CDataModuleRequestData = null):void
		{
			var answerdata:CDataModuleAnswerData = new CDataModuleAnswerData();
			answerdata.hasValue = hasValue;
			answerdata.RequestData = RequestData;
			answerdata.value = CObjectUtils.clone(value);
			notifyDataChange(EventType,answerdata);
		}
		/**
		 * 
		 * @param type
		 * @param listener
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * 
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_eventbus.addEventListener(type,listener,useCapture,priority,useWeakReference);			
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _eventbus.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_eventbus.removeEventListener(type,listener,useCapture);			
		}

		public function get remoteDataManager():CDataModuleRemote
		{
			return _remoteDataManager;
		}

	}
}