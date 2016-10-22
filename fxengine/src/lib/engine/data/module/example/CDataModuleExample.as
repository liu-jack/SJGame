package lib.engine.data.module.example
{
	import lib.engine.data.module.CDataModuleAbstract;
	import lib.engine.data.module.CDataModuleAnswerData;
	import lib.engine.data.module.CDataModuleRequestData;

	public class CDataModuleExample extends CDataModuleAbstract
	{
		private var data:int = -1;
		public function CDataModuleExample()
		{
			super("CDataModuleExample");
		}
//		override protected function onGetData(mRequest:CDataModuleRequestData):CDataModuleAnswerData
//		{
//			var dataanswer:CDataModuleAnswerData = new CDataModuleAnswerData();
//			dataanswer.RequestData = mRequest;
//			dataanswer.value = data;
//			if(data == -1)
//			{
//				dataanswer.hasValue = false;
//			}
//			else
//			{
//				dataanswer.hasValue = true;
//			}
//				
//			return dataanswer;
//		}
		
//		override protected function onGetRemoteDate(mRequest:CDataModuleRequestData):void
//		{
//			// TODO Auto Generated method stub
//			_getRemoteData(mRequest);
//		}
//		
//		override protected function onSetData(eventType:String, value:Object):void
//		{
//			// TODO Auto Generated method stub
//			super.onSetData(eventType, value);
//		}
		

		
		
		protected function _getRemoteData(mRequest:CDataModuleRequestData):void
		{
			if(mRequest.event_type == "getRemoteData")
			{
				//
				//
				//网路异步请求
				//.......................
				//
				
				onRemoteDataRecv(mRequest.event_type);
			}
		}
		
		protected function onRemoteDataRecv(eventtype:String):void
		{
			data = 0;
			var dataanswer:CDataModuleAnswerData = new CDataModuleAnswerData();
			dataanswer.RequestData = null;
			dataanswer.value = data;
			if(data == -1)
			{
				dataanswer.hasValue = false;
			}
			else
			{
				dataanswer.hasValue = true;
			}
			
			this.notifyDataChange(eventtype,dataanswer);
		}
		
		
		
	}
}