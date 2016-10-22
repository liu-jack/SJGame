package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_stageLevel;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	public class CJDataOfStageLevel extends SDataBaseRemoteData
	{
		/** {forceStar:xxx, forceSoul:xxx} **/
		private var _stageLevelInfo:Object = new Object;
		
		public function CJDataOfStageLevel()
		{
			super("CJDataOfStageLevel");
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onloadcomplete);
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			// TODO Auto Generated method stub
			SocketCommand_stageLevel.get_stagelevel_info();
			super._onloadFromRemote(params);
		}
		
		/**
		 * 武星
		 */
		public function set forceStar(value:uint):void
		{
			_stageLevelInfo["forceStar"] = value;
		}
		/**
		 * @private
		 */
		public function get forceStar():uint
		{
			return _stageLevelInfo["forceStar"];
		}
		
		/**
		 * 武魂
		 */
		public function set forceSoul(value:uint):void
		{
			_stageLevelInfo["forceSoul"] = value;
		}
		/**
		 * @private
		 */
		public function get forceSoul():uint
		{
			return _stageLevelInfo["forceSoul"];
		}
		
		/**
		 * 升阶信息
		 */
		public function set stageLevel(value:Object):void
		{
			_stageLevelInfo = value;
			setData("stageLevel", _stageLevelInfo);
		}
		/**
		 * @private
		 */
		public function get stageLevel():Object
		{
			return _stageLevelInfo;
		}
		
		/**
		 * 加载武将数据
		 * @param e
		 * 
		 */
		protected function _onloadcomplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_STAGELEVEL_GET_INFO)
				return;
			if(message.retcode == 0)
			{
				var rtnObject:Object = message.retparams;
				forceStar = rtnObject[0];
				forceSoul = rtnObject[1];
				var obj:Object = stageLevel;
				stageLevel = obj;
				
				this._onloadFromRemoteComplete();
				
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_STAGE_LEVEL_INFO_COMPLETE);
			}
		}
	}
}