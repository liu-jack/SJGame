package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_herotag;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	public class CJDataOfHeroTag extends SDataBaseRemoteData
	{
		public function CJDataOfHeroTag()
		{
			super("CJDataOfHeroTag");
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadcomplete);
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			// TODO Auto Generated method stub
			SocketCommand_herotag.get_herotag()
			super._onloadFromRemote(params);
		}
		
		/**
		 * 可使用的武将标签列表
		 */
		public function set herotaglist(value:Array):void
		{
			setData("herotaglist", value);
		}
		/**
		 * @private
		 */
		public function get herotaglist():Array
		{
			return getData("herotaglist");
		}
		
		/**
		 * 加载武将数据
		 * @param e
		 * 
		 */
		protected function _onloadcomplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_HERO_TAG_GET)
				return;
			if(message.retcode == 0)
			{
				// 移除事件
				e.target.removeEventListener(e.type, _onloadcomplete);
				var rtnObject:Object = message.retparams;
				herotaglist = message.retparams[0] as Array;
				this._onloadFromRemoteComplete();
			}
		}
	}
}