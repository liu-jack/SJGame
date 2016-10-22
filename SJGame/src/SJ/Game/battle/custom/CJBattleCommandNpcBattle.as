package SJ.Game.battle.custom
{
	import SJ.Common.Constants.ConstBattle;
	import SJ.Game.battle.CJBattlePlayerData;
	import SJ.Game.battle.CJBattleReplayManager;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.commandSys.core.SCommandBase;
	import engine_starling.commandSys.core.SCommandBaseData;
	
	public class CJBattleCommandNpcBattle extends SCommandBase
	{
		private var _vectorOfexecuteParams:Vector.<Object>;
		private var _onsidecount:int;
		private var _isSelf:Boolean;
		private var _mgr:CJBattleReplayManager;
		private var _heroid:String;
		private var _index:String;
		
		public function CJBattleCommandNpcBattle()
		{
			super(ConstBattle.CommandNpcBattle, CJBattleCommandNpcBattleData);
		}
		
		/**
		 * 添加参数,如果是同一方的 返回 true 否则 false 
		 * @param params
		 * @param isSelf
		 * @return 
		 * 
		 */
		private function _pushparams(params:Object,isSelf:Boolean):Boolean
		{
			if(_vectorOfexecuteParams.length == 0)
			{
				_isSelf = isSelf;
				_vectorOfexecuteParams.push(params);
				return true;
					
			}
			else if(_isSelf == isSelf)
			{
				_vectorOfexecuteParams.push(params);
				return true;
			}
			return false;
		}
		private function _actionEnd():void
		{
			//动作结束,设定下一回合状态
			var count:int = _mgr.battleJsonObject.battle.length;
			var startSet:Boolean = false;
			var found:Boolean = false;
			for(var i:int = 0; i < count; i++)
			{
				var battle:Object = _mgr.battleJsonObject.battle[i];
				if(battle.cmd == "CommandNpcBattle" && battle.info.heroid == _heroid)
				{
					if(startSet)
					{
						var _moveHero:CJBattlePlayerData = _mgr.getPlayer(_heroid);
						var bSkillAttack:Boolean = Boolean(parseInt(battle.info.bSkillAttack));
						_moveHero.playerSprite.setGuangquan(bSkillAttack);
						found = true;
						break;
					}
					else if(parseInt(_index) == i)
					{
						startSet = true;
					}
				}
			}
			if(!found)//最后一个回合了,所以没有下一个回合
			{
				_moveHero = _mgr.getPlayer(_heroid);
				_moveHero.playerSprite.setGuangquan(false);
			}
			
		}
		private function _attackbat(params:Object,mgr:CJBattleReplayManager):void
		{
			_mgr = mgr;
			_heroid = params.heroid;
			_index = params.index;
			var _moveHero:CJBattlePlayerData = _mgr.getPlayer(params._heroid);
			var bSkillAttack:Boolean = Boolean(parseInt(params.bSkillAttack));
			var destHero:CJBattlePlayerData;
			if(bSkillAttack)
			{
				var destHeroVec:Vector.<CJPlayerNpc> = new Vector.<CJPlayerNpc>();
				for each(var heroid:String in params.destheroids)
				{
					destHero = _mgr.getPlayer(heroid);
					destHeroVec.push(destHero.playerSprite);
				}
				_moveHero.playerSprite.skillAttack(destHeroVec,_endattack,params);
				
			}
			else//普通攻击
			{
				destHero = mgr.getPlayer(params.destheroids[0]);
				_moveHero.playerSprite.normalAttack(destHero.playerSprite,0,_endattack,params);
				
			}
			
			function _endattack():void
			{
				_actionEnd();
				_onsidecount --;
				if(_onsidecount == 0)
				{
					
					if(_vectorOfexecuteParams.length == 0)//没有下一个命令
					{
						executeEndImmediately();
					}
					else
					{
						var sparams:Object =_vectorOfexecuteParams[0];
						var battleisEnd:Boolean = Boolean(parseInt(sparams.battleend));
						if(battleisEnd)//是最后一个命令
						{
							_onsidecount = 1;
							_vectorOfexecuteParams.splice(0,_vectorOfexecuteParams.length);
							_attackbat(sparams,mgr)
						}
						else
						{
							executeEndImmediately();
						}
					}
				}
			}
		}
//		protected function execute1(battleData:SCommandBaseData):void
		override protected function execute(battleData:SCommandBaseData):void
		{
			var mgr:CJBattleReplayManager = battleData.params["mgr"];
			var params:Object = battleData.params["params"];
			_mgr = mgr;
			_heroid = params.heroid;
			_index = params.index;
			//找到动作的英雄
			var _moveHero:CJBattlePlayerData = mgr.getPlayer(params.heroid);
			
			var bSkillAttack:Boolean = Boolean(parseInt(params.bSkillAttack));
			var destHero:CJBattlePlayerData;
			if(bSkillAttack)
			{
				var destHeroVec:Vector.<CJPlayerNpc> = new Vector.<CJPlayerNpc>();
				for each(var heroid:String in params.destheroids)
				{
					destHero = mgr.getPlayer(heroid);
					destHeroVec.push(destHero.playerSprite);
				}
				_moveHero.playerSprite.skillAttack(destHeroVec,_endattack,params);
				
			}
			else//普通攻击
			{
				destHero = mgr.getPlayer(params.destheroids[0]);
				_moveHero.playerSprite.normalAttack(destHero.playerSprite,0,_endattack,params);
				
			}
			
			function _endattack():void
			{
				_actionEnd();
				executeEndImmediately();

			}
		}
		
		
//		override protected function execute(battleData:SCommandBaseData):void
		protected function execute1(battleData:SCommandBaseData):void
		{
	
			var mgr:CJBattleReplayManager = battleData.params["mgr"];
			var params:Object = battleData.params["params"];
			_vectorOfexecuteParams = mgr.vectorOfBattleBatch;
//			params	Object (@17807f29)	
//			mgr	SJ.Game.battle.CJBattleReplayManager (@15878791)	
//				params	Object (@177f3989)	
//			bSkillAttack	0	
//			destheroids	[] (@177a5df1)	
//			dosteps	[] (@177a5c71)	
//			[0]	Object (@177f3749)	
//			length	1	
//			heroid	"216175330854576129"	
//			skill	"4"	
			
			
			//找到动作的英雄
			var _moveHero:CJBattlePlayerData = mgr.getPlayer(params.heroid);
			if(_pushparams(params,_moveHero.playerBaseData.isSelf) == false)
			{
				_onsidecount = _vectorOfexecuteParams.length;

				//不是同一方运动,把之前的都运动了
				var sparams:Object = null;
				var i:int = 0;
				
				
				while(null != (sparams = _vectorOfexecuteParams.shift()))
				{
					var _moveHero1:CJBattlePlayerData = mgr.getPlayer(sparams.heroid);
					cmdOwner.mJuggler.delayCall(_attackbat,0.5 * i,sparams,mgr)
					i++;
				}
				
				//把自己填入下次的队列中
				_pushparams(params,_moveHero.playerBaseData.isSelf);
			}
			else
			{
				var battleisEnd:Boolean = Boolean(parseInt(params.battleend));
				if(battleisEnd)
				{
					_onsidecount = _vectorOfexecuteParams.length;
					//战斗已经结束了运动,把之前的都运动了
					while(null != (sparams = _vectorOfexecuteParams.pop()))
					{
						cmdOwner.mJuggler.delayCall(_attackbat,0.5 * i,sparams,mgr)
						i++;
					}
					
				}
				else
				{
					executeEndImmediately();
				}
				
			}
			
			
			
			
			
			return;


			//查询所有NPC,并按照速度排序
//			_vectorOfPlayerData = CJBattleMananger.o.getAllPlayerbattleData();
//			
//			_vectorOfPlayerData.sort(function(a:CJBattlePlayerData,b:CJBattlePlayerData):int
//			{
//				//a比b 慢
//				if(a.playerBaseData.speed > b.playerBaseData.speed)
//				{
//					return 1;
//				}
//				return -1;
//			});
//			
			
			//查询所有NPC,并按照速度排序
//			_vectorOfPlayerData = new Vector.<CJBattlePlayerData>();
//			
//			//差值排序
//			for(var i:int = 0;i<ConstBattle.ConstMaxLocationNum;i++)
//			{
//				var playerdata:CJBattlePlayerData = CJBattleMananger.o.battleDataBySelfLocationIndex(i);
//				if(playerdata != null)
//				{
//					_vectorOfPlayerData.push(playerdata);
//				}
//				playerdata = CJBattleMananger.o.battleDataByOtherLoactionIndex(i);
//				if(playerdata != null)
//				{
//					_vectorOfPlayerData.push(playerdata);
//				}
//			}
			
//			_vectorOfPlayerData.sort(function(a:CJBattlePlayerData,b:CJBattlePlayerData):int
//			{
//				//a比b 慢
//				if(a.playerBaseData.speed > b.playerBaseData.speed)
//				{
//					return 1;
//				}
//				return -1;
//			});
			
//			_exeBattle();
		}
		
//		private function _exeBattle():void
//		{
//			//查找同一时刻可以运动的NPC
//			var length:int = 0;
//			length = _vectorOfPlayerData.length;
//			if(length <= 0)
//			{
////				executeFinish();
//				executeEndImmediately();
//				
//				return;
//			}
//			
//			var side:Boolean = _vectorOfPlayerData[0].playerBaseData.isSelf;
//			//判断都是自己一方的运动
//			var i:int = 1;
//			for(i;i<length;i++)
//			{
//				//不是玩家,并且不是一方的人员
//				if(_vectorOfPlayerData[i].playerBaseData.isSelf != side)
//				{
//					break;
//				}
//			}
//			
//			//获取到本次运动的列表
//			var _canmoveVector:Vector.<CJBattlePlayerData> = _vectorOfPlayerData.splice(0,i);
//			
//			var moveVector:Vector.<CJBattlePlayerData> = new Vector.<CJBattlePlayerData>();
//			length = _canmoveVector.length;
//			for(i=0;i<length;i++)
//			{
//				//可以移动,并且不是玩家,并且没有死亡
//				if(_canmoveVector[i].moveAble && 
//					!_canmoveVector[i].playerBaseData.isDead())
//				{
//					moveVector.push(_canmoveVector[i]);
//				}
//			}
//			
//			//开始攻击
//			length = moveVector.length;
//			//攻击间隔
//			var attackSpace:Number = (_battleData as CJBattleCommandNpcBattleData).attackInterval;
//			if(length > 0 && _canAttack(moveVector[0]))
//			{
//				var logString:String = "Move Together ";
//				
//				
//				for(i=0;i<length;i++)
//				{
//					logString+= moveVector[i].playerName + ";";
//					//执行攻击
//					cmdOwner.mJuggler.delayCall(function f(data:CJBattlePlayerData):void
//					{
//						_executeAttack(data);
//					},attackSpace * i,moveVector[i]);
//				}
//				
//				Logger.log("CJBattleCommandNpcBattle",logString);
//				//延时1.5秒执行下一轮
//				_waitAttack(length);
//			}
//			else
//			{
//				_exeBattle();
//			}
//
//		}
//		
//		//本轮需要攻击的武将数
//		private var _currentAttackCount:int = 0;
//		private function _waitAttack(numOfAttack:int):void
//		{
//			_currentAttackCount = numOfAttack;
//		}
//		private function _reduceAttack():void
//		{
//			_currentAttackCount --;
//			if(_currentAttackCount == 0)//完成本次攻击
//			{
//				cmdOwner.mJuggler.delayCall(_exeBattle,1);
//			}
//			Assert(_currentAttackCount>=0,"等待攻击次数错误!");
//		}
//		
//		/**
//		 * 是否还有攻击目标 
//		 * @param player
//		 * @return 
//		 * 
//		 */
//		private function _canAttack(player:CJBattlePlayerData):Boolean
//		{
//			var underAttackPlayerData:CJBattlePlayerData;
//			var i:int= 0;
//			if(player.playerBaseData.isSelf)
//			{
//				for(i=0;i<5;i++)
//				{
//					underAttackPlayerData = CJBattleMananger.o.battleDataByOtherLoactionIndex(i);
//					if(underAttackPlayerData!= null && !underAttackPlayerData.playerBaseData.isDead())
//					{
//						return true;
//					}
//				}
//				
//			}
//			else
//			{
//				for(i=0;i<5;i++)
//				{
//					underAttackPlayerData = CJBattleMananger.o.battleDataBySelfLocationIndex(i);
//					if(underAttackPlayerData!= null && !underAttackPlayerData.playerBaseData.isDead())
//					{
//						return true;
//					}
//				}
//			}
//			return false;
//		}
//		/**
//		 * 执行攻击 
//		 * @param player 发起攻击的武将
//		 * 
//		 */
//		private function _executeAttack(player:CJBattlePlayerData):void
//		{
//			var r:int = Math.random() * 5;
//			
//			var i:int= 0;
//			//本轮已经移动过了
//			player.moveAble = false;
////			var pos:Point = null;
//			var underAttackPlayerData:CJBattlePlayerData;
//			
//			/**
//			 * 查找呗攻击的用户 
//			 * @param getplayerfunction
//			 * @param selfdata
//			 * @return 
//			 * 
//			 */
//			function _findUnderAttackPlayer(getplayerfunction:Function,selfdata:CJBattlePlayerData):CJBattlePlayerData
//			{
//				var underAttackPlayerData:CJBattlePlayerData;
//				//查找前排
//				for(i=player.playerBaseData.formationindex;i<ConstBattle.ConstMaxLocationNum / 2 + player.playerBaseData.formationindex;i++)
//				{
//					underAttackPlayerData = getplayerfunction(i % (ConstBattle.ConstMaxLocationNum / 2));
//					if(underAttackPlayerData!= null && !underAttackPlayerData.playerBaseData.isDead())
//					{
//						return underAttackPlayerData;
//					}
//				}
//				
//				//前排全挂了,查找后排
//				for(i=player.playerBaseData.formationindex;i<ConstBattle.ConstMaxLocationNum / 2 + player.playerBaseData.formationindex;i++)
//				{
//					underAttackPlayerData = getplayerfunction(i % (ConstBattle.ConstMaxLocationNum / 2) +  (ConstBattle.ConstMaxLocationNum / 2));
//					if(underAttackPlayerData!= null && !underAttackPlayerData.playerBaseData.isDead())
//					{
//						return underAttackPlayerData;
//					}
//				}
//				return underAttackPlayerData;
//			}
////			var formationData:CJBattleFormationData = ConstBattle.sBattleFormationData[data.formationType];
//			
//			if(player.playerBaseData.isSelf)
//			{
//				
//				underAttackPlayerData = _findUnderAttackPlayer(CJBattleMananger.o.battleDataByOtherLoactionIndex,player);
//			}
//			else
//			{
//				underAttackPlayerData = _findUnderAttackPlayer(CJBattleMananger.o.battleDataBySelfLocationIndex,player);
//			}
//			
//			//同一轮有所有的可能武将已经被干掉了 后面的武将就不出手了
//			if(underAttackPlayerData == null)
//			{
//				_reduceAttack();
//				return;
//			}
//			
////			技能攻击
////			if(Math.random() < 0.5)
////			{
////				player.playerSprite.shanAndAttack(underAttackPlayerData.playerSprite,0,_reduceAttack);
////			}
////			else
////			{
////				var skillId:int = player.playerBaseData.skill1();
////				
////				if(player.playerBaseData.playerType == 2 && Math.random() < 0.5 )
////				{
////					skillId = player.playerBaseData.skill2();
////				}
////
////				var skillData:Object = CJDataOfSkillSettting.o.getProperty(skillId);
////				player.playerSprite.npcSkill(underAttackPlayerData.playerSprite,skillData,_reduceAttack);
////			}
//			
//			// add by longtao
//			player.playerSprite.battleAction(underAttackPlayerData, _reduceAttack);
//			// add by longtao end
//		}
		
		
	}
}