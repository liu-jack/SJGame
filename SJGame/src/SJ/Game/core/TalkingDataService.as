package SJ.Game.core
{
	import com.talkingdata.game.TDAccountType;
	import com.talkingdata.game.TDCustomEvent;
	import com.talkingdata.game.TDGAAccount;
	import com.talkingdata.game.TDGAItem;
	import com.talkingdata.game.TDGAMission;
	import com.talkingdata.game.TDGAVirtualCurrency;
	import com.talkingdata.game.TalkingDataGA;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import SJ.Common.Constants.ConstTalkingData;
	
	import engine_starling.utils.SManufacturerUtils;

	/**
	 * talkingdata
	 * @author changmiao
	 * 
	 */
	public class TalkingDataService
	{
		private var _account: * = null;
		private var _isSupported:Boolean;
		
		public function TalkingDataService()
		{
			var manufactory:String = SManufacturerUtils.getManufacturerType();		
			if(manufactory == SManufacturerUtils.TYPE_ANDROID)
			{
				_isSupported = true;
			}
			else if(manufactory == SManufacturerUtils.TYPE_IOS)
			{
				_isSupported = true;
			}
			else 
			{
				_isSupported = false;
			}
			CONFIG::CHANNELID_0{
				_isSupported = false;
			}
			if(!_isSupported)
				return;
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE,_onActive);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,_onDeActive);
			TalkingDataGA.onStart(ConstTalkingData.ConstAppId, ConstTalkingData.ConstchannelId);
		}
		
		public function isSupported():Boolean
		{
			return _isSupported;
		}
		
		private function _onActive(e:Event):void
		{
			TalkingDataGA.onStart(ConstTalkingData.ConstAppId, ConstTalkingData.ConstchannelId);
		}
		private function _onDeActive(e:Event):void
		{
			TalkingDataGA.onDeactivate();
		}
		private static var _o:TalkingDataService = null;
		public static function get o():TalkingDataService
		{
			if(_o == null)
			{
				_o = new TalkingDataService();
			}
			return _o;
		}
		
		/**
		 * 记录玩家登录 
		 * @param userId
		 * @param serverName
		 * 
		 */		
		public function login(userId:String, serverName:String):void
		{
			if(!_isSupported)
				return;
			if(!_account)
			{
				_account = TDGAAccount.setAccount(userId); 
			}
			_account.setAccountType(TDAccountType.REGISTERED);
			_account.setAccountServer(serverName);
		}
		
		/**
		 * 玩家级别改变 
		 * @param newLevel
		 * 
		 */		
		public function levelChange(newLevel: int):void
		{
			if(!_isSupported)
				return;
			_account.setAccountLevel(newLevel);
		}
		
		/**
		 * 玩家创建订单
		 * @param orderId
		 * @param iapId
		 * @param currencyAmount
		 * @param virtualCurrencyAmount
		 * 
		 */		
		public function createOrder(orderId:String, iapId:String, currencyAmount:Number,
									virtualCurrencyAmount:Number):void
		{
			if(!_isSupported)
				return;
			TDGAVirtualCurrency.onChargeRequest(orderId, iapId, currencyAmount,
				TDGAVirtualCurrency.CNY, virtualCurrencyAmount, ConstTalkingData.ConstchannelId);
		}
		/**
		 * 玩家支付成功
		 * @param orderId
		 * 
		 */		
		public function chargeSuccess(orderId: String):void
		{
			if(!_isSupported)
				return;
			TDGAVirtualCurrency.onChargeSuccess(orderId);
		}
		
		/**
		 * 玩家消费元宝 
		 * @param name
		 * @return 
		 * 
		 */		
		public function useGold(name:String, count:int, goldNum:int):void
		{
			if(!_isSupported)
				return;
			TDGAItem.onPurchase(name, count, goldNum);
		}
		
		/**
		 * 玩家使用物品 
		 * @param itemname
		 * @param count
		 * 
		 */		
		public function useItem(itemName:String, count:int):void
		{
			if(!_isSupported)
				return;
			TDGAItem.onUse(itemName, count);
		}
		/**
		 * 关卡开始 
		 * @param missionId
		 * 
		 */		
		public function messionBegin(missionId:String):void
		{
			if(!_isSupported)
				return;
			TDGAMission.onMessionBegin(missionId);
		}
		/**
		 * 关卡失败 
		 * @param missionId
		 * @param reason
		 * 
		 */		
		public function missionFailed(missionId:String, reason:String = ""):void
		{
			if(!_isSupported)
				return;
			TDGAMission.onMissionFailed(missionId, reason);
		}
		/**
		 * 关卡完成 
		 * @param missionId
		 * 
		 */		
		public function missionCompleted(missionId:String):void
		{
			if(!_isSupported)
				return;
			TDGAMission.onMissionCompleted(missionId);
		}
		
		/**
		 * 自定义事件
		 * @param eventId
		 * @param key
		 * @param value
		 * 
		 */
		public function customEvent(eventId:String, values:Object):void
		{
			if(!_isSupported)
				return;
			var ev:TDCustomEvent = new TDCustomEvent();
			for(var key:String in values)
			{
				if(values[key] is int)
				{
					ev.setEntityInt(key, values[key]);
				}
				else if(values[key] is String)
				{
					ev.setEntityString(key, values[key]);
				}
			}	
			TalkingDataGA.onEvent(eventId, ev);
		}
	}
}