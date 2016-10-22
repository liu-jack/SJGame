package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 * 角色网络操作
	 * @author longtao
	 * 
	 */
	public class SocketCommand_role
	{
		public function SocketCommand_role()
		{
		}
		
		/**
		 * 判断玩家是否拥有角色
		 * 
		 */
		public static function own_role():void
		{
			
			
			SocketManager.o.call(ConstNetCommand.CS_ROLE_IS_OWN);
		}
		
		/**
		 * 创建角色
		 * @param rolename	角色名称
		 * @param job		角色职业
		 * @param sex		角色性别
		 * 
		 */
		public static function create_role(rolename:String, job:String, sex:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_ROLE_CREATE, rolename, job, sex);
		}
		
		/**
		 * 获取角色信息 
		 * 
		 */
		public static function get_role_info(callback:Function = null):void
		{
			SocketManager.o.callUnlockWithRtn(ConstNetCommand.CS_ROLE_GET_ROLE_INFO,callback,false);
		}
		
		/**
		 * 角色移动
		 * 
		 */
		public static function moveTo(x:int,y:int):void
		{
			SocketManager.o.callunlock(ConstNetCommand.CS_ROLE_MOVETO,x,y);
		}
		
		/**
		 * 获取其它帐号信息 
		 * @param uid 其它帐号的uid
		 * @param callback 返回值
		 * 
		 */
		public static function get_other_role_info(uid:String,callback:Function = null):void
		{
			SocketManager.o.callUnlockWithRtn(ConstNetCommand.CS_ROLE_GET_OTHER_ROLE_INFO,callback,false,uid);
		}
		/**
		 * 通过角色名获取其它帐号信息 
		 * @param rolename 其它帐号的角色名
		 * @param callback 返回值
		 * 
		 */
		public static function get_other_role_info_by_name(rolename:String,callback:Function = null):void
		{
			SocketManager.o.callwithRtn(ConstNetCommand.CS_ROLE_GET_OTHER_ROLE_INFO_BY_NAME,callback,false,rolename);
		}
		
		/**
		 *  玩家提交游戏问题
		 * @param content
		 */
		public static function collect_problem(content:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_ROLE_COLLECT_PROBLEM, content);
		}
	}
}