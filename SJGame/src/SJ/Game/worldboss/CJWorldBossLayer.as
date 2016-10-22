package SJ.Game.worldboss
{
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.controls.CJMapUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.config.CJDataOfMainSceneProperty;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.mainUI.CJScenePlayerManager;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	import SJ.Game.player.CJPlayerTitleLayer;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SCamera;
	import engine_starling.display.SLayer;
	import engine_starling.display.SMuiscNode;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	import engine_starling.utils.SMuiscChannel;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import lib.engine.math.Vector2D;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 +------------------------------------------------------------------------------
	 * 世界boss主界面
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-19 下午1:01:24  
	 +------------------------------------------------------------------------------
	 */
	public class CJWorldBossLayer extends SLayer
	{
		public static const FLAG_CHANGE_WORLDBOSS_SCENE:String = "FLAG_CHANGE_WORLDBOSS_SCENE";
		
		public static const MOVE_X_LEFT_OFFSET:int = 150;
		public static const MOVE_X_RIGHT_OFFSET:int = 150;
		public static const MOVE_Y_TOP_OFFSET:int = 20;
		public static const MOVE_Y_BOTTOM_OFFSET:int = 20;
		
		private var _bgLayer:SLayer;
		private var _playerLayer:SLayer;
		private var _panelLayer:CJWorldBossPanelLayer;
		
		/*地图背景*/
		private var _bg:Sprite;
		private var _camera:SCamera;
		private var _sceneId:int = 0;
		private var _sceneConfig:Object;
		private var _sceneplayermanager:CJScenePlayerManager;
		private var _role:CJPlayerNpc;
		private var _monsterManager:CJWorldBossMonsterManager;
		/*点击指示*/
		private var _touchmoveeffect:SAnimate;
		private var _moveLimitRect:Rectangle;
		/*黄泉线*/
		private var _fire:SAnimate;
		public static const FIREPOS:Point = new Point(210 , 85);
		
		public function CJWorldBossLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._drawContent();
			this._addEventListeners();
		}
		
		private function _drawContent():void
		{
			this.setSize(SApplicationConfig.o.stageWidth , SApplicationConfig.o.stageHeight);
			this._bgLayer = new SLayer();
			
			this._playerLayer = new SLayer();
			this.addChild(this._bgLayer);
			
			var sxml:XML = AssetManagerUtil.o.getObject("worldbosspanel.sxml") as XML;
			this._panelLayer = SFeatherControlUtils.o.genLayoutFromXML(sxml , CJWorldBossPanelLayer) as CJWorldBossPanelLayer;
			this.addChild(this._panelLayer);
			
			this._camera = new SCamera(this._bgLayer);
			this._initMoveEffect();
			
			_sceneplayermanager = new CJScenePlayerManager(this._playerLayer);
			
			_fire = new SAnimate(SApplication.assets.getTextures("worldboss_texiaoxian_") , 8);
			_fire.x = FIREPOS.x;
			_fire.y = FIREPOS.y;
			this._bgLayer.addChild(_fire);
			Starling.juggler.add(_fire);
			
			this._bgLayer.addChild(this._playerLayer);
			
			this._initMonster();
			
			this._initRole();
		}
		
		private function _initMonster():void
		{
			_monsterManager = new CJWorldBossMonsterManager();
			_monsterManager.createAllMonster();
			var allMonster:Vector.<CJWorldMonster> = _monsterManager.monsterList;
			for(var i:int = 0 ; i< allMonster.length ; i++)
			{
				this._playerLayer.addChild(allMonster[i]);
			}
		}
		
		private function _addEventListeners():void
		{
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_PLYER_UPLEVEL , this._otherUplevelHandler)
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_SELF_PLAYER_UPLEVEL , this._selfUplevelHandler)
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_PLAYER_ROLEUPDATE,this._updateRole);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_CHANGE_HORSE , this._horseChangeHandler);
			
			this._bgLayer.addEventListener(TouchEvent.TOUCH,_touchHandler);
		}
		
		private function _setBgMusic():void
		{
			var bgMuisc:SMuiscNode = new SMuiscNode(SMuiscChannel.SMuiscChannelCreateByName(_sceneConfig.music));
			bgMuisc.loop = true;
			addChild(bgMuisc);
		}
		
		/**
		 * 初始化角色
		 */ 
		private function _initRole():void
		{
			var role:CJDataOfHero = CJDataManager.o.DataOfHeroList.getMainHero();
			var playerData:CJPlayerData = new CJPlayerData();
			playerData.isPlayer = true;
			playerData.heroId = role.heroid;
			playerData.templateId = role.templateid;
			playerData.displayName = CJDataManager.o.DataOfRole.name;
			playerData.name = "zhujiao";
			_role = new CJPlayerNpc(playerData , null);
			_role.lodlevel = CJPlayerNpc.LEVEL_LOD_0|CJPlayerNpc.LEVEL_LOD_1;
			_role.hidebattleInfo();
			_role.addEventListener(CJEvent.Event_PlayerPosChange,_roleMoveHandler);
			_role.npcId = String(role.heroid);
			
			_role.onloadResourceCompleted = function loaded(npc:CJPlayerNpc):void{
				npc.sceneidle();
				npc.canAutoRide = true;
			};
			
			this._playerLayer.addChild(_role);
		}
		
		/**
		 * 移动点击特效
		 */ 
		private function _initMoveEffect():void
		{
			var moveeffectObject:Object = AssetManagerUtil.o.getObject("anim_changjing_moveeffect");
			if(moveeffectObject)
			{
				_touchmoveeffect = SAnimate.SAnimateFromAnimJsonObject(moveeffectObject);
				_touchmoveeffect.visible = false;
				_playerLayer.addChild(_touchmoveeffect);
				_touchmoveeffect.gotoAndPlay();
				Starling.juggler.add(_touchmoveeffect);
			}
		}
		
		/**
		 * 移动区域限制
		 */ 
		private function _setMoveRect():void
		{
			_moveLimitRect = new Rectangle(_sceneConfig.limitx , int(_sceneConfig.limity) , _sceneConfig.limitw , _sceneConfig.limith);
			_camera.maxx = _moveLimitRect.width - SApplicationConfig.o.stageWidth;
			_camera.maxy = _moveLimitRect.height;
		}
		
		/**
		 * 点击地图移动
		 */ 
		private function _touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(_bgLayer);
			if(touch)
			{
				if(touch.phase == TouchPhase.ENDED || touch.phase == TouchPhase.MOVED)
				{
					var destpoint:Point = touch.getLocation(_bgLayer);
					this._rolemoveTo(destpoint,function(role:CJPlayerNpc):void
					{
						if(_touchmoveeffect)
						{
							_touchmoveeffect.visible = false;
						}
					}
					);
					
					if(_touchmoveeffect)
					{
						_touchmoveeffect.visible = false;
						if(touch.phase == TouchPhase.ENDED)
						{
							var vecsrc:Vector2D = new Vector2D(_role.x,_role.y);
							if(vecsrc.dist(new Vector2D(destpoint.x,destpoint.y)) > 10)
							{
								_touchmoveeffect.visible = true;
							}
							_touchmoveeffect.x = destpoint.x;
							_touchmoveeffect.y = destpoint.y;
						}
					}
				}
			}
		}
		
		protected function _rolemoveTo(destPoint:Point,finishFunc:Function = null):void
		{
			destPoint.y = Math.max(destPoint.y , _moveLimitRect.y);
			destPoint.y = Math.min(destPoint.y , _moveLimitRect.y + _moveLimitRect.height);
			
			var vecsrc:Vector2D = new Vector2D(_role.x,_role.y);
			if(vecsrc.dist(new Vector2D(destPoint.x,destPoint.y)) < 10)
			{
				if(finishFunc != null)
				{
					finishFunc(_role);
				}
				return;
			}
			
			SocketCommand_role.moveTo(destPoint.x , destPoint.y);
			this._role.runTo(destPoint,function():void
			{
				if(_touchmoveeffect)
				{
					_touchmoveeffect.visible = false;
				}
			});
		}
		
		/**
		 * 移动请求响应
		 */ 
		private function _roleMoveHandler(e:Event):void
		{
			var moveToMapX:Number = e.data.x;
			var moveToMapY:Number = e.data.y;
			
			if(moveToMapX > _camera.x + SApplicationConfig.o.stageWidth - MOVE_X_RIGHT_OFFSET)
			{
				_camera.x = moveToMapX - SApplicationConfig.o.stageWidth + MOVE_X_RIGHT_OFFSET;
			}
			if(moveToMapX < _camera.x + MOVE_X_LEFT_OFFSET)
			{
				_camera.x = moveToMapX - MOVE_X_LEFT_OFFSET;
			}
		}
		
		override protected function draw():void
		{
			super.draw();
			if(!this._sceneConfig)
			{
				return;
			}
			if(this.isInvalid(FLAG_CHANGE_WORLDBOSS_SCENE))
			{
				this._refreshAll();
			}
		}
		
		private function _refreshAll():void
		{
			this._setBgMusic();
			this._setMoveRect();
			this._refreshBg();
			this._refreshRank();
			this._refreshMonster();
			this._refreshRolePos();
			this._refreshOtherPlayers();
			this._refreshWallBasicInfo();
		}
		
		private function _refreshRolePos():void
		{
			_role.setToPosition(new Point(this._sceneConfig.bornx,this._sceneConfig.borny))
		}
		
		/**
		 * 刷新其他玩家npc
		 */ 
		private function _refreshOtherPlayers():void
		{
			_sceneplayermanager.activeManager();
			_sceneplayermanager.freshAllPlayers();
		}
		
		private function _refreshBg():void
		{
			if(this._bg)
			{
				this._bg.removeFromParent();
				this._bg = null;
			}
			var sceneConfig:Object = CJDataOfMainSceneProperty.o.getPropertyById(this._sceneId);
			if(sceneConfig)
			{
				var textures:Vector.<Texture> = SApplication.assets.getTextures(sceneConfig.maptexturename);
				this._bg = CJMapUtil.getMapLayer(textures);
				this._bgLayer.addChildAt(this._bg , 0);
			}
		}
		
		/**
		 * 刷新怪物
		 */ 
		private function _refreshMonster():void
		{
			
		}
		
		/**
		 * 刷新主城血量，时间，按钮等
		 */ 
		private function _refreshWallBasicInfo():void
		{
			
		}
		
		/**
		 * 刷新排行榜
		 */ 
		private function _refreshRank():void
		{
			
		}
		
		/**
		 * 换坐骑
		 */ 
		private function _horseChangeHandler(e:Event):void
		{
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
		 * 主角升阶，更换形象
		 */ 
		private function _updateRole(e:Event):void
		{
			var tmpx:Number = this._role.x;
			var tmpy:Number = this._role.y;
			this._role.removeFromParent(true);
			this._initRole(); 
			this._role.x = tmpx
			this._role.y = tmpy
		}
		
		/**
		 * 自己升级，特效
		 */ 
		private function _selfUplevelHandler(e:Event):void
		{
			_role.showTitle(CJPlayerTitleLayer.TITLETYPE_NAME | CJPlayerTitleLayer.TITLETYPE_UPLEVEL);
			_role.showUplevelAnims();
		}
		
		/**
		 * 其它玩家升级
		 */ 
		private function _otherUplevelHandler(e:Event):void
		{
			var data:Object = e.data;
			var uid:String = data.uid;
			var heroid:String  = String(data.heroid);
			var currentLevel:int = int(data.currentLevel);
			var player:CJPlayerNpc = _sceneplayermanager.getPlayer(uid);
			if(player)
			{
				player.showTitle(CJPlayerTitleLayer.TITLETYPE_NAME | CJPlayerTitleLayer.TITLETYPE_UPLEVEL);
				player.showUplevelAnims();
			}
		}
		
		/**
		 * 世界boss场景销毁
		 */ 
		override public function dispose():void
		{
			super.dispose();
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_PLYER_UPLEVEL , this._otherUplevelHandler)
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_SELF_PLAYER_UPLEVEL , this._selfUplevelHandler);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_PLAYER_ROLEUPDATE,this._updateRole);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_CHANGE_HORSE , this._horseChangeHandler);
			if(_sceneplayermanager != null)
			{
				_sceneplayermanager.removeAllPlayers();
				_sceneplayermanager.deactiveManager();
				_sceneplayermanager = null;
			}
			if(_touchmoveeffect)
			{
				_touchmoveeffect.removeFromJuggler();
				_touchmoveeffect.removeFromParent();
			}
			
			Starling.juggler.remove(_fire);
		}
		
		/**
		 * 切换到其它城门
		 */ 
		public function set enterSceneId(sceneId:int):void
		{
			if(sceneId == _sceneId)
			{
				return;
			}
			_sceneId = sceneId;
			_sceneConfig = CJDataOfMainSceneProperty.o.getPropertyById(sceneId);
			this.invalidate(FLAG_CHANGE_WORLDBOSS_SCENE);
		}
	}
}