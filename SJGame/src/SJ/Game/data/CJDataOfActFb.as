package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_fuben;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	public class CJDataOfActFb extends SDataBaseRemoteData
	{
		private var _fbdata:Object
		private var _actdata:Object
		public function CJDataOfActFb()
		{
			super("CJDataOfActFb");
		}
		
		public function set fbdata(data:Object):void
		{
			this._fbdata = data;
		}
		
		public function get fbdata():Object
		{
			return this._fbdata
		}
		public function set actdata(data:Object):void
		{
			this._actdata = data;
		}
		
		public function get actdata():Object
		{
			return this._actdata
		}
		
		public function getfbdetail(aid:int,id:int):Object
		{
			var obj:Object;
			for(var i:String in _fbdata)
			{
				if(_fbdata[i].gid == id && _fbdata[i].fid == aid)
				{
					obj = _fbdata[i];
					break;
				}
			}
			return obj;
		}
	}
}