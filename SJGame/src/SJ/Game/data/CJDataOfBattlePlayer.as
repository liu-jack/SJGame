package SJ.Game.data
{
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	
	/**
	 * 与其他玩家进行切磋
	 * @author longtao
	 */
	public class CJDataOfBattlePlayer extends SDataBaseRemoteData
	{
		// 记录登录时间
		private var _markTime:uint = 0;
		/**
		 * {其他玩家uid:时间戳下次可进行切磋的时间}
		 * {otheruid:nexttime}
		 */
		private var _dataObj:Object = new Object;
		public function CJDataOfBattlePlayer()
		{
			super("CJDataOfBattlePlayer");
			
			var date:Date = new Date();
			_markTime = int(date.time/1000);
		}
		
		/**
		 * 添加信息
		 * @param userid		角色id
		 * @param lefttime		剩余时间
		 * @return 				
		 * 
		 */
		public function addBattlePlayerInfo(userid:String, lefttime:uint):void
		{
			var date:Date = new Date();
			// 当前时间
			var curtime:uint = uint(date.time/1000);
			// 时间戳
			var timestamp:uint = curtime + lefttime;
			_dataObj[userid] = timestamp;
		}
		
		public function waitTime(userid:String):uint
		{
			if ( null == _dataObj[userid] )
				return 0; // 认为是空闲的
			
			// 时间戳
			var timestamp:uint = _dataObj[userid];
			
			var date:Date = new Date();
			// 当前时间
			var curtime:uint = uint(date.time/1000);
			if (curtime >= timestamp)
				return 0; // 0为不差时间
			
			return timestamp - curtime; // 距离切磋冷却完成的时间
		}
			
		
	}
}