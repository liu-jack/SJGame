package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	public class SocketCommand_scene
	{
		public function SocketCommand_scene()
		{
		}
		/**
		 * 切换场景 
		 * @param sceneid 场景ID
		 * 
		 */
		public static function changeScene(sceneid:int , callback:Function = null):void
		{
			SocketManager.o.callwithRtn(ConstNetCommand.CS_SCENE_CHANGE,callback ,false, sceneid);
		}
		
		/**
		 * 获取场景用户uid
		 * 
		 */
		public static function getSceneUsers(callback:Function = null):void
		{
			SocketManager.o.callwithRtn(ConstNetCommand.CS_SCENE_GETSCENEUSERS,callback,false);
		}
		
		
	}
}