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
	 * 我的摇钱树数据
	 * @author sangxu
	 * 
	 */
	public class CJDataOfMoneyTreeMine extends SDataBaseRemoteData
	{
		public function CJDataOfMoneyTreeMine()
		{
			super("CJDataOfMoneyTreeMine");
			_init()
		}
		
		private static var _o:CJDataOfMoneyTreeMine;
		public static function get o():CJDataOfMoneyTreeMine
		{
			if(_o == null)
			{
				_o = new CJDataOfMoneyTreeMine();
			}
			return _o;
		}
		
		
		
		private function _init():void
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onloadData);
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			SocketCommand_moneytree.getSelfMoneyTreeInfo();
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
			if(message.getCommand() != ConstNetCommand.CS_MONEYTREE_GETSELFMONEYTREEINFO)
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
		 * 初始化摇钱树数据
		 * @param obj
		 * 
		 */		
		private function _initMoneyTreeData(obj:Object):void
		{
			this.advtree = obj.advtree;
			this.exp = obj.exp;
			this.friendFeedTimes = obj.friendfeedtimes;
			this.harvestLevel = obj.harvestlevel;
			this.harvestTimes = obj.harvesttimes;
			this.history = obj.histroy;
			this.leftFeedTimes = obj.leftfeedtimes;
			this.nextFeedTime = obj.nextfeedtime;
			this.selfFeedTimes = obj.selffeedtimes;
			this.treeLevel = obj.treelevel;
			this.updateTime = obj.updatetime;
		}
		
		/** setter */
		public function set advtree(value:int):void
		{
			this.setData("advtree", value);
		}
		public function set exp(value:int):void
		{
			this.setData("exp", value);
		}
		public function set friendFeedTimes(value:int):void
		{
			this.setData("friendfeedtimes", value);
		}
		public function set harvestLevel(value:int):void
		{
			this.setData("harvestlevel", value);
		}
		public function set harvestTimes(value:int):void
		{
			this.setData("harvesttimes", value);
		}
		public function set history(value:String):void
		{
			this.setData("history", value);
		}
		public function set leftFeedTimes(value:int):void
		{
			this.setData("leftfeedtimes", value);
		}
		public function set nextFeedTime(value:Number):void
		{
			this.setData("nextfeedtime", value);
		}
		public function set selfFeedTimes(value:int):void
		{
			this.setData("selffeedtimes", value);
		}
		public function set treeLevel(value:int):void
		{
			this.setData("treelevel", value);
		}
		public function set updateTime(value:int):void
		{
			this.setData("updatetime", value);
		}
		public function set cooldownEnd(value:Number):void
		{
			this.setData("cooldownend", value);
		}
		
		/** getter */
		public function get advtree():int
		{
			return this.getData("advtree");
		}
		public function get exp():int
		{
			return this.getData("exp");
		}
		public function get friendFeedTimes():int
		{
			return this.getData("friendfeedtimes");
		}
		public function get harvestLevel():int
		{
			return this.getData("harvestlevel");
		}
		public function get harvestTimes():int
		{
			return this.getData("harvesttimes");
		}
		public function get history():String
		{
			return this.getData("history");
		}
		public function get leftFeedTimes():int
		{
			return this.getData("leftfeedtimes");
		}
		public function get nextFeedTime():Number
		{
			return this.getData("nextfeedtime");
		}
		public function get selfFeedTimes():int
		{
			return this.getData("selffeedtimes");
		}
		public function get treeLevel():int
		{
			return this.getData("treelevel");
		}
		public function get updateTime():int
		{
			return this.getData("updatetime");
		}
		public function get cooldownEnd():Number
		{
			return this.getData("cooldownend");
		}
		
		
	}
}