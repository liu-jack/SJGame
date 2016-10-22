package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_fuben;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	public class CJDataOfNavigator extends SDataBaseRemoteData
	{
		private var _npcSceneId:int
		private var _npcId:int
		private var _gid:int
		
		public function CJDataOfNavigator()
		{
			super("CJDataOfNavigator");
		}
		
		public  function set npcSceneId(value:int):void
		{
			_npcSceneId = value;
		}
		public function get npcSceneId():int
		{
			return _npcSceneId
		}
		public function set npcId(value:int):void
		{
			_npcId = value;
		}
		public function get npcId():int
		{
			return _npcId
		}
		public function set gid(value:int):void
		{
			_gid = value;	
		}
		public function get gid():int
		{
			return _gid
		}
		
	}
}