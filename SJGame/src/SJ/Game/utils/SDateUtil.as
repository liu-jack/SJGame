package SJ.Game.utils
{
	/**
	 +------------------------------------------------------------------------------
	 * 日期工具类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-11-20 下午4:46:14  
	 +------------------------------------------------------------------------------
	 */
	public class SDateUtil
	{
		public static function get currentUTCSeconds():Number
		{
			return new Date().millisecondsUTC / 1000;
		}
		
		public static function get currentSeconds():Number
		{
			return new Date().milliseconds / 1000;
		}
		
		/**
		 * 本地时间 -> Y-M-D h:i:s
		 */ 
		public static function LTSeconds2YMDHIS(ltSeconds:Number = 0):String
		{
			var date:Date;
			if(int(ltSeconds) == 0)
			{
				date = new Date();
			}
			else
			{
				date = new Date(ltSeconds * 1000 + new Date().timezoneOffset * 60 * 1000);
			}
			return date.fullYear+"-"+int(date.month + 1)+"-"+date.date + " " + date.hours + ":" +date.minutes +":" +date.seconds;
		}
		
		/**
		 * 本地时间 -> YY-MM-DD HH:II:SS
		 */ 
		public static function LTSeconds2YYMMDDHHIISS(ltSeconds:Number = 0):String
		{
			var date:Date;
			if(int(ltSeconds) == 0)
			{
				date = new Date();
			}
			else
			{
				date = new Date(ltSeconds * 1000 + new Date().timezoneOffset * 60 * 1000);
			}
			var monthAS:int = date.month + 1;
			var month:String = monthAS < 10 ? "0"+ monthAS : ""+monthAS;
			var d:String = date.date < 10 ? "0"+ date.date : ""+date.date;
			var hours:String = date.hours < 10 ? "0"+ date.hours : ""+date.hours;
			var minutes:String = date.minutes < 10 ? "0"+ date.minutes : ""+date.minutes;
			var seconds:String = date.seconds < 10 ? "0"+ date.seconds : ""+date.seconds;
			return date.fullYear+"-"+month+"-"+d + " " + hours + ":" +minutes +":" +seconds;
		}
		
		/**
		 * UTC时间 -> Y-M-D h:i:s
		 */ 
		public static function UTCSeconds2YMDHIS(utcSeconds:Number):String
		{
			var date:Date;
			if(int(utcSeconds) == 0)
			{
				date = new Date();
			}
			else
			{
				date = new Date(utcSeconds * 1000);
			}
			return date.fullYear+"-"+int(date.month + 1)+"-"+date.date + " " + date.hours + ":" +date.minutes +":" +date.seconds;
		}
		
		/**
		 * UTC时间 -> YY-MM-DD HH:II:SS
		 */ 
		public static function UTCSeconds2YYMMDDHHIISS(utcSeconds:Number):String
		{
			var date:Date;
			if(int(utcSeconds) == 0)
			{
				date = new Date();
			}
			else
			{
				date = new Date(utcSeconds * 1000);
			}
			var monthAS:int = date.month + 1;
			var month:String = monthAS < 10 ? "0"+ monthAS : ""+monthAS;
			var d:String = date.date < 10 ? "0"+ date.date : ""+date.date;
			var hours:String = date.hours < 10 ? "0"+ date.hours : ""+date.hours;
			var minutes:String = date.minutes < 10 ? "0"+ date.minutes : ""+date.minutes;
			var seconds:String = date.seconds < 10 ? "0"+ date.seconds : ""+date.seconds;
			return date.fullYear+"-"+month+"-"+d + " " + hours + ":" +minutes +":" +seconds;
		}
	}
}