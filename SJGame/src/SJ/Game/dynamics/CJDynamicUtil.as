package SJ.Game.dynamics
{
	import SJ.Common.Constants.ConstDynamic;
	
	import flash.globalization.DateTimeStyle;

	/**
	 * 动态工具类
	 * @author zhengzheng
	 * 
	 */	
	public class CJDynamicUtil
	{
		public function CJDynamicUtil()
		{
		}
		
		/**
		 * 动态工具类的单例
		 * @return CJDynamicUtil实例
		 */		
		private static var _o:CJDynamicUtil = null;
		public static function get o():CJDynamicUtil
		{
			if(null == _o)
			{
				_o = new CJDynamicUtil();
			}
			return _o;
		}
		
		/**
		 *  邮件显示排序
		 * 
		 */		
		public function mailShowSort(mailInfo0:Object, mailInfo1:Object):Number
		{
			var num0:Number = Number(mailInfo0.maildate);
			var num1:Number = Number(mailInfo1.maildate);
			if (num0 > num1)
			{
				return 1;
			}
			else if (num0 < num1)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * 转化分钟为日期
		 */
		public function changeSecondToDate(seconds:Number):String
		{
			var date:Date = new Date(seconds * 1000);
			var time:String = date.fullYearUTC + "-" + _setStringStyle(date.monthUTC + 1) + "-" + _setStringStyle(date.dateUTC) +
				"  " + _setStringStyle(date.hoursUTC) + ":" + _setStringStyle(date.minutesUTC) + ":" + _setStringStyle(date.secondsUTC);
			return time;
		}
		/**
		 * 设置字符串的样式
		 * 
		 */		
		private function _setStringStyle(srcNum:Number):String
		{
			var desString:String;
			if (srcNum < 10)
			{
				desString = "0" + srcNum;
			}
			else
			{
				desString = String(srcNum);
			}
			return desString;
		}
		
	}
}