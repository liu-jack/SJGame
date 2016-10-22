package SJ.Game.treasure
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.utils.Logger;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	/**
	 +------------------------------------------------------------------------------
	 * 聚灵服务器请求接口类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-1 下午1:38:45  
	 +------------------------------------------------------------------------------
	 */
	public class CJTreasureActionHandler extends EventDispatcher
	{
		private static var INSTANCE:CJTreasureActionHandler = null;
		
		public function CJTreasureActionHandler()
		{
			super();
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , this._serverEventHandler);
		}
		
		private function _serverEventHandler(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			var retCode:int = message.params(0);
			if(retCode == 1)
			{
				var retData:Object = message.retparams;
				if(message.getCommand() == ConstNetCommand.CS_TREASURE_GETTREASURE)
				{
					CJDataManager.o.DataOfTreasureList.initData(retData);
					SocketManager.o.call(ConstNetCommand.CS_ROLE_GET_ROLE_INFO);
				}
				else if(message.getCommand() == ConstNetCommand.CS_TREASURE_TRANSFERSINGAL)
				{
					
				}
				else if(message.getCommand() == ConstNetCommand.CS_TREASURE_TRANSFERALL)
				{
					
				}
				else if(message.getCommand() == ConstNetCommand.CS_TREASURE_TREASUREUPLEVEL)
				{
					
				}
				else if(message.getCommand() == ConstNetCommand.CS_TREASURE_EXCHANGETREASURE)
				{
					
				}
				else if(message.getCommand() == ConstNetCommand.CS_TREASURE_PUTONTREASURE)
				{
				}
				else if(message.getCommand() == ConstNetCommand.CS_TREASURE_TAKEOFFTREASURE)
				{
				}
				else if(message.getCommand() == ConstNetCommand.CS_TREASURE_GETALLHEROTREASURELIST)
				{
				}
				else if(message.getCommand() == ConstNetCommand.CS_TREASURE_GETUSERINFO)
				{
				}
				else if(message.getCommand() == ConstNetCommand.CS_TREASURE_MOVETREASURETOUSERBAG)
				{
				}
			}
		}
		
		public static function get o():CJTreasureActionHandler
		{
			if (null == INSTANCE)
			{
				INSTANCE = new CJTreasureActionHandler();
			}
			return INSTANCE;
		}
	}
}