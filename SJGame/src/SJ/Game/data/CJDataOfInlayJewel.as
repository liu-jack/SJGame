package SJ.Game.data
{
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_enhance;
	import SJ.Game.SocketServer.SocketCommand_jewel;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	/**
	 * 宝石镶嵌数据
	 * 数据格式{heroId, CJDataOfInlayHero}
	 * @author sangxu
	 * 
	 */
	public class CJDataOfInlayJewel extends SDataBaseRemoteData
	{
		public function CJDataOfInlayJewel()
		{
			super("CJDataOfInlayJewel");
			_init()
		}
		private var userid:String = "";
		private static var _o:CJDataOfInlayJewel;
		public static function get o():CJDataOfInlayJewel
		{
			if(_o == null)
			{
				_o = new CJDataOfInlayJewel();
			}
			return _o;
		}
		
		private function _init():void
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onloadHeroInlay);
		}
		
		/**
		 * 加载装备强化
		 * @param e
		 * 
		 */
		protected function _onloadHeroInlay(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_JEWEL_GETINLAYINFO)
			{
				return;
			}
			if(message.retcode == 0)
			{
				var rtnObject:Object = message.retparams;
				this._dataIsEmpty = false;
				this._initJewelInlayData(rtnObject);
				this._dataIsEmpty = true;
				this._onloadFromRemoteComplete();
			}
		}
		
		/**
		 * 设置装备强化数据
		 * @param obj
		 * 
		 */		
		private function _initJewelInlayData(obj:Object):void
		{
			
			var positionData:CJDataOfInlayPosition;
			var inlayHeroData:CJDataOfInlayHero;
			for each(var data:Object in obj)
			{
				positionData = new CJDataOfInlayPosition();
				positionData.heroid = data.heroid;
				positionData.positiontype = int(data.positiontype);
				positionData.userid = data.userid;
				positionData.holeitemid0 = data.holeitemid0;
				positionData.holeitemid1 = data.holeitemid1;
				positionData.holeitemid2 = data.holeitemid2;
				positionData.holeitemid3 = data.holeitemid3;
				positionData.holeitemid4 = data.holeitemid4;
				positionData.holeitemid5 = data.holeitemid5;
				
				inlayHeroData = this.getHeroInlayInfo(data.heroid);
				if (inlayHeroData != null)
				{
					inlayHeroData.setInlayPosition(data.positiontype, positionData);
				}
				else
				{
					inlayHeroData = new CJDataOfInlayHero();
					inlayHeroData.setInlayPosition(data.positiontype, positionData);
					this.setHeroInlayInfo(data.heroid, inlayHeroData);
				}
				this.userid = data.userid;
			}
		}
		/**
		 * 增加武将镶嵌数据
		 * @param heroId	武将id
		 * 
		 */		
		public function addNewHeroInlayData(heroId:String):void
		{
			var positionData:CJDataOfInlayPosition;
			var inlayHeroData:CJDataOfInlayHero = new CJDataOfInlayHero();
			for each(var positionType:int in ConstItem.SCONST_ITEM_POSITION_ALL)
			{
				positionData = new CJDataOfInlayPosition();
				positionData.heroid = heroId;
				positionData.positiontype = int(positionType);
				positionData.userid = this.userid;
				positionData.holeitemid0 = "0";
				positionData.holeitemid1 = "-1";
				positionData.holeitemid2 = "-1";
				positionData.holeitemid3 = "-1";
				positionData.holeitemid4 = "-1";
				positionData.holeitemid5 = "-1";
				inlayHeroData.setInlayPosition(positionType, positionData);
			}
			this.setHeroInlayInfo(heroId, inlayHeroData);
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			SocketCommand_jewel.getInlayInfo();
			super._onloadFromRemote(params);
		}
		
		/**
		 * 获取武将镶嵌信息
		 * @param heroId	武将id
		 * @return 若无镶嵌信息返回null
		 * 
		 */
		public function getHeroInlayInfo(heroId:String) : CJDataOfInlayHero
		{
			var inlayHeroData:CJDataOfInlayHero = this.getData(heroId);
			if (inlayHeroData == null)
			{
				inlayHeroData = new CJDataOfInlayHero();
				inlayHeroData = CJDataOfInlayHero.getNewCJDataOfInlayHero(heroId, this.userid);
				this.setHeroInlayInfo(heroId, inlayHeroData);
			}
			return inlayHeroData;
		}
		
		/**
		 * 设置武将镶嵌信息
		 * @param heroId	武将id
		 * @param inlayHeroData	武将宝石镶嵌数据
		 * 
		 */		
		public function setHeroInlayInfo(heroId:String, inlayHeroData:CJDataOfInlayHero):void
		{
			this.setData(heroId, inlayHeroData);
		}
		
	}
}