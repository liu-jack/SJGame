package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstPlayer;
	import SJ.Game.SocketServer.SocketCommand_vip;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	/**
	 * 武将信息
	 * @author longtao
	 * 
	 */
	public class CJDataOfVIP extends SDataBaseRemoteData
	{
		/** {exp:xxx} **/
		private var _obj:Object = new Object;
		
		public function CJDataOfVIP()
		{
			super("CJDataOfVIP");
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onLoadComplete);
		}
		
		override protected function _onloadFromRemote(params:Object = null):void
		{
			super._onloadFromRemote(params);
			
			SocketCommand_vip.get_info();
		}
		
		/**
		 * 加载武将数据
		 * @param e
		 * 
		 */
		protected function _onLoadComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_VIP_INFO)
				return;
			if(message.retcode == 0)
			{
				var rtnObject:Object = message.retparams;
				
				vipExp = rtnObject[0];
				
				this._onloadFromRemoteComplete();
			}
		}
		
		/** vip经验 **/
		public function set vipExp(value:uint):void
		{
			_obj["exp"] = value;
		}
		/** @private **/
		public function get vipExp():uint
		{
			return _obj["exp"];
		}
		
		
	}
}