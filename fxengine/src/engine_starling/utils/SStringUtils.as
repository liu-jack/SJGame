package engine_starling.utils
{
	import com.hurlant.crypto.hash.MD5;
	import com.hurlant.util.Hex;
	
	import flash.utils.ByteArray;

	public class SStringUtils
	{
		public function SStringUtils()
		{
		}
		/**
		 * 替换字符串中的变量,变量的格式为{0}....{N} 
		 * @param sourceString 要记录的信息。此字符串可以包含 {x} 形式的特殊标记字符，其中 x 是从零开始的索引，将由在该索引位置找到的附加参数取代（如果已指定）。
		 * @param params 可以在字符串参数中的每个“{x}”位置处作为替代内容的附加参数，其中 x 是指定值的 Array 中一个从零开始的整数索引值。
		 * 
		 */
		public static function format(fmt:String,...params):String
		{
			for (var i:int=0; i<params.length; ++i)
				fmt = fmt.replace(new RegExp("\\{"+i+"\\}", "g"), params[i]);
			
			return fmt;
			
//			var paramsobj:Object = new Object();
//			for(var key:String in params)
//			{
//				paramsobj[key] = params[key];
//			}
//			return replaceStringByKey(fmt,paramsobj);
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
		 * 替换字符串的变量,变量格式为{key} 
		 * @param sourceString 原始字符串
		 * @param params 字典 key 是需要替换的字符 value 是替换为的字符
		 * 
		 */
		public static function replaceStringByKey(sourceString:String,params:Object = null):String
		{
			var mDestString:String = sourceString;
			//获取原始语言
			for (var key:String in params)
			{
//				var replacekey:String = "{"+ key +"}";
				mDestString = mDestString.replace(new RegExp("\\{"+key+"\\}", "g"), params[key]);
//				mDestString = mDestString.split(replacekey).join(params[key]);
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
		
		/**
		 * 字符串是否iou为空 
		 * @param value
		 * @return 
		 * 
		 */
		public static function isEmpty(value:*):Boolean
		{
			return !Boolean(value as String);
		}
		
		
		/**
		 * md5字符串 
		 * @param inString 需要计算md5的字符串
		 * @return 字符串16进制 caf1a3dfb505ffed0d024130f58c5cfa  共32个Ascll 16字节 
		 * 
		 */
		public static function md5String(inString:String):String
		{
			var md5:MD5 = new MD5;
			var bytes:ByteArray = new ByteArray;
			bytes.writeUTFBytes(inString);
			var hashString:String = Hex.fromArray(md5.hash(bytes));
			return hashString;
		}
	}
}