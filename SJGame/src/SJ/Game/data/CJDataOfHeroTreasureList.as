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
	 * 武将身上装备灵丸列表
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-31 下午2:29:25  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfHeroTreasureList extends SDataBaseRemoteData
	{
		/*武将身上灵丸信息字典*/
		private var _heroTreasureListDic:Dictionary = new Dictionary();
		
		public static const DATA_KEY:String = "treasure_data_list";
		
		public function CJDataOfHeroTreasureList()
		{
			super("CJDataOfHeroTreasureList");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , this._onDataLoaded);
		}
		
		private function _onDataLoaded(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() == ConstNetCommand.CS_TREASURE_GETALLTREASURELIST)
			{
				if(message.retcode == 1)
				{
					this._initData(message.retparams);
					this._onloadFromRemoteComplete();
				}
			}
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			SocketCommand_Treasure.getAllHeroTreasureList();
		}
		
		private function _initData(obj:Object):void
		{
			for(var heroid:String in obj)
			{
				var heroTreasure:CJDataOfTreasure = new CJDataOfTreasure();
				heroTreasure.init(obj[heroid]);
				this._heroTreasureListDic[heroid] = heroTreasure;
			}
			this.setData(DATA_KEY , this._heroTreasureListDic);
		}
	}
}