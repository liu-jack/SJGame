package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_Treasure;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBase;
	import engine_starling.data.SDataBaseRemoteData;
	
	import flash.utils.Dictionary;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 用户聚灵信息 - 积分 ， 灵气值 ， 临时灵丸背包 ， 用户灵丸背包
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-31 下午2:53:01  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfTreasureUserInfo extends SDataBaseRemoteData
	{
		private var _dataDict:Dictionary  = new Dictionary();
		private var _treasurenum:int;
		private var _scorenum:int;
		private var _tempbagnum:int;
		private var _userbagbum:int;
		
		public static const DATA_KEY:String = "treasure_user_info";
		
		public function CJDataOfTreasureUserInfo()
		{
			super("CJDataOfTreasureUserInfo");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , this._onDataLoaded);
		}
		
		private function _onDataLoaded(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() == ConstNetCommand.CS_TREASURE_GETUSERINFO)
			{
				if(message.retcode == 1)
				{
					this._initData(message.retparams);
					this._onloadFromRemoteComplete();
				}
			}
		}
		
		private function _initData(obj:Object):void
		{
			this._treasurenum = obj.treasurenum;
			this._scorenum = obj.scorenum;
			this._tempbagnum = obj.tempbagnum;
			this._userbagbum = obj.userbagbum;
			this._dataDict["treasurenum"] = this._treasurenum;
			this._dataDict["scorenum"] = this._scorenum;
			this._dataDict["tempbagnum"] = this._tempbagnum;
			this._dataDict["userbagbum"] = this._userbagbum;
			this.setData(DATA_KEY , this._dataDict);
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			SocketCommand_Treasure.getTreasureUserInfo();
		}

		/**
		 * 灵气值
		 */
		public function get treasurenum():int
		{
			return _treasurenum;
		}

		public function set treasurenum(value:int):void
		{
			_treasurenum = value;
			this._dataDict["treasurenum"] = _treasurenum;
		}

		/**
		 * 积分值
		 */		
		public function get scorenum():int
		{
			return _scorenum;
		}

		public function set scorenum(value:int):void
		{
			_scorenum = value;
			this._dataDict["scorenum"] = _scorenum;
		}

		/**
		 * 临时灵丸背包 剩余数量
		 */		
		public function get tempbagnum():int
		{
			return _tempbagnum;
		}

		public function set tempbagnum(value:int):void
		{
			_tempbagnum = value;
			this._dataDict["tempbagnum"] = _tempbagnum;
		}

		/**
		 * 用户背包剩余数量
		 */		
		public function get userbagbum():int
		{
			return _userbagbum;
		}

		public function set userbagbum(value:int):void
		{
			_userbagbum = value;
			this._dataDict["userbagbum"] = _userbagbum;
		}
	}
}