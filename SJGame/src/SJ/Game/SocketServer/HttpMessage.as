package SJ.Game.SocketServer
{
	

	public class HttpMessage
	{
		private var _url:String
		private var _data:Object;
		private var _func:Function;

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

		public function get func():Function
		{
			return _func;
		}

		public function set func(value:Function):void
		{
			_func = value;
		}


		public function HttpMessage()
		{
		}
	}
}