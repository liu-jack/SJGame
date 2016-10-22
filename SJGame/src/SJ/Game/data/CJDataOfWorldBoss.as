package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import flash.geom.Point;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 世界Boss数据类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-18 下午6:39:15  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfWorldBoss extends SDataBaseRemoteData
	{
		/*默认的为东城区*/
		private var _currentSceneId:int = 105;
		/*怪物列表*/
		private var _monsterDataList:Array;
		/*城门数据信息*/
		private var _gateDataList:Array;
		/*排行榜信息*/
		private var _rankDataList:CJDataOfWorldBossRank;
		/*用户数据*/
		private var _userData:CJDataOfWorldBossUserInfo;
		/*怪物出生点*/
		private var _bornPoint:Point;
		/*死亡红线*/
		private var _deadX:Number = 0;
		
		public function CJDataOfWorldBoss()
		{
			super("CJDataOfWorldBoss");
			this._initData();
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , this._onDataLoaded);
		}
		
		private function _initData():void
		{
			_rankDataList = new CJDataOfWorldBossRank();
			_userData = new CJDataOfWorldBossUserInfo();
			_monsterDataList = new Array();
			_gateDataList = new Array();
		}
		
		private function _onDataLoaded(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() == ConstNetCommand.CS_WORLDBOSS_GETALL)
			{
				if(message.retcode == 1)
				{
					this._resetData(message.retparams);
					this._onloadFromRemoteComplete();
				}
			}
		}
		
		private function _resetData(allData:Object):void
		{
			
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			super._onloadFromRemote(params);
			this._onloadFromRemoteComplete();
		}
		
		public function get currentSceneId():int
		{
			return _currentSceneId;
		}

		public function get monsterDataList():Array
		{
			return _monsterDataList;
		}

		public function get gateDataList():Array
		{
			return _gateDataList;
		}

		public function get rankDataList():CJDataOfWorldBossRank
		{
			return _rankDataList;
		}

		public function get userData():CJDataOfWorldBossUserInfo
		{
			return _userData;
		}

		public function get bornPoint():Point
		{
			if(!_bornPoint)
			{
				var bornPlace:Array = CJDataOfGlobalConfigProperty.o.getData("MONSTERBORNPLACE").split("_");
				_bornPoint = new Point(bornPlace[0] , bornPlace[1]);
			}
			return _bornPoint;
		}

		public function get deadX():Number
		{
			if(!_deadX)
			{
				_deadX = int(CJDataOfGlobalConfigProperty.o.getData("DEADLINE"));
			}
			return _deadX;
		}
	}
}