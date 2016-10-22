package SJ.Game.data
{
	import SJ.Common.Constants.ConstFuben;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_fuben;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	public class CJDataOfFuben extends SDataBaseRemoteData
	{
		private var _from:String;
		private var _goto:String;
		private var _fid:int = 0;
		public function CJDataOfFuben()
		{
			super("CJDataOfFuben");
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
//			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onReceived);
		}
		public function set lastfid(id:int):void
		{
			_fid = id;
		}
		public function get lastfid():int
		{
			return _fid;
		}
		
		public function set from(value:String):void
		{
			_from = value
		}
		public function get from():String
		{
			return _from
		}
		public function set gotos(value:String):void
		{
			_goto = value
		}
		public function get gotos():String
		{
			return _goto
		}
		public function buyVit():void
		{
			SocketCommand_fuben.buyVit();
		}

		
	}
}