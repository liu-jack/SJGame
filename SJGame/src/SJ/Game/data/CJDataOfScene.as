package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.SApplication;
	import engine_starling.data.SDataBaseRemoteData;
	
	import lib.engine.game.module.CModuleSubSystem;
	
	import starling.events.Event;
	
	public class CJDataOfScene extends SDataBaseRemoteData
	{
		public static var SCENE_CITY:String = "city";
		public static var SCENE_WORLD:String = "world";
		public static var SCENE_FUBEN:String = "fuben";
		//世界sceneid
		public static var SCENE_WORLD_ID:int = 1;
		//副本复活城市ID，
		public static var RELIVE_CITY_ID:int = 100
			
		private var _fromSceneId:int = RELIVE_CITY_ID;
		private var _isInMainCity:Boolean = false;
		/*世界boss东城区*/
		public static const SCENE_ID_WORLD_BOSS_EAST:int = 104;
		/*世界boss西城区*/
		public static const SCENE_ID_WORLD_BOSS_WEAST:int = 105;
			
		public function CJDataOfScene()
		{
			super("CJDataOfScene");
			this._init();
		}
		private static var _o:CJDataOfScene;
		public static function get o():CJDataOfScene
		{
			if(_o == null)
				_o = new CJDataOfScene();
			return _o;
		}
		
		private function _init():void
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onReceived);
		}
		
		private function _onReceived(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_SCENE_CHANGE)
			{
				if (message.retcode == 0)
				{
					var rtnObject:Object = message.retparams;
					this._fromSceneId = this._sceneid
					this._sceneid = int(rtnObject)
					_canEnter = true;
				}
				else
				{
					_canEnter = false;
				}
				this._dataIsEmpty = true;
				this._onloadFromRemoteComplete();
				SocketCommand_role.get_role_info();
			}
		}
		
		private var _canEnter:Boolean
		public function get canEnter():Boolean
		{
			return _canEnter;
		}
		
		private var _sceneid:int = 100;
		public function get sceneid():int
		{
			return this._sceneid;
		}
		public function set sceneid(id:int):void
		{
			this._fromSceneId = this._sceneid;
			this._sceneid = id;
		}
		
		/**
		 * 判断场景id是否是主城
		 * @param sceneid
		 */		
		public function isTown():Boolean
		{
			return this._isInMainCity;
		}

		/**
		 * 是否在主场景中，需要排除一些个特别的模块
		 */ 
		private function _inSpecialModule():Boolean
		{
			var moduleList:Array = ["CJActiveFbModule"];
			for(var i:String in moduleList)
			{
				if((SApplication.moduleManager.getModule(moduleList[i]) as CModuleSubSystem).onEntered)
				{
					return true;
				}
			}
			return false;
		}
		
		public function get fromSceneId():int
		{
			return _fromSceneId;
		}

		public function set fromSceneId(value:int):void
		{
			_fromSceneId = value;
		}
		
		public function get isInMainCity():Boolean
		{
			return _isInMainCity;
		}
		public function set isInMainCity(b:Boolean):void
		{
			_isInMainCity = b;
		}

	}
}