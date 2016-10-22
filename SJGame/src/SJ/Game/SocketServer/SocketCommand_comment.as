package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	/**
	 * 评论活动网络操作
	 * @author zhengzheng
	 * 
	 */
	public class SocketCommand_comment
	{
		public function SocketCommand_comment()
		{
		}
		
		/**
		 * 获取评论活动奖励 
		 */
		public static function goToComment():void
		{
			SocketManager.o.call(ConstNetCommand.CS_COMMENT_GOTOCOMMENT);
		}
	}
}