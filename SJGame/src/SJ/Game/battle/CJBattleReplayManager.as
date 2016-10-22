package SJ.Game.battle
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstBattle;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.SocketServer.SocketCommand_battle;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.battle.custom.CJBattleCommandBattleEnd;
	import SJ.Game.battle.custom.CJBattleCommandBattleOrder;
	import SJ.Game.battle.custom.CJBattleCommandBattleStart;
	import SJ.Game.battle.custom.CJBattleCommandEndRound;
	import SJ.Game.battle.custom.CJBattleCommandNpcBattle;
	import SJ.Game.battle.custom.CJBattleCommandNpcBattleEnd;
	import SJ.Game.battle.custom.CJBattleCommandNpcBattleStart;
	import SJ.Game.battle.custom.CJBattleCommandStandBy;
	import SJ.Game.battle.custom.CJBattleCommandStartRound;
	import SJ.Game.battle.data.CJBattleFormationData;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.SApplication;
	import engine_starling.Events.CommandEvent;
	import engine_starling.commandSys.core.SCommandBaseData;
	import engine_starling.commandSys.core.SCommandManager;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SArrayUtil;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.events.Event;

	/**
	 * 战斗播放管理器 
	 * @author caihua
	 * 
	 */
	public class CJBattleReplayManager implements IAnimatable
	{
		public function CJBattleReplayManager()
		{
			_init();
		}
		
		/**
		 * 命令管理器 
		 */
		private var _commandManager:SCommandManager;
		


		/**
		 * 奖励数据 
		 */
		public function get battleAwards():Object
		{
			return _battleAwards;
		}

		private function _init():void
		{
			_commandManager = new SCommandManager();
			
			_commandManager.registerCommand(new CJBattleCommandStandBy());
			_commandManager.registerCommand(new CJBattleCommandBattleOrder());
			
			_commandManager.registerCommand(new CJBattleCommandBattleStart());
			_commandManager.registerCommand(new CJBattleCommandBattleEnd());
			
			_commandManager.registerCommand(new CJBattleCommandStartRound());
			_commandManager.registerCommand(new CJBattleCommandEndRound());
			
			_commandManager.registerCommand(new CJBattleCommandNpcBattleStart());
			_commandManager.registerCommand(new CJBattleCommandNpcBattle());
			_commandManager.registerCommand(new CJBattleCommandNpcBattleEnd());
			
			_heroContains = new Dictionary();
			
//			_playerContains = new Dictionary();
//			_playerContainsByLocationIndex = new Dictionary();
//			
//			
//			_initFormation();
			
			//初始化阵型数据
			var formationInfo:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonBattleFormation) as Array;
			//目前支持3个阵型
			ConstBattle.sBattleFormationData = new Array();
			//			"formationJson"	Object (@2d277f1)	
			//			id	"0"	
			//			posid	"0"	
			//			postiontype	"0"	
			//			postionx	"1500"	
			//			postiony	"1500"	
			
			
			var length:int = formationInfo.length;
			for(var i:int = 0;i<length;i++)
			{
				var formationJson:Object = formationInfo[i];
				var formationId:int = formationJson["id"];
				//十位数是索引
				var formationType:int = formationJson["postiontype"];
				if(ConstBattle.sBattleFormationData[formationId] == null)
				{
					ConstBattle.sBattleFormationData[formationId] = new CJBattleFormationData();
				}
				var formationData:CJBattleFormationData = ConstBattle.sBattleFormationData[formationId];
				//添加进去位置
				formationData.addPos( formationJson["posid"],formationJson["postionx"]/2,formationJson["postiony"]/2,formationType);
			}
		}
		private var _battleJsonObject:Object;
		/**
		 *战斗奖励 
		 */		
		private var _battleAwards:Object;
		/**
		 *战斗结果，0成功，1失败 
		 */		
		
		private var _jugger:Juggler = new Juggler;
		
		/**
		 * 战斗过程数据 
		 */
		private var _battleprocessObject:Array
		/**
		 *战斗结果，0 成功，1失败 
		 */		
		private var _battleResult:int;
		/**
		 * 设置战斗数据 
		 * @param json
		 * 
		 */
		public function setbattleJson(json:String):void
		{
			_battleJsonObject = JSON.parse(json);
			_battleprocessObject = _battleJsonObject["battle"] as Array;
			_battleAwards = _battleJsonObject["award"];
			_battleResult = _battleJsonObject["result"];
		}

		private var _vectorOfBattleBatch:Vector.<Object> = new Vector.<Object>();
		/**
		 * 战斗批次 
		 */
		public function get vectorOfBattleBatch():Vector.<Object>
		{
			return _vectorOfBattleBatch;
		}
		public function get battleResult():int
		{
			return this._battleResult;
		}
		
		public function advanceTime(time:Number):void
		{
			_jugger.advanceTime(time);
			
		}
		
		
		/**
		 * 完成回调函数 function(mgr:CJBattleReplayManager):void 
		 */
		private var _onFinish:Function;
		
		/**
		 * 当前播放到的步骤 
		 */
		private var _currentplayindex:int = 0;
		private var _currentCmd:SCommandBaseData = null;
		
		private var _isPlaying:Boolean = false;
		
		private var _isShowBattleStartAnims:Boolean = true;

		/**
		 * 开始播放 重头播放
		 * @param onfinish 完成回调函数 function(mgr:CJBattleReplayManager):void 
		 * 
		 */
		public function play(onfinish:Function = null):void
		{
			if(_isPlaying)
				return;
			
			
			SApplication.juggler.speedup= 1.2;
			_onFinish = onfinish;
			_isPlaying = true;
			Starling.juggler.add(this);
			_commandManager.start(_jugger);
			_play();
		}
		
	
		
		/**
		 * 停止播放 
		 * 
		 */
		public function stop():void
		{
			if(!_isPlaying)
				return;
			SApplication.juggler.speedup = 1.0;
			if(_onFinish != null)
			{
				_onFinish(this);
				_onFinish = null;
			}
			_isPlaying = false;
			_jugger.purge();
			Starling.juggler.remove(this);
			
			_heroContains = new Dictionary();
//			_vectorOfBattleBatch.splice(0,_vectorOfBattleBatch.length);
			_commandManager.stop();
		}
		
		/**
		 * 销毁 
		 * 
		 */
		public function dispose():void
		{
			stop();
			_battleJsonObject = null;
			_battleAwards = null;
			_heroContains = null;
			_vectorOfBattleBatch = null;
		}
		
		
		private function _play():void
		{
			_currentplayindex = 0;
			_gotoend = false;
			_nextCommand();
		}
		private function _executeCmd(cmd:String,params:Object):void
		{
			var commandId:int = ConstBattle[cmd];
			var dataOfCommand:SCommandBaseData = _commandManager.genCommandData(commandId);
			dataOfCommand.during = 50000;
			//fix 如果一个武将战斗播放超过10秒，自动进入下一个武将的战斗播放
			if(commandId == ConstBattle.CommandNpcBattle)
			{
				dataOfCommand.during = 10;
			}
			dataOfCommand.params = {mgr:this,params:params}
			_currentCmd = dataOfCommand;
			_commandManager.addCommand(dataOfCommand);
			_commandManager.addCommandEventListener(commandId,
				CommandEvent.Event_Finshed,_execteCmdFinish);
		}
		private var _gotoend:Boolean = false;
		/**
		 * 播放到结束动画 
		 * 
		 */
		public function playtoend():void
		{
			_gotoend = true;
		}
		
		private var  _onCmdFinishCallBack:Function = null;

		/**
		 * 命令执行结束回调 function( dataOfCommand:SCommandBaseData);
		 */
		public function set onCmdFinishCallBack(value:Function):void
		{
			_onCmdFinishCallBack = value;
		}

		
		private function _execteCmdFinish(e:Event):void
		{
			e.target.removeEventListener(CommandEvent.Event_Finshed,_execteCmdFinish);
			if(_onCmdFinishCallBack != null)
			{
				_onCmdFinishCallBack(_currentCmd);
			}
			_currentCmd = null;
			_nextCommand();
		}
		
		private function _nextCommand():Boolean
		{
			if(_currentplayindex >= _battleprocessObject.length)
			{
				stop();
				return false;
			}
			else
			{
				
				if(_gotoend == true)
				{
					_currentplayindex = _battleprocessObject.length-1;
				}
				
				var cmdObject:Object = _battleprocessObject[_currentplayindex];
				_currentplayindex ++;
				
				var cmd:String = cmdObject["cmd"] as String;
				var info:Object = cmdObject["info"];
				if(!(info is String))
				{
					info["index"] = _currentplayindex - 1;
				}
				_executeCmd(cmd,info);
				return true;
			}
		}
		
		/**
		 * 
		 * @param playerData 玩家远程数据
		 * 
		 */		
		public function addPlayer(HeroDataDict:Object,isSelf:Boolean):CJBattlePlayerData
		{
//			"event"	 <求值期间出错>	
//				"this"	SJ.Game.battle.CJBattleReplayManager (@16ea8a41)	
//				"params"	 <求值期间出错>	
//				"playerData"	Object (@17b55ce9)	
//				blood	"100"	
//			144118838966431233	Object (@289250e9)	
//			agility	0	
//			basehp	572 [0x23c]	
//			basemattack	0	
//			basemdef	85 [0x55]	
//			basepattack	110 [0x6e]	
//			basepdef	85 [0x55]	
//			blood	"0"	
//			crit	"0"	
//			cure	"0"	
//			dodge	"0"	
//			formationindex	"4"	
//			genius	"None"	
//			heroid	"144118838966431233"	
//			hit	"0"	
//			hp	"574"	
//			inchurt	"0"	
//			intelligence	0	
//			level	"2"	
//			mattack	"0"	
//			mcrit	"0"	
//			mdef	"85"	
//			mimmuno	"0"	
//			mpassthrough	"0"	
//			mtoughness	"0"	
//			pattack	"110"	
//			pdef	"85"	
//			physique	50 [0x32]	
//			reducehurt	"0"	
//			skill1	1010 [0x3f2]	
//			skill1eachround	3	
//			skill1startround	1	
//			speed	"0"	
//			spirit	0	
//			strength	0	
//			templateid	"10001"	
//			toughness	"0"	
//			userid	"144118838966431233"	

			var playerData:CJPlayerData = new CJPlayerData();
			playerData.isSelf = isSelf;
			playerData.name = HeroDataDict.heroid;
			playerData.heroId = HeroDataDict.heroid;
			playerData.templateId = parseInt(HeroDataDict["templateid"]);
			playerData.formationindex = parseInt(HeroDataDict["formationindex"]);
			playerData.hp_max = parseInt(HeroDataDict.hp);
			
			playerData.hp = parseInt(HeroDataDict.hp);
			playerData.level =  parseInt(HeroDataDict.level);
			playerData.herostar = parseInt(HeroDataDict.herostar);
			playerData.battleeffect = parseInt(HeroDataDict.battleeffect);


			playerData.skillcurrentid = parseInt(HeroDataDict.skill1);
			playerData.skillstartround = parseInt(HeroDataDict.skill1startround);
			playerData.skilleachround = parseInt(HeroDataDict.skill1eachround);
			if(HeroDataDict.hasOwnProperty("heroname"))
			{
				playerData.displayName = String(HeroDataDict.heroname);
			}
			
			//playerData.super_hero = parseInt(HeroDataDict.skill1startround) == 0?true:false;
				
			_heroContains[playerData.name] = new CJBattlePlayerData(playerData);
			return _heroContains[playerData.name];
		}
		/**
		 * 获得战斗的player 
		 * @param heroid
		 * @return 
		 * 
		 */
		public function getPlayer(heroid:String):CJBattlePlayerData
		{
			return _heroContains[heroid];
		}
		/**
		 *获取己方战斗player
		 * @return 
		 * 
		 */
		public function getSelfPlayers():Array
		{
			var array: Array = new Array();
			for each(var data:CJBattlePlayerData in _heroContains)
			{
				if(data.playerBaseData.isSelf)
				{
					array.push(data);
				}
			}		
			return array;
		}
		/**
		 *获取敌方战斗player
		 * @return 
		 * 
		 */
		public function getEnemyPlayers():Array
		{
			var array: Array = new Array();
			for each(var data:CJBattlePlayerData in _heroContains)
			{
				if(!data.playerBaseData.isSelf)
				{
					array.push(data);
				}
			}		
			return array;
		}	
	
		
		private var _heroContains:Dictionary;
		

		public static function testBattle():void
		{
			SocketCommand_battle.battlenpc();
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,
				function _onSocket(e:Event):void
				{
					var msg:SocketMessage = e.data as SocketMessage
					if(msg.getCommand() == ConstNetCommand.CS_BATTLENPC)
					{
						SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onSocket);
						var jsonString:String = msg.retparams[0]
						
						//初始化战斗播放器
						var battlereplymanager:CJBattleReplayManager = new CJBattleReplayManager();
						battlereplymanager.setbattleJson(jsonString);
						battlereplymanager.play();
					}
					
				});
		}

		/**
		 * 战斗json数据 
		 */
		public function get battleJsonObject():Object
		{
			return _battleJsonObject;
		}
		
		
		/**
		 * 获取战斗需要资源 
		 * @return 
		 * 
		 */
		public static function getBattleResource(battleString:String):Array
		{
			var res:Array = new Array();
			var battleJsonObject:Object = JSON.parse(battleString);
			var battleprocessObject:Object = battleJsonObject["battle"] as Array;
			
			var battleHeros:Object = battleprocessObject[0].info.player0.battleheros;
			var heroinfo:Object;
			for each(heroinfo in battleHeros)
			{
				res = res.concat(CJPlayerNpc.getLoadResourceListByTemplateId(parseInt(heroinfo.templateid),CJPlayerNpc.LEVEL_LOD_1|CJPlayerNpc.LEVEL_LOD_2));
			}
			battleHeros = battleprocessObject[0].info.player1.battleheros;
			for each(heroinfo in battleHeros)
			{
				res = res.concat(CJPlayerNpc.getLoadResourceListByTemplateId(parseInt(heroinfo.templateid),CJPlayerNpc.LEVEL_LOD_1|CJPlayerNpc.LEVEL_LOD_2));
			}
			res = SArrayUtil.deleteRepeat(res);
		
			return res;
		}

		/**
		 * 是否显示战斗开始动画 
		 */
		public function get isShowBattleStartAnims():Boolean
		{
			return _isShowBattleStartAnims;
		}

		/**
		 * @private
		 */
		public function set isShowBattleStartAnims(value:Boolean):void
		{
			_isShowBattleStartAnims = value;
		}
		
		

	}
}