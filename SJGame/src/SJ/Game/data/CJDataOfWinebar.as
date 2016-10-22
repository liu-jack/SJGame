package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_winebar;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	public class CJDataOfWinebar extends SDataBaseRemoteData
	{
		private var _secondDirect:int;
		
		public function CJDataOfWinebar()
		{
			super("CJDataOfWinebar");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onloadComplete);
		}
		
		public function get secondDirect():int
		{
			return _secondDirect;
		}

		public function set secondDirect(value:int):void
		{
			_secondDirect = value;
		}

		/**
		 * 刷新时间
		 */
		public function set refreshtime(value:String):void
		{
			setData("refreshtime", value);
		}
		/**
		 * @private
		 */
		public function get refreshtime():String
		{
			return getData("refreshtime");
		}
		
		/**
		 * 酒馆状态
		 */
		public function set state(value:String):void
		{
			setData("state", value);
		}
		/**
		 * @private
		 */
		public function get state():String
		{
			return getData("state");
		}
		
		/**
		 * 剩余抽牌次数，仅在暗牌状态下有效
		 */
		public function set pickcount(value:String):void
		{
			setData("pickcount", value);
		}
		/**
		 * @private
		 */
		public function get pickcount():String
		{
			return getData("pickcount");
		}
		
		/**
		 * 武将模板id
		 */
		public function set herotemplateid0(value:String):void
		{
			setData("herotemplateid0", value);
		}
		/**
		 * @private
		 */
		public function get herotemplateid0():String
		{
			return getData("herotemplateid0");
		}
		
		/**
		 * 武将模板id
		 */
		public function set herotemplateid1(value:String):void
		{
			setData("herotemplateid1", value);
		}
		/**
		 * @private
		 */
		public function get herotemplateid1():String
		{
			return getData("herotemplateid1");
		}
		
		/**
		 * 武将模板id
		 */
		public function set herotemplateid2(value:String):void
		{
			setData("herotemplateid2", value);
		}
		/**
		 * @private
		 */
		public function get herotemplateid2():String
		{
			return getData("herotemplateid2");
		}
		
		/**
		 * 武将模板id
		 */
		public function set herotemplateid3(value:String):void
		{
			setData("herotemplateid3", value);
		}
		/**
		 * @private
		 */
		public function get herotemplateid3():String
		{
			return getData("herotemplateid3");
		}
		
		/**
		 * 武将模板id
		 */
		public function set herotemplateid4(value:String):void
		{
			setData("herotemplateid4", value);
		}
		/**
		 * @private
		 */
		public function get herotemplateid4():String
		{
			return getData("herotemplateid4");
		}
		
		/**
		 * 武将状态
		 */
		public function set herostate0(value:String):void
		{
			setData("herostate0", value);
		}
		/**
		 * @private
		 */
		public function get herostate0():String
		{
			return getData("herostate0");
		}
		
		/**
		 * 武将状态
		 */
		public function set herostate1(value:String):void
		{
			setData("herostate1", value);
		}
		/**
		 * @private
		 */
		public function get herostate1():String
		{
			return getData("herostate1");
		}
		
		/**
		 * 武将状态
		 */
		public function set herostate2(value:String):void
		{
			setData("herostate2", value);
		}
		/**
		 * @private
		 */
		public function get herostate2():String
		{
			return getData("herostate2");
		}
		
		/**
		 * 武将状态
		 */
		public function set herostate3(value:String):void
		{
			setData("herostate3", value);
		}
		/**
		 * @private
		 */
		public function get herostate3():String
		{
			return getData("herostate3");
		}
		
		/**
		 * 武将状态
		 */
		public function set herostate4(value:String):void
		{
			setData("herostate4", value);
		}
		/**
		 * @private
		 */
		public function get herostate4():String
		{
			return getData("herostate4");
		}
		
		/**
		 * 酒馆id
		 */
		public function set winebarid(value:String):void
		{
			setData("winebarid", value);
		}
		/**
		 * @private
		 */
		public function get winebarid():String
		{
			return getData("winebarid");
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			super._onloadFromRemote(params);
			// TODO Auto Generated method stub
			if (params != null)
			{
				SocketCommand_winebar.get_winbarInfo(params.toString());
			}
		}
		
		
		/**
		 * 加载数据完成
		 * @param e
		 * 
		 */
		protected function _onloadComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_WINEBAR_GETINFO)
				return;
			if(message.retcode == 0)
			{
				var rtnObject:Object = message.retparams;
				resetWinebar(rtnObject);
				this._onloadFromRemoteComplete();
			}
		}
		
		/**
		 * 重置winebar信息
		 * @param rtnObject
		 */
		public function resetWinebar(rtnObject:Object):void
		{
			winebarid		= rtnObject[0].toString();
			refreshtime 	= rtnObject[1].toString();
			state 			= rtnObject[2].toString();
			pickcount 		= rtnObject[3].toString();
			herotemplateid0 = rtnObject[4].toString();
			herostate0 		= rtnObject[5].toString();
			herotemplateid1 = rtnObject[6].toString();
			herostate1 		= rtnObject[7].toString();
			herotemplateid2 = rtnObject[8].toString();
			herostate2 		= rtnObject[9].toString();
			herotemplateid3 = rtnObject[10].toString();
			herostate3 		= rtnObject[11].toString();
			herotemplateid4 = rtnObject[12].toString();
			herostate4 		= rtnObject[13].toString();
		}
	}
}