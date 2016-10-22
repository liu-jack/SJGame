package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_reward;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * @comment 发奖的数据类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-11-19 下午5:27:20  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfReward extends SDataBaseRemoteData
	{
		private var _validList:Array = new Array();
		
		public function CJDataOfReward()
		{
			super("CJDataOfReward");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , _onSocketMessage);
		}
		
		private function _onSocketMessage(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			var command:String = message.getCommand();
			if(command == ConstNetCommand.CS_REWARD_GETALL)
			{
				if(message.retcode == 1)
				{
					if(!message.retparams)
					{
						return;
					}
					_validList = message.retparams;
					this._onloadFromRemoteComplete();
				}
			}
			else if(command == ConstNetCommand.CS_REWARD_GETREWARD)
			{
				if(message.retcode == 1)
				{
					if(!message.retparams)
					{
						return;
					}
					_validList = message.retparams;
					this.dispatchEventWith(CJEvent.EVENT_REWARD_CHANGE);
				}
			}
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			SocketCommand_reward.getAll();
		}

		public function get validList():Array
		{
			return this._validList;
		}
	}
}