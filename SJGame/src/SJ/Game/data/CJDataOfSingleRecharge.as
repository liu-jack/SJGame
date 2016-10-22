package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_singleRecharge;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	/**
	 * 单笔充值
	 * @author sangxu
	 */
	public class CJDataOfSingleRecharge extends SDataBaseRemoteData
	{
		// 开服时间
		private var _serverOpenTime:int;
		// {type:gold}
//		private var _data:Object;
		// 当前单笔充值活动类型
		private var _curPRTypeSingle:String;
		
		public function CJDataOfSingleRecharge()
		{
			super("CJDataOfSingleRecharge");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onloadroleInfo);
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			super._onloadFromRemote(params);
			SocketCommand_singleRecharge.getSingleRechargeInfo();
		}
		
		/**
		 * 加载用户数据 
		 * @param e
		 * 
		 */
		protected function _onloadroleInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() == ConstNetCommand.CS_SINGLE_RECHARGE_GETINFO)
			{
				if(message.retcode != 0)
				{
					return;
				}
				
				_serverOpenTime = message.retparams[0];
				var data:Object = message.retparams[1];
				_curPRTypeSingle = message.retparams[2];
				setData("_data", data);
				
				this._onloadFromRemoteComplete();
			}
		}
		/**
		 * 是否已获取该等级礼物
		 * @param singleRechargeType	单笔充值类型
		 * @return 
		 * 
		 */		
		public function hasGetGift(singleRechargeType:String):Boolean
		{
			var data:Object = getData("_data", null);
			if (data != null)
			{
				if (data[singleRechargeType])
				{
					return true;
				}
			}
			return false;
		}
		/**
		 * 获取当前服务器开服时间
		 * @return 
		 * 
		 */
		public function get serverOpenTime():uint
		{
			return _serverOpenTime;
		}
		/**
		 * 获取单笔充值奖励数据
		 * @return 
		 * 
		 */
		public function get singleRechargeData():Object
		{
//			return _data;
			return getData("_data");
		}
		/**
		 * 获取当前单笔充值奖励类型
		 * @return 
		 * 
		 */
		public function get curType():String
		{
			return _curPRTypeSingle;
		}
	}
}