package lib.engine.net
{
	import lib.engine.utils.functions.Assert;
	
	/**
	 * Amf返回助手解析类 
	 * @author caihua
	 * 
	 */
	public class CAmfCallRtn
	{
		private var _data:Object;
		/**
		 * Amf调用回复助手类 
		 * @param amfReturn amf 返回类
		 * 
		 */
		public function CAmfCallRtn(amfReturn:Object)
		{
			_data = amfReturn;
			if(!_data.hasOwnProperty("phpfunc"))
			{
				Assert(false,"CAmfCallRtn 返回错误,不包含 phpfunc属性");
			}
			if(!_data.hasOwnProperty("func"))
			{
				Assert(false,"CAmfCallRtn 返回错误,不包含 result属性");
			}
			if(!_data.hasOwnProperty("data"))
			{
				Assert(false,"CAmfCallRtn 返回错误,不包含 data属性");
			}
			
			
			if(!_data.data.hasOwnProperty("result"))
			{
				Assert(false,"CAmfCallRtn 返回错误,不包含 data.result属性");
			}
			
			if(!_data.data.hasOwnProperty("code"))
			{
				Assert(false,"CAmfCallRtn 返回错误,不包含 data.code属性");
			}
			
			if(!_data.data.hasOwnProperty("data"))
			{
				Assert(false,"CAmfCallRtn 返回错误,不包含 data.data属性");
			}
		}
		
		/**
		 * 返回包含数据 
		 * @return 
		 * 
		 */
		public function get data():Object
		{
			return _data.data.data;
		}
		
		/**
		 * 是否执行成功 
		 * @return 
		 * 
		 */
		public function get succ():Boolean
		{
			return String(_data.data.result) == "succ";
		}
		
		/**
		 * 错误或者正确代码 
		 * @return 
		 * 
		 */
		public function get code():int
		{
			return int(_data.data.code);
		}
		
		/**
		 * php完整函数 
		 * @return 
		 * 
		 */
		public function get phpfunc():String
		{
			return String(_data.phpfunc);
		}
		
		/**
		 * 函数短名称 
		 * @return 
		 * 
		 */
		public function get func():String
		{
			return String(_data.func);
		}
	}
}