package lib.engine.data.module
{
	import flash.utils.Dictionary;
	
	import lib.engine.iface.game.IGameUpdate;

	public class CDataModuleRemote implements IGameUpdate
	{
		private var _CDataModule:CDataModuleAbstract
		private var _RequestContains:Dictionary = new Dictionary();
		public function CDataModuleRemote(mCDataModule:CDataModuleAbstract)
		{
			_CDataModule = mCDataModule;
		}
		
		/**
		 * 获取远端数据 
		 * @param module
		 * @param mRequest
		 * 
		 */
		public function RequestRemoteData(mRequest:CDataModuleRequestData):void
		{
			if(mRequest.request_type == CDataModuleRequestType.TYPE_Local_Request)
			{
				return;
			}
			if(_RequestContains[mRequest.request_type] == null)
			{
				_RequestContains[mRequest.request_type] = new Vector.<CDataModuleRemoteRequestData>();
			}
			var vec:Vector.<CDataModuleRemoteRequestData> = _RequestContains[mRequest.request_type];
			var mRemoteRequestData:CDataModuleRemoteRequestData = new CDataModuleRemoteRequestData(mRequest);
			vec.push(mRemoteRequestData);
			
			switch(mRequest.request_type)
			{
				case CDataModuleRequestType.TYPE_Immediately_Request:
				{
					_mergeRequestImmediately(vec);
					break;
				}
				case CDataModuleRequestType.TYPE_Timing_Request:
				{
					_mergeRequestTiming(vec);
					break;
				}
			}
			
		}
		
		/**
		 * 合并立即请求 
		 * @param vec
		 * 
		 */
		protected function _mergeRequestImmediately(vec:Vector.<CDataModuleRemoteRequestData>):void
		{
			//最后一个元素为检查主元素
			var mRequest:CDataModuleRemoteRequestData = vec[vec.length - 1];
			
			for(var i:int = vec.length - 1 - 1;i>=0;i--)
			{
				if(vec[i].Event_Type == mRequest.Event_Type 
				&& vec[i].Data.params == mRequest.Data.params)
				{
					vec.splice(i,1);
				}
			}
		}
		
		protected function _mergeRequestTiming(vec:Vector.<CDataModuleRemoteRequestData>):void
		{
			//最后一个元素为检查主元素
			var mRequest:CDataModuleRemoteRequestData = vec[vec.length - 1];
			
			for(var i:int = vec.length - 1 - 1;i>=0;i--)
			{
				if(vec[i].Event_Type == mRequest.Event_Type 
					&& vec[i].Data.params == mRequest.Data.params)
				{
					vec.splice(i,1);
				}
			}
		}
		
		public function update(currenttime:Number, escapetime:Number):void
		{
			var vec:Vector.<CDataModuleRemoteRequestData> = _RequestContains[CDataModuleRequestType.TYPE_Immediately_Request];
			if(vec != null)
			{
				updateRequest(vec,currenttime,escapetime);
				while(null != vec.pop()){};
			}
			
			vec = _RequestContains[CDataModuleRequestType.TYPE_Timing_Request];
			if(vec != null)
			{
				updateRequest(vec,currenttime,escapetime);
			}

		}
		
		protected function updateRequest(vec:Vector.<CDataModuleRemoteRequestData>,currenttime:Number, escapetime:Number):void
		{
			for each(var mRequest:CDataModuleRemoteRequestData in vec)
			{
				if(mRequest.RequestLoop)
				{
					mRequest.RequestLefttime -= escapetime;
					if(mRequest.RequestLefttime < 0)
					{
						_CDataModule.getRemoteData(mRequest.Data);
						mRequest.RequestLefttime = mRequest.RequestSpace;
					}
				}
				else
				{
					_CDataModule.getRemoteData(mRequest.Data);
					//mRequest.
				}
			}
		}
		
	}
}