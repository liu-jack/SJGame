package SJ.Game.Platform
{
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	
	import starling.core.Starling;

	public class KaixinSDK
	{
		private var _APIID:String;
		private var _APIKEY:String;
		private var _SECRETKEY:String;
		
		private var _webView:StageWebView;
		
		public function KaixinSDK()
		{
		}
		
		public function init(ApiId:String,ApiKey:String,SecretKey:String):void
		{
			_APIID = ApiId;
			_APIKEY = ApiKey;
			_SECRETKEY = SecretKey;
			
			_webView = new StageWebView();
			_webView.stage = Starling.current.nativeStage;
			_webView.viewPort = new Rectangle(0,0,_webView.stage.fullScreenWidth,_webView.stage.fullScreenHeight);
			_webView.loadURL("http://api.kaixin001.com/oauth2/authorize?response_type=token&client_id=" + _APIKEY);
			
		}
		public function login():void
		{
			
		}
	}
}