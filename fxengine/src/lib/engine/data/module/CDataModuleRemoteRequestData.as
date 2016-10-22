package lib.engine.data.module
{
	/**
	 * 远端请求结构体 
	 * @author caihua
	 * 
	 */
	public class CDataModuleRemoteRequestData
	{
		private var _RequestLoop:Boolean = false;
		private var _RequestLefttime:Number = 0;
		private var _Data:CDataModuleRequestData = null;
		private var _RequestSpace:Number = 0;
		private var _Event_Type:String;
		
		/**
		 * 通过  CDataModuleRequestData 构建
		 * @param data
		 * 
		 */
		public function CDataModuleRemoteRequestData(data:CDataModuleRequestData)
		{
			_Data = data;
			if(_Data.request_type == CDataModuleRequestType.TYPE_Timing_Request)
			{
				_RequestLoop = true;
			}
			
			_RequestSpace = _Data.request_space;
			_RequestLefttime = _RequestSpace;
			_Event_Type = _Data.event_type;
		}

		/**
		 * 是否为循环请求 
		 */
		public function get RequestLoop():Boolean
		{
			return _RequestLoop;
		}

		/**
		 * @private
		 */
		public function set RequestLoop(value:Boolean):void
		{
			_RequestLoop = value;
		}

		/**
		 * 请求剩余时间 
		 */
		public function get RequestLefttime():Number
		{
			return _RequestLefttime;
		}

		/**
		 * @private
		 */
		public function set RequestLefttime(value:Number):void
		{
			_RequestLefttime = value;
		}

		/**
		 * 请求时间间隔 
		 */
		public function get RequestSpace():Number
		{
			return _RequestSpace;
		}

		/**
		 * @private
		 */
		public function set RequestSpace(value:Number):void
		{
			_RequestSpace = value;
		}

		/**
		 * 消息类型 
		 */
		public function get Event_Type():String
		{
			return _Event_Type;
		}

		/**
		 * @private
		 */
		public function set Event_Type(value:String):void
		{
			_Event_Type = value;
		}

		/**
		 * 原始请求数据 
		 */
		public function get Data():CDataModuleRequestData
		{
			return _Data;
		}

		/**
		 * @private
		 */
		public function set Data(value:CDataModuleRequestData):void
		{
			_Data = value;
		}


	}
}