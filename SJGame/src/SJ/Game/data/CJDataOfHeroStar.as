package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_herostar;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	public class CJDataOfHeroStar extends SDataBaseRemoteData
	{
		// { heroid:blessingvalue }
		private var _dataObj:Object = new Object;

		public function CJDataOfHeroStar()
		{
			super("CJDataOfHeroStar");
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onloadcomplete);
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			// TODO Auto Generated method stub
			SocketCommand_herostar.get_herostarInfo();
			super._onloadFromRemote(params);
		}
		
		override public function clearAll():void
		{
			super.clearAll();
			_dataIsEmpty = true;
		}
		
		/**
		 * 加载武将数据
		 * @param e
		 * 
		 */
		protected function _onloadcomplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_HEROSTAR_INFO)
				return;
			if(message.retcode == 0)
			{
				var rtnObject:Array = message.retparams;
				_initData(rtnObject);
				this._onloadFromRemoteComplete();
			}
		}
		
		// 初始化数据
		private function _initData(arr:Array):void
		{
			for(var i:int=0; i<arr.length; ++i)
			{
				_dataObj[arr[i][0]] = arr[i][1]
			}
		}
		
		// 获取对应武将的祝福值
		public function getBlessingValue(heroid:String):String
		{
			if (null == _dataObj[heroid])
				_dataObj[heroid] = "0";
			
			return _dataObj[heroid];
		}
		public function setBlessingValue(heroid:String, blessingValue:String):void
		{
			_dataObj[heroid] = blessingValue;
		}
	}
}