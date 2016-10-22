package SJ.Game.battle
{
	import SJ.Common.Constants.ConstBattle;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.battle.custom.CJBattleCommandBattleEnd;
	import SJ.Game.battle.custom.CJBattleCommandBattleStart;
	import SJ.Game.battle.custom.CJBattleCommandEndRound;
	import SJ.Game.battle.custom.CJBattleCommandExecSkill;
	import SJ.Game.battle.custom.CJBattleCommandNpcBattle;
	import SJ.Game.battle.custom.CJBattleCommandNpcBattleEnd;
	import SJ.Game.battle.custom.CJBattleCommandNpcBattleStart;
	import SJ.Game.battle.custom.CJBattleCommandQTE;
	import SJ.Game.battle.custom.CJBattleCommandSelectSkill;
	import SJ.Game.battle.custom.CJBattleCommandStandBy;
	import SJ.Game.battle.custom.CJBattleCommandStartRound;
	import SJ.Game.battle.data.CJBattleFormationData;
	import SJ.Game.battle.data.CJBattleQteFormation;
	import SJ.Game.event.CJEvent;
	import SJ.Game.map.CJBattleMapManager;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.Events.CommandEvent;
	import engine_starling.commandSys.core.SCommandBaseData;
	import engine_starling.commandSys.core.SCommandManager;
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	import starling.events.Event;

	public class CJBattleMananger
	{
		private var _commandManager:SCommandManager;
		/**
		 * 玩家容器 key name value
		 */
		private var _playerContains:Dictionary;
		private var _playerContainsByLocationIndex:Dictionary;
		public function CJBattleMananger()
		{
			_init();
		}
		
		private static var _ins:CJBattleMananger = null;
		
		public static function get o():CJBattleMananger
		{
			if(_ins == null)
				_ins = new CJBattleMananger();
			return _ins;
		}
		private function _init():void
		{
			_commandManager = new SCommandManager();
			
			_commandManager.registerCommand(new CJBattleCommandStandBy());
			
			_commandManager.registerCommand(new CJBattleCommandBattleStart());
			_commandManager.registerCommand(new CJBattleCommandBattleEnd());
			
			_commandManager.registerCommand(new CJBattleCommandStartRound());
			_commandManager.registerCommand(new CJBattleCommandEndRound());
			
			_commandManager.registerCommand(new CJBattleCommandNpcBattleStart());
			_commandManager.registerCommand(new CJBattleCommandNpcBattle());
			_commandManager.registerCommand(new CJBattleCommandNpcBattleEnd());
			
			_commandManager.registerCommand(new CJBattleCommandSelectSkill());
			_commandManager.registerCommand(new CJBattleCommandExecSkill());

			_commandManager.registerCommand(new CJBattleCommandQTE());
			
			_playerContains = new Dictionary();
			_playerContainsByLocationIndex = new Dictionary();
			
			
			_initFormation();
			
			
		}
		
		/**
		 * 初始化阵型 
		 * 
		 */
		private function _initFormation():void
		{
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
			
			
			//初始化QTE阵型
			formationInfo = AssetManagerUtil.o.getObject(ConstResource.sResJsonQteFormation) as Array;
			ConstBattle.sBattleQTEFormationData = new Dictionary();
			length = formationInfo.length;
			for(i = 0;i<length;i++)
			{
				formationJson = formationInfo[i];
				formationType = formationJson["postiontype"];
				//QTE阵型数据
				var formationQTEData:CJBattleQteFormation = null;
				if(!ConstBattle.sBattleQTEFormationData.hasOwnProperty(formationType))
				{
					ConstBattle.sBattleQTEFormationData[formationType] = new CJBattleQteFormation(formationType);	
				}
				
				formationQTEData = ConstBattle.sBattleQTEFormationData[formationType];
				formationQTEData.addPos(formationJson["posid"],formationJson["postionx"]/2,formationJson["postiony"]/2);
			}
			
			
		}
		
		/**
		 * 命令模板序列 
		 */
		private var _comandVec:Vector.<Object>;
		/**
		 * 当前执行到的命令 
		 */
		private var _currentCommandIndex:int = 0;
		private function _initBattleTemplate(cmdsTemplate:Object):void
		{
			_currentCommandIndex = 0;
			_comandVec = new Vector.<Object>();
			var length:int = 0;
			var i:int = 0;
			var arr:Array = cmdsTemplate["command"];
			length = arr.length;
			for(i=0;i<length;i++)
			{
				_comandVec.push(arr[i]);
			}
			
			_comandVec.sort(function(a:Object,b:Object):int{
				if(a["i"]>b["i"])
					return 1;
				return -1;
			});
			
		}
		/**
		 * 开始战斗 
		 * @param playerDatas
		 * @param cmdsTemplate 战斗模板数据
		 * 
		 */
		public function startBattle(playerDatas:Vector.<CJPlayerData>,cmdsTemplate:Object):void
		{
			//初始化战斗模板数据
			_initBattleTemplate(cmdsTemplate);
			
			_commandManager.start();
			_playerContains = new Dictionary();
			_playerContainsByLocationIndex = new Dictionary();
			
			var length:int = playerDatas.length;
			for(var i:int=0;i<length;++i)
			{
				_createPlayer(playerDatas[i]);
			}
			
			

			_executeCommand();

			
	
		}
		
		private function _executeCommand():void
		{
			
			var cmdParams:Object = _comandVec[_currentCommandIndex];
			var commandId:int = ConstBattle[cmdParams.cid];
			var dataOfCommand:SCommandBaseData = _commandManager.genCommandData(commandId);
			
			//property
			var length:int = 0;
			var propertyDic:Object = cmdParams["property"];
			if(propertyDic == null)
				propertyDic = new Object();
			
			
			
			
			for(var key:String in propertyDic)
			{
				dataOfCommand[key] = propertyDic[key];
			}
			propertyDic = cmdParams["varproperty"];
			if(propertyDic == null)
				propertyDic = new Object();
			for( key in propertyDic)
			{
				dataOfCommand[key] = this[propertyDic[key]];
			}
			
			
			_commandManager.addCommand(dataOfCommand);
			_commandManager.addCommandEventListener(commandId,CommandEvent.Event_Finshed,_executeCommandFinish);
			
		}
		private function _executeCommandFinish(e:Event):void
		{
			var cmdParams:Object = _comandVec[_currentCommandIndex];
			var commandId:int = ConstBattle[cmdParams.cid];
			_commandManager.removeCommandEventListener(commandId,CommandEvent.Event_Finshed,_executeCommandFinish);
			
			var nextIndexs:Object = cmdParams["ni"];
			if(nextIndexs == null)
			{
				nextIndexs = {"0":(++ _currentCommandIndex ) % _comandVec.length};
			}

			
			//是否继续播放下一个命令
			_currentCommandIndex = nextIndexs[e.data["returnCode"]];
			if(_currentCommandIndex == -1)
			{
//				endBattle();
			}
			else
			{
				_executeCommand();
			}
		}
		
		/**
		 * 通过玩家名称返回玩家数据 
		 * @param name
		 * @return 
		 * 
		 */
		public function battleDataByPlayerName(name:String):CJBattlePlayerData
		{
			var data:CJBattlePlayerData = _playerContains[name];
			if(data == null)
				return data;
			//从地图中查找对象
			if(data.playerSprite == null)
			{
				data.playerSprite = CJBattleMapManager.o.playerLayer.getChildByName(name) as CJPlayerNpc;
			}
			return data;
		}
		public function battleDataBySelfLocationIndex(index:int):CJBattlePlayerData
		{
			return battleDataByLocationIndex(index);
		}
		
		public function battleDataByOtherLoactionIndex(index:int):CJBattlePlayerData
		{
			return battleDataByLocationIndex(index + ConstBattle.ConstLocationOffSet);
		}
		/**
		 * 通过位置查找用户 
		 * @param index 位置索引
		 * @return 
		 * 
		 */
		public function battleDataByLocationIndex(index:int):CJBattlePlayerData
		{
			if(!_playerContainsByLocationIndex.hasOwnProperty(index))
			{
				return null;
			}
			else
			{
				var name:String = (_playerContainsByLocationIndex[index] as CJBattlePlayerData).playerName;
				return battleDataByPlayerName(name);
			}
		}
		
		/**
		 * 遍历所有玩家信息 ,活着的
		 * @return 
		 * 
		 */
		public function getAllPlayerbattleData():Vector.<CJBattlePlayerData>
		{
			var outvector:Vector.<CJBattlePlayerData> = new Vector.<CJBattlePlayerData>();
			for(var name:String in _playerContains)
			{
				var data:CJBattlePlayerData = battleDataByPlayerName(name);
				outvector.push(battleDataByPlayerName(name)); 
			}
			return outvector;
		}
		/**
		 * 重置回合,主要是重置移动状态等 
		 * 
		 */		
		public function resetRound():void
		{
			for each(var data:CJBattlePlayerData in _playerContains)
			{
				data.moveAble = true;
			}
		}
		
		/**
		 * 创建玩家 
		 * @param data
		 * 
		 */
		private function _createPlayer(data:CJPlayerData):void
		{
//			var dataOfStandBy:CJBattleCommandStandByData = new CJBattleCommandStandByData;
//			dataOfStandBy.playerName = data.name;
//			dataOfStandBy.playerAnimName = data.playerAnim;
//			dataOfStandBy.delaytime = 0;
//			var pos:Point = null;
			var posIndex:int = 0;
			var formationData:CJBattleFormationData = ConstBattle.sBattleFormationData[data.formationId];
			
			if(data.isSelf)
			{

					posIndex = data.formationindex;
				
			}
			else
			{
				
			
					
					posIndex = ConstBattle.ConstLocationOffSet + data.formationindex;
				
			}
//			dataOfStandBy.x = pos.x;
//			dataOfStandBy.y = pos.y;
			
//			_commandManager.addCommand(dataOfStandBy);
			
			
			_playerContains[data.name] = new CJBattlePlayerData(data);
			_playerContainsByLocationIndex[posIndex] = _playerContains[data.name];
			//创建时间线
//			_createTimeline(_playerContains[data.name]);
			

			
		}
		
		public function endBattle():void
		{
			_commandManager.stop();
			_playerContains = new Dictionary();
			_playerContainsByLocationIndex = new Dictionary();
			//删除所有的对象
//			CJMapManager.o.playerLayer.removeChildren();
		}
		public static function testPk1v1Player():void
		{
			//假设有1个玩家 5个将
			
			var playerDatas:Vector.<CJPlayerData> = new Vector.<CJPlayerData>();
			
			var playerData:CJPlayerData = null;
			
			//主角
			playerData = new CJPlayerData;
			playerData.isPlayer = true;
			playerData.templateId = 1;
			playerData.name = "zhujiao";
			playerData.formationId = 3;
			playerData.formationindex = 0;
			//			playerData.playerAnim = "guanyu";
			playerDatas.push(playerData);
			
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 0;
			playerData.name = "npc1";
			playerData.formationId = 3;
			playerData.formationindex = 0;
			//			playerData.playerAnim = "guanyu";
			playerDatas.push(playerData);
			
			
		
			
			
			//主角
			playerData = new CJPlayerData;
			playerData.isPlayer = true;
			playerData.templateId = 2;
			playerData.name = "zhujiao1";
			playerData.isSelf = false;
			playerData.formationId = 3;
			playerData.formationindex = 0;
			//			playerData.playerAnim = "zhaoyun";
			playerDatas.push(playerData);
			
			
			
		
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 1;
			playerData.name = "npc1_3";
			playerData.isSelf = false;
			playerData.formationId = 3;
			//			playerData.speed = 1000;
			playerData.formationindex = 0;
			//			playerData.playerAnim = "zhaoyun";
			playerDatas.push(playerData);
			
		
			
			playerDatas.push(playerData);
			
			
			var cmdstemplate:Object = AssetManagerUtil.o.getObject(ConstResource.sResBattleCmds);
			
			o.startBattle(playerDatas,cmdstemplate);
		}
		
		public static function testPk1v1Boss():void
		{
			//假设有1个玩家 5个将
			
			var playerDatas:Vector.<CJPlayerData> = new Vector.<CJPlayerData>();
			
			var playerData:CJPlayerData = null;
			
			//主角
			playerData = new CJPlayerData;
			playerData.isPlayer = true;
			playerData.templateId = 2;
			playerData.name = "zhujiao";
			playerData.formationId = 4;
			playerData.formationindex = 0;
			//			playerData.playerAnim = "guanyu";
			playerDatas.push(playerData);
			
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 0;
			playerData.name = "npc1";
			playerData.formationId = 4;
			playerData.formationindex = 0;
			//			playerData.playerAnim = "guanyu";
			playerDatas.push(playerData);
			
			
			
			
			
			//主角
			playerData = new CJPlayerData;
			playerData.isPlayer = true;
			playerData.templateId = 2;
			playerData.name = "zhujiao1";
			playerData.isSelf = false;
			playerData.formationId = 4;
			playerData.formationindex = 0;
			//			playerData.playerAnim = "zhaoyun";
			//			playerDatas.push(playerData);
			
			
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 3;
			playerData.formationId = 4;
			playerData.name = "npc1_1";
			playerData.isSelf = false;
			//			playerData.speed = 1300;
			playerData.formationindex = 0;
			//			playerData.playerAnim = "zhaoyun";
			playerDatas.push(playerData);
			
			
			
			playerDatas.push(playerData);
			
			
			var cmdstemplate:Object = AssetManagerUtil.o.getObject(ConstResource.sResBattleCmds);
			
			o.startBattle(playerDatas,cmdstemplate);
		}
		
		public static function testPkPlayer():void
		{
			//假设有1个玩家 5个将
			
			var playerDatas:Vector.<CJPlayerData> = new Vector.<CJPlayerData>();
			
			var playerData:CJPlayerData = null;
			
			//主角
			playerData = new CJPlayerData;
			playerData.isPlayer = true;
			playerData.templateId = 1;
			playerData.name = "zhujiao";
//			playerData.speed = 3000;
			playerData.formationindex = 0;
//			playerData.playerAnim = "guanyu";
			playerDatas.push(playerData);
			
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 0;
			playerData.name = "npc1";
//			playerData.speed = 1300;
			playerData.formationindex = 1;
//			playerData.playerAnim = "guanyu";
			playerDatas.push(playerData);
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 1;
			playerData.name = "npc2";
//			playerData.speed = 1800;
			playerData.formationindex = 2;
//			playerData.playerAnim = "zhaoyun";
			playerDatas.push(playerData);
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 0;
			playerData.name = "npc3";
//			playerData.speed = 2200;
			playerData.formationindex = 3;
//			playerData.playerAnim = "guanyu";
			playerDatas.push(playerData);
			
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 1;
			playerData.name = "npc4";
//			playerData.speed = 3800;
			playerData.formationindex = 4;
//			playerData.playerAnim = "guanyu";
			playerDatas.push(playerData);
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 0;
			playerData.name = "npc5";
//			playerData.speed = 4500;
			playerData.formationindex = 5;
//			playerData.playerAnim = "guanyu";
			playerDatas.push(playerData);
			
			
			//主角
			playerData = new CJPlayerData;
			playerData.isPlayer = true;
			playerData.templateId = 1;
			playerData.name = "zhujiao1";
			playerData.isSelf = false;
//			playerData.speed = 1800;
			playerData.formationindex = 0;
//			playerData.playerAnim = "zhaoyun";
			playerDatas.push(playerData);
			
			
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 1;
			playerData.name = "npc1_1";
			playerData.isSelf = false;
//			playerData.speed = 1300;
			playerData.formationindex = 1;
//			playerData.playerAnim = "zhaoyun";
			playerDatas.push(playerData);
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 0;
			playerData.name = "npc1_2";
			playerData.isSelf = false;
//			playerData.speed = 600;
			playerData.formationindex = 2;
//			playerData.playerAnim = "guanyu";
			playerDatas.push(playerData);
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 1;
			playerData.name = "npc1_3";
			playerData.isSelf = false;
//			playerData.speed = 1000;
			playerData.formationindex = 3;
//			playerData.playerAnim = "zhaoyun";
			playerDatas.push(playerData);
			
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 1;
			playerData.name = "npc1_4";
			playerData.isSelf = false;
//			playerData.speed = 1200;
			playerData.formationindex = 4;
//			playerData.playerAnim = "zhaoyun";
			playerDatas.push(playerData);
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 0;
			playerData.isSelf = false;
			playerData.name = "npc1_5";
//			playerData.speed = 3500;
			playerData.formationindex = 5;
//			playerData.playerAnim = "guanyu";
			
			//测试保存
			playerData.saveToCache();
			
			playerData.loadFromCache();
			
			
			playerDatas.push(playerData);
			
			
			var cmdstemplate:Object = AssetManagerUtil.o.getObject(ConstResource.sResBattleCmds);
			
			o.startBattle(playerDatas,cmdstemplate);
		}
		
		
		public static function test_pkBoss():void
		{
			var playerDatas:Vector.<CJPlayerData> = new Vector.<CJPlayerData>();
			
			var playerData:CJPlayerData = null;
			
			//主角
			playerData = new CJPlayerData;
			playerData.isPlayer = true;
			playerData.templateId = 2;
			playerData.name = "zhujiao";
			//			playerData.speed = 3000;
			playerData.formationindex = 0;
			//			playerData.playerAnim = "guanyu";
			playerDatas.push(playerData);
			
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 0;
			playerData.name = "npc1";
			//			playerData.speed = 1300;
			playerData.formationindex = 0;
			//			playerData.playerAnim = "guanyu";
			playerDatas.push(playerData);
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 1;
			playerData.name = "npc2";
			//			playerData.speed = 1800;
			playerData.formationindex = 1;
			//			playerData.playerAnim = "zhaoyun";
			playerDatas.push(playerData);
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 0;
			playerData.name = "npc3";
			//			playerData.speed = 2200;
			playerData.formationindex = 2;
			//			playerData.playerAnim = "guanyu";
			playerDatas.push(playerData);
			
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 1;
			playerData.name = "npc4";
			//			playerData.speed = 3800;
			playerData.formationindex = 3;
			//			playerData.playerAnim = "guanyu";
			playerDatas.push(playerData);
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 0;
			playerData.name = "npc5";
			//			playerData.speed = 4500;
			playerData.formationindex = 4;
			//			playerData.playerAnim = "guanyu";
			playerDatas.push(playerData);
			
			
			
			//主角
			playerData = new CJPlayerData;
			playerData.isPlayer = true;
			playerData.templateId = 2;
			playerData.name = "zhujiao1";
			playerData.isSelf = false;
			//			playerData.speed = 1800;
			playerData.formationindex = 0;
			//			playerData.playerAnim = "zhaoyun";
//			playerDatas.push(playerData);
			
			
			
			playerData = new CJPlayerData;
			playerData.isPlayer = false;
			playerData.templateId = 3;
			playerData.formationId = 2;
			playerData.name = "npc1_1";
			playerData.isSelf = false;
			//			playerData.speed = 1300;
			playerData.formationindex = 0;
			//			playerData.playerAnim = "zhaoyun";
			playerDatas.push(playerData);
			
			
			var cmdstemplate:Object = AssetManagerUtil.o.getObject(ConstResource.sResBattleCmds);
			o.startBattle(playerDatas,cmdstemplate);
		}
		

	}
}