package SJ.Game.mainUI
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstMainUI;
	import SJ.Common.Constants.ConstTask;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.controls.CJMapUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfScene;
	import SJ.Game.data.CJDataOfTask;
	import SJ.Game.data.CJDataOfTaskList;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfMainSceneProperty;
	import SJ.Game.data.config.CJDataOfScreenNPCProperty;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.map.CJPlayerSceneLayer;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	import SJ.Game.player.CJPlayerTitleLayer;
	import SJ.Game.task.CJTaskUIHandler;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SCamera;
	import engine_starling.display.SLayer;
	import engine_starling.display.SMuiscNode;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SMuiscChannel;
	
	import lib.engine.math.Vector2D;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	
	/**
	 *  主城层
	 * @author yongjun
	 * 
	 */
	public class CJMainSceneLayer extends SLayer
	{
		private var _mapInfo:Object;
		//是否显示玩家配置
		private var _displayConfig:int;
		public function CJMainSceneLayer()
		{
			super();
		}
		
		override protected function draw():void
		{
			super.draw();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._init();
			//副本中继承了此方法
			if(this._mapInfo != null)
			{
				_sceneConfig = CJDataOfMainSceneProperty.o.getPropertyById(this._mapInfo.id);
				
				var _bgMuisc:SMuiscNode = new SMuiscNode(SMuiscChannel.SMuiscChannelCreateByName(_mapInfo.music));
				_bgMuisc.loop = true;
				addChild(_bgMuisc);
				
				//设置主城背景图
				var textures:Vector.<Texture> = SApplication.assets.getTextures(this._mapInfo.texturename);
				_mapbackgroundLayer = CJMapUtil.getMapLayer(textures);
				
				
				this._mapLayer.addChildAt(_mapbackgroundLayer,0);
				
				_mapLayer.clipRect = new Rectangle(0,0,480,320);
				//设置行动区域
				_initHotArea();
				//传送点
				_initTeleporter();
				//初始化NPC
				_initNpc();
				//初始化事件监听器
				_initEventListener();
				//取主角数据
				_initData();
				//初始化其它玩家
				_initOtherPlayers();

				_initMoveEffect();				
				
			}
		}
		
		
		
		protected var _mapLayer:SLayer = null;
		protected var _npcLayer:SLayer = null;
		protected var _playerLayer:CJPlayerSceneLayer = null;
		
		/**
		 * 背景元素层,高于背景层,低于其它层 
		 */
		protected var _backelementslayer:SLayer = null;
		
		protected var _mapbackgroundLayer:Sprite = null;
		
		/**
		 * 场景玩家管理器 
		 */
		protected var _sceneplayermanager:CJScenePlayerManager = null;
		/**
		 *  地图层
		 * @return 
		 * 
		 */
		public function get mapLayer():SLayer
		{
			return _mapLayer;
		}
		/**
		 * NPC层
		 * @return 
		 * 
		 */
		public function get npcLayer():SLayer
		{
			return this._npcLayer;
		}
		/**
		 * 玩家层 
		 */
		public function get playerLayer():SLayer
		{
			return _playerLayer;
		}
		
		public function set mapInfo(info:Object):void
		{
			this._mapInfo = info;
			

		}
		
		private function _initEventListener():void
		{
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_SCENE_CITY_MOVE,_moveToNpc);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_SCENE_CITY_MOVETOENTER,_moveToEnter);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_PLYER_UPLEVEL , this._uplevelHandler)
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_SELF_PLAYER_UPLEVEL , this._selfUplevelHandler)
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_PLAYER_ROLEUPDATE,this._updateRole);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_CHANGE_HORSE , this._horseChangeHandler);
			
			CJDataManager.o.DataOfTaskList.addEventListener(DataEvent.DataLoadedFromRemote , this._updateNpcStatus);
			CJDataManager.o.DataOfTaskList.addEventListener(CJEvent.EVENT_TASK_DATA_CHANGE , this._updateNpcStatus);
			
			
			if (_displayConfig == 0)
			{
				CJEventDispatcher.o.addEventListener(CJEvent.EVENT_NOT_DISPLAY_SCENE_PLAYERS,_notdisplay_player);
				CJEventDispatcher.o.addEventListener(CJEvent.EVENT_DISPLAY_SCENE_PLAYERS,_displayer_player);
			}
			
			
			_displaycount = 0;
		}
		private var _displaycount:int = 0;
		private function _notdisplay_player(e:*):void
		{
			_displaycount ++;
			_npcLayer.visible = false;
			playerLayer.visible = false;
		}
		private function _displayer_player(e:*):void
		{
			_displaycount --;
			if(_displaycount < 0)
				_displaycount = 0;
			if(_displaycount == 0)
			{
				_npcLayer.visible = true;
				playerLayer.visible = true;
			}
		}

		/**
		 * 自己主角升级
		 */ 
		private function _selfUplevelHandler(e:Event):void
		{
			if(e.type != CJEvent.EVENT_SELF_PLAYER_UPLEVEL)
			{
				return;
			}
			_role.showTitle(CJPlayerTitleLayer.TITLETYPE_NAME | CJPlayerTitleLayer.TITLETYPE_UPLEVEL);
			_role.showUplevelAnims();
			this._doUpdateNpcStatus();
		}
		
		private function _horseChangeHandler(e:Event):void
		{
			if(e.type != CJEvent.EVENT_CHANGE_HORSE)
			{
				return;
			}
			
			var data:Object = e.data;
			var uid:String = data.uid;
			var rideStatus:int  = int(data.rideStatus);
			var horseid:int = int(data.horseid);
			var player:CJPlayerNpc = _sceneplayermanager.getPlayer(uid);
			if(player)
			{
				player.RideId = horseid;
			}
		}
		
		/**
		 * 别人主角升级
		 */ 
		private function _uplevelHandler(e:Event):void
		{
			if(e.type != CJEvent.EVENT_PLYER_UPLEVEL)
			{
				return;
			}
			
			var data:Object = e.data;
			var uid:String = data.uid;
			var heroid:String  = String(data.heroid);
			var currentLevel:int = int(data.currentLevel);
			//其他玩家的升级特效
			var player:CJPlayerNpc = _sceneplayermanager.getPlayer(uid);
			if(player)
			{
				player.showTitle(CJPlayerTitleLayer.TITLETYPE_NAME | CJPlayerTitleLayer.TITLETYPE_UPLEVEL);
				player.showUplevelAnims();
			}
		}
		
		private var _gotoSceneId:int = 0;
		private function _moveToEnter(e:Event):void
		{
			_gotoSceneId = e.data["sceneid"];
			this._role.runTo(new Point(this._enterRect.x+1,this._enterRect.y+(this._enterRect.height/2)),_movefinish);
		}
		
		private function _updateNpcStatus(e:Event):void
		{
			if(e.target is CJDataOfTaskList)
			{
				this._doUpdateNpcStatus();
			}
			this._refreshTeleporter();
		}
		
		private function _doUpdateNpcStatus():void
		{
			for(var npcid:String in this._npcList)
			{
				var status:int = CJDataManager.o.DataOfTaskList.getNpcStatus(int(npcid));
				this._showNpcStatus(status, this._npcList[npcid]);
			}
		}
		
		private function _showNpcStatus(status:int , npc:CJPlayerNpc):void
		{
			npc.hideAllTitle();
			switch(status)
			{
				case ConstTask.TASK_NPC_TASK_CAN_ACCEPT : 
					npc.showTitle(CJPlayerTitleLayer.TITLETYPE_NAME | CJPlayerTitleLayer.TITLETYPE_TASK_CLAIM);
					break;
				case ConstTask.TASK_NPC_TASK_EXECUTING : 
					npc.showTitle(CJPlayerTitleLayer.TITLETYPE_NAME | CJPlayerTitleLayer.TITLETYPE_TASK_UNQUESTION);
					break;
				case ConstTask.TASK_NPC_TASK_COMPLETED : 
					npc.showTitle(CJPlayerTitleLayer.TITLETYPE_NAME | CJPlayerTitleLayer.TITLETYPE_TASK_QUESTION);
					break;
				case ConstTask.TASK_NPC_CAN_NOT_ACCEPT : 
					npc.showTitle(CJPlayerTitleLayer.TITLETYPE_NAME | CJPlayerTitleLayer.TITLETYPE_TASK_UNCLAIM);
					break;
				default:
					npc.showTitle(CJPlayerTitleLayer.TITLETYPE_NAME);
			}
		}
		/**
		 * 初始化其它玩家 
		 * 
		 */
		private function _initOtherPlayers():void
		{
			_sceneplayermanager = new CJScenePlayerManager(this.playerLayer);
			_sceneplayermanager.activeManager();
			_sceneplayermanager.freshAllPlayers();
		}
		
		override public function dispose():void
		{
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_SCENE_CITY_MOVE,_moveToNpc);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_SCENE_CITY_MOVETOENTER,_moveToEnter);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_PLYER_UPLEVEL , this._uplevelHandler)
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_SELF_PLAYER_UPLEVEL , this._selfUplevelHandler);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_PLAYER_ROLEUPDATE,this._updateRole);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_CHANGE_HORSE , this._horseChangeHandler);
			
			CJDataManager.o.DataOfTaskList.removeEventListener(DataEvent.DataLoadedFromRemote , this._updateNpcStatus);
			CJDataManager.o.DataOfTaskList.removeEventListener(CJEvent.EVENT_TASK_DATA_CHANGE , this._updateNpcStatus);
			
			
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_NOT_DISPLAY_SCENE_PLAYERS,_notdisplay_player);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_DISPLAY_SCENE_PLAYERS,_displayer_player);
			
			// TODO Auto Generated method stub
			if(_sceneplayermanager != null)
			{
				_sceneplayermanager.removeAllPlayers();
				_sceneplayermanager.deactiveManager();
				_sceneplayermanager = null;
			}
			_npcList = null;
			
			if(_touchmoveeffect)
			{
				_touchmoveeffect.removeFromJuggler();
				_touchmoveeffect.removeFromParent();
			}
			if (null != teleporterAnim)
			{
				Starling.juggler.remove(teleporterAnim);
				teleporterAnim = null;
			}
			super.dispose();
		}
		
		
		protected function _initData():void
		{
			var heroList:CJDataOfHeroList = CJDataManager.o.DataOfHeroList;
			if(heroList.dataIsEmpty)
			{
				heroList.addEventListener(DataEvent.DataLoadedFromRemote, this._onDataLoaded);
				heroList.herolist;
			}
			else
			{
				_initRole();
			}
			
			_displayConfig = int(CJDataOfGlobalConfigProperty.o.getData("MAIN_SCENE_DISPLAY_SCENE_PLAYERS"));
		}
		
		private function _onDataLoaded(e:Event):void
		{
			if(e.target is CJDataOfHeroList)
			{
				_initRole();
			}
		}
		/**
		 * 摄像机 
		 */
		protected var _carmera:SCamera;
		private var _sceneConfig:Object;
		/**
		 *  
		 * 初始化
		 */
		private function _init():void
		{
			_mapLayer = new SLayer;

			_backelementslayer = new SLayer();
			this._mapLayer.addChild(_backelementslayer);
			
			this.addChild(_mapLayer);
			_mapLayer.addEventListener(TouchEvent.TOUCH,_touchHandler);
			
			_carmera = new SCamera(_mapLayer);
			this.addChild(_carmera);
			_carmera.autoclip = true;
			_carmera.clipRect = new Rectangle(0,0,SApplicationConfig.o.stageWidth,SApplicationConfig.o.stageHeight);
			
			
			_npcLayer = new SLayer;
			_mapLayer.addChild(_npcLayer);
			
			_playerLayer = new CJPlayerSceneLayer();
			_mapLayer.addChild(_playerLayer);
		}
		
		protected function _initMoveEffect():void
		{
			var moveeffectObject:Object = AssetManagerUtil.o.getObject("anim_changjing_moveeffect");
			if(moveeffectObject)
			{
				_touchmoveeffect = SAnimate.SAnimateFromAnimJsonObject(moveeffectObject);
				_touchmoveeffect.visible = false;
				_npcLayer.addChild(_touchmoveeffect);
				_touchmoveeffect.gotoAndPlay();
				Starling.juggler.add(_touchmoveeffect);
			}
		}
		protected var _touchmoveeffect:SAnimate;
		
		protected var _hotAreaRect:Rectangle;
		/**
		 * 跑动距离左边界的距离 
		 */
		protected var _runDisplayLeftWidth:int = 160;
		/**
		 * 跑动距离右边界的距离 
		 */
		protected var _runDisplayRightWidth:int = 160;
		protected function _initHotArea():void
		{
			_hotAreaRect = new Rectangle(_sceneConfig.limitx,int(_sceneConfig.limity),_sceneConfig.limitw,_sceneConfig.limith);
			
			_carmera.maxx = _hotAreaRect.width - SApplicationConfig.o.stageWidth;
			_carmera.maxy = _hotAreaRect.height;
		}
		
		/**
		 * 初始化传送点 
		 */
		private var _enterRect:Rectangle = new Rectangle(900,200,80,80);
		private var teleporterAnim:MovieClip;
		private function _initTeleporter():void
		{
			var imgTeleporters:Vector.<Texture> = SApplication.assets.getTextures("changjing_chuansong");
			teleporterAnim = new MovieClip(imgTeleporters, ConstMainUI.ConstTeleporterFPS);
			//设置加载动画的坐标
			teleporterAnim.pivotX = teleporterAnim.width>>1;
			teleporterAnim.pivotY = teleporterAnim.height>>1;
			teleporterAnim.x = this._mapInfo.transferx;
			teleporterAnim.y = this._mapInfo.transfery;
			//传送点位置
			_enterRect.x = teleporterAnim.x - 40;
			_enterRect.y = teleporterAnim.y;
			
			if (null != teleporterAnim)
			{
				_backelementslayer.addChild(teleporterAnim);
				Starling.juggler.add(teleporterAnim);
			}
			
			this._refreshTeleporter();
		}
		
		private function _refreshTeleporter():void
		{
			var mainTask:CJDataOfTask = CJDataManager.o.DataOfTaskList.getCurrentMainTask();
			if(mainTask && mainTask.taskId == 1 && mainTask.status < ConstTask.TASK_ACCEPTED)
			{
				teleporterAnim.visible = false;
			}
			else
			{
				teleporterAnim.visible = true;
			}
		}
		/**
		 * 初始化主角 
		 */		
		protected var _role:CJPlayerNpc;
		private function _initRole():void
		{
			var heroList:CJDataOfHeroList = CJDataManager.o.getData( "CJDataOfHeroList" ) as CJDataOfHeroList;
			var roleId:String = heroList.getRoleId();
			var roleConf:CJDataOfHero = heroList.getHero(roleId);
			
			
			var playerDatas:Vector.<CJPlayerData> = new Vector.<CJPlayerData>();
			var playerData:CJPlayerData = null;
			//主角
			playerData = new CJPlayerData;
			playerData.isPlayer = true;
			playerData.heroId = roleId;
			playerData.templateId = roleConf.templateid;
			playerData.displayName = CJDataManager.o.DataOfRole.name;
			playerData.name = "zhujiao";
			playerDatas.push(playerData);
			_role= new CJPlayerNpc(playerData,Starling.juggler);
			_role.lodlevel = CJPlayerNpc.LEVEL_LOD_0|CJPlayerNpc.LEVEL_LOD_1;
			_role.hidebattleInfo();
			_role.addEventListener(CJEvent.Event_PlayerPosChange,_roleMoveHandler);
			_role.onloadResourceCompleted = function loaded(npc:CJPlayerNpc):void{
				npc.sceneidle();
				npc.canAutoRide = true;
//				npc.RideId = 0;
				//派发完成加载事件
				
				
				var evt:Event = new Event(CJEvent.EVENT_SCENE_CHANGE_COMPLETE,false,{scene:CJDataOfScene.SCENE_CITY});
				CJEventDispatcher.o.dispatchEvent(evt);
			};
			
			setRolePos();
			//添加npc索引
			_role.npcId = String(roleId);

			
			this._playerLayer.addChild(_role);

		}
		/**
		 * 主角升阶后更新场景中的主角形象 
		 * 
		 */		
		private function _updateRole():void
		{
			var tmpx:Number = this._role.x;
			var tmpy:Number = this._role.y;
			//销毁旧主角
//			this._role.dispose();
			this._role.removeFromParent(true);
			//初始化新主角
			this._initRole(); 
			//设置位置
			this._role.x = tmpx
			this._role.y = tmpy
				
			//设置阵型数据
			CJDataManager.o.DataOfFormation.setSkillNeedFire();
		}
		
		protected function setRolePos():void
		{
			if(this._mapInfo.hasOwnProperty("fromscreen") && this._mapInfo.fromscreen == "world")
			{
				_role.setToPosition(_enterRect.topLeft);
			}
			else
			{
				if(CJDataManager.o.DataOfRole.pos_x || CJDataManager.o.DataOfRole.pos_y)
				{
					_role.setToPosition(new Point(CJDataManager.o.DataOfRole.pos_x,CJDataManager.o.DataOfRole.pos_y));
				}
				else
				{
					_role.setToPosition(new Point(this._mapInfo.bornx,this._mapInfo.borny))
				}
			}
			
		}
		/**
		 * 主角移动 
		 * @param destPoint
		 * @param finishFunc
		 * 
		 */
		protected function _rolemoveTo(destPoint:Point,finishFunc:Function = null):void
		{
//			_role.showBattleTips();
			_rolemoveToWithSendSocket(destPoint,finishFunc,true);
		}
		
		private function _rolemoveToWithSendSocket(destPoint:Point,finishFunc:Function = null,isSend:Boolean = true):void
		{
			destPoint.x = Math.min(destPoint.x,_hotAreaRect.x + _hotAreaRect.width + 120);
			destPoint.x = Math.max(destPoint.x,_hotAreaRect.x);
			
			destPoint.y = Math.max(destPoint.y,_hotAreaRect.y);
			destPoint.y = Math.min(destPoint.y,_hotAreaRect.y + _hotAreaRect.height);
			
			var vecsrc:Vector2D = new Vector2D(_role.x,_role.y);
			if(vecsrc.dist(new Vector2D(destPoint.x,destPoint.y))<10)
			{
				if(finishFunc != null)
				{
					finishFunc(_role);
				}
				return;
			}
			if(isSend)
			{
				SocketCommand_role.moveTo(destPoint.x,destPoint.y);
			}
			this._role.runTo(destPoint,finishFunc);
		}
		
		protected function _roleMoveHandler(e:Event):void
		{
			var destx:Number = 0.0;
			if (e.data.x >_carmera.x+(SApplicationConfig.o.stageWidth - _runDisplayRightWidth))
			{
				destx = e.data.x - (SApplicationConfig.o.stageWidth - _runDisplayRightWidth);
//				_carmera.x =destx;
				
				_carmera.moveTo(destx,_carmera.y,0.1);
			}
			else if (e.data.x < _carmera.x + _runDisplayLeftWidth)
			{
				 destx = e.data.x - _runDisplayLeftWidth;
//				_carmera.x = destx;
				
			}
			if(destx != 0)
			{
				var distance:Number = Math.abs(_carmera.x - destx);
				if(distance > 10)
				{
					_carmera.x = destx;
				}
				else
				{
					_carmera.moveTo(destx,_carmera.y,distance/_role.speed);
				}
			}
		}
		/**
		 * 初始化场景中的NPC 
		 */		
		private var _npcList:Dictionary = new Dictionary(true);
		private function _initNpc():void
		{
			var list:Array = CJDataOfScreenNPCProperty.o.getNpcInfo(this._mapInfo.id);
			var dataOfNPC:CJDataOfHeroPropertyList = CJDataOfHeroPropertyList.o;
			for(var i:String in list)
			{
				var id:int = parseInt(list[i]["id"]);
				var npcInfo:CJDataHeroProperty = dataOfNPC.getProperty(id);
				
				var npcDatas:Vector.<CJPlayerData> = new Vector.<CJPlayerData>();
				var playerData:CJPlayerData = new CJPlayerData;
				playerData.isPlayer = false;
				playerData.templateId = id;
				npcDatas.push(playerData);
				
				var npc:CJPlayerNpc = new CJPlayerNpc(playerData,Starling.juggler);
				npc.hidebattleInfo();
//				npc.visible = false;
				npc.needAutoSort = false;
				npc.lodlevel = CJPlayerNpc.LEVEL_LOD_0;
				npc.onloadResourceCompleted = function loaded(_npc:CJPlayerNpc):void{
					_npc.sceneidle();
				};
				npc.x = list[i]["x"];
				npc.y = list[i]["y"];
				//添加npc索引
				npc.addEventListener(TouchEvent.TOUCH,function t(e:TouchEvent):void{
					var touch:Touch = e.getTouch(_mapLayer,TouchPhase.ENDED);
					if(touch == null) {
						return;
					}
					e.stopImmediatePropagation();
					_moveToNpcAndOpenDialog(e.currentTarget as CJPlayerNpc);
					
					//如果地面存在移动的特效标志，则移除
					if(_touchmoveeffect)
					{
						_touchmoveeffect.visible = false;
					}
					
				});

				_npcList[id] = npc;
				this._npcLayer.addChild(npc);
			}
			
//			数据不为空，初始化NPC的状态
			if(!CJDataManager.o.DataOfTaskList.dataIsEmpty)
			{
				_doUpdateNpcStatus();
			}
		}

		
		protected function _touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(_mapLayer);
			if(touch)
			{
				if(touch.phase == TouchPhase.ENDED)
				{
					this._role.hideTitle(CJPlayerTitleLayer.TITLETYPE_TASK_NAVIGATING);
					var destpoint:Point = _mapLayer.globalToLocal(new Point(touch.globalX,touch.globalY));
					_rolemoveTo(destpoint,_movefinish);
					
					if(_touchmoveeffect)
					{
						_touchmoveeffect.visible = false;
						var vecsrc:Vector2D = new Vector2D(_role.x,_role.y);
						if(vecsrc.dist(new Vector2D(destpoint.x,destpoint.y)) > 10)
						{
							_touchmoveeffect.visible = true;
						}
						_touchmoveeffect.x = destpoint.x;
						_touchmoveeffect.y = destpoint.y;
					}
				}
				else if(touch.phase == TouchPhase.MOVED)
				{
					this._role.hideTitle(CJPlayerTitleLayer.TITLETYPE_TASK_NAVIGATING);
					var destpoint:Point = _mapLayer.globalToLocal(new Point(touch.globalX,touch.globalY));
					_rolemoveToWithSendSocket(destpoint,_movefinish,false);
					
					if(_touchmoveeffect)
					{
						_touchmoveeffect.visible = false;
					}
				}
			}
		}
		
		/**
		 * 检测是否进入传送点 
		 * @param role
		 * 
		 */
		protected function _movefinish(role:CJPlayerNpc):void
		{
			if(_touchmoveeffect)
			{
				_touchmoveeffect.visible = false;
			}
			if(_enterRect.contains(this._role.x,this._role.y))
			{
					if(!teleporterAnim.visible)
					{
						return;
					}
					
					var prams:Object
					if(_gotoSceneId>0)
					{
						prams= {cityid:_gotoSceneId};
						_gotoSceneId = 0;
					}
					SApplication.moduleManager.enterModule("CJWorldMapModule",prams);
//					CJLoaderMoudle.loadModuleWithResource(["CJWorldModule"],["CJWorldModule"],[prams]);
//					CJLoaderMoudle.helper_enterWorld(prams);
//					SApplication.moduleManager.enterModule("CJWorldModule",prams);
			}
			
			
		}
		
		/**
		 *移动到NPC身边兵打开对话框 
		 * @param destNpc
		 * 
		 */		
		private function _moveToNpcAndOpenDialog(destNpc:CJPlayerNpc):void
		{
			_rolemoveTo(new Point(destNpc.x-20,destNpc.y+20),
				function finish(npc:CJPlayerNpc):void{
					_guidComplete();
					//打开NPC面板
					CJTaskUIHandler.o.npcClick(destNpc.playerData);
				});
		}
		
		/**
		 * 任务引导结束 
		 * 
		 */		
		private function _guidComplete():void
		{
			this._role.hideTitle(CJPlayerTitleLayer.TITLETYPE_TASK_NAVIGATING);
			var evt:Event = new Event(CJEvent.EVENT_SCENE_TASKGUID_COMPLETE);
			CJEventDispatcher.o.dispatchEvent(evt);
		}
		
		/**
		 * 任务引导NPC 
		 * @param event
		 * 
		 */
		private function _moveToNpc(event:Event):void
		{
			var npcid:int = event.data.npcid;
			if(_npcList.hasOwnProperty(npcid))
			{
				var destnpc:CJPlayerNpc = _npcList[npcid];
				this._role.showTitle(CJPlayerTitleLayer.TITLETYPE_TASK_NAVIGATING);
				_moveToNpcAndOpenDialog(destnpc);
				
			}
		}
	}
}