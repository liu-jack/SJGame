package SJ.Game.data
{
	import SJ.Game.core.PushService;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import lib.engine.utils.CTimerUtils;
	
	public class CJDataOfArena extends SDataBaseRemoteData
	{
		public function CJDataOfArena()
		{
			super("CJDataOfArena");
			this._init();
		}
		private static var _o:CJDataOfFuben;
		public static function get o():CJDataOfFuben
		{
			if(_o == null)
				_o = new CJDataOfFuben();
			return _o;
		}
		
		private function _init():void
		{
//			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,_onDeActive);
		}
		//发送召回push
		private function _onDeActive(e:Event):void
		{
			var currentlocaltimeInday:Number = (CTimerUtils.getCurrentMiSecondLocal() / 1000) % CTimerUtils.TotalSecDay;
			var difftime:Number = (21 * CTimerUtils.TotalSecHour - currentlocaltimeInday);
			var currentsecond:Number = difftime + CTimerUtils.TotalSecDay;
			//每天10点发送
			currentsecond =currentsecond + CTimerUtils.getCurrentTime() / 1000;
			PushService.o.sendLocalNotification(CJLang("ARENA_AWARD_BEFOREPUSH"),currentsecond,CJLang("PUSH_TITLE"),PushService.RECURRENCE_DAY);
		}
	}
}