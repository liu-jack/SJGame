package SJ.Game.utils
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	
	import engine_starling.utils.SStringUtils;

	public class SAdUtils
	{
		public function SAdUtils()
		{
		}
		
		/**
		 * 广告回调 
		 * 
		 */
		public static function ADCallBack():void
		{
			if(!CJDataManager.o.DataOfSetting.isSendAdCallback)
			{
				var adurl:String = CJDataOfGlobalConfigProperty.o.getData("ADURL");
				if(SStringUtils.isEmpty(adurl))
				{
					return;
				}
				var postadurl:String = adurl +"?appid=0" + "&udid=" + ConstGlobal.DeviceInfo.DeviceId+"&channelid="+ConstGlobal.CHANNEL;
				var resourceLoader:URLLoader = new URLLoader();
				var scriptRequest:URLRequest = new URLRequest(postadurl);
				var header:URLRequestHeader = new URLRequestHeader("Referer", "wg.imghb.com");
				
				resourceLoader.addEventListener(Event.COMPLETE,function (e:Event):void
				{
					var loader:URLLoader = e.target as URLLoader;
					
					CJDataManager.o.DataOfSetting.CallSendAdCallbackSucc();
					CJDataManager.o.DataOfSetting.saveToCache();
				});
				resourceLoader.addEventListener(IOErrorEvent.IO_ERROR,function (e:Event):void
				{
	
					
				});
				
				
				scriptRequest.requestHeaders.push(header);
				resourceLoader.dataFormat = URLLoaderDataFormat.TEXT;
				resourceLoader.load(scriptRequest);
			}
			
		}
	}
}