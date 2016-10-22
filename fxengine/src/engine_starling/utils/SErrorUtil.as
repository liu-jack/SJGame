package engine_starling.utils
{
	import engine_starling.data.SDataBase;
	
	import lib.engine.utils.CTimerUtils;

	/**
	 * 错误收集工具类 
	 * @author caihua
	 * 
	 */
	public class SErrorUtil
	{
		public function SErrorUtil()
		{
		}
		
		/**
		 * 汇报错误 
		 * @param e 错误
		 * @param tags 附加到错误名称后面的tag
		 * 
		 */
		public static function reportError(e:Error,tags:String = ""):void
		{
			var error:Error = e;
			var errobj:Object = new Object();
			errobj.errorId = error.errorID;
			errobj.name =error.name + tags;
			errobj.message = error.message;
			errobj.stack = error.getStackTrace();
			
			
			
			var errorlog:SDataBase = new SDataBase("errorlogging");
			errorlog.loadFromCache();
			errorlog.setData("error_" + CTimerUtils.getCurrentTime(),errobj);
			errorlog.saveToCache();
		}
		
		/**
		 * 清楚汇报 错误
		 * 
		 */
		public static function clearReportError():void
		{
			var errorlog:SDataBase = new SDataBase("errorlogging");
			errorlog.loadFromCache();
			errorlog.clearAll();
			errorlog.saveToCache();
		}
		
		
		/**
		 * 获取错误报告 
		 * @return 
		 * 
		 */
		public static function getReportError():SDataBase
		{
			var errorlog:SDataBase = new SDataBase("errorlogging");
			errorlog.loadFromCache();
			return errorlog;
		}
	}
}