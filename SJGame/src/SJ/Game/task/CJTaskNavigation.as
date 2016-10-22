package SJ.Game.task
{
	import flash.utils.Dictionary;
	
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfNavigator;
	import SJ.Game.data.CJDataOfScene;
	import SJ.Game.data.config.CJDataOfFubenProperty;
	import SJ.Game.data.config.CJDataOfGuankaBattleProperty;
	import SJ.Game.data.config.CJDataOfScreenNPCProperty;
	import SJ.Game.data.json.Json_scene_npc_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	
	import engine_starling.SApplication;
	
	import starling.events.Event;

	/**
	 *  任务导航，基于事件
	 * @author yongjun
	 * 
	 */
	public class CJTaskNavigation
	{
		public function CJTaskNavigation()
		{
			_init();
		}
		private var cjdataofNavigator:CJDataOfNavigator
//		private static var _o:CJTaskNavigation;
//		public static function get o():CJTaskNavigation
//		{
//			if(_o == null)
//				_o = new CJTaskNavigation();
//			return _o;
//		}
		
		public function dispose():void
		{
			//任务引导事件
			CJEventDispatcher.o.removeEventListener(CJEvent.Event_Task_GuideNpc,_ontaskGuideNpc);
			//场景切换完成事件
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_SCENE_CHANGE_COMPLETE,_sceneChangeHandler);
			//当前任务导航结束
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_SCENE_TASKGUID_COMPLETE,guildComplete);
			

		}
		public function _init():void
		{
			//任务引导事件
			CJEventDispatcher.o.addEventListener(CJEvent.Event_Task_GuideNpc,_ontaskGuideNpc);
			//场景切换完成事件
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_SCENE_CHANGE_COMPLETE,_sceneChangeHandler);
			//当前任务导航结束
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_SCENE_TASKGUID_COMPLETE,guildComplete);
			
			cjdataofNavigator = CJDataManager.o.getData("CJDataOfNavigator") as CJDataOfNavigator;
			
		}
		private function _ontaskGuideNpc(e:Event):void
		{
			cjdataofNavigator.npcId =  e.data.npcid;
			cjdataofNavigator.gid = e.data.gid;
			//关卡中
			var allNpc:Dictionary = CJDataOfGuankaBattleProperty.o.getAllBattleNpc();
			if(allNpc.hasOwnProperty(cjdataofNavigator.npcId))
			{
				var fid:int = CJDataOfFubenProperty.o.getFidByGid(cjdataofNavigator.gid);
				SApplication.moduleManager.enterModule("CJWorldMapModule",{fid:fid,gid:cjdataofNavigator.gid});
				return;
//				//战斗ID
//				var zid:int = allNpc[_npcId]
//				//关卡ID
//				var gid:int = CJDataOfGuankaProperty.o.getGidByZid(zid)
				//副本ID
//				var cjdataof:CJDataOfFuben = (CJDataManager.o.getData("CJDataOfFuben") as CJDataOfFuben);
//				cjdataof.from = ConstFuben.FUBEN_COMMON;
//				
//				CJDataOfScene.o.addEventListener(DataEvent.DataLoadedFromRemote,enterFb)
//				SocketCommand_scene.changeScene(fid)
//					
//				guildComplete(e);
//				e.stopPropagation();
//				
//				function enterFb(e:Event):void
//				{
//					e.currentTarget.removeEventListener(DataEvent.DataLoadedFromRemote,enterFb);
//					SApplication.moduleManager.enterModule("CJFubenModule",{fid:fid,gid:cjdataofNavigator.gid});
//				}
//				return;
//				cjdataofNavigator.npcSceneId = fid;
			}
			else
			{
				var sceneConfig:Json_scene_npc_setting = CJDataOfScreenNPCProperty.o.getNpcConfig(cjdataofNavigator.npcId);
				//npc 场景ID
				cjdataofNavigator.npcSceneId = sceneConfig.id;
				//主角所在场景ID
				var roleSceneId:int = CJDataOfScene.o.sceneid;
				_goToNpc(roleSceneId,cjdataofNavigator.npcSceneId);
			}
		}
		
		private function _goToNpc(roleSceneId:int,npcSceneId:int):void
		{
			if(roleSceneId == npcSceneId)
			{
				dispatchEvent(CJDataOfScene.SCENE_CITY);
				cjdataofNavigator.npcSceneId = 0;
			}
			else
			{
				var evt:Event = new Event(CJEvent.EVENT_SCENE_CITY_MOVETOENTER,false,{"sceneid":npcSceneId});
				CJEventDispatcher.o.dispatchEvent(evt);
			}
		}
		/**
		 * 场景切换完成 
		 * @param e
		 * 
		 */
		private function _sceneChangeHandler(e:Event):void
		{
			var scene:String = e.data.scene;
			dispatchEvent(scene);
		}
		
		/**
		 * 不同场景派发不同移动事件 
		 * @param scene
		 * 
		 */
		private function dispatchEvent(scene:String):void
		{
			switch(scene)
			{
				case  CJDataOfScene.SCENE_CITY:
					if(cjdataofNavigator.npcId)
					{
						var evt:Event = new Event(CJEvent.EVENT_SCENE_CITY_MOVE,false,{npcid:cjdataofNavigator.npcId});
						CJEventDispatcher.o.dispatchEvent(evt);
					}
					break;
				case CJDataOfScene.SCENE_WORLD:
					if(cjdataofNavigator.npcSceneId)
					{
						evt = new Event(CJEvent.EVENT_SCENE_WORLD_MOVE,false,{tosceneid:cjdataofNavigator.npcSceneId,gid:cjdataofNavigator.gid});
							CJEventDispatcher.o.dispatchEvent(evt);
					}
					break;
				case CJDataOfScene.SCENE_FUBEN:
					if(cjdataofNavigator.npcSceneId)
					{
						evt = new Event(CJEvent.EVENT_SCENE_WORLD_MOVE,false,{tosceneid:cjdataofNavigator.npcSceneId});
						CJEventDispatcher.o.dispatchEvent(evt);
					}
					break;
			}
		}
		/**
		 * 导航结束， 
		 * @param e
		 * 
		 */
		private function guildComplete(e:Event):void
		{
			cjdataofNavigator.npcSceneId = 0;
			cjdataofNavigator.npcId = 0;
			cjdataofNavigator.gid = 0;
		}
	}
}