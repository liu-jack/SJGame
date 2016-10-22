package lib.engine.utils
{
	/**
	 * String的助手类
	 *  
	 * @author caihua
	 * 
	 */
	public class CStringUtils
	{
		public function CStringUtils()
		{
		}
		
		/**
		 * 替换字符串中的变量,变量的格式为{0}....{N} 
		 * @param sourceString 要记录的信息。此字符串可以包含 {x} 形式的特殊标记字符，其中 x 是从零开始的索引，将由在该索引位置找到的附加参数取代（如果已指定）。
		 * @param params 可以在字符串参数中的每个“{x}”位置处作为替代内容的附加参数，其中 x 是指定值的 Array 中一个从零开始的整数索引值。
		 * 
		 */
		public static function replaceStringByOrder(sourceString:String,...params):String
		{
			
			var paramsobj:Object = new Object();
			for(var key:String in params)
			{
				paramsobj[key] = params[key];
			}
			return replaceStringByKey(sourceString,paramsobj);
		}
		
		/**
		 * 替换字符串的变量,变量格式为{xxx} 
		 * @param sourceString
		 * @param params
		 * 
		 */
		public static function replaceStringByKey(sourceString:String,params:Object = null):String
		{
			var mDestString:String = sourceString;
			//获取原始语言
			for (var key:String in params)
			{
				var replacekey:String = "{"+ key +"}";
				mDestString = mDestString.split(replacekey).join(params[key]);
				//				{
				//					if(-1 != mDestString.indexOf("{"+ key +"}"))
				//					{
				//						mDestString = mDestString.replace(/\./g"{"+ key +"}",params[key]);
				//					}
				//					else
				//					{
				//						break;
				//					}
				//				}
				
			}
			
			return mDestString;
		}
	}
}