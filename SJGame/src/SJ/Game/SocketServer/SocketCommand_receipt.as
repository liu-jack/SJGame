package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.event.CJEvent;
	import SJ.Game.task.CJTaskEvent;
	import SJ.Game.task.CJTaskEventHandler;
	
	import engine_starling.utils.Logger;
	import engine_starling.utils.SPlatformUtils;

	/**
	 * 平台充值票据
	 * @author sangxu
	 * 
	 */
	public class SocketCommand_receipt
	{
		public function SocketCommand_receipt()
		{
			
		}
		/**
		 * 登录操作 
		 * @param username 用户名
		 * @param password 密码 需要外部MD5加密
		 * 
		 */
		public static function verifyreceipt(receipt:String, thirdPartyType:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_RECEIPT_VERIFYRECEIPT, receipt, thirdPartyType);
		}
		
		
		public static function verifyreceipt20(receipt:String, thirdPartyType:String, rechargeid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_RECEIPT_VERIFYRECEIPT20, receipt, thirdPartyType, rechargeid);
		}
		
		/**
		 * 获取票据	
		 */	
		public static function createOrderId(thirdPartyType:String, Version:String, rechargeId:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_RECEIPT_CREATEORDER, thirdPartyType, Version, rechargeId);
		}
	}
}