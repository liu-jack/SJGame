package SJ.Game.data
{
	import SJ.Common.Constants.ConstDynamic;
	import SJ.Common.Constants.ConstMail;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_mail;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;

	/**
	 * 邮件信息
	 * @author zhengzheng
	 * 
	 */	
	public class CJDataOfMail extends SDataBaseRemoteData
	{
		//邮件数据
		private var _mailData:Array;
		
		public function CJDataOfMail()
		{
			super("CJDataOfMail");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , this._onSocketComplete);
		}
		
		/**
		 * 从远程加载数据
		 * @param params
		 * 
		 */		
		override protected function _onloadFromRemote(params:Object = null):void
		{
			SocketCommand_mail.getMails();
			super._onloadFromRemote(params);
		}
		
		/**
		 * 数据加载完毕
		 * @param e
		 * 
		 */		
		private function _onSocketComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			var retParams:Array;
			if (message.getCommand() == ConstNetCommand.CS_MAIL_GET_MAILS)
			{
				if (message.retcode == 0)
				{
					_mailData = new Array()
					_mailData = message.retparams;
					this._dataIsEmpty = true;
					this._onloadFromRemoteComplete();
					this.dispatchEventWith(ConstDynamic.DYNAMIC_MAIL_CHANGED);
				}
			}
		}

		/**
		 * 
		 * 获得系统邮件
		 */		
		public function get normalMailData():Array
		{
			var normalMail:Array = new Array();
			for (var i:int = 0; i < _mailData.length; i++) 
			{
				if (_mailData[i].mailtype == ConstMail.MAIL_TYPE_SYSTEM)
				{
					normalMail.push(_mailData[i]);
				}
			}
			return normalMail;
			
		}
		/**
		 * 
		 * 获得好友助战邮件
		 */		
		public function get friendHelpMailData():Array
		{
			var friendHelpMail:Array = new Array();
			for (var i:int = 0; i < _mailData.length; i++) 
			{
				if (_mailData[i].mailtype == ConstMail.MAIL_TYPE_FRIEND)
				{
					friendHelpMail.push(_mailData[i]);
				}
			}
			return friendHelpMail;
			
		}
		/**
		 * 
		 * 获得夺宝邮件
		 */		
		public function get snatchMailData():Array
		{
			var snatchMail:Array = new Array();
			for (var i:int = 0; i < _mailData.length; i++) 
			{
				if (_mailData[i].mailtype == ConstMail.MAIL_TYPE_SNATCH || _mailData[i].mailtype == ConstMail.MAIL_TYPE_FRISNATCH)
				{
					snatchMail.push(_mailData[i]);
				}
			}
			return snatchMail;
			
		}
		/**
		 * 获得全部的邮件数据
		 * 
		 */		
		public function get allMailData():Array
		{
			return _mailData;
		}
		
	}
}