package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_camp;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.task.CJTaskEvent;
	import SJ.Game.task.CJTaskEventHandler;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 阵营数据类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-20 上午9:07:41  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfCamp extends SDataBaseRemoteData
	{
		private var _recommendCampid:int = 0;
		private var _currentCampid:int = 0;
		
		public function CJDataOfCamp()
		{
			super("CJDataOfCamp");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , this._onSocketComplete);
		}
		
		override protected function _onloadFromRemote(params:Object = null):void
		{
			SocketCommand_camp.getCurrentCampid();
		}
		
		private function _onSocketComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.retcode != 1)
			{
				return;
			}
			var retData:Object = message.retparams;
			if(message.getCommand() == ConstNetCommand.CS_JOINCAMP)
			{
				currentCampid = int(retData);
				CJDataManager.o.DataOfBag.loadFromRemote();
				CJTaskEventHandler.o.dispatchEventWith(CJTaskEvent.TASK_EVENT_JOIN_CAMP);
				CJEventDispatcher.o.dispatchEventWith("join_camp_succ");
			}
			else if(message.getCommand() == ConstNetCommand.CS_GET_RECOMMENDEDCAMP)
			{
				_recommendCampid = int(retData);
				CJEventDispatcher.o.dispatchEventWith("get_recommend_succ");
			}
			else if(message.getCommand() == ConstNetCommand.CS_GET_CURRENTCAMP)
			{
				currentCampid = int(retData.camp);
				_recommendCampid = int(retData.recommendCampid);
				this._onloadFromRemoteComplete();
			}
		}

		public function get recommendCampid():int
		{
			return _recommendCampid;
		}

		public function get currentCampid():int
		{
			return _currentCampid;
		}

		public function set currentCampid(value:int):void
		{
			_currentCampid = value;
			CJDataManager.o.DataOfRole.camp = value;
		}
	}
}