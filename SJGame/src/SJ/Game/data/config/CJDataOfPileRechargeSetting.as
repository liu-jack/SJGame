package SJ.Game.data.config
{
	import SJ.Game.ServerList.CJServerList;
	import SJ.Game.data.json.Json_pile_recharge_gift_setting;
	import SJ.Game.data.json.Json_pile_recharge_setting;
	
	import engine_starling.utils.AssetManagerUtil;

	/**
	 * 累积充值回馈
	 * @author longtao
	 * 
	 */
	public class CJDataOfPileRechargeSetting
	{
		
		private static var _o:CJDataOfPileRechargeSetting;
		public static function get o():CJDataOfPileRechargeSetting
		{
			if(_o == null)
				_o = new CJDataOfPileRechargeSetting();
			return _o;
		}
		
		// {pileType:Json_pile_recharge_setting}
		private var _dataPileRecharge:Object;
		// {pileType:{pileid:Json_pile_recharge_gift_setting}}
		private var _dataPileRechargeGift:Object;
		
		public function CJDataOfPileRechargeSetting()
		{
			_initData();
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject("pile_recharge_setting.json") as Array;
			if(obj == null)
				return;
			
			var serverid:int = CJServerList.getServerID();
			_dataPileRecharge = new Object();
			var length:int = obj.length;
			for(var i:int=0 ; i < length ; i++)
			{
				var data:Json_pile_recharge_setting = new Json_pile_recharge_setting();
				data.loadFromJsonObject(obj[i]);
				if (int(data.serverid) == serverid || int(data.serverid) == -1)
					_dataPileRecharge[data.type] = data;
			}
			
			obj = AssetManagerUtil.o.getObject("pile_recharge_gift_setting.json") as Array;
			if (null == obj)
				return;
			
			_dataPileRechargeGift = new Object;
			length = obj.length;
			for(i=0; i<length ; i++)
			{
				var tdata:Json_pile_recharge_gift_setting = new Json_pile_recharge_gift_setting();
				tdata.loadFromJsonObject(obj[i]);
				if (_dataPileRecharge[tdata.type]) // 本服务器有该类型活动才加载礼包信息
				{
					if (null == _dataPileRechargeGift[tdata.type])
						_dataPileRechargeGift[tdata.type] = new Object
					_dataPileRechargeGift[tdata.type][tdata.pileid] = tdata;
				}
			}
		}
		
		/**
		 * 获取累积奖励信息
		 * @param pileType
		 * @return 
		 * 
		 */
		public function getPileRechargeSetting(pileType:String):Json_pile_recharge_setting
		{
			return _dataPileRecharge[pileType];
		}
		
		public function get pileRechargeSetting():Object
		{
			return _dataPileRecharge;
		}
		
		
		/**
		 * 获取累计奖励礼品信息
		 * @param pileType
		 * @param pileIndex
		 * @return 
		 */
		public function getPileRechargeGiftSetting(pileType:String, pileIndex:String):Json_pile_recharge_gift_setting
		{
			return _dataPileRechargeGift[pileType][pileIndex];
		}
		
		public function get PileRechargeGiftSetting():Object
		{
			return _dataPileRechargeGift;
		}
		
		
		/**
		 * 是否显示累积充值
		 * @return 
		 */
		public function isShowFunc(_serverOpenTime:uint):Boolean
		{
			var startTime:uint = 0;// 活动开启时间
			var endTime:uint = 0;// 活动结束时间
			
			// {pileType:Json_pile_recharge_setting}
			var tDate:Date = new Date;
			var curTime:uint = uint(tDate.time/1000);
			
			for(var pileType:* in _dataPileRecharge)
			{		
				var js:Json_pile_recharge_setting = CJDataOfPileRechargeSetting.o.getPileRechargeSetting(pileType);
				if(!((int(js.serverid) == -1) || (int(js.serverid) == CJServerList.getServerID())))
					continue;
				if (null != js.startday)
				{
					startTime = int(js.startday)*3600*24 + _serverOpenTime;
				}
				else if(null != js.startdate)
				{
					// 切分日期
					var date:Array = String(js.startdate).split("/");
					if (date.length == 1)
						date = String(js.startdate).split("-");
					// 切分时间
					var atime:Array = String(js.starttime).split(":");
					
					var aDate:Date = new Date(date[0],date[1],date[2], atime[0],atime[1],atime[2]);
					
					startTime = int(aDate.time / 1000);
				}
				endTime = startTime + int(js.effectivetime)*60;
				if ( curTime < endTime )
					// 显示
					return true;
			}
			
			return false;
		}
		
	}
}