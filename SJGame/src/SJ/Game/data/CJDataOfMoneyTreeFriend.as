package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_moneytree;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	/**
	 * 好友摇钱树数据
	 * @author sangxu
	 * 
	 */
	public class CJDataOfMoneyTreeFriend extends SDataBaseRemoteData
	{
		public function CJDataOfMoneyTreeFriend()
		{
			super("CJDataOfMoneyTreeFriend");
			_init()
		}
		
		private static var _o:CJDataOfMoneyTreeFriend;
		public static function get o():CJDataOfMoneyTreeFriend
		{
			if(_o == null)
			{
				_o = new CJDataOfMoneyTreeFriend();
			}
			return _o;
		}
		
		
		
		private function _init():void
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onloadData);
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			SocketCommand_moneytree.getFriendMoneyTreeInfo();
			super._onloadFromRemote(params);
		}
		
		/**
		 * 加载数据
		 * @param e
		 * 
		 */
		protected function _onloadData(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_MONEYTREE_GETFRIENDMONEYTREEINFO)
			{
				return;
			}
			if(message.retcode == 0)
			{
				var rtnObject:Object = message.retparams;
				_initMoneyTreeData(rtnObject);
				this._dataIsEmpty = true;
				this._onloadFromRemoteComplete();
			}
			
		}
		
		/**
		 * 初始化好友摇钱树数据
		 * @param obj
		 * 
		 */		
		private function _initMoneyTreeData(obj:Object):void
		{
			var tempArray:Array = new Array();
			for each(var data:Object in obj)
			{
				var singleData : CJDataOfMoneyTreeSingleFriend = new CJDataOfMoneyTreeSingleFriend();
				for ( var key:String in data)
				{
					singleData.setData(key, data[key]);
				}
				tempArray.push(singleData);
			}
			this.friendDataArray = tempArray;
		}
		
		/**
		 * 设置是否可施肥
		 * @param friendUid	好友uid
		 * @param canFeed	是否可施肥
		 * 
		 */		
		public function setFriendCanFeed(friendUid:String, canFeed:Boolean):void
		{
			for each (var singleData : CJDataOfMoneyTreeSingleFriend in this.friendDataArray)
			{
				if (singleData.uid == friendUid)
				{
					singleData.canfeed = canFeed;
					break;
				}
			}
		}
		
		/**
		 * 设置所有好友不可施肥
		 * 
		 */		
		public function setAllFriendCanNotFeed():void
		{
			var canFeed:Boolean = false;
			for each (var singleData : CJDataOfMoneyTreeSingleFriend in this.friendDataArray)
			{
				singleData.canfeed = canFeed;
			}
		}
		
		/**
		 * 根据好友uid获取好友名
		 * @param friendUid
		 * @return 
		 * 
		 */		
		public function getFriendName(friendUid:String):String
		{
			var canFeed:Boolean = false;
			for each (var singleData : CJDataOfMoneyTreeSingleFriend in this.friendDataArray)
			{
				if (friendUid == singleData.uid)
				{
					return singleData.name;
				}
			}
			return "";
		}
		
		/** setter */
		public function set friendDataArray(value:Array):void
		{
			this.setData("friendDataArray", value);
		}
		
		/** getter */
		public function get friendDataArray():Array
		{
			return this.getData("friendDataArray");
		}
	}
}