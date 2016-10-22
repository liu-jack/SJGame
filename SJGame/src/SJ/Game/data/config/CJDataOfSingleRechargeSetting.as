package SJ.Game.data.config
{
	import SJ.Game.ServerList.CJServerList;
	import SJ.Game.data.json.Json_single_recharge_gift_setting;
	import SJ.Game.data.json.Json_single_recharge_setting;
	
	import engine_starling.utils.AssetManagerUtil;

	/**
	 * 单笔充值配置
	 * @author sangxu
	 * 
	 */
	public class CJDataOfSingleRechargeSetting
	{
		
		private static var _o:CJDataOfSingleRechargeSetting;
		public static function get o():CJDataOfSingleRechargeSetting
		{
			if(_o == null)
				_o = new CJDataOfSingleRechargeSetting();
			return _o;
		}
		
		// {singleType:Json_single_recharge_setting}
		private var _dataSingleRecharge:Object;
		// {singleType:{singleid:Json_single_recharge_gift_setting}}
		private var _dataSingleRechargeGift:Object;
		
		public function CJDataOfSingleRechargeSetting()
		{ 
			_initData();
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject("single_recharge_setting.json") as Array;
			if(obj == null)
			{
				return;
			}
			
			var serverid:int = CJServerList.getServerID();
			_dataSingleRecharge = new Object();
			var length:int = obj.length;
			for(var i:int=0 ; i < length ; i++)
			{
				var data:Json_single_recharge_setting = new Json_single_recharge_setting();
				data.loadFromJsonObject(obj[i]);
				if (int(data.serverid) == serverid || int(data.serverid) == -1)
					_dataSingleRecharge[data.type] = data;
			}
			
			obj = AssetManagerUtil.o.getObject("single_recharge_gift_setting.json") as Array;
			if (null == obj)
			{
				return;
			}
			
			_dataSingleRechargeGift = new Object;
			length = obj.length;
			for(i=0; i<length ; i++)
			{
				var tdata:Json_single_recharge_gift_setting = new Json_single_recharge_gift_setting();
				tdata.loadFromJsonObject(obj[i]);
				if (_dataSingleRecharge[tdata.type]) // 本服务器有该类型活动才加载礼包信息
				{
					if (null == _dataSingleRechargeGift[tdata.type])
						_dataSingleRechargeGift[tdata.type] = new Object
					_dataSingleRechargeGift[tdata.type][tdata.singleid] = tdata;
				}
			}
		}
		
		/**
		 * 获取累积奖励信息
		 * @param singleType
		 * @return 
		 * 
		 */
		public function getSingleRechargeSetting(singleType:String):Json_single_recharge_setting
		{
			return _dataSingleRecharge[singleType];
		}
		
		public function get singleRechargeSetting():Object
		{
			return _dataSingleRecharge;
		}
		
		
		/**
		 * 获取累计奖励礼品信息
		 * @param singleType
		 * @param singleIndex
		 * @return 
		 */
		public function getSingleRechargeGiftSetting(singleType:String, singleIndex:String):Json_single_recharge_gift_setting
		{
			return _dataSingleRechargeGift[singleType][singleIndex];
		}
		
		public function get singleRechargeGiftSetting():Object
		{
			return _dataSingleRechargeGift;
		}
		
		
		/**
		 * 是否显示单笔充值
		 * @return 
		 */
		public function isShowFunc(serverOpenTime:uint):Boolean
		{
			var startTime:uint = 0;// 活动开启时间
			var endTime:uint = 0;// 活动结束时间
			
			// {singleType:Json_single_recharge_setting}
			var tDate:Date = new Date;
			var curTime:uint = uint(tDate.time/1000);
			
			for(var singleType:* in _dataSingleRecharge)
			{
				var js:Json_single_recharge_setting = CJDataOfSingleRechargeSetting.o.getSingleRechargeSetting(singleType);
				if(!((int(js.serverid) == -1) || (int(js.serverid) == CJServerList.getServerID())))
				{
					continue;
				}
				if (null != js.startday)
				{
					startTime = int(js.startday) * 3600 * 24 + serverOpenTime;
				}
				else if(null != js.startdate)
				{
					// 切分日期
					var date:Array = String(js.startdate).split("/");
					if (date.length == 1)
					{
						date = String(js.startdate).split("-");
					}
					// 切分时间
					var atime:Array = String(js.starttime).split(":");
					
					var aDate:Date = new Date(date[0],date[1],date[2], atime[0],atime[1],atime[2]);
					
					startTime = int(aDate.time / 1000);
				}
				endTime = startTime + int(js.effectivetime)*60;
				if ( curTime < endTime )
				{
					// 显示
					return true;
				}
			}
			
			return false;
		}
		
	}
}