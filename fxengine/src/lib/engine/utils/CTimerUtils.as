package lib.engine.utils
{
	/**
	 * 时钟类 
	 * @author caihua
	 * 
	 */
	public class CTimerUtils
	{
		/**
		 * 时间偏移 
		 */
		private static var  _timeoffset:Number = 0;
		public function CTimerUtils()
		{
		}
		/**
		 * 设置当前真实时间
		 * 主要用于客户端时间不准 
		 * @param time
		 * 
		 */
		public static function setRealTime(time:Number):void
		{
			_timeoffset = time - new Date().time;
		}
		/**
		 * 
		 * 按照通用时间返回 Date 对象中自 1970 年 1 月 1 日午夜以来的毫秒数。在比较两个或更多个 Date 对象时，可使用此方法表示某一特定时刻。
		 * @return Date 对象代表的自 1970 年 1 月 1 日以来的毫秒数。
		 * 
		 */
		public static function getCurrentTime():Number
		{
			
//			var d:Date = ;
			return new Date().time + _timeoffset;
		}
		
		/**
		 * 系统本地毫秒数 
		 * @return 
		 * 
		 */
		public static function getCurrentMiSecondLocal():Number
		{
			var d:Date = new Date();
			var n:Number = d.timezoneOffset * 60 * 1000
			return d.time - n;
		}
		
		/**
		 * 一天的总秒数 
		 */
		public static const TotalSecDay:Number = 24 * 60 * 60;
		
		/**
		 * 一小时的总秒数 
		 */
		public static const TotalSecHour:Number = 1 * 60 * 60;
	}
}