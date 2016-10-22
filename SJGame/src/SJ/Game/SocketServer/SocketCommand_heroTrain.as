package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 * 武将训练
	 * @author longtao
	 * 
	 */
	public class SocketCommand_heroTrain
	{
		public function SocketCommand_heroTrain()
		{
		}
		
		/**
		 * 获取武将训练信息
		 */
		public static function get_train_info():void
		{
			SocketManager.o.call(ConstNetCommand.CS_HERO_TRAIN_GET_INFO);
		}
		
		/**
		 * 获取武将训练信息
		 */
		public static function start_train( trainType:int, arrHeroid:Array ):void
		{
			SocketManager.o.call(ConstNetCommand.CS_HERO_TRAIN_START_TRAIN, trainType, arrHeroid);
		}
		
		/**
		 * 获取武将训练信息
		 */
		public static function clean_cd( heroid:String ):void
		{
			SocketManager.o.call(ConstNetCommand.CS_HERO_TRAIN_CLEAN_CD, heroid);
		}
		
		/**
		 * 清空所有训练中武将CD
		 * @param func 回调函数
		 */
		public static function clean_cd_all(func:Function):void
		{
			SocketManager.o.callwithRtn(ConstNetCommand.CS_HERO_TRAIN_CLEAN_CD_ALL, func,false);
		}
	}
}