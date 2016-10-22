package SJ.Game.utils
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	
	public class SNetUrlUtil
	{
		private static var urlRequest:URLRequest
		public function SNetUrlUtil()
		{
		}
		public static function openurl(url:String,data:Object):void
		{
			urlRequest = new URLRequest;
			urlRequest.method = URLRequestMethod.GET
			urlRequest.url = url;
			urlRequest.data = data;
			navigateToURL(urlRequest);
		}
	}
}