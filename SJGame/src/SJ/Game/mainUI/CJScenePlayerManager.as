package SJ.Game.mainUI
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstMainUI;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketCommand_scene;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.display.SLayer;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 玩家管理器 
	 * @author caihua
	 * 
	 */
	public class CJScenePlayerManager
	{
		public function CJScenePlayerManager(playerLayer:SLayer)
		{
			_playerLayer = playerLayer;
		}
		
		/**
		 * 是否自动移动 
		 */
		private var _autoRandomMove:Boolean = true;
		
		
		private var _isActive:Boolean = false;
	
		private var _playerLayer:SLayer;
		private var _currentPlayersCount:uint = 0;
		/**
		 * 最大xianshishuliang 
		 */
		private static const MAX_DISPLAY_COUNT:uint = 10;
		
		
		private var _dictOfOtherPlayers:Dictionary = new Dictionary();
		/**
		 * 刷新所有的玩家 
		 * 
		 */
		public function freshAllPlayers():void
		{
			
			function _oncallback(m:SocketMessage):void
			{
				
			}
			SocketCommand_scene.getSceneUsers(function (m:SocketMessage):void
			{
				var params:Array = m.retparams;
				var i:uint,length:uint;
				length = params.length;
				for (i=0;i<length;i++)
				{
					_addPlayer(params[i]);
				}
				
				// add by longtao
				if (!CJDataManager.o.DataOfSetting.isShowOthers)// 不显示
					CJEventDispatcher.o.dispatchEvent(new Event(CJEvent.EVENT_SCENEPLAYERMANAGER_RESETANDPAUSE));
				// add by longtao end
			});
			
			
		}
		public function getPlayer(uid:String):CJPlayerNpc
		{
			if(!_dictOfOtherPlayers.hasOwnProperty(uid))
			{
				return null;
			}
			else
			{
				var data:DataOfScenePlayer = _dictOfOtherPlayers[uid];
				if(data.isLoading)
					return null;
				return data.playerIns;
			}
		}
		
		/**
		 * 激活管理器 
		 * 
		 */
		public function activeManager():void
		{
			if(_isActive){
				return;
			}
			_isActive = true;
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onSocketPlayerAppear);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onSocketPlayerDisAppear);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onSocketPlayerMoveTo);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onSocketPlayerUplevel);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onSocketPlayerChangeRide);
			
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_SCENEPLAYERMANAGER_RESETANDPAUSE,_clearandpause);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_SCENEPLAYERMANAGER_FLASH,_freshandgo);
			
		}
		
		
		
		public function deactiveManager():void
		{
			if(!_isActive){
				return;
			}
			_isActive = false;
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onSocketPlayerAppear);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onSocketPlayerDisAppear);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onSocketPlayerMoveTo);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onSocketPlayerUplevel);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onSocketPlayerChangeRide);
			
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_SCENEPLAYERMANAGER_RESETANDPAUSE,_clearandpause);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_SCENEPLAYERMANAGER_FLASH,_freshandgo);
		}
		
		
		
		/**
		 * 更换坐骑 
		 * @param e
		 */
		private function _onSocketPlayerChangeRide(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.SC_SYNC_RIDE_CHANGE)
				return;
			var params:Array = message.retparams;
			
			var uid:String = params[0];
			var rideStatus:int = int(params[1]);
			var horseid:int = int(params[2]);
			//发事件
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_CHANGE_HORSE , false , {"uid":uid , "rideStatus":rideStatus , "horseid":horseid});
		}
		
		/**
		 * 玩家升级
		 * addby caihua
		 */		
		private function _onSocketPlayerUplevel(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.SC_SYNC_UPLEVEL)
				return;
			var params:Array = message.retparams;
			var heroId:String = params[2];
			var uid:String = params[0];
			//是主角
			if(heroId == uid)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_PLYER_UPLEVEL , false , {heroid:heroId , currentLevel:params[1] , "uid":uid});
			}
			//刷新主界面战斗力
			SocketCommand_hero.get_heros();
		}
		
		/**
		 * 玩家出现 
		 * @param e
		 * 
		 */
		private function _onSocketPlayerAppear(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.SC_SYNC_SYNCAPPEAR)
				return;
			var params:Array = message.retparams;
			var i:uint,length:uint;
			length = params.length;
			for (i=0;i<length;i++)
			{
				_addPlayer(params[i]);
			}
			
		}
		private function _onSocketPlayerDisAppear(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.SC_SYNC_SYNDISAPPEAR)
				return;
			var params:Array = message.retparams;
			var i:uint,length:uint;
			length = params.length;
			for (i=0;i<length;i++)
			{
				_removePlayer(params[i]);
				CJEventDispatcher.o.dispatchEventWith(ConstMainUI.MAIN_UI_CLICK_PLAYER_DISAPPEAR, false, {"clickedPlayerUid":params[i]});
			}
		}
		private function _onSocketPlayerMoveTo(e:Event):void
		{
			if(_autoRandomMove)
				return;
			
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.SC_SYNC_SYNCMOVETO)
				return;
			var params:Array = message.retparams;
			var uid:String = params[0];
			var x:int = parseInt(params[1]);
			var y:int = parseInt(params[2]);
			
			var destplayer:CJPlayerNpc = getPlayer(uid);
			if(destplayer != null)
				destplayer.runTo(new Point(x,y));
		}

		/**
		 * 
		 * @param playerinfos 远程返回的用户信息[uid,x,y,level]
		 * 
		 */
		private function _addPlayer(playerinfos:Array):void
		{
			if(_pause)
			{
				return;
			}
			//没有到显示其它玩家的等级
			if(parseInt(CJDataManager.o.DataOfHeroList.getMainHero().level)
				< parseInt(CJDataOfGlobalConfigProperty.o.getData("DISPLAY_OTHER_PLAYER_LEVEL")))
			{
				
				if(playerinfos.length >= 4)//如果包含了等级字段
				{
					if(parseInt(playerinfos[3])>parseInt(CJDataOfGlobalConfigProperty.o.getData("DISPLAY_OTHER_PLAYER_LEVEL")))
					{
						return;
					}
						
				}
				else
				{
					return;
				}
			}
			
			
			//根据设备类型判断显示用户
			switch(ConstGlobal.DeviceLevel)
			{
				case ConstGlobal.DeviceLevel_High:
				case ConstGlobal.DeviceLevel_Normal:
				{
					if(_currentPlayersCount >= MAX_DISPLAY_COUNT)
					{
						return;
					}
					break;
				}
				case ConstGlobal.DeviceLevel_Low:
				{
					if(_currentPlayersCount >= MAX_DISPLAY_COUNT * 0.5)
					{
						return;
					}
					break;
				}
			}
			
			
			
			var uid:String = playerinfos[0];
			var basex:int = parseInt(playerinfos[1]);
			var basey:int = parseInt(playerinfos[2]);
			if(!_dictOfOtherPlayers.hasOwnProperty(uid))
			{
				_currentPlayersCount ++;
				
				var newplayerData:DataOfScenePlayer =  new DataOfScenePlayer(basex,basey);
				_dictOfOtherPlayers[uid] = newplayerData;
				
				
				SocketCommand_role.get_other_role_info(uid,function(m:SocketMessage):void{
					//快速退出 则不处理这个了
					if(_dictOfOtherPlayers.hasOwnProperty(uid) &&
					_playerLayer.getChildByName("PC_" + uid) == null)
					{
						newplayerData = _dictOfOtherPlayers[uid];
						newplayerData.loadData(m.retparams);
						newplayerData.playerIns.playerData.heroId = uid; //zhengzheng++
						_playerLayer.addChild(newplayerData.playerIns);
						newplayerData.playerIns.addEventListener(TouchEvent.TOUCH,_onTouchPlayerNpc);//zhengzheng++
						if(_autoRandomMove)
						{
							newplayerData.playerIns.RandomRun(new Rectangle(100,220,1180,100));
						}
					}
					
				});
			}
		}
		/**
		 * 点击玩家事件
		 * @param e
		 * 
		 */		
		private function _onTouchPlayerNpc(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(_playerLayer,TouchPhase.BEGAN);
			if(touch)
			{
				var playerIns:CJPlayerNpc = (e.target as DisplayObject).parent.parent as CJPlayerNpc;
				var playerId:String = playerIns.playerData.heroId;
				e.stopImmediatePropagation();
				CJEventDispatcher.o.dispatchEventWith(ConstMainUI.MAIN_UI_CLICK_PLAYER, false, {"playerid":playerId});
			}
		}
		/**
		 * 删除玩家 
		 * @param uid
		 * 
		 */
		private function _removePlayer(uid:String):void
		{
			if(_dictOfOtherPlayers.hasOwnProperty(uid))
			{
				_currentPlayersCount --;
				(_dictOfOtherPlayers[uid] as DataOfScenePlayer).dispose();
				delete _dictOfOtherPlayers[uid];
			}
			
		}
		public function removeAllPlayers():void
		{
			for( var k:String in _dictOfOtherPlayers)
			{
				(_dictOfOtherPlayers[k] as DataOfScenePlayer).dispose();
			}
			_dictOfOtherPlayers = new Dictionary();
			_currentPlayersCount = 0;
		}
		private var _pause:Boolean = false;

		/**
		 * 是否暂停添加新用户 
		 */
		public function get pause():Boolean
		{
			return _pause;
		}

		private function _clearandpause(e:Event):void
		{
			if(_pause)
				return;
			_pause = true;
			removeAllPlayers();
		}
		
		private function _freshandgo(e:Event):void
		{
			if(_pause == false)
				return;
			// 设置为不显示则直接返回
			if(!CJDataManager.o.DataOfSetting.isShowOthers)
				return;
			_pause = false;
			freshAllPlayers();
		}
	}
	
	
}
import flash.geom.Point;

import SJ.Game.player.CJPlayerData;
import SJ.Game.player.CJPlayerNpc;

import starling.core.Starling;
import starling.events.TouchEvent;

class DataOfScenePlayer
{
	/**
	 * 基础的x,y坐标 
	 */
	public var basex:int,basey:int;
	public function DataOfScenePlayer(basex:int,basey:int)
	{
		this.basex = basex;
		this.basey = basey;
	}
	public function dispose():void
	{
		if(playerIns != null)
		{
			playerIns.removeFromParent(true);
			playerIns.removeEventListeners(TouchEvent.TOUCH)
			
		}
	}
	
	/**
	 * 加载数据 
	 * @param data
	 * 
	 */
	public function loadData(data:Object):void
	{
//		"data"	Object (@f23a479)	
//		activehorseid	"0"	
//		creat_time	"0"	
//		gmlevel	"0"	
//		gold	0	
//		isriding	"0"	
//		job	"1"	
//		last_map	"101"	
//		lately_login	"1369292605"	
//		pos_x	"600"	
//		pos_y	"300"	
//		rolename	""	
//		sex	"1"	
//		silver	"49498491"	
//		starleveltime	"0"	
//		templateid	"10001"	
//		ticket	"0"	
//		userid	"216175330854012167"	
//		viplevel	"0"	
//		vit	"0"	


		playerData = data;
		
		var playerSpriteData:CJPlayerData = new CJPlayerData;
		playerSpriteData.isPlayer = false;
		playerSpriteData.templateId = data.templateid;
		playerSpriteData.displayName = data.rolename;
		
		playerIns = new CJPlayerNpc(playerSpriteData,Starling.juggler);
		playerIns.lodlevel = CJPlayerNpc.LEVEL_LOD_0|CJPlayerNpc.LEVEL_LOD_1;
		playerIns.hidebattleInfo();
		playerIns.needAutoSort = true;
		playerIns.name = "PC_" + playerData.userid;
	
		playerIns.onloadResourceCompleted = function loaded(_npc:CJPlayerNpc):void{
			_npc.sceneidle();
			if(int(data.isriding) == 1)
			{
				_npc.RideId = int(data.activehorseid);
			}
		};
		
		playerIns.setToPosition(new Point(basex,basey));
		
		
		
		isLoading = false;
	}
	/**
	 * 数据是否正在载入中 
	 */
	public var isLoading:Boolean = true;
	/**
	 * 对象实例 
	 */
	public var playerIns:CJPlayerNpc = null;
	
	/**
	 * 玩家其它数据 
	 */
	public var playerData:Object = null;
}