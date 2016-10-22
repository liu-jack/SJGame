package SJ.Game.data
{
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_itemRecast;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	/**
	 * 玩家洗练数据
	 * 数据格式{heroId, CJDataOfRecastHero}
	 * @author zhengzheng
	 * 
	 */
	public class CJDataOfRecast extends SDataBaseRemoteData
	{
		public function CJDataOfRecast()
		{
			super("CJDataOfRecast");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , this._onloadHeroRecast);
		}
		private var userid:String = "";
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			SocketCommand_itemRecast.getEquipRecastInfo();
			super._onloadFromRemote(params);
		}
		/**
		 * 加载玩家洗练数据
		 * @param e
		 * 
		 */
		protected function _onloadHeroRecast(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_ITEMRECAST_GETRECASTINFO)
			{
				return;
			}
			if(message.retcode == 0)
			{
				var rtnObject:Object = message.retparams;
				this._dataIsEmpty = false;
				this._initRecastData(rtnObject);
				this._dataIsEmpty = true;
				this._onloadFromRemoteComplete();
			}
		}
		
		/**
		 * 设置装备位洗练数据
		 * @param obj
		 * 
		 */		
		private function _initRecastData(obj:Object):void
		{
			
			var positionData:CJDataOfRecastPosition;
			var recastHeroData:CJDataOfRecastHero;
			for each(var data:Object in obj)
			{
				positionData = new CJDataOfRecastPosition();
				positionData.heroid = data.heroid;
				positionData.positiontype = int(data.positiontype);
				positionData.userid = data.userid;
				positionData.addattrjin = data.addattrjin;
				positionData.addattrmu = data.addattrmu;
				positionData.addattrshui = data.addattrshui;
				positionData.addattrhuo = data.addattrhuo;
				positionData.addattrtu = data.addattrtu;
				positionData.addattrbaoji = data.addattrbaoji;
				positionData.addattrrenxing = data.addattrrenxing;
				positionData.addattrshanbi = data.addattrshanbi;
				positionData.addattrmingzhong = data.addattrmingzhong;
				positionData.addattrzhiliao = data.addattrzhiliao;
				positionData.addattrjianshang = data.addattrjianshang;
				positionData.addattrxixue = data.addattrxixue;
				positionData.addattrshanghai = data.addattrshanghai;
				
				recastHeroData = this.getHeroRecastInfo(data.heroid);
				if (recastHeroData != null)
				{
					recastHeroData.setRecastPosition(data.positiontype, positionData);
				}
				else
				{
					recastHeroData = new CJDataOfRecastHero();
					recastHeroData.setRecastPosition(data.positiontype, positionData);
					this.setHeroRecastInfo(data.heroid, recastHeroData);
				}
				this.userid = data.userid;
			}
		}
		/**
		 * 增加武将洗练数据
		 * @param heroId	武将id
		 * 
		 */		
		public function addNewHeroRecastData(heroId:String):void
		{
			var positionData:CJDataOfRecastPosition;
			var recastHeroData:CJDataOfRecastHero = new CJDataOfRecastHero();
			for each(var positionType:int in ConstItem.SCONST_ITEM_POSITION_ALL)
			{
				positionData = new CJDataOfRecastPosition();
				positionData.heroid = heroId;
				positionData.positiontype = int(positionType);
				positionData.userid = this.userid;
				positionData.addattrjin = "0";
				positionData.addattrmu = "0";
				positionData.addattrshui = "0";
				positionData.addattrhuo = "0";
				positionData.addattrtu = "0";
				positionData.addattrbaoji = "0";
				positionData.addattrrenxing = "0";
				positionData.addattrshanbi = "0";
				positionData.addattrmingzhong = "0";
				positionData.addattrzhiliao = "0";
				positionData.addattrjianshang = "0";
				positionData.addattrxixue = "0";
				positionData.addattrshanghai = "0";
				recastHeroData.setRecastPosition(positionType, positionData);
			}
			this.setHeroRecastInfo(heroId, recastHeroData);
		}
		
		
		/**
		 * 获取武将洗练信息
		 * @param heroId	武将id
		 * @return 若洗练信息返回null
		 * 
		 */
		public function getHeroRecastInfo(heroId:String) : CJDataOfRecastHero
		{
			var recastHeroData:CJDataOfRecastHero = this.getData(heroId);
			if (recastHeroData == null)
			{
				recastHeroData = new CJDataOfRecastHero();
				recastHeroData = CJDataOfRecastHero.getNewCJDataOfRecastHero(heroId, this.userid);
				this.setHeroRecastInfo(heroId, recastHeroData);
			}
			return recastHeroData;
		}
		
		/**
		 * 设置武将洗练信息
		 * @param heroId	武将id
		 * @param recastHeroData	武将洗练数据
		 * 
		 */		
		public function setHeroRecastInfo(heroId:String, recastHeroData:CJDataOfRecastHero):void
		{
			this.setData(heroId, recastHeroData);
		}
		
	}
}