package SJ.Game.data
{
	import SJ.MainApplication;
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.Platform.ISPlatfrom;
	import SJ.Game.SocketServer.SocketCommand_receipt;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.core.TalkingDataService;
	import SJ.Game.data.config.CJDataOfRechargeProperty;
	import SJ.Game.data.json.Json_recharge_setting;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.layer.CJLoadingLayer;
	
	import engine_starling.SApplication;
	import engine_starling.data.SDataBase;
	import engine_starling.utils.Logger;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 * 数据 - 平台票据
	 * @author sangxu
	 * 
	 */
	
	public class CJDataOfPlatformReceipt extends SDataBase
	{
		public static const RECEIPT_FAILED:String = "RECEIPT_FAILED";
		
		public function CJDataOfPlatformReceipt()
		{
			super("CJDataOfPlatformReceipt");
		}
		
		/**
		 * 数据，key为平台类型，value为票据内容
		 */
		
		private var _verifyreceiptTimes: int = 0;
		
		/**
		 * 保存
		 * @param key	平台类型
		 * @param value	票据内容
		 * 
		 */
		public function saveDataToCache(key:String, value:String, talkingCount:Boolean = true):void
		{
			this.setData(key, value);
			this.saveToCache();
			
			if(talkingCount)
			{
				var arrayProductData:Array = CJDataOfRechargeProperty.o.getPropertysByChannel(ConstGlobal.CHANNEL);
				var json:Object = JSON.parse(value);
				var rechargeId:String = json["rechargeid"];
				var orderId:String = json["receipt"];
				
				for(var index:* in arrayProductData)
				{
					var obj:Json_recharge_setting = arrayProductData[index];
					if(obj.rechargeid == rechargeId)
					{
						
						TalkingDataService.o.createOrder(orderId, obj.rechargeid, obj.rmbnum, obj.goldnum);	
						break;
					}
				}
			}
		}
		
		/**
		 * 从Cache中读取数据
		 * 
		 */		
		public function loadCache():void
		{
			this.loadFromCache();
		}
		
		/**
		 * 清除Cache中数据
		 * 
		 */		
		public function completeReceipt():void
		{
			this.clearAll();
			this.saveToCache();
			SocketCommand_role.get_role_info();
		}
		
		/**
		 * 是否含有票据
		 * @param key
		 * @return 
		 * 
		 */		
		public function hasReceipt(key:String):Boolean
		{
			return hasKey(key);
		}
		
		/**
		 * 获取票据信息
		 * @param key	平台类型 ConstGlobal.CHANNEL
		 * @return 存在数据返回String，否则返回null
		 * 
		 */		
		public function getReceipt(key:String):String
		{
			return getData(key, null);
		}
		
		public function pay(productId: String):void
		{
			if(hasUncompleteReceipt())
			{
				clearVerifyreceiptTimes();
				checkAndSend();
				return;
			}
			var iplatform: ISPlatfrom = (SApplication.appInstance as MainApplication).platform;
			iplatform.pay(productId, 1, "", null);	
		}
		
		public function clearVerifyreceiptTimes():void
		{
			_verifyreceiptTimes = 0;
		}
		
		/**
		 * 检查是否有未完成的票据
		 */ 
		public function hasUncompleteReceipt():Boolean
		{
			var receipt:String = getReceipt(ConstGlobal.CHANNELID);
			if (null == receipt)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 检验并发送票据数据到服务器
		 * 当前类如果有对应当前平台的票据则发送，发送后清空本地缓存,
		 * 登录时调用需先调用loadCache()方法加载本地缓存到当前数据类中
		 */		
		public function checkAndSend(callback:Function = null):void
		{
			_verifyreceiptTimes++;
			var receipt:String = getReceipt(ConstGlobal.CHANNELID);
			if (null == receipt)
			{
				return;
			}
			// 监听rpc票据校验
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			// 向服务器发送票据校验请求
			
			// TODO to delete this line 
//			SocketCommand_receipt.verifyreceipt(receipt, ConstPlatformId.PlatformIds[ConstPlatformId.ID_ANDRIODUC]);
//			return;
			try{
				var object:Object
				object = JSON.parse(receipt);
				if(object)
				{
					Logger.log("verifyreceipt", "verify  _verifyreceiptTimes: " + _verifyreceiptTimes);
					SocketCommand_receipt.verifyreceipt20(object["receipt"], ConstGlobal.CHANNEL, object["rechargeid"]);
				}
				else
				{
					Logger.log("verifyreceipt", "verify  _verifyreceiptTimes: " + _verifyreceiptTimes);
					SocketCommand_receipt.verifyreceipt(receipt, ConstGlobal.CHANNEL);
				}
			}
			catch(e:Error)
			{
				Logger.log("verifyreceipt", "verify  _verifyreceiptTimes: " + _verifyreceiptTimes);
				SocketCommand_receipt.verifyreceipt(receipt, ConstGlobal.CHANNEL);
			}
		}
		
		/**
		 * rpc消息监听
		 * @param e
		 * 
		 */		
		private function _onRpcReturn(e:Event):void{
			var msg:SocketMessage = e.data as SocketMessage;
			if((msg.getCommand() == ConstNetCommand.CS_RECEIPT_VERIFYRECEIPT) 
				|| (msg.getCommand() == ConstNetCommand.CS_RECEIPT_VERIFYRECEIPT20))
			{
//				0:成功
//				1：没有订单  X
//				2：没有收到平台通知 继续
//				3：更新失败
//				4：参数错误
//				5：未知错误
//              6：已经验过
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
				if (msg.retcode == 0)
				{							
					var receipt:String = getReceipt(ConstGlobal.CHANNELID);
					try
					{
						var object:Object
						object = JSON.parse(receipt);
						TalkingDataService.o.chargeSuccess(object["receipt"]);
					}
					catch(e:Error)
					{
						Logger.log("verifyreceipt", "receipt is not a json, channelid: " + ConstGlobal.CHANNELID);
					}
					completeReceipt();				
				}
				else if(msg.retcode == 2)
				{
					if(_verifyreceiptTimes >= 3)
					{
						Logger.log("verifyreceipt", "over 3 times, give up");
						
						dispatchEventWith(RECEIPT_FAILED, false, {retcode: msg.retcode});
					}
					else 
					{
						//需要轮询
						CJLoadingLayer.show();
						Starling.juggler.delayCall(checkAndSend, 3.0);
						return;
					}
				}
				else 
				{
					completeReceipt();
				}
			}
		}
	}
}