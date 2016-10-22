package SJ.Game.task.util
{
	import SJ.Game.data.CJDataOfScene;
	import SJ.Game.data.config.CJDataOfScreenNPCProperty;
	import SJ.Game.data.json.Json_scene_npc_setting;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 +------------------------------------------------------------------------------
	 * 导航辅助寻路
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-24 下午4:04:29  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskPathUtil
	{
		private var navigatePathList:Dictionary;
		
		public function CJTaskPathUtil()
		{
			
		}
		
		/**
		 * 判断任务NPC与主角是否在同一个场景 
		 * @param npcid : 任务NPC位置
		 */		
		public function isTaskNpcInSameScene(npcid:int):Boolean
		{
			var currentScene:int = CJDataOfScene.o.sceneid;
			var sceneConfig:Json_scene_npc_setting = CJDataOfScreenNPCProperty.o.getNpcConfig(npcid);
			var targetScene:int = sceneConfig.id;
			return currentScene == targetScene;
		}
		
		/**
		 * 获取导航路径列表 
		 * @param targetScene : 前往的目标场景
		 * @return dictionary : 寻路列表
		 */		
		public function getNavigatePath(npcid:int):Dictionary
		{
			navigatePathList = new Dictionary();
			var currentScene:int = CJDataOfScene.o.sceneid;
			var targetPos:Point = new Point();
			var sceneConfig:Json_scene_npc_setting = CJDataOfScreenNPCProperty.o.getNpcConfig(npcid);
			var targetScene:int = sceneConfig.id;
			targetPos.x = sceneConfig.npcx;
			targetPos.y = sceneConfig.npcy;
			if(currentScene == targetScene)
			{
				navigatePathList
			}
			return navigatePathList;
		}
	}
}