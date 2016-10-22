package lib.engine.utils
{
	/**
	 * 日志单元 
	 * @author caihua
	 * 
	 */
	public class CLogUtils
	{

		private static var _ins:CLogUtils = null;
		private var flags:Array = new Array();
		public static const _DEBUGFLAG:int = 0;
		public static const _INFOFLAG:int = 1;
		public static const _WARNFLAG:int = 2;
		public static const _ERRORFLAG:int = 3;
		public static const _EXCEPTIONFLAG:int = 4;
		
		private var _loglevel:int = 0;
		public function CLogUtils() 
		{
			flags[_DEBUGFLAG] = "DEBUG";
			flags[_INFOFLAG] = "INFO";
			flags[_WARNFLAG] = "WARN";
			flags[_ERRORFLAG] = "ERROR";
			flags[_EXCEPTIONFLAG] = "EXCEPTION";
		}
		
		public function set loglevel(value:int):void
		{
			_loglevel = value;
		}
		public function get __loglevel():int
		{
			return _loglevel;
		}
		public static function get o():CLogUtils
		{
			if (_ins == null)
				_ins = new CLogUtils();
			return _ins;
		}
		
		/**
		 * 调试级日志输出
		 * @param	str
		 */
		public function debug(str:String):void
		{
			_print(_DEBUGFLAG, str);
			
		}
		/**
		 * 普通信息日志输出
		 * @param	str
		 */
		public function info(str:String):void
		{
			_print(_INFOFLAG, str);
		}
		public function warn(str:String):void
		{
			_print(_WARNFLAG, str);
		}
		public function error(str:String):void
		{
			_print(_ERRORFLAG, str);
		}
		
		public function _print(flag:int,str:String):void
		{
			//日志输出等级
			if (flag < _loglevel)
				return;
			var t:Date = new Date();
			//t.toLocaleString
			trace(t.getFullYear() + "-" + t.getMonth() + "-" + t.getDate() + " " + t.getHours() + ":" + t.getMinutes() + ":" + t.getSeconds() +"."+ t.getMilliseconds() +
				" [" + flags[flag] + "] " + str);
			
		}
	}
}