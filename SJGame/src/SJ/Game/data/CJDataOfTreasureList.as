package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTreasure;
	import SJ.Game.SocketServer.SocketCommand_Treasure;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBase;
	import engine_starling.data.SDataBaseRemoteData;
	
	import flash.utils.Dictionary;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 聚灵 - 用户灵丸数据列表
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-31 下午12:34:30  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfTreasureList extends SDataBaseRemoteData
	{
		/*灵丸数据的字典  treasureid => CJDataOfTreasure*/
		private var _treasureDic:Dictionary  = new Dictionary();
		public static const DATA_KEY:String = "treasure_data_list";
		private var _treasureTempBagList:Array = null;
		private var _treasureUserBagList:Array = null;
		private var _treasureHeroList:Array = null;
		
		public function CJDataOfTreasureList()
		{
			super("CJDataOfTreasureList");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , this._onDataLoaded);
		}
		
		private function _onDataLoaded(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() == ConstNetCommand.CS_TREASURE_GETALLTREASURELIST)
			{
				if(message.retcode == 1)
				{
					this.initData(message.retparams);
					this._onloadFromRemoteComplete();
				}
			}
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			SocketCommand_Treasure.getAllTreasureList();
		}
		
		public function initData(obj:Object):void
		{
			this._treasureDic = new Dictionary();
			_treasureTempBagList = new Array();
			_treasureUserBagList = new Array();
			_treasureHeroList = new Array();
			for(var treasureid:String in obj)
			{
				var treasure:CJDataOfTreasure = new CJDataOfTreasure();
				treasure.init(obj[treasureid]);
				this._treasureDic[treasureid] = treasure;
				if(treasure.placetype == ConstTreasure.TREASURE_PLACE_TEMP_BAG)
				{
					this._treasureTempBagList.unshift(treasure);
				}
				else if(treasure.placetype == ConstTreasure.TREASURE_PLACE_USER_BAG)
				{
					this._treasureUserBagList.unshift(treasure);
				}
				else if(treasure.placetype == ConstTreasure.TREASURE_PLACE_HERO)
				{
					this._treasureHeroList.unshift(treasure);
				}
				else
				{
					Assert(false , "灵丸位置信息错误");	
				}
			}
			this.setData(DATA_KEY , this._treasureDic);
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_TREASURE_DATA_CHANGE);
		}
		
		/**
		 * 临时背包灵丸列表
		 */		
		public function get treasureTempBagList():Array
		{
			return _treasureTempBagList;
		}

		/**
		 * 用户背包灵丸列表
		 */	
		public function get treasureUserBagList():Array
		{
			return _treasureUserBagList;
		}

		/**
		 * 武将身上灵丸列表
		 */	
		public function get treasureHeroList():Array
		{
			return _treasureHeroList;
		}
	}
}