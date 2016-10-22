package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	/**
	 * 邮件网络操作
	 * @author zhengzheng
	 * 
	 */
	public class SocketCommand_mail
	{
		public function SocketCommand_mail()
		{
		}
		
		/**
		 * 获取所有邮件
		 * @param pages 分页缓存页数
		 */
		public static function getMails(pages:int = 0):void
		{
			SocketManager.o.call(ConstNetCommand.CS_MAIL_GET_MAILS, pages);
		}
		
		/**
		 * 读邮件
		 * @param mailId 邮件id
		 * 
		 */		
		public static function readMail(mailId:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_MAIL_READ_MAIL, mailId);
		}
		/**
		 * 获取邮件附件
		 * @param mailId 邮件id
		 */
		public static function recvMailAttach(mailId:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_MAIL_RECV_MAIL_ATTACH, mailId);
		}
		/**
		 * 删除邮件
		 * @param mailId 邮件id
		 */
		public static function delMail(mailId:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_MAIL_DEL_MAIL,mailId);
		}
	}
}