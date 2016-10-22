package SJ.Game.fuben
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import SJ.Common.Constants.ConstBattle;
	import SJ.Common.Constants.ConstFuben;
	import SJ.Common.Constants.ConstMainUI;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.NPCDialog.CJNPCStoryHandler;
	import SJ.Game.SocketServer.SocketCommand_fuben;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.battle.data.CJBattleFormationData;
	import SJ.Game.controls.CJGeomUtil;
	import SJ.Game.controls.CJMapUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFuben;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfGuankaBattleProperty;
	import SJ.Game.data.config.CJDataOfGuankaProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.json.Json_fuben_guanka_config;
	import SJ.Game.data.json.Json_guanka_battle_config;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLayerRandomBackGround;
	import SJ.Game.mainUI.CJMainSceneLayer;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.display.SMuiscNode;
	import engine_starling.utils.SMuiscChannel;
	import engine_starling.utils.SStringUtils;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 副本战斗UI
	 * @author yongjun
	 * 
	 */
	public class CJFubenBattleBaseLayer extends CJMainSceneLayer
	{
		//当前战斗ID
		private var _currentBattleId:int = 0;
		private var _aheadSprite:SLayer;
		private var _aheadIcon:SImage
		private var _playerdatas:Object = null;
		/**
		 * 战斗偏移距离 
		 */
		private var _offsetbattlex:Number = 0;
		public function CJFubenBattleBaseLayer()
		{
			super();
			var formationData:CJBattleFormationData = ConstBattle.sBattleFormationData[0];
			_offsetbattlex = formationData.getOtherNpcPos(0).x - formationData.getSelfNpcPos(0).x;
			
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_GUANKABATTLE_COMPLETE,_battleCompleteHandler);
		}
		
		override protected function draw():void
		{
			super.draw();
			CJLayerRandomBackGround.Close();
			Starling.juggler.delayCall(_loadComplete,2,null);
		}
	
		override protected function initialize():void
		{
			super.initialize();
			var texturename:String = CJDataOfGuankaProperty.o.getBgimg(_data.guankaConf.id)
			_mapbackgroundLayer = CJMapUtil.getMapLayer(SApplication.assets.getTextures(texturename))
			_mapLayer.addChildAt(_mapbackgroundLayer,0);
			
			var bgmusic:SMuiscNode = new SMuiscNode(SMuiscChannel.SMuiscChannelCreateByName(_data.guankaConf.music));
			bgmusic.loop = true;
			_mapLayer.addChild(bgmusic);
			
			_initHotArea();
			_createAheadbtn();
			
			createPlayer(playerdatas);
		}
		
		/**
		 *  
		 * @param data
		 * 
		 */
		private var _data:Object;
		public function set data(data:Object):void
		{
			_data = data;
		}
		/**
		 * 创建前进提示按钮 
		 * 
		 */		
		private function _createAheadbtn():void
		{
			_aheadSprite = new SLayer
			_aheadSprite.x = SApplicationConfig.o.stageWidth - 180;
			_aheadSprite.y = 100;
			var aheadWord:SImage = new SImage(SApplication.assets.getTexture("fuben_qianjin"));
			_aheadSprite.addChild(aheadWord);
			_aheadIcon = new SImage(SApplication.assets.getTexture("fuben_qianjinjiantou"));
			_aheadIcon.x = 70;
			_aheadIcon.y = 10;
			_aheadSprite.addEventListener(TouchEvent.TOUCH,_aheadTouchHandler);
			_aheadSprite.addChild(_aheadIcon);
			_hideAhead();
			CJLayerManager.o.tipsLayer.addChild(_aheadSprite);
		}
		private function _showAhead():void
		{
			_aheadSprite.visible = true;
			_aheadSprite.touchable = true;
			mapLayer.addEventListener(TouchEvent.TOUCH,_mapTouchHandler);
		}
		private function _hideAhead():void
		{
			_aheadSprite.touchable = false;
			_aheadSprite.visible = false;
			mapLayer.removeEventListener(TouchEvent.TOUCH,_mapTouchHandler);
		}
		
		private function _mapTouchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this._mapLayer,TouchPhase.BEGAN);
			if(touch)
			{
				if(touch.globalX > Starling.current.stage.stageWidth/2)
				{
					_nextbattle();
				}
			}
		}
		
		/**
		 * 点击前进按钮 
		 * @param e
		 * 
		 */		
		private function _aheadTouchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(CJLayerManager.o.tipsLayer,TouchPhase.BEGAN)
			if(touch)
			{
				_nextbattle();
			}
		}
		
	
		/**
		 * 重新设置玩家自己位置 
		 * 
		 */
		override protected function setRolePos():void
		{
			
		}
		/**
		 * 设置可点击区域 
		 * 
		 */		
		override protected function _initHotArea():void
		{
			_hotAreaRect = new Rectangle(0,130,1600,290);
			_runDisplayRightWidth = 332;
			_carmera.maxx = 1600 - SApplicationConfig.o.stageWidth;
			_carmera.minx = -100;
		}
		
		override protected function _initMoveEffect():void
		{
			
		}
		
		override protected function _touchHandler(e:TouchEvent):void
		{
			//主要为了重写父类方法
		}
		
		
		/**
		 * 创建玩家队伍 
		 * 
		 */
		private var _playerTroop:CJTroopsItem
		/**
		 * 创建玩家, 
		 * @param data 玩家数据数组
		 * 
		 * 216175330484267009	Object (@22213b81)	
	blood	"0"	
	crit	"0"	
	cure	"0"	
	dodge	"0"	
	formationindex	"0"	
	genius	"None"	
	heroid	"216175330484267009"	
	hit	"9500"	
	hp	"4466"	
	inchurt	"0"	
	level	"6"	
	mattack	"0"	
	mcrit	"0"	
	mdef	"6"	
	mimmuno	"0"	
	mpassthrough	"9500"	
	mtoughness	"0"	
	pattack	"318"	
	pdef	"9"	
	reducehurt	"0"	
	skill1	1012 [0x3f4]	
	speed	"0"	
	templateid	"10001"	
	toughness	"0"	
	userid	"216175330484267009"	

		 * 
		 * 
		 * 
		 * 
		 */
		private function createPlayer(data:Object):void
		{
			_playerTroop = new CJTroopsItem(data,true);
			var formationData:CJBattleFormationData = ConstBattle.sBattleFormationData[0];
			_playerTroop.x = formationData.getSelfNpcPos(0).x;
			_playerTroop.speed = 1200;
			_playerTroop.addEventListener(CJEvent.Event_PlayerPosChange,this._roleMoveHandler)
			this._playerLayer.addChild(_playerTroop)
			createNpc();

		}
		/**
		 *  创建NPC怪
		 * 
		 */	
		private var _npcTroopList:Vector.<CJTroopsItem> = new Vector.<CJTroopsItem>;
		private function createNpc():void
		{
			var guankaConf:Json_fuben_guanka_config = _data.guankaConf;
			var zids:Array = [guankaConf.zid1,guankaConf.zid2,guankaConf.zid3];
			for(var i:String in zids)
			{
				if(!zids[i]) continue;
				var heroDict:Array = new Array;
				var guankaBattale:Json_guanka_battle_config = CJDataOfGuankaBattleProperty.o.getPropertyById(zids[i]);
				var npcs:Array = CJDataOfGuankaBattleProperty.o.getBattleNpc(zids[i]);
				for(var j:int=0;j<6;j++)
				{
					if(npcs[j] ==0)continue;
					var heroItem:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(npcs[j]);
					var obj:Object = {"formationindex":String(j),"heroid":npcs[j],"templateid":npcs[j],"hp":heroItem.hp}
					heroDict.push(obj);
				}
				//初始化NPC怪
				var _npcTroop:CJTroopsItem = new CJTroopsItem(heroDict,false);
				//战斗ID
				_npcTroop.id = zids[i];
				//NPC怪位置
				var pos:Point = CJDataOfGuankaProperty.o.getnpcPos(_data.guankaConf.id,int(i))
				
				_npcTroop.x = pos.x;
				this._npcLayer.addChild(_npcTroop);
				_npcTroopList.push(_npcTroop);
			}
		}
		/**
		 * 进入关卡，资源加载完成，自动前进 
		 * @param e
		 * 
		 */		
		private function _loadComplete(e:Event):void
		{
			var firstTroop:CJTroopsItem = _npcTroopList[0];
			var npcpoint:Point = CJGeomUtil.translate(new Point(firstTroop.x,firstTroop.y),this._npcLayer,this.playerLayer);
			var guankaConf:Json_fuben_guanka_config = CJDataOfGuankaProperty.o.getPropertyById(_data.guankaConf.id)
			if (guankaConf.enterstory !=undefined)
			{
				CJNPCStoryHandler.checkBattleStory(guankaConf.enterstory[0],guankaConf.enterstory[1],guankaConf.enterstory[2],function():void
				{
					_nextbattle();
				})
			}
			else
			{
				_nextbattle();
			}
		}
		
		
		/**
		 * 移动结束 
		 * @param troop
		 * 
		 */		
		private function _moveTroopFinish(troop:CJTroopsItem):void
		{
			var battlId:int = _npcTroopList[0].id;
			this.checkBattleStartStory(battlId,function():void
			{
				_startBattle(battlId)
			})
		}
		
		/**
		 *移除NPC怪部队 
		 * @param zid
		 * 
		 */		
		private function removeNpcTroop(zid:int):void
		{
			for(var i:String in _npcTroopList)
			{
				if(_npcTroopList[i].id == zid)
				{
					_npcTroopList[i].removeFromParent(true);
					_npcTroopList.splice(int(i),1);
				}
			}
		}
		
		override protected function _rolemoveTo(destPoint:Point,finishFunc:Function = null):void
		{
			_playerTroop.runTo(destPoint,finishFunc);
		}
		
		override protected function _roleMoveHandler(e:Event):void
		{
			
			var formationData:CJBattleFormationData = ConstBattle.sBattleFormationData[0];
			_carmera.x = e.data.x - formationData.getSelfNpcPos(0).x;
//			trace (_carmera.x)
//			var time:Number = (e.data.x - formationData.getSelfNpcPos(0).x - _carmera.x)/_playerTroop.speed;
//			_carmera.moveTo(e.data.x - formationData.getSelfNpcPos(0).x,_carmera.y,time);
		}
		
		

		private var _batteString:String;
		/**
		 * 自动进入战斗,主要是应对网络比较卡的情况 
		 */
		private var _isAutoInBattleing:Boolean = false;
		
		/**
		 * 是否正在战斗中 
		 */
		private var _isBattleing:Boolean = false;

		/**
		 * 开始战斗 
		 * @param battleId
		 * 
		 */
		private function _startBattle(battleId:int):void
		{
			//战斗结果还没有返回回来
			if(SStringUtils.isEmpty(_batteString))
			{
				_isAutoInBattleing = true;
				return;
			}
			
			
			//是否正在战斗中
			if(_isBattleing)
				return;
			_isBattleing = true;
			
			
			
			SApplication.moduleManager.enterModule("CJFubenBattleModule",{"battletype":1,"battleid":battleId,"gid":_data.gid,"fid":_data.fid,
				"battleString":_batteString,"startcallback":function():void{
					mapLayer.touchable = false;
					npcLayer.visible = false;
					_playerLayer.visible = false;
				}});
			
			_batteString = "";
			_isAutoInBattleing = false;
			
		}
		/**
		 * 下zhandou 
		 * 
		 */		
		private function _nextbattle():void
		{
			_rolemoveTo(new Point(_npcTroopList[0].x - _offsetbattlex,0),_moveTroopFinish);
			_hideAhead();
			
			var battleId:int = _npcTroopList[0].id;
			var cjdataof:CJDataOfFuben = (CJDataManager.o.getData("CJDataOfFuben") as CJDataOfFuben);	
			SocketCommand_fuben.startBattle(_data.fid,_data.gid,battleId,cjdataof.from,function finish(msg:SocketMessage):void
			{
				_batteString = msg.retparams[0];
				//是否需要返回结构就自动进入战斗了
				if(_isAutoInBattleing)
				{
					_startBattle(battleId);
				}
			});
		}
		/**
		 * 战斗结束 
		 * @param e
		 * 
		 */	
		private var _fuBattlePassLayer:CJFubenGuankaBoxLayer
		private function _battleCompleteHandler(e:Event):void
		{
			_isBattleing = false;
			
			//战斗结果
			var ret:int = int(e.data.ret);
			var zid:int = int(e.data.zid);
			var gid:int = int(e.data.gid);
			var fid:int = int(e.data.fid);
			var _currentBattleData:Object = e.data.battleData;
			var formation:Object = _currentBattleData.formation;
			var showAward:int = ConstFuben.FUBEN_BATTLE_NOAWARD;
			//获取助战赠送体力丹个数   add by zhengzheng 
			if (_currentBattleData.hasOwnProperty("addVitCount"))
			{
				ConstMainUI.addVitCount = _currentBattleData.addVitCount;
			}
				
			// 检测剧情
			checkBattleEndStory(zid,function():void
			{
				if(_currentBattleData.hasOwnProperty("award"))
				{
					showAward = ConstFuben.FUBEN_BATTLE_SHOWAWARD
					_fuBattlePassLayer = new CJFubenGuankaBoxLayer(fid,gid);
					_fuBattlePassLayer.awardData = _currentBattleData["award"];
					CJLayerManager.o.addModuleLayer(_fuBattlePassLayer);
					SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,randkAwardItemRet);
					SocketCommand_fuben.randAwarditem(fid,gid)
				}
				else
				{
					//没有奖励，显示前进按钮
					_showAhead();
				}
				//更新玩家死亡武将
				_playerTroop.updateToDead(formation);
				
				if(ret == ConstBattle.BattleResultSuccess)
				{
					//移除怪物
					removeNpcTroop(zid);
				}
				npcLayer.visible = true;
				playerLayer.visible = true;
				mapLayer.touchable = true;

			})
		}
		
		private function randkAwardItemRet(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage
			if(msg.getCommand() == ConstNetCommand.CS_FUBEN_PASS_RAND_AWARD)
			{
				e.currentTarget.removeEventListener(CJSocketEvent.SocketEventData,randkAwardItemRet)
				if(msg.retcode!=0)
				{
					switch(msg.retcode)
					{
						case 1:
							
							break;
					}
					return;
				}
				var iteminfo:Object = msg.retparams;
				_fuBattlePassLayer.iteminfo = iteminfo
			}
		}
		/**
		 * 检测战斗开始剧情 
		 * @param func
		 * 
		 */		
		private function checkBattleStartStory(battleId:int,func:Function):void
		{
			var guankaBattale:Json_guanka_battle_config = CJDataOfGuankaBattleProperty.o.getPropertyById(battleId)
			if(!guankaBattale.startstory)
			{
				func();
				return;
			}
			CJNPCStoryHandler.checkBattleStory(guankaBattale.startstory[0],guankaBattale.startstory[1],guankaBattale.startstory[2],function():void
			{
				func();
			})	
		}
		/**
		 * 检测战斗结束剧情
		 * @param battleId
		 * @param func
		 * 
		 */
		private function checkBattleEndStory(battleId:int,func:Function):void
		{
			var guankaBattale:Json_guanka_battle_config = CJDataOfGuankaBattleProperty.o.getPropertyById(battleId)
			if(!guankaBattale.endstory)
			{
				func();
				return;
			}
			CJNPCStoryHandler.checkBattleStory(guankaBattale.endstory[0],guankaBattale.endstory[1],guankaBattale.endstory[2],function():void
			{
				func();
			})	
		}
		
		override public function dispose():void
		{
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_GUANKABATTLE_COMPLETE,_battleCompleteHandler);
			_playerTroop.dispose();
			for(var i:String in _npcTroopList)
			{
				_npcTroopList[i].dispose();
			}
			_playerTroop.removeEventListener(CJEvent.Event_PlayerPosChange,this._roleMoveHandler)
			_aheadSprite.removeEventListener(TouchEvent.TOUCH,_aheadTouchHandler);
			_aheadSprite.removeFromParent();
			_mapLayer.removeEventListener(TouchEvent.TOUCH,_mapTouchHandler);
			if(_fuBattlePassLayer)
			{
				_fuBattlePassLayer.clear();
				_fuBattlePassLayer.dispose();
				_fuBattlePassLayer = null;
			}
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,randkAwardItemRet);
			super.dispose();
		}

		public function get playerdatas():Object
		{
			return _playerdatas;
		}

		public function set playerdatas(value:Object):void
		{
			_playerdatas = value;
		}

	
	}
}