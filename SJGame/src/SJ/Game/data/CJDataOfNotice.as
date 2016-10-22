package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_notice;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 公告数据
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-4 
	 +------------------------------------------------------------------------------
	*/
	public class CJDataOfNotice extends SDataBaseRemoteData
	{
		private var _noticeList:Array = new Array();
		private var _newestNotice:Object = new Object();
		private var _hasAutoShown:Boolean = false;
		
		public function CJDataOfNotice()
		{
			super("CJDataOfNotice");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onSocketNoticeMessage);
		}
		
		public function get hasAutoShown():Boolean
		{
			return _hasAutoShown;
		}

		public function set hasAutoShown(value:Boolean):void
		{
			_hasAutoShown = value;
		}

		/**
		 * 公告消息
		 */		
		private function _onSocketNoticeMessage(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() == ConstNetCommand.CS_GET_NEWEST_NOTICE)
			{
				var params1:Object = message.retparams;
				this._initData(params1);
				this._onloadFromRemoteComplete();
			}
		}
		
		/**
		 * 获取最新的公告
		 */ 
		private function _initData(notice:Object):void
		{
			if(notice &&　notice.hasOwnProperty('id'))
			{
				_newestNotice = notice;
			}
			else
			{
				_newestNotice = new Object();
			}
		}
		
		/**
		 * 获取最新公告
		 */ 
		public function getNewestNotice():Object
		{
			return this._newestNotice;
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			SocketCommand_notice.getLatestNoitce();
		}
		
	}
}