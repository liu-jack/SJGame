package lib.engine.data.module
{
	/**
	 * 数据请求模块 
	 * @author caihua
	 * 
	 */
	public class CDataModuleRequestData
	{
		private var _request_type:String = CDataModuleRequestType.TYPE_Local_Request;
		private var _request_space:int = 0;
		private var _event_type:String;
		private var _moduleName:String;
		private var _params:Object;
		/**
		 *  构造函数
		 *
		 * @param moduleName 请求模块名称
		 * @param event_type 事件类型
		 * @param request_type 请求类型 CDataModuleRequestType
		 * @param requeset_space 请求时间间隔
		 * @param params 如果为setdata 则为赋值字段
		 * 
		 */
		public function CDataModuleRequestData(moduleName:String,event_type:String,
											   request_type:String = "TYPE_Local_Request"
											   ,requeset_space:int = 1000,params:Object = null)
		{
			this.request_type = request_type;
			this.event_type = event_type;
			this.moduleName = moduleName;
			this.request_space = requeset_space;
			this.params = params;
		}

		/**
		 * 请求类型 
		 */
		public function get request_type():String
		{
			return _request_type;
		}

		/**
		 * @private
		 */
		public function set request_type(value:String):void
		{
			_request_type = value;
		}

		/**
		 * 事件类型 
		 */
		public function get event_type():String
		{
			return _event_type;
		}

		/**
		 * @private
		 */
		public function set event_type(value:String):void
		{
			_event_type = value;
		}

		/**
		 * 模块名称 
		 */
		public function get moduleName():String
		{
			return _moduleName;
		}

		/**
		 * @private
		 */
		public function set moduleName(value:String):void
		{
			_moduleName = value;
		}

		/**
		 * 间隔请求时间间隔 
		 */
		public function get request_space():int
		{
			return _request_space;
		}

		/**
		 * @private
		 */
		public function set request_space(value:int):void
		{
			_request_space = value;
		}

		public function get params():Object
		{
			return _params;
		}

		public function set params(value:Object):void
		{
			_params = value;
		}


	}
}