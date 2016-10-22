package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	/**
	 * 传功网络操作
	 * @author zhengzheng
	 * 
	 */
	public class SocketCommand_transferAbility
	{
		public function SocketCommand_transferAbility()
		{
		}
		
		/**
		 * 获取武将传功信息
		 * @param heroidnew 被传功武将id(接收武将)
		 * @param heroidold 传功武将id(发出武将)
		 */
		public static function getTransInfo(heroidnew:String, heroidold:String):void
		{
			SocketManager.o.callunlock(ConstNetCommand.CS_TRANS_GET_TRANS_INFO, heroidnew, heroidold);
		}
		/**
		 * 武将传功
		 * @param heroidnew: 被传功武将id(接收武将)
         * @param heroidold: 传功武将id(发出武将)
         * @param useitem: 是否使用道具[True or False]
		 * 
		 */		
		public static function heroTrans(heroidnew:String, heroidold:String, useitem:Boolean = false):void
		{
			SocketManager.o.callunlock(ConstNetCommand.CS_TRANS_HERO_TRANS, heroidnew, heroidold, useitem);
		}
	}
}