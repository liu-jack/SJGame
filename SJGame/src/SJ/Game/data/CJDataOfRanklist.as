package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_rank;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;

	/**
	 * 排行榜信息
	 * @author zhengzheng
	 * 
	 */	
	public class CJDataOfRanklist extends SDataBaseRemoteData
	{
		//等级排行榜数据
		private var _rankLevelData:Array = new Array();
		//战力排行榜数据
		private var _rankBattleData:Array = new Array();
		//土豪排行榜数据
		private var _rankRichData:Array = new Array();
		
		public function CJDataOfRanklist()
		{
			super("CJDataOfRanklist");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , this._onSocketComplete);
		}
		
		/**
		 * 从远程加载数据
		 * @param params
		 * 
		 */		
		override protected function _onloadFromRemote(params:Object = null):void
		{
			SocketCommand_rank.getRankLevel();
			SocketCommand_rank.getRankBattleLevel();
			SocketCommand_rank.getRankRichLevel();
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
			if (message.getCommand() == ConstNetCommand.CS_RANK_LEVEL)
			{
				if (message.retcode == 0)
				{
					_rankLevelData = message.retparams as Array;
					this._onloadFromRemoteComplete();
				}
			}
			else if (message.getCommand() == ConstNetCommand.SC_RANK_BATTLE_LEVEL)
			{
				if (message.retcode == 0)
				{
					_rankBattleData = message.retparams as Array;
					this._onloadFromRemoteComplete();
				}
			}
			else if (message.getCommand() == ConstNetCommand.SC_RANK_RICH_LEVEL)
			{
				if (message.retcode == 0)
				{
					var tempRankRichData:Array = message.retparams as Array;
					for (var i:int = 0; i < tempRankRichData.length; i++) 
					{
						var rankRichObj:Object = tempRankRichData[i] as Object;
						if (rankRichObj.hasOwnProperty("expensegold") && rankRichObj.expensegold > 0
							&& !_isDictContain(rankRichObj))
						{
							_rankRichData.push(rankRichObj);
						}
					}
					
					this._onloadFromRemoteComplete();
				}
			}
		}

		/**
		 * 
		 * 获得等级排行榜数据
		 */		
		public function get rankLevelData():Array
		{
			return _rankLevelData;
			
		}
		/**
		 * 
		 * 获得战力排行榜数据
		 */		
		public function get rankBattleData():Array
		{
			return _rankBattleData;
			
		}
		
		/**
		 * 
		 * 获得土豪排行榜数据
		 */		
		public function get rankRichData():Array
		{
			return _rankRichData;
			
		}
		
		/**
		 * 判断土豪排行榜数据数组中是否已经有该数据
		 */		
		private function _isDictContain(element:Object):Boolean
		{
			for (var i:int = 0; i < rankRichData.length; i++) 
			{
				var rankRichObj:Object = rankRichData[i] as Object;
				if (element.rankid == rankRichObj.rankid)
				{
					return true;
				}
			}
			return false;
		}
	}
}