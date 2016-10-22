package lib.engine.data.module
{
	import lib.engine.utils.CObjectUtils;

	/**
	 * 数据模块应答数据 
	 * @author caihua
	 * 
	 */
	public class CDataModuleAnswerData 
	{
		private var _hasValue:Boolean = false;
		private var _value:* = null;
		private var _RequestData:CDataModuleRequestData;
		/**
		 * 对象 
		 * @param value 具体对象
		 * @param hasValue 是否有值
		 * @param RequestData 原始请求数据
		 * @param CloneData 是否克隆数据,默认clone
		 * 
		 */
		public function CDataModuleAnswerData(value:* = null,hasValue:Boolean = false,RequestData:CDataModuleRequestData = null,CloneData:Boolean = true)
		{
			if(CloneData)
			{
				this.value = CObjectUtils.clone(value);
			}
			else
			{
				this.value = value;
			}
			this.hasValue = hasValue;
			this.RequestData = RequestData;
		}

		/**
		 * 是否包含数据 
		 */
		public function get hasValue():Boolean
		{
			return _hasValue;
		}

		/**
		 * @private
		 */
		public function set hasValue(value:Boolean):void
		{
			_hasValue = value;
		}

		/**
		 * 数据 
		 */
		public function get value():*
		{
			return _value;
		}

		/**
		 * @private
		 */
		public function set value(value:*):void
		{
			_value = value;
		}

		/**
		 * 原始请求数据 
		 */
		public function get RequestData():CDataModuleRequestData
		{
			return _RequestData;
		}

		/**
		 * @private
		 */
		public function set RequestData(value:CDataModuleRequestData):void
		{
			_RequestData = value;
		}


	}
}