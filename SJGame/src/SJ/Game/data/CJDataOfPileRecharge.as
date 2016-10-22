package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_pileRecharge;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	/**
	 * 累积充值
	 * @author longtao
	 */
	public class CJDataOfPileRecharge extends SDataBaseRemoteData
	{
		// 开服时间
		private var _serverOpenTime:int;
		// {type:gold}
//		private var _data:Object;
		
		/** 当前累积充值类型 **/
		private var _curPRType:String = "0";
		
		public function CJDataOfPileRecharge()
		{
			super("CJDataOfPileRecharge");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadroleInfo);
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			// TODO Auto Generated method stub
			SocketCommand_pileRecharge.getInfo(null);
			super._onloadFromRemote(params);
		}
		
		/**
		 * 加载用户数据 
		 * @param e
		 * 
		 */
		protected function _onloadroleInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() == ConstNetCommand.CS_PILE_RECHARGE_GETINFO)
			{
				if(message.retcode != 0)
					return;
				
				_serverOpenTime = message.retparams[0];
				var data:Object = message.retparams[1];
				_curPRType = message.retparams[2];
				setData("_data", data);
				this._onloadFromRemoteComplete();
			}
		}
		
		public function get serverOpenTime():uint
		{
			return _serverOpenTime;
		}
		/**
		 * 获取累计充值奖励数据
		 * @return 
		 * 
		 */
		public function get pileRechargeData():Object
		{
//			return _data;
			return getData("_data");
		}
		/**
		 * 获取当前累计充值奖励类型
		 * @return 
		 * 
		 */
		public function get curType():String
		{
			return _curPRType;
		}
	}
}