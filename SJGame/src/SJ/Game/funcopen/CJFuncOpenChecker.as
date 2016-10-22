package SJ.Game.funcopen
{
	import SJ.Game.SocketServer.SocketCommand_funcpoint;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFunctionList;
	import SJ.Game.data.CJDataOfScene;
	import SJ.Game.data.CJDataOfTask;
	import SJ.Game.data.CJDataOfTaskList;
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	import SJ.Game.data.json.Json_function_open_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	
	import engine_starling.SApplication;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	/**
	 +------------------------------------------------------------------------------
	 * 功能开启 - 监听任务数据变化和等级变化
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-21 下午1:55:44  
	 +------------------------------------------------------------------------------
	 */
	public class CJFuncOpenChecker extends EventDispatcher
	{
		private static var INSTANCE:CJFuncOpenChecker;
		private var _functionList:CJDataOfFunctionList;
		private var _taskList:CJDataOfTaskList;
		
		public function CJFuncOpenChecker(s:Singal)
		{
			super();
			this._functionList = CJDataManager.o.DataOfFuncList;
			_taskList = CJDataManager.o.DataOfTaskList;
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_SELF_PLAYER_UPLEVEL , this._checkFuncUnlock);
			_taskList.addEventListener(CJEvent.EVENT_TASK_DATA_CHANGE , _checkFuncUnlock);
		}
		
		private function _checkFuncUnlock(e:Event):void
		{
			if(e.type == CJEvent.EVENT_SELF_PLAYER_UPLEVEL)
			{
				var data:Object = e.data;
				var uid:String = data.uid;
				var currentLevel:int = data.currentLevel;
				//如果是自己
				if(uid == CJDataManager.o.DataOfAccounts.userID)
				{
					//设置主角等级
					CJDataManager.o.DataOfHeroList.getMainHero().level = ""+currentLevel;
					this.checkTriggerFunction(currentLevel);
				}
			}
			else if(e.type == CJEvent.EVENT_TASK_DATA_CHANGE && e.data.eventKey == "rewardTask")
			{
				this.checkTriggerFunction(currentLevel);
			}
		}
		
		public function testOpen():void
		{
			var nextFunctionId:int = 1;
			var config:Json_function_open_setting = CJDataOfFuncPropertyList.o.getProperty(nextFunctionId);
			SocketCommand_funcpoint.addOpenFunciton(nextFunctionId);
			//正式触发
			SApplication.moduleManager.enterModule("CJFunctionOpenModule");
			_functionList.currentIndicatingModule = config.modulename;
		}
		
		public function checkTriggerFunction(currentLevel:int):void
		{
			var nextFunctionId:int = _functionList.getNextUnOpenFunctionId(currentLevel);
//			当前没有需要开启的功能点
			if(nextFunctionId == -1)
			{
				return;
			}
			var config:Json_function_open_setting = CJDataOfFuncPropertyList.o.getProperty(nextFunctionId);
			if(config.taskid != undefined)
			{
				//			检测是否完成任务
				var functionDao:CJDataOfTask = this._taskList.getTaskById(config.taskid);
				if(!functionDao.isTaskRewarded())
				{
					return;
				}
			}
			
//			检测场景
			if(!CJDataOfScene.o.isTown())
			{
				CJDataManager.o.DataOfFuncList.needOpenFunctionAfterReturnToTown = nextFunctionId;
				return;
			}
			
			//移除所有其他层
//			CJLayerManager.o.removeAllModuleLayer();
			
			SocketCommand_funcpoint.addOpenFunciton(nextFunctionId);
			//正式触发
			
			Starling.juggler.delayCall(function():void
			{
				SApplication.moduleManager.enterModule("CJFunctionOpenModule");
				_functionList.currentIndicatingModule = config.modulename;
			},1);
		}
		
		public static function get o():CJFuncOpenChecker
		{
			if( null == INSTANCE)
			{
				INSTANCE = new CJFuncOpenChecker(new Singal());
			}
			return INSTANCE;
		}
	}
}

class Singal {}